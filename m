Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E803B16DEAC;
	Wed,  3 Jul 2024 11:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006250; cv=none; b=RPZ+o/H2nLdXctloaDUplSHpxAbAyC3wTTtHXeol2I1w2oBLDN3saGrq4XedSmWkc9BUP9fgMeAa6U9L3yAh8sr0qYqgCqhQKbj0hFG1AzeWKwjRA2EV+aom8/9JXFiUhDjeCFjVrACSZhUZyzW2P8z7hfnhuSoYb3/41untfbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006250; c=relaxed/simple;
	bh=WIGakxGbpz913DlNwoAn6g8kVWimoFnx9TVwlqWw/7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHU/2xi+TH+QTK5fj9QVCFaQ8579NI4sAruL9n9rfttrOH89+AnOYsfrydGyx3/1UKHcFEFcZ4B3iMJAhHTrQSXEHO+V05z4uGqKaMALvY6txC1C/iF5X+o1B4rOLPP70t8DQTTzGZFu7IjhgVBQM+SudoLd6GxiYhza/sGTor0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NiDBOPRF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NiDBOPRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5F5C2BD10;
	Wed,  3 Jul 2024 11:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006249;
	bh=WIGakxGbpz913DlNwoAn6g8kVWimoFnx9TVwlqWw/7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NiDBOPRFC4jOiZJ/KEtpLS4FK54UKUDqr6SnK2ra0XclNv1/9nd71FMbD/7DAea11
	 3fN0amq4/C+L4znqd1KDgoiyBZuL+oGk/+YT4AWiA9/niTDUP8S3grE80XAWzJuurV
	 tyTLfLAQQNGBNKw9Mw2aN1zCu0XBe+2kSHsyCHAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 5.15 319/356] usb: musb: da8xx: fix a resource leak in probe()
Date: Wed,  3 Jul 2024 12:40:55 +0200
Message-ID: <20240703102925.184989041@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit de644a4a86be04ed8a43ef8267d0f7d021941c5e upstream.

Call usb_phy_generic_unregister() if of_platform_populate() fails.

Fixes: d6299b6efbf6 ("usb: musb: Add support of CPPI 4.1 DMA controller to DA8xx")
Cc: stable <stable@kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/69af1b1d-d3f4-492b-bcea-359ca5949f30@moroto.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/da8xx.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/usb/musb/da8xx.c
+++ b/drivers/usb/musb/da8xx.c
@@ -556,7 +556,7 @@ static int da8xx_probe(struct platform_d
 	ret = of_platform_populate(pdev->dev.of_node, NULL,
 				   da8xx_auxdata_lookup, &pdev->dev);
 	if (ret)
-		return ret;
+		goto err_unregister_phy;
 
 	memset(musb_resources, 0x00, sizeof(*musb_resources) *
 			ARRAY_SIZE(musb_resources));
@@ -582,9 +582,13 @@ static int da8xx_probe(struct platform_d
 	ret = PTR_ERR_OR_ZERO(glue->musb);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register musb device: %d\n", ret);
-		usb_phy_generic_unregister(glue->usb_phy);
+		goto err_unregister_phy;
 	}
 
+	return 0;
+
+err_unregister_phy:
+	usb_phy_generic_unregister(glue->usb_phy);
 	return ret;
 }
 



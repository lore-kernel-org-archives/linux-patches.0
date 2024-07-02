Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1830D63D;
	Tue,  2 Jul 2024 17:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941510; cv=none; b=jIVpHh03Vk1W8RVBIUSgiKn7FayUMZ7bttEpmKEqrkVLypC5lJY3hydqZOgDVy1X94W03uPuhuY8BqOxaXjco5KJyJ151lyHFc99FypXu3w9C8gNKJBc4VDiJd8Itc0uL+2HKBb/zxL2JcUvL43SvVsTiPSNZHt+clfUdj/PTcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941510; c=relaxed/simple;
	bh=UpQiO1Z4kKWUQwLwuRs9hJXEezi18eFc/6hDdH418gU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArOwSQO6VtDEQBp9nrr2WWy9ItsQI+GdjOx7EinGNanEJF0ozNJMrT2Whu3MPnkHY7vPxKgLkE7NQP7SF0nkm+4ErQvXnkvjY4/iI6BfZyuqHJ9gRXmRBcdA/Kk9EiPKXVKWqrKGRqCtNSqSxsE/3sBgEJ3XFQv91mi2qm0bahE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MebVBchg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MebVBchg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC4EC116B1;
	Tue,  2 Jul 2024 17:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941510;
	bh=UpQiO1Z4kKWUQwLwuRs9hJXEezi18eFc/6hDdH418gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MebVBchgWvFdVm0VHmca9GsoVT5GRSoDWaD6M+k4KIEFWy2KPWQk+T5iic6V+1gi8
	 RHNhN1RW3ZJDck2dwcl/WOumGZH7R/3PTNDlbFMW7NnbdT3yT65HEyglCC780ECh8d
	 8TKvU9bxWvABwE2CNYNNYTDd7CAcBvu7qv086MXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 6.1 085/128] usb: musb: da8xx: fix a resource leak in probe()
Date: Tue,  2 Jul 2024 19:04:46 +0200
Message-ID: <20240702170229.438334260@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -553,7 +553,7 @@ static int da8xx_probe(struct platform_d
 	ret = of_platform_populate(pdev->dev.of_node, NULL,
 				   da8xx_auxdata_lookup, &pdev->dev);
 	if (ret)
-		return ret;
+		goto err_unregister_phy;
 
 	pinfo = da8xx_dev_info;
 	pinfo.parent = &pdev->dev;
@@ -568,9 +568,13 @@ static int da8xx_probe(struct platform_d
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
 



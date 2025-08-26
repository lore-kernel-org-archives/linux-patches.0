Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73831DF75A;
	Tue, 26 Aug 2025 14:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218297; cv=none; b=d0UXEJqGUTvbayHFC7in4QPM7PKcAomi1J5zz61Beqr+F1hfV0grZt2HJwgeKp8QOjaAHOX6doSi07YRGYzkqdse6wDuYGq4TSXB+oCJXayT8gQCW5pCxTpneOJ0uzzCrHZdHtgG/OQkvEsmubgtuyK0nNSfmwZO+qbCD3l8dlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218297; c=relaxed/simple;
	bh=mwkbWIzGJfeNK4g14Sn/0eAT1AT1wkOMaubhU4iSfr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t97vQGbZK76yoafbDhcC2Qp6PswAhum3TmGQpva/ehG3PQA13FMyqZk/uZGxIdpYFo6VSsw+bJMkO5Hx5wk+5YGtMNHPSrW5Cz1HuRJP31FusGgPSWoEqPwdqkuaHygNqRU0e5QlEgGdJB6n6njNUkbp+MRgzEiYlFaIIoZASmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rikKzIf9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rikKzIf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717CFC4CEF1;
	Tue, 26 Aug 2025 14:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218296;
	bh=mwkbWIzGJfeNK4g14Sn/0eAT1AT1wkOMaubhU4iSfr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rikKzIf9cvL2h0ibUfbU4wcCnWikzNdgIiTi2YtZfMbgZTIqvOudGhcodKr7siiCb
	 rq5G7avvnWMtq8rVLx7dbQ9o9baUCpSyvFxdOya/4Sje3KrN21JXjB1CsvsAP7ThzF
	 2xwy9iONeWq/AxGW+xkBOVsHPzjcdbpEr80eIQ88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Quadros <rogerq@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 467/523] usb: musb: omap2430: fix device leak at unbind
Date: Tue, 26 Aug 2025 13:11:17 +0200
Message-ID: <20250826110935.963394045@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 1473e9e7679bd4f5a62d1abccae894fb86de280f ]

Make sure to drop the reference to the control device taken by
of_find_device_by_node() during probe when the driver is unbound.

Fixes: 8934d3e4d0e7 ("usb: musb: omap2430: Don't use omap_get_control_dev()")
Cc: stable@vger.kernel.org	# 3.13
Cc: Roger Quadros <rogerq@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20250724091910.21092-5-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ Removed populate_irqs-related goto changes ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/omap2430.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -403,13 +403,13 @@ static int omap2430_probe(struct platfor
 			ARRAY_SIZE(musb_resources));
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add resources\n");
-		goto err2;
+		goto err_put_control_otghs;
 	}
 
 	ret = platform_device_add_data(musb, pdata, sizeof(*pdata));
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add platform_data\n");
-		goto err2;
+		goto err_put_control_otghs;
 	}
 
 	pm_runtime_enable(glue->dev);
@@ -424,7 +424,9 @@ static int omap2430_probe(struct platfor
 
 err3:
 	pm_runtime_disable(glue->dev);
-
+err_put_control_otghs:
+	if (!IS_ERR(glue->control_otghs))
+		put_device(glue->control_otghs);
 err2:
 	platform_device_put(musb);
 
@@ -438,6 +440,8 @@ static int omap2430_remove(struct platfo
 
 	platform_device_unregister(glue->musb);
 	pm_runtime_disable(glue->dev);
+	if (!IS_ERR(glue->control_otghs))
+		put_device(glue->control_otghs);
 
 	return 0;
 }



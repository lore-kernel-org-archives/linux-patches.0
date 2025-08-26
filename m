Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9A31E500C;
	Tue, 26 Aug 2025 14:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219456; cv=none; b=hcOWKAAZfpDWWmoFuahjrW46M/PYc0uhleohS/xfNPxYaqFkcCu+dCzTSkDZZwIwYP88/EaplSUaGZgtq9LAH4UZvDlmRWd37puTDEx9ERCFnNBGxCb5tB/BaNZOBA60zmlZI/6S8EGiIf7dBwYzSkDEo/JDsZ2bYrca6M/t6jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219456; c=relaxed/simple;
	bh=mFv9DMMQvUq3/ztyOE7UxKa3bI/3lbOVen4bdZUTbjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RlBvXbJ56LJqFx++giq+unP+VWhWA9+coe0zhjXoBSfNQ4Yy/HnlAVlqJv8XSmvsRQaXdFmbn+D1qz7hxGC1OATuHrgweosKNJyk/qz4UfoA/eYRG+8Bhe/hDY64uLsCnDY+cLr3mAHOVEHYU+7wr3kdDYC6SumhIz5fxIbyfKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PCjRBBFn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PCjRBBFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EB1C4CEF1;
	Tue, 26 Aug 2025 14:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219456;
	bh=mFv9DMMQvUq3/ztyOE7UxKa3bI/3lbOVen4bdZUTbjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PCjRBBFnGmdXc8MurlF9pmwohkfR84Bse0jYIUUisryAFkWl20OGmLbQjfOucJyua
	 fWjbVxpJE9bFEKXdSRYy3TT/UMA5ZXDYo/ZSZLVvXZQn7etm9JMbBMz91VDjLAqKj6
	 jL+Zm/2T/saP5hLt5CZtavAyYaPALAvbspZ3f+uY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Quadros <rogerq@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 358/403] usb: musb: omap2430: fix device leak at unbind
Date: Tue, 26 Aug 2025 13:11:24 +0200
Message-ID: <20250826110916.880308413@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -476,13 +476,13 @@ static int omap2430_probe(struct platfor
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
@@ -497,7 +497,9 @@ static int omap2430_probe(struct platfor
 
 err3:
 	pm_runtime_disable(glue->dev);
-
+err_put_control_otghs:
+	if (!IS_ERR(glue->control_otghs))
+		put_device(glue->control_otghs);
 err2:
 	platform_device_put(musb);
 
@@ -511,6 +513,8 @@ static int omap2430_remove(struct platfo
 
 	platform_device_unregister(glue->musb);
 	pm_runtime_disable(glue->dev);
+	if (!IS_ERR(glue->control_otghs))
+		put_device(glue->control_otghs);
 
 	return 0;
 }



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B482626ED46;
	Sat, 12 Sep 2026 19:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242437; cv=none; b=X2vy5AWyRgnSje8f2lYbzY619UGBVgkRtBqqmEfAEKtPLHGHXtul2wdF5MncyoSyxApQAyZJB5DxIqVLCU89w8ATKgPwDeoL9swhH/UD5YraKYtx57l8IAboX6+7GrYyUGSS6t6aNXGL/nvROIJLVFw6het3uHPfWzDXJ62g6ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242437; c=relaxed/simple;
	bh=zZy+r2twDn71bsLnyHIsldCDncuI8KsfVGa0/0wTUX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIFDYR7d5o/ACWiVKyTIOCPOZPzqN3pzOLSlgR6NqB+DLfZoCSWgbusogWLx2YhLaJknxSwjeD4+zDEd21d2zFKacxQEEjaW9TY0Xv5EjL0UrT3zlCUHwvo4CcpCXVobCF40krxnbN/v6h/TiIL4q24LnIzCDKudaWyZYOfd1Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DAHNyrMT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DAHNyrMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1721F000FF;
	Sat, 12 Sep 2026 19:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242436;
	bh=xHX0J/XAmJyFJ/ANmzyMlIPIxxeEtSuOO+2M7+zd8i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DAHNyrMTMlRfCLbACqIvHmxwsXnOzU45KNUmB4c41EO2KxVyVijgGPjixCuUaUbT9
	 gkuv1GRgLBOixOzqTuXuCDxoGRyGYEPfG5xXwMs3BNsbbYcqvQxGWZ4/PaCQW6p7F2
	 Cy9j0I7fhMssGaQEPEVCiQGcAQ+Yh5O4E8fOZSeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Slavin Liu <220245772@seu.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 403/798] usb: gadget: r8a66597: avoid double free of ep0_req in probe error path
Date: Sat, 12 Sep 2026 09:00:31 +0200
Message-ID: <20260912065526.384706728@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit 41d541e3718db01668a4cd29815ee4b3b55f76d2 ]

If usb_add_gadget_udc() fails, r8a66597_probe() jumps to err_add_udc
and frees ep0_req, then falls through to clean_up2 where ep0_req is
freed again when it is non-NULL.

Remove the redundant free from err_add_udc and keep the cleanup in
clean_up2 so the request is released exactly once.

Fixes: 776976a67ae2 ("usb: gadget: r8a66597-udc: cleanup error path")
Issue found using a prototype static analysis tool
and confirmed by code review.

Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Signed-off-by: Slavin Liu <220245772@seu.edu.cn>
Link: https://patch.msgid.link/20260624140908.1282-1-getshell@seu.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/r8a66597-udc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/r8a66597-udc.c b/drivers/usb/gadget/udc/r8a66597-udc.c
index 38e4d6b505a05..e36eacc0f4d72 100644
--- a/drivers/usb/gadget/udc/r8a66597-udc.c
+++ b/drivers/usb/gadget/udc/r8a66597-udc.c
@@ -1953,7 +1953,6 @@ static int r8a66597_probe(struct platform_device *pdev)
 	return 0;
 
 err_add_udc:
-	r8a66597_free_request(&r8a66597->ep[0].ep, r8a66597->ep0_req);
 clean_up2:
 	if (r8a66597->pdata->on_chip)
 		clk_disable_unprepare(r8a66597->clk);
-- 
2.53.0




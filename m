Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EE527FB37;
	Sat, 12 Sep 2026 16:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229498; cv=none; b=LXeC4WP5Of5ADKu4AwZF3QY1NJzgh7311AXTTloC28R4eVKfe+XFtsfcid/cYwcsOxOgzD8kD5PBZVYcj2V1AgNEt3JrYnk1iqI7ouDQ+sjJvU3NS5fx9R6OTbHAx6YBtKE146Bpq81Y+Ep4hCDieosqVIYRkBtvR1vAWj+B9AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229498; c=relaxed/simple;
	bh=rBh9ATOjL30GKlRzaWrmt3ypgXSZwc6yBo5VZLZyt0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbATrSx8ZIGIHBxMbwtptwqhVk5PB6wP6PJRU4tdDuCQTlj/HJ/jOro60oKE0HORibnHJl/hwIlrlKBB7b67ZtD5afIvAl9Qc/v+M5n+p91AXVwute9yJ43FyXwH6lk7atI7jQrc23cSzzj/wZHDS4ATnOrwrAz+nD6PTdhpfQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kV3buofM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kV3buofM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1104F1F000FF;
	Sat, 12 Sep 2026 16:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229497;
	bh=T0r17OB0UfG/OEyPIuOY+wE325cJeypvbObJd2Juf2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kV3buofMF8LBTcyZ6pGipI2S27Ap/0uyJye383+3Mxy/9QejZFSw9heGusRd7wQGb
	 NB9s0qlsSDK2qjrOGKKmgo5OfYjYMokUKBXFDF+XNzajz7/cURcVnt8O98XDieYr9N
	 0crHQz6XmJBrbVepVxVt2zQkfBihMdeOkwndrJfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Slavin Liu <220245772@seu.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0560/1191] usb: gadget: r8a66597: avoid double free of ep0_req in probe error path
Date: Sat, 12 Sep 2026 08:54:48 +0200
Message-ID: <20260912065600.822557843@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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




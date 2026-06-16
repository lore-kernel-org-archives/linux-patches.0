Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705603C09E1;
	Tue, 16 Jun 2026 18:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633068; cv=none; b=pwzITr0Wc+I2N7j72ylVZ0HkQMmFrxQzJTtO/+xb9FOOB11c7y2uu5iFQ4j10f68AgdNjcKDwdhrwGKszUY6NqEe4V1V2TAQrqZE3INEfFNYaASN0PAgIZaCVkNsal2lo74B5t/5102kH1jh2vWU5yFY+p1IIT/7j7ZN56YukII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633068; c=relaxed/simple;
	bh=oCfvSNY7mAgLvUTeVcrZ6PxJLsP3YT1Buygso2OqCRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PgST591/eexvfyHJwIVA1S0LUpuIMm1sjSmQVFv2w6fiQj+dmiEHgwGzHK/rLUeoMDy0+prvpVcLGC9NSt7iFZkbsTncaZ8Eo9upOfOUI1O92/Sglo//sAM7vL7ZnV/T0bXQ30ZsCAjvG/zYJLHdbrXJVSZ6zxdH0off9l4HK/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WPwzJP54; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WPwzJP54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8631F000E9;
	Tue, 16 Jun 2026 18:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633067;
	bh=896ggkoYY2g/r76ALX9SU08WbofWDlfp0GgFDnAcS9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WPwzJP54wWCDDGpx/sv+6XMY31NWx74I6bYKfhfoHS5o6blzvkWBq0IcD3XWTUePG
	 XcGwUrVftxWVu4RQyVXju0BemvPn0Uu+gu8+0U+fK5+P2utqz8T1WQbLOZjgqJxM60
	 wNuH29oJCRo0QNssul9FrU74tIdC4p6K3DooQAlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <benh@debian.org>
Subject: [PATCH 6.1 520/522] fbdev: vt8500lcdfb: Fix dma_free_coherent() cpu_addr parameter
Date: Tue, 16 Jun 2026 20:31:07 +0530
Message-ID: <20260616145150.038498380@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Ben Hutchings <benh@debian.org>

Before commit 63a11adaceb8 "fbdev/vt8500lcdfb: Initialize fb_ops with
fbdev macros", the virtual address of the screen buffer was stored in
the fb_info::screen_base field and not fb_info::screen_buffer.  The
backport of commit 88b3b9924337 ("fbdev: vt8500lcdfb: fix missing
dma_free_coherent()") did not take that into account.

Change the cpu_addr parameter to dma_free_coherent() accordingly.

Fixes: 778f31be5b8c ("fbdev: vt8500lcdfb: fix missing dma_free_coherent()")
Signed-off-by: Ben Hutchings <benh@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/vt8500lcdfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/fbdev/vt8500lcdfb.c
+++ b/drivers/video/fbdev/vt8500lcdfb.c
@@ -434,7 +434,7 @@ failed_free_palette:
 			  fbi->palette_cpu, fbi->palette_phys);
 failed_free_mem_virt:
 	dma_free_coherent(&pdev->dev, fbi->fb.fix.smem_len,
-			  fbi->fb.screen_buffer, fbi->fb.fix.smem_start);
+			  fbi->fb.screen_base, fbi->fb.fix.smem_start);
 failed_free_io:
 	iounmap(fbi->regbase);
 failed_free_res:



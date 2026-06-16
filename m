Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D473A3DE45B;
	Tue, 16 Jun 2026 19:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636971; cv=none; b=uaDTuflUtn//XRt8CyW1K6z8zmvVzTAwnI3KKGQCHuEJijGUUdJwwccHEprVOJ162Y2EhZjdP8VawZ6OJ7NLvb+MQ6b7KdIf9v1DWFdDrU1/DexAzqYu5fPe0JRaMk1mVW8HauWDkYraV0fHZXPp8359fe0lu05aHXbzjIxqLHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636971; c=relaxed/simple;
	bh=1QXDDcy4/yhhjcnWxgeB7Z665HKA6xwMiaecrylnEFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BZXppiFXjIVb2XxHGGJNAqng8MDJee24vFbFkRUbiSimuokOCNUocAwAEViVpfLrXM7+G1qyseehKW90YoO5/vG6+usL2yRkONdnIhv9MWCmnl9zKX7aGK9D6MPwWq/5WDGjcNrTYKdugBPkRtrY/eHpX0ya04Lgaq6sft1QtmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpXnM4MX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpXnM4MX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD93E1F000E9;
	Tue, 16 Jun 2026 19:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636970;
	bh=qNm4CD78uaNN/d/wxZmWb0GRwwlFXCTSi8kCovIItc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zpXnM4MXaoLsQdApL6srk0dgDjhc3tsWguUxaJq1nGe+JNxoCrxd79ak7E2QHCSTl
	 ZecXL33ydQqrh41KHJ7QFT0vm9hwAnAIgMEzuWDRgVUAoBYmeQpTX+5a6dwdwE3Pg/
	 JVSkz13sWPeKdn4DoBrsYXDZkLOfPVDOrqtRwmNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <benh@debian.org>
Subject: [PATCH 5.10 340/342] fbdev: vt8500lcdfb: Fix dma_free_coherent() cpu_addr parameter
Date: Tue, 16 Jun 2026 20:30:36 +0530
Message-ID: <20260616145104.485230861@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

From: Ben Hutchings <benh@debian.org>

Before commit 63a11adaceb8 "fbdev/vt8500lcdfb: Initialize fb_ops with
fbdev macros", the virtual address of the screen buffer was stored in
the fb_info::screen_base field and not fb_info::screen_buffer.  The
backport of commit 88b3b9924337 ("fbdev: vt8500lcdfb: fix missing
dma_free_coherent()") did not take that into account.

Change the cpu_addr parameter to dma_free_coherent() accordingly.

Fixes: 9a9bc60ed372 ("fbdev: vt8500lcdfb: fix missing dma_free_coherent()")
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



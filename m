Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215162;
	b=aVE7Y9e4g1KNbXEPxR0a15T3eM4ksRNlgCNOQAFkt/YrYUQJb43NvdhQItGLHXo0UUEx
	 i4b0lNOgtK34DcGGySMWcUgSXuS+OIR5O22Gzob4RcZ/PXtkr9Qd2HJzat5mOej68Vtai
	 z9MzxCnBC3AHuZ/+cJIvgHa/+nDUR3O88To5IShnyEsYYPH9z9qSLA95c3WFGMZL9XmMV
	 fuymx4aqB6YDUTCB69STHsqA2rIqZ5KY6IEGtCVcSxjptXS88d+ujvZJPLMX+RrEMdFrf
	 6zMjXlqLG65TKU8rOqkvyQAcnutwiX2Q6EFFaIx8meuYKcdER9O9Dw952RmafDBU1tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215162;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1jFIRWz4OmXBsTJVPcZ+dV3j78weif6GjAytIl4CzgM=;
	b=Jd4NjfPcFn0/GElQV0Xh+5Cqpswhs8+RvlQYdRbD98cMs8UKPiWjDMxLZatf8hyj2QLW
	 cwRlCBVjiaWckJBaYFLIfmxI3R1AzMiJFogVm+xtLdnF5tlBdKiaoFVmNOvj9t4zP4peo
	 3fkPB5o3CtV7CObhRTEv8djrO+tuV7wN5yOm1e90Z2UrG6Emy9P+YzpFZXaJEv6M2n0Nu
	 ucXgGxTQKjZdeocqNlaRsvQwmko9POO4nqybj5CbVAWiz9+rfvwZOeSB/1YIf/rC7DZ54
	 /qWIBxQyCAJaq5SvH1EOtEcClcyeQoV3NGzlRoUFW6YF3AqxFe59z36pOQWmhUEXGkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OjtDYt2T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E9F606A31A;
	Wed, 28 Oct 2026 19:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OjtDYt2T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB481F01825;
	Wed, 28 Oct 2026 19:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215161;
	bh=1jFIRWz4OmXBsTJVPcZ+dV3j78weif6GjAytIl4CzgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OjtDYt2TpFa84uuHxGyRAIuUqTMVdUpovXrlGuLaFKCZZQczCsm8Nw0AyZvmIz+7j
	 lkanYNYHx3g916JV5OMd0IB0mLGzAFlxh0of7qLpnBVLuPHEmk1R8LTTk6+vjvMQv0
	 BOpB+vHMC2ikuaaL1JWiCflqp7cXRnMSb/bbIicU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1114/1887] fbdev: omap2: fix use-after-free in omapfb_mmap
Date: Wed, 28 Oct 2026 17:53:30 +0100
Message-ID: <20261028170524.753718224@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 7958e67375aa111522086286bba13cfc0816ce8d ]

omapfb_mmap() has a race condition with OMAPFB_SETUP_PLANE ioctl that
can lead to use-after-free:

The fb_mmap() entry point holds mm_lock but not lock (fb_info->lock),
while ioctl handlers like OMAPFB_SETUP_PLANE hold lock but not mm_lock.
This allows concurrent execution.

In omapfb_mmap():
1. rg = omapfb_get_mem_region(ofbi->region);      // Get old region ref
2. start = omapfb_get_region_paddr(ofbi);          // Read from NEW region
3. len = fix->smem_len;                             // Read from NEW region
4. vm_iomap_memory(vma, start, len);               // Map NEW region memory
5. atomic_inc(&rg->map_count);                      // Increment OLD region!

Concurrently, OMAPFB_SETUP_PLANE can:
- Reassign ofbi->region = new_rg
- Update fix->smem_len
- OMAPFB_SETUP_MEM then checks NEW region's map_count (0!) and frees it

This leaves userspace with a mapping to freed physical memory.

The fix is to read all required values (start, len) from the same
region reference (rg) that will have its map_count incremented,
preventing the region from being freed while still mapped.

Cc: stable@vger.kernel.org
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/omap2/omapfb/omapfb-main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/omap2/omapfb/omapfb-main.c b/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
index dc91d10209da2..7e6e177ad2af4 100644
--- a/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
+++ b/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
@@ -1097,7 +1097,11 @@ static int omapfb_mmap(struct fb_info *fbi, struct vm_area_struct *vma)
 
 	rg = omapfb_get_mem_region(ofbi->region);
 
-	start = omapfb_get_region_paddr(ofbi);
+	if (ofbi->rotation_type == OMAP_DSS_ROT_VRFB)
+		start = rg->vrfb.paddr[0];
+	else
+		start = rg->paddr;
+
 	len = fix->smem_len;
 
 	DBG("user mmap region start %lx, len %d, off %lx\n", start, len,
@@ -1107,6 +1111,8 @@ static int omapfb_mmap(struct fb_info *fbi, struct vm_area_struct *vma)
 	vma->vm_ops = &mmap_user_ops;
 	vma->vm_private_data = rg;
 
+	atomic_inc(&rg->map_count);
+
 	r = vm_iomap_memory(vma, start, len);
 	if (r)
 		goto error;
@@ -1119,6 +1125,7 @@ static int omapfb_mmap(struct fb_info *fbi, struct vm_area_struct *vma)
 	return 0;
 
 error:
+	atomic_dec(&rg->map_count);
 	omapfb_put_mem_region(rg);
 
 	return r;
-- 
2.53.0




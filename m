Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C760A368276;
	Fri,  7 Aug 2026 14:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114387; cv=none; b=JgfefgEfaapUA1yVrKXQnpcdM/Zj9xlE74mOiI5evK15ZHsuUPAv2LHH+bcvfGPgZTZXVYCGbmc+xRA/lannvuZK8DGybeb41AT5M1DH2TrMW1Paq23RW8Y98974vxMRkNJ2uf3apJE7MgyldJHMG2//kBKNWZcq6oFTYp/A9ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114387; c=relaxed/simple;
	bh=KFFaA4Ovkp//97vtygaBlbbAfwyoS3RqNRfUUOCiNPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=inny8dJE+FJepUe556wqqv6HzkOa0D731R5uDeoE+mBYGOyQB4m9V6DZnWJYFK9w89Nf3m1h2hHWVGGTVbvyqe9HyTl4pwRoMl+MYA4GZYH26PZyswvBV/eJosdeq4XIeYM98X4p39qEYXdNnJs/Z17bgz3zCEbStKzWBOPKbzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNSHPVnB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNSHPVnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F6D1F000E9;
	Fri,  7 Aug 2026 14:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114385;
	bh=xQy1bBRHII9ymc1qON/SRI5jIrTd0hiu32vNtjprNjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fNSHPVnBQthjga7HYN9+3mdVBqVVyuxkQkWMwG9/R5AxGSMDYhxHeLiNEuiuljGJ4
	 eic4/q4OjISyew9Zy8iia+bM8g0b+onu5yBFqQHwxW+kDK9MbvQo1KetGsW27Ro+P8
	 MZ/l4u8TfoGGCcsEDkwP9dGHKd7jtYbgP589XRrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Maria Casanova Crespo <jmcasanova@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>
Subject: [PATCH 6.12 245/337] drm/vc4: Supply the overflow slot size in BPOS, not the whole bin BO size
Date: Fri,  7 Aug 2026 16:37:28 +0200
Message-ID: <20260807143423.860923684@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Maria Casanova Crespo <jmcasanova@igalia.com>

commit 6395789e4739aa5177bbec0fa0f07ccc38d249b0 upstream.

vc4_overflow_mem_work() points BPOA at a 512KB slot inside the 16MB
binner BO, but writes the size of the whole BO to BPOS. On every binner
out-of-memory event the PTB is therefore authorized to write tile lists
across all the other slots (which may hold the tile state, tile alloc and
overflow memory of in-flight jobs) and, for any slot but the first, past
the end of the binner BO into unrelated CMA memory.

Since CMA pages are recycled into page cache and user allocations, this
is arbitrary memory corruption by GPU DMA. In practice it shows up as GPU
hangs with corrupted control list pointers, userspace heap corruption, a
GPU that stays permanently wedged after the first hang, and occasional
full system crashes, whenever a job overflows the initial binner slot.

The bug dates back to the conversion from a dedicated overflow BO (where
writing the full BO size was correct) to the slotted binner BO.

Fixes: 553c942f8b2c ("drm/vc4: Allow using more than 256MB of CMA memory.")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Jose Maria Casanova Crespo <jmcasanova@igalia.com>
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Link: https://patch.msgid.link/20260727-vc4-bin-oom-fixes-v2-1-0d8a5eddc7c9@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/vc4_irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/vc4/vc4_irq.c
+++ b/drivers/gpu/drm/vc4/vc4_irq.c
@@ -104,7 +104,7 @@ vc4_overflow_mem_work(struct work_struct
 	vc4->bin_alloc_overflow = BIT(bin_bo_slot);
 
 	V3D_WRITE(V3D_BPOA, bo->base.dma_addr + bin_bo_slot * vc4->bin_alloc_size);
-	V3D_WRITE(V3D_BPOS, bo->base.base.size);
+	V3D_WRITE(V3D_BPOS, vc4->bin_alloc_size);
 	V3D_WRITE(V3D_INTCTL, V3D_INT_OUTOMEM);
 	V3D_WRITE(V3D_INTENA, V3D_INT_OUTOMEM);
 	spin_unlock_irqrestore(&vc4->job_lock, irqflags);



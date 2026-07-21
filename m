Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B3439733E;
	Tue, 21 Jul 2026 22:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674512; cv=none; b=ZdMUsTn31QOY/5g1McHMfdfRFJWuHW1hE3zqdQC5vIsfp/X0t0a88v6Z7pdfwZk0LK0cRTSsFTqvgYTesD3KsC8rivC2rCggvG6UhvjeBdAz+jdYHvI3VOWBFyAzkISu0t/LaxPt3klZSpyj+xjnlwuN4khJfvd0PWl67YpAH/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674512; c=relaxed/simple;
	bh=FVJy48Tgvy+QKQqcKc+dYLgkLwksUA9mPazrWcsey1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZnTTku/4YX9jw/nVeX6QLb8a5Udf2ajpv7LQMDoHsWvIkEaA0YuI/Pl3XOGvAWgGZ+zzZFQ3JhihU45moQFonTFz4tShDbyMAOXb1tgEVTpaEViIA5N/ywcJhJcgDIt82MX40782EtDRlCWssOqN0B+d6uvGUKY68vdEncmOLiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fc7AKJ7H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fc7AKJ7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE731F000E9;
	Tue, 21 Jul 2026 22:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674511;
	bh=p5lENLHbNJ6Ee1W0kjhXbLI+2yp9F1RERSdkrur0xaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fc7AKJ7HZpb/Oq1rxH2VZVWajyZNe/Lrbtjm5+FvfcrbF1ukRlkHk/iXlTZbb5QNm
	 bFerjl1VaXCan7Anw5nSWzRb3u5n6vUVWfjPgnWJK2coprgCQryCRrpGSUUukVOQN4
	 y2QFBAuSj47OTkx5/ubPTh8ZdPtC7y4P9XznPlvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 5.10 569/699] powerpc/spufs: fix out-of-bounds access in spufs_mem_mmap_access()
Date: Tue, 21 Jul 2026 17:25:28 +0200
Message-ID: <20260721152408.544026222@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

commit 47b87f469a35b5ffc81c16eee6b13a9b6c8d55c6 upstream.

spufs_mem_mmap_access() computes the local store offset as
address - vma->vm_start, but bounds-checks it against vma->vm_end
instead of the local store size. On 64-bit, offset is always well
below vma->vm_end, so the clamp never fires and len stays unbounded
against the LS_SIZE buffer returned by ctx->ops->get_ls().

Reject offsets at or beyond LS_SIZE and clamp len to the remaining
space, mirroring the guard already used by spufs_mem_mmap_fault() and
spufs_ps_fault().

Fixes: a352894d0705 ("spufs: use new vm_ops->access to allow local state access from gdb")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/SYBPR01MB7881EE775E8B51C09F5A29E7AF152@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/cell/spufs/file.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/powerpc/platforms/cell/spufs/file.c
+++ b/arch/powerpc/platforms/cell/spufs/file.c
@@ -268,10 +268,12 @@ static int spufs_mem_mmap_access(struct
 
 	if (write && !(vma->vm_flags & VM_WRITE))
 		return -EACCES;
+	if (offset >= LS_SIZE)
+		return -EFAULT;
 	if (spu_acquire(ctx))
 		return -EINTR;
-	if ((offset + len) > vma->vm_end)
-		len = vma->vm_end - offset;
+	if ((offset + len) > LS_SIZE)
+		len = LS_SIZE - offset;
 	local_store = ctx->ops->get_ls(ctx);
 	if (write)
 		memcpy_toio(local_store + offset, buf, len);



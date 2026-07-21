Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E76834B1A6;
	Tue, 21 Jul 2026 21:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670435; cv=none; b=ZzBtBVFKkcO4mF9LyoArU4MUFQYn06IoP/bRcRI5SghCiNGp3wzy4WY5gM+kO7lujMIhJcuCP/XSpIa8jIyDKruBNTduSAyf4cjRbkW6OhwRL4wKymyobLgpzP8uE7MGj0yjuImH/cq0pZvlvyot3uj4aTNNUpRlomPXw6qMB5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670435; c=relaxed/simple;
	bh=v5JtNOnkhoTfStnCXI1ikkwKEd2rr42y+VEvENW6oIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTnDi5R4REGYyYmUE7IP5aiakQTk5PY19Gz9rncwiz+ttTP8RVPxTX8590wuw6Kp8NulQppMwnzk6L1Ni6AzBmJtOg0bp9EqY1/ZMWzaeDEdE3ISKqk4WvUL2ttZGfocIZkXMXs8xz73YRXZC+UFXJMFao/tdf+lThTTG4wh9qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LD1t7Etz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LD1t7Etz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534841F000E9;
	Tue, 21 Jul 2026 21:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670433;
	bh=flZwqN/6dTpIyjv2RSrrPCRygOeDz34xP/KU8FRlwV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LD1t7EtzbHAGxc+mfF9RjWGtAWzEbXQMd3Lmq9DEirr0OJxpuj0sSzPbGLbsqPY0E
	 r+NlnDpj/1+P95XtNiFqajn00JRRCokH2W72VT9trYbC8zpTUHQIw4/fphYdd40+IY
	 ftCYxBZoI1AN7sH2zr55VAoSR3QNmuLQDOupmXRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.1 0929/1067] powerpc/spufs: fix out-of-bounds access in spufs_mem_mmap_access()
Date: Tue, 21 Jul 2026 17:25:30 +0200
Message-ID: <20260721152445.314222228@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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



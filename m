Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4767C35388B;
	Fri, 21 Nov 2025 13:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733404; cv=none; b=VMLaaRvY5fYQFhtP/4bCozR1DIz5dUaFEdcI7NVk7HTS9To7xWfL0dTa7DeMOaCXO/xU4Y4vArlnRA0cghmiGUo4MHTEf2DySAJKhMjXY7tWmPowhknMXPAbxxD8TiL34AfGRrDrA4bZdmg2VkxnTv/h7A19Y0AHBE77C5O+5Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733404; c=relaxed/simple;
	bh=5T1I+WHE6W26R6pi8KePN/EFVLxTDINXoQZeS51tc98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6uUmGm8QrhiN7RRH8yn8NPrrlywWSG3jmUJc8m2FilaZ1P8XUrHVsl8EvLwOx1TMCjzBSSZ5b3PKBX37wUgxsgT4WJRNBzr4XRucbc0mn3wtf/MhU6wgCLJc75odmXNCnRtlAWJs+m2d4QHS8PXXLdwCCkHo8Pf3IMtN5DnsCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VJMSPKhF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VJMSPKhF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917BCC116C6;
	Fri, 21 Nov 2025 13:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733403;
	bh=5T1I+WHE6W26R6pi8KePN/EFVLxTDINXoQZeS51tc98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VJMSPKhFs3BIitYg1srm7mLJVjK/ZBH0sQ4Ybv7IoePyG9aUwsYoG1i1W5ZaGDF9H
	 pgDRUu+wFbuxHVqJKhpIhDJHsJNL5iHrg/UrezfswykNu2LhiikSMZRc/OHZPinehe
	 Bz8f7qVRUOGLmjiMSID41/lVG5YwtwITWW3RvtWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	David Howells <dhowells@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.6 423/529] cifs: Fix uncached read into ITER_KVEC iterator
Date: Fri, 21 Nov 2025 14:12:02 +0100
Message-ID: <20251121130246.065763635@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

If a cifs share is mounted cache=none, internal reads (such as by exec)
will pass a KVEC iterator down from __cifs_readv() to
cifs_send_async_read() which will then call cifs_limit_bvec_subset() upon
it to limit the number of contiguous elements for RDMA purposes.  This
doesn't work on non-BVEC iterators, however.

Fix this by extracting a KVEC iterator into a BVEC iterator in
__cifs_readv()  (it would be dup'd anyway it async).

This caused the following warning:

  WARNING: CPU: 0 PID: 6290 at fs/smb/client/file.c:3549 cifs_limit_bvec_subset+0xe/0xc0
  ...
  Call Trace:
   <TASK>
   cifs_send_async_read+0x146/0x2e0
   __cifs_readv+0x207/0x2d0
   __kernel_read+0xf6/0x160
   search_binary_handler+0x49/0x210
   exec_binprm+0x4a/0x140
   bprm_execve.part.0+0xe4/0x170
   do_execveat_common.isra.0+0x196/0x1c0
   do_execve+0x1f/0x30

Fixes: d08089f649a0 ("cifs: Change the I/O paths to use an iterator rather than a page list")
Acked-by: Bharath SM <bharathsm@microsoft.com>
Tested-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: stable@kernel.org # v6.6~v6.9
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/file.c | 97 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 94 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 1f0a53738426e..92e43589fd83f 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -37,6 +37,81 @@
 #include "cifs_ioctl.h"
 #include "cached_dir.h"
 
+/*
+ * Allocate a bio_vec array and extract up to sg_max pages from a KVEC-type
+ * iterator and add them to the array.  This can deal with vmalloc'd buffers as
+ * well as kmalloc'd or static buffers.  The pages are not pinned.
+ */
+static ssize_t extract_kvec_to_bvec(struct iov_iter *iter, ssize_t maxsize,
+					unsigned int bc_max,
+					struct bio_vec **_bv, unsigned int *_bc)
+{
+	const struct kvec *kv = iter->kvec;
+	struct bio_vec *bv;
+	unsigned long start = iter->iov_offset;
+	unsigned int i, bc = 0;
+	ssize_t ret = 0;
+
+	bc_max = iov_iter_npages(iter, bc_max);
+	if (bc_max == 0) {
+		*_bv = NULL;
+		*_bc = 0;
+		return 0;
+	}
+
+	bv = kvmalloc(array_size(bc_max, sizeof(*bv)), GFP_NOFS);
+	if (!bv) {
+		*_bv = NULL;
+		*_bc = 0;
+		return -ENOMEM;
+	}
+	*_bv = bv;
+
+	for (i = 0; i < iter->nr_segs; i++) {
+		struct page *page;
+		unsigned long kaddr;
+		size_t off, len, seg;
+
+		len = kv[i].iov_len;
+		if (start >= len) {
+			start -= len;
+			continue;
+		}
+
+		kaddr = (unsigned long)kv[i].iov_base + start;
+		off = kaddr & ~PAGE_MASK;
+		len = min_t(size_t, maxsize, len - start);
+		kaddr &= PAGE_MASK;
+
+		maxsize -= len;
+		ret += len;
+		do {
+			seg = umin(len, PAGE_SIZE - off);
+			if (is_vmalloc_or_module_addr((void *)kaddr))
+				page = vmalloc_to_page((void *)kaddr);
+			else
+				page = virt_to_page((void *)kaddr);
+
+			bvec_set_page(bv, page, len, off);
+			bv++;
+			bc++;
+
+			len -= seg;
+			kaddr += PAGE_SIZE;
+			off = 0;
+		} while (len > 0 && bc < bc_max);
+
+		if (maxsize <= 0 || bc >= bc_max)
+			break;
+		start = 0;
+	}
+
+	if (ret > 0)
+		iov_iter_advance(iter, ret);
+	*_bc = bc;
+	return ret;
+}
+
 /*
  * Remove the dirty flags from a span of pages.
  */
@@ -4330,11 +4405,27 @@ static ssize_t __cifs_readv(
 		ctx->bv = (void *)ctx->iter.bvec;
 		ctx->bv_need_unpin = iov_iter_extract_will_pin(to);
 		ctx->should_dirty = true;
-	} else if ((iov_iter_is_bvec(to) || iov_iter_is_kvec(to)) &&
-		   !is_sync_kiocb(iocb)) {
+	} else if (iov_iter_is_kvec(to)) {
+		/*
+		 * Extract a KVEC-type iterator into a BVEC-type iterator.  We
+		 * assume that the storage will be retained by the caller; in
+		 * any case, we may or may not be able to pin the pages, so we
+		 * don't try.
+		 */
+		unsigned int bc;
+
+		rc = extract_kvec_to_bvec(to, iov_iter_count(to), INT_MAX,
+					&ctx->bv, &bc);
+		if (rc < 0) {
+			kref_put(&ctx->refcount, cifs_aio_ctx_release);
+			return rc;
+		}
+
+		iov_iter_bvec(&ctx->iter, ITER_DEST, ctx->bv, bc, rc);
+	} else if (iov_iter_is_bvec(to) && !is_sync_kiocb(iocb)) {
 		/*
 		 * If the op is asynchronous, we need to copy the list attached
-		 * to a BVEC/KVEC-type iterator, but we assume that the storage
+		 * to a BVEC-type iterator, but we assume that the storage
 		 * will be retained by the caller; in any case, we may or may
 		 * not be able to pin the pages, so we don't try.
 		 */
-- 
2.51.0




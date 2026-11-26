Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704892;
	b=S4jmjoqxNd618hv9lOPPqPfn/pTwWLXm1UDpAU6PytDqspvQOR45WE4172Xwv9H45eSd
	 3GevMRl9p+Q6CIAhP23sRZ1JRv4ANbuIzubcrjbaN2ZbLS/qxRunwETfLm0Ux+Ajj9UfQ
	 ubcXzcqSG5D/usjIWfY2RBFLUCZpa5VSHXj+CeiU3IQx90JjfDpgw/k5UA94nA3Xh4lwd
	 1WyqnZaMiFTmRH1iQQmk0AYNvXZQGak/6HdjNG1kZCsJKNFCGSiwiNRqRfPUIdaX72zH3
	 EFgNDSyMuIHsZ162O32jkz3GiK82X/+YBco/UTetsLpD22sv0qEV0b3e4Gdo4UtTvxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704892;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KO5NFWj01xgilf7zvYSeZYqfzVfQbc1Xd3ppGtDx1MU=;
	b=vhNSAvQMUwIuczQPr5q4i1xZmNUMF8Rot5MjorIAqg381rjz45ryTNQo2AGIMRgDIMsM
	 mbdqmv/4zP7jaJLXn0fEi6N4aqlsXLa8aB7gCdnUS1UhSAMl5h0b0AgDJ0SLg8YUjbp5s
	 JpInGWoD1MKHSE0/82AzN4Qd9Gwp0Albl0BhSkxVKhklVfBiaksPlxiy3IUS2Np+SXTLP
	 DL0zPwYftd2znV/Ay0fqNXgh0Ed3kArJd+uOZuzsKZsjZC0KfSzrka1akh8QwSgD+SfqW
	 HOPZh1pcUvnmZldzja92A2xAoXEvPmKeuVquQ00Rt7F+IvsygDjRicLFmI3rJinnokg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YB29hSIc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB84606A32A;
	Thu, 26 Nov 2026 14:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YB29hSIc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA15A1F000C6;
	Thu, 26 Nov 2026 14:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704892;
	bh=KO5NFWj01xgilf7zvYSeZYqfzVfQbc1Xd3ppGtDx1MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YB29hSIcZEAS2fE7BkebT7//uI9l5HpjhWP0JB/ldpCwNrz1p929A/qLsd8JEpRdW
	 m/x0CSpEXsg/9osxixbSrUDAEVnPEiF690WuUdzXiOocS1ViN2YS3bnZOO3/vQC1Wi
	 E/iP42sIwUz+ua8mXGW0IsGfnZt4Qtut453a82YU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huaweicloud.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/319] fs: aio: reject partial mremap to avoid Null-pointer-dereference error
Date: Thu, 26 Nov 2026 15:36:20 +0100
Message-ID: <20261126144007.017099860@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 3adf7ae18bf42601246031002287c103a27df307 ]

[BUG]
Recently, our internal syzkaller testing uncovered a null pointer
dereference issue:
BUG: kernel NULL pointer dereference, address: 0000000000000000
...
[   51.111664]  filemap_read_folio+0x25/0xe0
[   51.112410]  filemap_fault+0xad7/0x1250
[   51.113112]  __do_fault+0x4b/0x460
[   51.113699]  do_pte_missing+0x5bc/0x1db0
[   51.114250]  ? __pte_offset_map+0x23/0x170
[   51.114822]  __handle_mm_fault+0x9f8/0x1680
...
Crash analysis showed the file involved was an AIO ring file. The
phenomenon triggered is the same as the issue described in [1].

[CAUSE]
Consider the following scenario: userspace sets up an AIO context via
io_setup(), which creates a VMA covering the entire ring buffer. Then
userspace calls mremap() with the AIO ring address as the source, a smaller
old_len (less than the full ring size), MREMAP_MAYMOVE set, and without
MREMAP_DONTUNMAP. The kernel will relocate the requested portion to a new
destination address.

During this move, __split_vma() splits the original AIO ring VMA. The
requested portion is unmapped from the source and re-established at the
destination, while the remainder stays at the original source address as
an orphan VMA. The aio_ring_mremap() callback fires on the new destination
VMA, updating ctx->mmap_base to the destination address. But the callback
is unaware that only a partial region was moved and that an orphan VMA
still exists at the source:

  source(AIO):
  +-------------------+---------------------+
  |  moved to dest    |  orphan VMA (AIO)   |
  +-------------------+---------------------+
  A                 A+partial_len        A+ctx->mmap_size

  dest:
  +-------------------+
  |  moved VMA (AIO)  |
  +-------------------+
  B                 B+partial_len

Later, io_destroy() calls vm_munmap(ctx->mmap_base, ctx->mmap_size), which
unmaps the destination. This not only fails to unmap the orphan VMA at the
source, but also overshoots the destination VMA and may unmap unrelated
mappings adjacent to it! After put_aio_ring_file() calls truncate_setsize()
to remove all pages from the pagecache, any subsequent access to the orphan
VMA triggers filemap_fault(), which calls a_ops->read_folio(). Since aio
does not implement read_folio, this results in a NULL pointer dereference.

[FIX]
Note that expanding mremap (new_len > old_len) is already rejected because
AIO ring VMAs are created with VM_DONTEXPAND. The only problematic case is
a partial move where "old_len == new_len" but both are smaller than the
full ring size.

Fix this by checking in aio_ring_mremap() that the new VMA covers the
entire ring. This ensures the AIO ring is always moved as a whole,
preventing orphan VMAs and the subsequent crash.

[1]: https://lore.kernel.org/all/20260413010814.548568-1-wozizhi@huawei.com/

Signed-off-by: Zizhi Wo <wozizhi@huaweicloud.com>
Link: https://patch.msgid.link/20260418060634.3713620-1-wozizhi@huaweicloud.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/aio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/aio.c b/fs/aio.c
index 86532d483a8ea..0e46867c43a56 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -342,7 +342,8 @@ static int aio_ring_mremap(struct vm_area_struct *vma)
 
 		ctx = rcu_dereference(table->table[i]);
 		if (ctx && ctx->aio_ring_file == file) {
-			if (!atomic_read(&ctx->dead)) {
+			if (!atomic_read(&ctx->dead) &&
+			    (ctx->mmap_size == (vma->vm_end - vma->vm_start))) {
 				ctx->user_id = ctx->mmap_base = vma->vm_start;
 				res = 0;
 			}
-- 
2.53.0




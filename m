Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620924;
	b=xoXHnQFXPXWPyaO/PSfiqDiV6K4FmLp0sE6BYK2IdiWDPZUyUPOBrZqNgSAp3gwWeDK5
	 3YCcSDGKQTzvVPw+cWQQkE0RwYh+S9+IBojj2YrbncrjCQfNrTAstdrxRJfY1kcqnau93
	 dAuxjRR18fLqmw4Q2QEQiTkpS9roECfuKi0lLT6jPeZt4fou5Yj/TXVdg/ohIuFZLHmNp
	 Yr/Ep4aYiSwn1bAddw/Is6yuS8AlXlSxQK696S2m8DKJX6odKTT8gY5B4EbblH2fs8hsC
	 Eg+3Fg3iIsLOSv+IK562MJhd/2G65O7YyT1ENGm8A9xZHpPVT56uV/1UX+vy2zhLHbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620924;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8wAxcrvmrtB5K200z5fAW3m2z/R3OOER7sgIhHXP5UI=;
	b=2rcTj1KhYcDFE9zfHz9WXID8q9+qj2M18eqXdnXMsu7eW4+R/7aC/257+XodgiFf12kV
	 I1rWdxZBYqZxw6tCsbx1iff938niqXUFxKTvteBwNn8Jydpt+aasOQIwkruNlhd7LjA2K
	 mlkBDaMugeRLvZ6KJHo7A2tLzN8/YFM9z71KOBzZdRSdAOPjYMUoYP+t98QgflU7n2hcO
	 bnJhT2VXirj2Sphu/xKPdDKV3YxQiqOgRUdAFZjdci6poZD6LBP2PNR1CtmcJkHq57SNK
	 AxsepNA4iWOALMFvWfrcInuiujXHKUxatrFyjJmYRCe3NQB9GjKR3W0xPz5+bM2HEOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M2klITMV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4825606A323;
	Wed, 25 Nov 2026 15:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M2klITMV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D6B1F00A00;
	Wed, 25 Nov 2026 15:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620924;
	bh=8wAxcrvmrtB5K200z5fAW3m2z/R3OOER7sgIhHXP5UI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M2klITMV6XA28pNFRRpdady+nzIJ6naWlkAtPf+7BuokNyDEQpczcYLxJEAdy+7U/
	 joulTyPlX4pXzg0VeHNAAEPsIwS36is7+aPA19osoIc3kEHvus7wYysdWAPZS9fb+7
	 P1Vyy/8aXnVeQ7IMiCqxwh6bwgXUPr6c9ozqD/Ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huaweicloud.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 021/990] fs: aio: reject partial mremap to avoid Null-pointer-dereference error
Date: Wed, 25 Nov 2026 15:23:08 +0100
Message-ID: <20261125143822.585549510@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e06fa57b05ca9..641cf69bc959b 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -369,7 +369,8 @@ static int aio_ring_mremap(struct vm_area_struct *vma)
 
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




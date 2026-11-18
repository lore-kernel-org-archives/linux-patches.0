Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037138;
	b=ci1hdWDwcnnoDhUxQJ+HRnVFmHvF4FOnN2M3tE1AMM1WlFA4hv5DpwSp4UPQXOxZsNu+
	 lhKgErrPiy6bcwCr0+PMGHmN64MfjxB6OpHb+grCyMWQWqXkUdSOCZJ4deDXbBqJ3LDwX
	 /KpMlvMbQQdBMDd5+yAuvSEbvYtIgCf41/uI8zWIpJ775kyUZmndmuXJeSisNthmrPN9c
	 2Ty2foBMTHfUqz4P2RZeRvUEFFr3UAMrYnt9QOdoHEZK5COlw0CPDoaOiK7VgXqEvw7R8
	 DvQepxsHlhhUifncr7q5Yss3OvPD7iVN2bKFCto2Id9EWUrbO7WUEHtbm3Ao/kMSq4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kwRwDS6hQcPJm93NX6EQOOg3ELXcvBUoE3jKrUjb7jo=;
	b=CC7iQbMDSgm4v9p0ASu9p2P5dnjmCZZ04FFNV6Ff+BvtXUxKfPWgYTFgeKBljpjGRELL
	 xJfP7vdIUfkVIzPnEaYQrOjEfAYJWMAPGLa+WgFGJS5aSZzPyaXoIj4jYF12jwbUiQqKy
	 UfrTA5h9clHL+4XoEHNbn1aAA8YL5AyfW9S36wSMGiEsj7YOgGQOqAuKl4dGX4T4WlT4P
	 zLgciZTQ6tVvbTO8jFCD2UIFMkt8HFoFR1+XjqGnYMK9gndMZZmE8KSDlb3UmaAEMXtAu
	 /K6NjN7C5v9ebtsZrMf70dzPXrbaSO79PpOfzh1lgearNdqy1gRrMTviCkV5/sYVaXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Xn/lH9y4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C92460A3828;
	Wed, 18 Nov 2026 21:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xn/lH9y4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63FD1F000C8;
	Wed, 18 Nov 2026 21:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037138;
	bh=kwRwDS6hQcPJm93NX6EQOOg3ELXcvBUoE3jKrUjb7jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xn/lH9y4zXngOv/Nk3anbC+ASiTYLS7yECHdNIO2EgmGDGumpx+5l1O8t1awP8Jhr
	 2Kzix0IVdax+m1RLzkzXJga5ifwHWXzi1NZ2TcyKnBMH1/ih5uHYjCptDJIm4ERde1
	 CdGj8tNyDICxRqNL6ti5Abt/RVkuq+pRJWbtlAoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1290/3318] aio: fix NULL deref when a fault races ring truncation
Date: Wed, 18 Nov 2026 15:31:52 +0100
Message-ID: <20261118150358.965173549@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit d53b5aa5cfae27e4d236fc0ab9581085d27f7d33 ]

The aio ring lives in a file on the aio pseudo filesystem and the ring
VMA uses filemap_fault(). aio_ctx_aops doesn't have a ->read_folio
because aio_setup_ring() puts all folios of the ring into the page
cache. So a fault on the ring only works as long as it finds its folio
in the page cache. If it doesn't, filemap_fault() calls ->read_folio
without checking and we jump to NULL.

We already fixed this twice this year. A forked child could inherit the
ring mapping, fixed by commit c03ce4173c7b ("fs: aio: set
VMA_DONTCOPY_BIT in mmap to fix NULL-pointer-dereference error"). And a
partial mremap() could leave part of the ring mapped, fixed by
commit 3adf7ae18bf4 ("fs: aio: reject partial mremap to avoid
Null-pointer-dereference error"). Both times a VMA outlived the ring and
the ring file was truncated under it.

There's a third way to get there. kill_ioctx() and the error path of
ioctx_alloc() unmap the ring with vm_munmap() and ignore the return
value. If vm_munmap() has to wait for mmap_lock and a fatal signal is
pending it returns -EINTR and the VMA stays. free_ioctx() then calls
put_aio_ring_file() which truncates the ring file to zero. A fault that
passed the i_size check in filemap_fault() before that doesn't find its
folio anymore, allocates a new one and calls ->read_folio:

    fault on the ring                 io_destroy() with SIGKILL pending
    =================                 =================================
                                      vm_munmap() returns -EINTR
    filemap_fault()
      i_size check passes
                                      free_ioctx()
                                        put_aio_ring_file()
                                          truncate_setsize(inode, 0)
      no folio, allocate a new one
      filemap_read_folio()
        ->read_folio == NULL

All that's needed is a second process that shares the mm. If a CLONE_VM
child calls io_destroy() and gets SIGKILLed while it waits for mmap_lock
the ring stays mapped for the threads of the parent. Any user can do
that.

Instead of plugging the routes one by one give the ring a ->read_folio
that unlocks the folio and returns -EIO. All folios of a live ring are
in the page cache so a fault can only end up there if the ring was
truncated. The fault now gets SIGBUS. Nothing else reads the ring file
and the aio filesystem uses noop_backing_dev_info so there's no
readahead either.

Making vm_munmap() unkillable in those two places would only close this
one route and bring back what commit ae7987835643 ("mm: make vm_munmap
killable") fixed.

Fixes: 36bc08cc0170 ("fs/aio: Add support to aio ring pages migration")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Link: https://patch.msgid.link/20261029-work-fs-ai-fixes-v1-1-88f22792f6f7@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/aio.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/aio.c b/fs/aio.c
index 918ef4fea8531..8a4d95a825678 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -483,7 +483,18 @@ static int aio_migrate_folio(struct address_space *mapping, struct folio *dst,
 #define aio_migrate_folio NULL
 #endif
 
+/*
+ * filemap_fault() reads a folio that it did not find in the page cache. All
+ * folios of a live ring are there, so the ring was truncated under the fault.
+ */
+static int aio_read_folio(struct file *file, struct folio *folio)
+{
+	folio_unlock(folio);
+	return -EIO;
+}
+
 static const struct address_space_operations aio_ctx_aops = {
+	.read_folio	= aio_read_folio,
 	.dirty_folio	= noop_dirty_folio,
 	.migrate_folio	= aio_migrate_folio,
 };
-- 
2.53.0




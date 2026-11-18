Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060075;
	b=Y2FECJJg2Nxc9G2J1+AqHcQCYVDa23MVBKK6sOOPGCb2EKAFdE4sL0LAy64qOKnfshYG
	 VfYZ9KFhE3WIYvbVzIKALk7qKKp/0CfJcrZ1/c7KUBE/pLAtPKBFo/FEvxAZbUTwLSUMK
	 Zl2JR9gmE/EaqSUhOQFMB/niFbG+/jLc9B602rsGieiNasq6gwzsWUp3e3yVjGjdvWw47
	 j2esnYA/lB846Im1bHWJT2PvWR2VGJWGpENyzZhYpkSPfb6zuzAwmZfNUHyP2OZzKCp1H
	 MhebMJAHrIaxeh8pn59ID8FPS4o3f5bFPnoPZd3B08OKug+7pB1nTlFHhdkbWTirmtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060075;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RQHjeWUCLkth5N8BNJyxFeyf2RGC9CELwyYFz0Jb3tA=;
	b=AbMJJ1iDWJPQfY8DsmMt4DzRKO1a5rYsjHNFqV6m9j86BjdQVhN/cIQE/M7szNyRo2Fq
	 KTWVa3DlbV6GqODkC5AH7RYZ+pR6x540CtXPHcG0j4pzKcir9rD1IWlrFAHI7tGpqyKho
	 /a884cpaHHF9WfCfBOrf4sxENa0ErL/hm+PQHLNVLWaYT/gW7KY71nvxW1zzqm+6R2iRZ
	 GKhHUqy81wpgG49hXazJx3BwU02OT0sPMF4iLO62TXZqOIQ4I0AMRESvS7xftl5nTvYFS
	 84Veh09pB0j5C0wDHWlt+FCHTy+vq+xtBm4zdKOVThM5ht4E1/pNvqihrduQzPtJqJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vbLtIEhR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38307606A320;
	Thu, 19 Nov 2026 03:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vbLtIEhR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C8F1F000C4;
	Thu, 19 Nov 2026 03:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060075;
	bh=RQHjeWUCLkth5N8BNJyxFeyf2RGC9CELwyYFz0Jb3tA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vbLtIEhRAuYTs8Ejx9kRsc6aqtTxQC+gLDOggkmb+IaCs4K11L7Rb7nUcFf0CjcKx
	 tdImBSTTnLIXXnIR03ztEdL0dTGiTT3jLAglzIh87i12FYPgLjphpx851Ktd6HQQc+
	 QYj4/jyqZFwjMI1yHpWu40IGkmPUSO0o6LJa0LwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1062/1848] aio: fix NULL deref when a fault races ring truncation
Date: Wed, 18 Nov 2026 15:51:40 +0100
Message-ID: <20261118150002.025272714@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted the folio-based read_folio callback to page-based readpage using unlock_page() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/aio.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/aio.c b/fs/aio.c
index 16ceed755b7e5..8ba65b4ec8fc2 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -455,7 +455,18 @@ static int aio_migratepage(struct address_space *mapping, struct page *new,
 }
 #endif
 
+/*
+ * filemap_fault() reads a page that it did not find in the page cache. All
+ * pages of a live ring are there, so the ring was truncated under the fault.
+ */
+static int aio_readpage(struct file *file, struct page *page)
+{
+	unlock_page(page);
+	return -EIO;
+}
+
 static const struct address_space_operations aio_ctx_aops = {
+	.readpage	= aio_readpage,
 	.set_page_dirty = __set_page_dirty_no_writeback,
 #if IS_ENABLED(CONFIG_MIGRATION)
 	.migratepage	= aio_migratepage,
-- 
2.53.0




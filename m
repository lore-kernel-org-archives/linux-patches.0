Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F773BBFA1;
	Mon, 17 Aug 2026 13:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973901; cv=none; b=qDR4GRjRrJQ7fQCPkXz3v663U84HPbb6qRn2/EuvlCAs/vegXN5yEvLaw1RwI0uAPzszEez2XMPCZZV3/BBEH6ZjHVAi79domyfLifmWZm246ge4A/AEQr+2W+kOae0a1vZ+V+1l+5ti0Zj0xitecXB3p+ytkllRiTvCpvRhUn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973901; c=relaxed/simple;
	bh=VIGDDOSSrfXfM4grxzVBfEmfUvf4YS8+xay5AZbVNy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlM689UGixXEGW55SERIeWhLXqmtMdRFXj8UzeJxbveWlU8wBxKEs3gq+T5kvjWINSO9gIY7q36odCyEwX4xY4YnFiKfY/2T0Glb6rPD7GN5rCJIP3tkhKt7WrH1jtwZvZkBjS+w90LbZuLUws/JRkuzI8/MiPXQT91BGtOwK1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q4crrroC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q4crrroC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0CB31F000E9;
	Mon, 17 Aug 2026 13:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973900;
	bh=joNmEMf8yXjGAI1ZslnVqvBzyEyw5zjktoAVGjuRI5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q4crrroCRBqb8W9s34FCuqVGW8O7VkkIgkMJQP6ojGmKeswx5Jl3Qksu+YofQt+I9
	 SLNVEYnaoa7tt/BvktVJJITxca/0OH76mvFI4E3y2EfmmvsXrgBj+kwV8mW18GNulX
	 yo7XNBctQbca6yzw9OSkpXkBYFxCI3qx7Z6KJOlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+94c22d92f72f5a235b7d@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 020/271] xfs: handle NULL b_addr in xfs_buf_free
Date: Mon, 17 Aug 2026 15:29:05 +0200
Message-ID: <20260817132537.594460486@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit d852729c5f4f830fbe7413df032e29459b3daf83 ]

When xfs_buf_alloc_backing_mem() fails, xfs_buf_free() is called with
bp->b_addr still NULL.  The code falls through to the folio_put path
which calls virt_to_folio(NULL), dereferencing an invalid address and
causing a kernel crash.

 Call Trace:
  xfs_buf_free+0x25f/0x510
  xfs_buf_alloc+0xc98/0x19b0
  xfs_buf_find_insert+0x55/0x14d0
  xfs_buf_get_map+0x122b/0x17c0
  xfbtree_init_leaf_block+0x11c/0x4a0
  xfbtree_init+0x1bb/0x460
  xrep_rmap_setup_scan+0x100/0x1f0
  xrep_rmapbt+0x41/0xc0

Fix this by skipping folio_put() when bp->b_addr is NULL.

Fixes: 5076a6040ca1 ("xfs: support in-memory buffer cache targets")
Reported-by: syzbot+94c22d92f72f5a235b7d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=94c22d92f72f5a235b7d
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 0cea458f13536..23bd81fbc2788 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -114,7 +114,7 @@ xfs_buf_free(
 		vfree(bp->b_addr);
 	else if (bp->b_flags & _XBF_KMEM)
 		kfree(bp->b_addr);
-	else
+	else if (bp->b_addr)
 		folio_put(virt_to_folio(bp->b_addr));
 
 	call_rcu(&bp->b_rcu, xfs_buf_free_callback);
-- 
2.53.0




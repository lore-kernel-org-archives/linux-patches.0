Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABEF2628D;
	Wed, 20 May 2026 17:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298277; cv=none; b=rpw0trBjPV59O+gbeqTw5qc7rwYfmADXzONSIOYa5MYhAl5v252SaXuR3i35edLSa0MBXv4wdkyQMCTkJlEMtl7uir8J9iNnb6+QJCsqUf59so+RqU4us+bKSFaI4KtHw2Plc7Mqej1jcDX5pZImF/DwrxdfuLyGNw3lq5HAbQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298277; c=relaxed/simple;
	bh=ccu3uSTK7ZQ3VaRZ+7rMlmnV9SahNPdgP9Ohn3EU68A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQcd6rmU88RdApmzyDazj5wZjMkcBMiIO1oTOnuEZUQgHr8txgqE98jU1AAW/HCZcBrE37BAWkuDBV1S08as1uOa6eoXr12Hn/XHCkTj6E1NEYz75HkXy7sG0uOeoAk5bH6HmtDOTOaiDQ7TGc5LMGemLAfCy+PPUJndE7+4O/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rX/JTETn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rX/JTETn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C20B1F000E9;
	Wed, 20 May 2026 17:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298275;
	bh=pPLVNXBAak6HwoKDGODmjDsOwIgk/YUS1nA5DJ81GDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rX/JTETnn9SQKAJKmWFLsedHMASVM1q25XNiQfNMdH6lt9MSes/nDBacDrUtOgL2P
	 QOqiSTztyZtHE00sBjKmMTHlKZ6SSyT+lKOG+giyy8v+BgeMkzgBFtfxIpvYsx9PsL
	 xGvIOFQKWMFAYOGEsY6vAD2ct+VBcw5m0YcWP/fM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fdebb2dc960aa56c600a@syzkaller.appspotmail.com,
	Luis Henriques <luis@igalia.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 347/957] fuse: fix uninit-value in fuse_dentry_revalidate()
Date: Wed, 20 May 2026 18:13:50 +0200
Message-ID: <20260520162142.056223919@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Henriques <luis@igalia.com>

[ Upstream commit 5a6baf204610589f8a5b5a1cd69d1fe661d9d3cd ]

fuse_dentry_revalidate() may be called with a dentry that didn't had
->d_time initialised.  The issue was found with KMSAN, where lookup_open()
calls __d_alloc(), followed by d_revalidate(), as shown below:

=====================================================
BUG: KMSAN: uninit-value in fuse_dentry_revalidate+0x150/0x13d0 fs/fuse/dir.c:394
 fuse_dentry_revalidate+0x150/0x13d0 fs/fuse/dir.c:394
 d_revalidate fs/namei.c:1030 [inline]
 lookup_open fs/namei.c:4405 [inline]
 open_last_lookups fs/namei.c:4583 [inline]
 path_openat+0x1614/0x64c0 fs/namei.c:4827
 do_file_open+0x2aa/0x680 fs/namei.c:4859
[...]

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:4466 [inline]
 slab_alloc_node mm/slub.c:4788 [inline]
 kmem_cache_alloc_lru_noprof+0x382/0x1280 mm/slub.c:4807
 __d_alloc+0x55/0xa00 fs/dcache.c:1740
 d_alloc_parallel+0x99/0x2740 fs/dcache.c:2604
 lookup_open fs/namei.c:4398 [inline]
 open_last_lookups fs/namei.c:4583 [inline]
 path_openat+0x135f/0x64c0 fs/namei.c:4827
 do_file_open+0x2aa/0x680 fs/namei.c:4859
[...]
=====================================================

Reported-by: syzbot+fdebb2dc960aa56c600a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69917e0d.050a0220.340abe.02e2.GAE@google.com
Fixes: 2396356a945b ("fuse: add more control over cache invalidation behaviour")
Signed-off-by: Luis Henriques <luis@igalia.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dir.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 77982fdbcf278..98b174bd802f0 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -455,6 +455,11 @@ static int fuse_dentry_init(struct dentry *dentry)
 	fd->dentry = dentry;
 	RB_CLEAR_NODE(&fd->node);
 	dentry->d_fsdata = fd;
+	/*
+	 * Initialising d_time (epoch) to '0' ensures the dentry is invalid
+	 * if compared to fc->epoch, which is initialized to '1'.
+	 */
+	dentry->d_time = 0;
 
 	return 0;
 }
-- 
2.53.0




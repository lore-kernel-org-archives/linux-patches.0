Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8203D8137;
	Wed, 20 May 2026 16:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295512; cv=none; b=MdsoXOW6//f1gJqUaef9w4F7TCwVB9F7ZqfIX2UhmZlC/FlU5PasHyefd7oSk1r3Q9+QdPaRMlmsdBjbMngLo6Uyz1nDQeifeJrBL1Xa5hrHPAORe7hBs93y0dlHqa9/2SrkkMI7APMMhy7BhT/J2tV7WmWOBKlk3+CoEXHmvSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295512; c=relaxed/simple;
	bh=29D2/oF99WgrzlaLv07vnbY/2183lgeYDw9N71FTpKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vw5oQKOlAIuMjsgnO4EyFdmp9K3cP1b+kp5HV+0o7gAHXj8123c/Xm43qANeVUkNXntVeFh/mmLyt3fyT4XfAaHyDYl66N4ZwG79NBImf6QAo3J9xFU27jgZWCnzh7r/6VriY173iWlkTbdN1Z8YLPw6QNWXURkC9lSyVeHvLQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V9whAWyj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V9whAWyj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3C71F000E9;
	Wed, 20 May 2026 16:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295511;
	bh=QR50ekvir0RjoSKGLYtga2WBARPF/5sc85F6g18WsI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V9whAWyjTAEQ4aslAGmBUDLL5NWUtv3+EAT/96rFx5MuUonm+tGmwzjnNRUL1DZmk
	 6rjrpMyVw4uaqP8F2WozEALVkQYOwcCm9YwVR/uhox+UZrxH74BtjN/3CTvqbJiBeD
	 9SqTfbxBFJk4WjzxyrtfwKBU/BWY3NRlhnNPBr/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fdebb2dc960aa56c600a@syzkaller.appspotmail.com,
	Luis Henriques <luis@igalia.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0447/1146] fuse: fix uninit-value in fuse_dentry_revalidate()
Date: Wed, 20 May 2026 18:11:37 +0200
Message-ID: <20260520162158.315026164@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 7ac6b232ef123..d3acfd346ab52 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -481,6 +481,11 @@ static int fuse_dentry_init(struct dentry *dentry)
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




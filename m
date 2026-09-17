Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38983D3D1B;
	Thu, 17 Sep 2026 17:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667466; cv=none; b=JFzrUhSmoRr9LPQU5jPUFyTmfmBvD/URQNGBMuEGdlugWfOKh59RTlHsdkuHApYd1/CExRamA0z+jLnRvUjt2Y5zrb2Naw04RT80KEMUu1lG5BrYasj2YJRcTJYiYN3pE/eBXld2hRA+X4kb9tCRTV+OxTm3WkGYHVn0NaWyxqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667466; c=relaxed/simple;
	bh=57atktJBxcg5aRJdSHuKGFALu5/ELyrKL6/dfXJykmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FBd+kBJLZhaMyKaFsb9MSJtCpCGAlVoGPfxUE7KHKDdT4LZKKDFbp4mZOjGqSL4Ov2DwGhssk5eCVFNKFZ+cIgsHr7ubuvfLPSyf1/9CKaEvFzmx083WymWxGLPKgATWNuAEK3NkTV7Kpd1/ccBBm3yPHV1pcCqWkZWuIWyht6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uoBcKgnD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uoBcKgnD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554421F000FF;
	Thu, 17 Sep 2026 17:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667464;
	bh=T7CgvDKjKtM7CI/BnDf4D56BYNPEaWNCTp8OQGYcxE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uoBcKgnDQJbs03QQBaaZGGbWSmUsoUP9bv60JzJTt/Rwgw+FbkLvZh8Jx+lQehtwe
	 C7txPkcwKFUldTV3jRK+eeYCzde6nC9YPt8pjbZxvchXY8yibkAftYBsKUqMMipbji
	 JXqO2jtQznns4HhlH54zejQ/q4XWcF/vf/Ptzqzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Barre <pierre@barre.sh>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0103/1102] 9p: use kvzalloc for readdir buffer
Date: Thu, 17 Sep 2026 16:00:46 +0100
Message-ID: <20260917151542.084491621@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre Barre <pierre@barre.sh>

[ Upstream commit b4d71bea144550ff4a0917f8c4b06d4063eb27a6 ]

The readdir buffer is sized to msize, so kzalloc() can fail under
fragmentation with a page allocation failure in v9fs_alloc_rdir_buf()
/ v9fs_dir_readdir_dotl().

The buffer is only a response sink and is never pack_sg_list()'d,
so kvzalloc() is safe for all transports, unlike the fcall buffers
fixed in e21d451a82f3 ("9p: Use kvmalloc for message buffers on
supported transports").

Signed-off-by: Pierre Barre <pierre@barre.sh>
Message-ID: <20260512132032.369281-1-pierre@barre.sh>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_dir.c | 2 +-
 net/9p/client.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
index edef553bbd59e..323f85352f6a4 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -72,7 +72,7 @@ static struct p9_rdir *v9fs_alloc_rdir_buf(struct file *filp, int buflen)
 	struct p9_fid *fid = filp->private_data;
 
 	if (!fid->rdir)
-		fid->rdir = kzalloc(sizeof(struct p9_rdir) + buflen, GFP_KERNEL);
+		fid->rdir = kvzalloc(sizeof(struct p9_rdir) + buflen, GFP_KERNEL);
 	return fid->rdir;
 }
 
diff --git a/net/9p/client.c b/net/9p/client.c
index 54a05d9082c50..17f7b1290f6b9 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -890,7 +890,7 @@ static void p9_fid_destroy(struct p9_fid *fid)
 	spin_lock_irqsave(&clnt->lock, flags);
 	idr_remove(&clnt->fids, fid->fid);
 	spin_unlock_irqrestore(&clnt->lock, flags);
-	kfree(fid->rdir);
+	kvfree(fid->rdir);
 	kfree(fid);
 }
 
-- 
2.53.0




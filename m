Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD2D36998C;
	Wed, 30 Sep 2026 18:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794031; cv=none; b=jBqb1QNnTCnpKlj40zrxeQAr60NINah2HXGaVRbP6YXFyxBqppFP7ZZloQoS9DYYPteW471curAHN6SIyZ1sDvnSNFZkwPhfejvcKrXWVSjHohSQkfyORJI2t2CoRbUiFKnKiPpsGUOjhZllPd2RDUYR0tEQZ+avT/XnR3x+o5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794031; c=relaxed/simple;
	bh=djnMGuOdmjIJ/uaWrULtCL3cVFxvXhEvZGA2CnRMrIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CibzikiehKn5RGJtHgS6TIEO+1MhEolebKl6VSkB1xcbGa/s37dkySre0SkYYjqm0r3BZ8bfxv4dwwKcp4mT3fz1lxBkvIUIwU8+8BTao4w3qU1t+nn/gkkl2mLm8co+QljbUx8Bbmc8UjtfwZO8WFvG31vwXAXky2fMKxo0zHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=db6W45hg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="db6W45hg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABAAC1F000FF;
	Wed, 30 Sep 2026 18:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794029;
	bh=JN1oggjJ1k64ghBmwxjesZxEqNck106wraQmnT3T+0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=db6W45hg1Lz7ZEnh/V69jjhsDqn7ZeDvZqVE/tTSfxfU2ErJeDCtKregGEqt5qymX
	 4hBkEa1eRg8F4Rvl8QILEloPHgiDCGoKbyOfLWUurDqKM5vsMuIvuNbTlGZDL1v+Y3
	 RJI7tXyoy32Hytvzz8p7cpw3mTNWb9KQvlVi9XB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Barre <pierre@barre.sh>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0068/1193] 9p: use kvzalloc for readdir buffer
Date: Wed, 30 Sep 2026 17:12:32 +0200
Message-ID: <20260930152435.780466459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index b2775165afb44..da87f1e5a153a 100644
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
index 6d9480ba92746..82d2077c7a974 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -889,7 +889,7 @@ static void p9_fid_destroy(struct p9_fid *fid)
 	spin_lock_irqsave(&clnt->lock, flags);
 	idr_remove(&clnt->fids, fid->fid);
 	spin_unlock_irqrestore(&clnt->lock, flags);
-	kfree(fid->rdir);
+	kvfree(fid->rdir);
 	kfree(fid);
 }
 
-- 
2.53.0




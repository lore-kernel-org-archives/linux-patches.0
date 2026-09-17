Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE644DEC30;
	Thu, 17 Sep 2026 16:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661299; cv=none; b=qFrciZKS6NraLp66mWQu8nfKED7AagrjZTvM9BUOSB4QJnEpHaVTJoPZIV/byY48Wyi8Bma0+mjOrsvrPBQBzrtsKf6YLGl/ujWaONKsdcx9yLgnNu4T5UH9DXNgeYe7GtW7/wloIVEd2TFqBsjZGGepPnSZAeXqTMzySnCGiAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661299; c=relaxed/simple;
	bh=L7NNb2iBtYO2VremKWYXmgXtFrDNTjZuInRSqGOTa1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W55UrIPK6pSsYpnVg5wgL6f6h7n/97MfcNKraTi6/5E+PNl4GhOFU8YGM6an8/C0axw5RHSIt5pNUTt5oJRrPuByMD9yUNNxBknuJduFbEdHEn5hWUzDYoV4/qz1vBrhKqLzrFb93j6lpc1B3qtbB8uSvYfs0XqSb6tNmVB0VEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OeBfX3zJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OeBfX3zJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF7A1F000FF;
	Thu, 17 Sep 2026 16:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661297;
	bh=gXeLdH5RDxWShayWEEkkjo3c4j5uNP6KqXxg9NbTtYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OeBfX3zJbixPteD9GtG51NtLDrxH+RlJQhm80jsioBDEDhH+Tgm2oV7QhfR5EAGFd
	 EVe8IfTs+BKMbY7kkClqmj5ND/e4SaCbT8a7OEZcKEVORTh44fnMNhHqQInI3J2aB5
	 Kw5pdSzSfmB48aJwiQKak8zgfW5ggLJ3V12KZG6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Barre <pierre@barre.sh>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0148/1250] 9p: use kvzalloc for readdir buffer
Date: Thu, 17 Sep 2026 15:59:03 +0100
Message-ID: <20260917151556.077022097@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 08ae4c44d7305..75aac636b20e7 100644
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




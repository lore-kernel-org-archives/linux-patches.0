Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0724DEC03;
	Wed, 30 Sep 2026 16:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784163; cv=none; b=RvimzkLLzBoH8jjHYvH55a2sJfO5KUD2OlJSZWe20Er9rTCUzn1kkHGnptvBFuX+58iaPo9E+QMWVD3kuQMFKRLV9rDSBGiXXOK/86mHTCzNf20cXQ+VqO6F5mkdMcwGhyusok+iBWIseWFlpx2YyFUg4lxYPLXyM7fUi5DAriM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784163; c=relaxed/simple;
	bh=OdPaOx9ReqxR+ew6EBbmbKrVHplgg3+6wcRyTazi064=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PCQEs1hXzXDaprKKZ0RZrY+UWsLe2xuNTwYJmEgTOknKMvMfcl0QPeUZSUYWUcicN0pDDvlQqmPVPqJrvD5hoGg2R/2/Q92iBJ8VEDe7BoP1AaooyLDpUJZOqr5aym9UVBpdTAENlOdd1WiBThCWeSj9DbdiQitNiyvOz6JDbco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w6LEmhiA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w6LEmhiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DD81F000FF;
	Wed, 30 Sep 2026 16:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784159;
	bh=c/nLEmMD+9AcM6gWRy+za15ZTm2UZg84eKG1++XvLRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w6LEmhiABHvfyCPqah2LJHIKEiyS6g80h2FeVJdXkAPu2LNbmD8D2JEyeC7AJqJeV
	 r8g/PE6fvRIXCFhEkP0tM0VhhSmuWxAyT+Bu3OSHkDhiCI7juXww8dc9xjUxHfJ3C+
	 i7e5XSJYngQ8xAyrAbPZ6U5JEWyzlVDnow6G2rPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Barre <pierre@barre.sh>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/982] 9p: use kvzalloc for readdir buffer
Date: Wed, 30 Sep 2026 17:13:12 +0200
Message-ID: <20260930152417.995672596@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index dd36dce582839..3be09b94a8e24 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -74,7 +74,7 @@ static struct p9_rdir *v9fs_alloc_rdir_buf(struct file *filp, int buflen)
 	struct p9_fid *fid = filp->private_data;
 
 	if (!fid->rdir)
-		fid->rdir = kzalloc(sizeof(struct p9_rdir) + buflen, GFP_KERNEL);
+		fid->rdir = kvzalloc(sizeof(struct p9_rdir) + buflen, GFP_KERNEL);
 	return fid->rdir;
 }
 
diff --git a/net/9p/client.c b/net/9p/client.c
index 70c2cf23128fb..1a65c51636188 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -880,7 +880,7 @@ static void p9_fid_destroy(struct p9_fid *fid)
 	spin_lock_irqsave(&clnt->lock, flags);
 	idr_remove(&clnt->fids, fid->fid);
 	spin_unlock_irqrestore(&clnt->lock, flags);
-	kfree(fid->rdir);
+	kvfree(fid->rdir);
 	kfree(fid);
 }
 
-- 
2.53.0




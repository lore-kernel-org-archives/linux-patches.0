Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7D7158A16;
	Tue, 18 Jun 2024 13:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716733; cv=none; b=FdZy/rSLrTxir6FKY360drsEnllI/WDQdchMXNEOhRJXIIuyAw0J7g8pmQZMP5QirqeawjmUnDZjy3cemmyaximNwm1UtgWwUqMn5P2210U9a+M+hIQDjp7+pEkWGSzCGhQ5phm+eVbqmnjl3kklc4GdFbKj/JybkH4QZWwUwc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716733; c=relaxed/simple;
	bh=HiesF5cTq3+vL/tm0dmTthKzYYftkNW27NSCpOYdKxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXGIkpKEtwmiWnTJztGI2+3+UDlKqfnrRhtku40Ve76YAmEfMg7WUu5gus28XhmZNIelzXnlTLY3WWsMhrMLX9oMfUOSkyGJUQk7Xb4Qgs4lqcM5636JPzGO3TSUQVnn3Kfjsx17uy9ULBs3gCD4SrFZrjI3jJFWOHcm2XjYsXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AzDFVwKs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AzDFVwKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BEC8C3277B;
	Tue, 18 Jun 2024 13:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716733;
	bh=HiesF5cTq3+vL/tm0dmTthKzYYftkNW27NSCpOYdKxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AzDFVwKsm/9S+yHXLVHfjXvlxMHn0SAqDHOwD8gqA5cOVyHwUSybAUERbQSvkJlBq
	 1psJGih+IwC+fFcvHkSx/v8uxkJsiFMLGKrPnl4HyNOVk5aV89HQ1HYMXJUkWm50pa
	 uSk/5zvwMswiTW/Vt1ACrpnkXy9tif5fqCNdtGjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 744/770] nfsd: dont open-code clear_and_wake_up_bit
Date: Tue, 18 Jun 2024 14:39:57 +0200
Message-ID: <20240618123435.986828975@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit b8bea9f6cdd7236c7c2238d022145e9b2f8aac22 ]

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 4a3796c6bd957..677a8d935ccc2 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1173,9 +1173,7 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		status = nfserr_jukebox;
 	if (status != nfs_ok)
 		nfsd_file_unhash(nf);
-	clear_bit_unlock(NFSD_FILE_PENDING, &nf->nf_flags);
-	smp_mb__after_atomic();
-	wake_up_bit(&nf->nf_flags, NFSD_FILE_PENDING);
+	clear_and_wake_up_bit(NFSD_FILE_PENDING, &nf->nf_flags);
 	goto out;
 }
 
-- 
2.43.0




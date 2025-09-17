Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBB01E25EF;
	Wed, 17 Sep 2025 12:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112619; cv=none; b=dGkAuwCIT+LmrGVeGSqpFQX+WoXblCDDvGlYXhLPCnKXB7N2pIso4EAN/NyQiR/xk3DAKRg8asIwXbM4qsl6IzqZDiaC8Xp32rdijDLUyWGh4SlP6WtwLdTwWvtR61QSIF/izOfiAxR5i+a2epQJmijO8kQwDa7xhFAKpvVbEhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112619; c=relaxed/simple;
	bh=/Ph+kzZNhEUsGkAMKXAQ7YatEEWNOPVv0FKHsqjuEn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5TV5/kYcszvJNTq/70lcXbS/K+vS5wbRIhrx+aC5KIhmSEQNg/57CrexNpOlVYf0Nzglgq0eTWtcSDn/ve7hC5IrW5m/QUWuX4z1ToxiwdGa5sUoUndkxRWwDHs4g/Qn4GGpX+sPTH0YqrlBqFpdqIPUdlyrXxttYGUPfaDzMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVo1JPtD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVo1JPtD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFA1C4CEFC;
	Wed, 17 Sep 2025 12:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112619;
	bh=/Ph+kzZNhEUsGkAMKXAQ7YatEEWNOPVv0FKHsqjuEn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yVo1JPtDeR7/jvuFaPoLNVAIjsU37QqnzqBu/pjBbyOAJ5Z/9GblIJEThBTlBD2Bs
	 FAm77pWtExpRxyxb2hf/L3sBq+ZLp44eTOM0w/KSmDHJVpHUh41vT8JYO0Y2KS1cYP
	 gGuvrmvOOoG6i6u1UnD9A4cM6zDQkInTuZwbOmw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Mayhew <smayhew@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 026/189] nfs/localio: restore creds before releasing pageio data
Date: Wed, 17 Sep 2025 14:32:16 +0200
Message-ID: <20250917123352.493712149@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Mayhew <smayhew@redhat.com>

[ Upstream commit 992203a1fba51b025c60ec0c8b0d9223343dea95 ]

Otherwise if the nfsd filecache code releases the nfsd_file
immediately, it can trigger the BUG_ON(cred == current->cred) in
__put_cred() when it puts the nfsd_file->nf_file->f-cred.

Fixes: b9f5dd57f4a5 ("nfs/localio: use dedicated workqueues for filesystem read and write")
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Link: https://lore.kernel.org/r/20250807164938.2395136-1-smayhew@redhat.com
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/localio.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/localio.c b/fs/nfs/localio.c
index 510d0a16cfe91..e2213ef18baed 100644
--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -453,12 +453,13 @@ static void nfs_local_call_read(struct work_struct *work)
 	nfs_local_iter_init(&iter, iocb, READ);
 
 	status = filp->f_op->read_iter(&iocb->kiocb, &iter);
+
+	revert_creds(save_cred);
+
 	if (status != -EIOCBQUEUED) {
 		nfs_local_read_done(iocb, status);
 		nfs_local_pgio_release(iocb);
 	}
-
-	revert_creds(save_cred);
 }
 
 static int
@@ -649,14 +650,15 @@ static void nfs_local_call_write(struct work_struct *work)
 	file_start_write(filp);
 	status = filp->f_op->write_iter(&iocb->kiocb, &iter);
 	file_end_write(filp);
+
+	revert_creds(save_cred);
+	current->flags = old_flags;
+
 	if (status != -EIOCBQUEUED) {
 		nfs_local_write_done(iocb, status);
 		nfs_local_vfs_getattr(iocb);
 		nfs_local_pgio_release(iocb);
 	}
-
-	revert_creds(save_cred);
-	current->flags = old_flags;
 }
 
 static int
-- 
2.51.0




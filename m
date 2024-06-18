Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A073156F39;
	Tue, 18 Jun 2024 13:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715782; cv=none; b=DFtkNv2N4I2gw8khi17zAI5YnJko6lLdDxzVBOEffc2QizzDj3SMIKcWajI2AUYx/+YU473F7ir6JIhdQBwnY1oXUMSIZjDi23dJyYa2oW/A3uVZdom24G8kJR3zhdW2IlKV3N0kh1KA/KlgiVqWiLC0GhysVR+iw/0ZXjh2QFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715782; c=relaxed/simple;
	bh=8luX5EWn6NHhoCL9y9zhAWQiGLN1BA9+cy2Oc01LqKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9H/9jc+U6Y4xkkFC0KEUY8ms9FCbiLZowfb0BfZOSPyPkYsetiTxY+fg7v1fHupqhWrteLHL3NWjNcBGCx9oHH2HDundrhZEnpFpMYjsy8Q4dD5BfD+vX/yadjmyBzHW6+ud13dMGz1FDLwWcBVKva33XG5SOFAmlq+Ib68n2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCBHYtsw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCBHYtsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B96C3277B;
	Tue, 18 Jun 2024 13:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715782;
	bh=8luX5EWn6NHhoCL9y9zhAWQiGLN1BA9+cy2Oc01LqKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VCBHYtswhVAZgOFlI/H4AWaXz4T3VBjA4FuQNfJU5aDU78feH+RkNpYxU8WUaiFYY
	 TIrKUQX2zoZ8GKZPL4ZkXl/STebCnmZINY33uduNwfXWBxMKR4WRcpdbjGv1qMcoyQ
	 oJzeRbamdbrK0ZQksNeSCvNGjroWsDsbGC/IhdBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 425/770] NFSD: narrow nfsd_mutex protection in nfsd thread
Date: Tue, 18 Jun 2024 14:34:38 +0200
Message-ID: <20240618123423.688874796@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

[ Upstream commit 9d3792aefdcda71d20c2b1ecc589c17ae71eb523 ]

There is nothing happening in the start of nfsd() that requires
protection by the mutex, so don't take it until shutting down the thread
- which does still require protection - but only for nfsd_put().

Signed-off-by: NeilBrown <neilb@suse.de>
[ cel: address merge conflict with fd2468fa1301 ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfssvc.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 16884a90e1ab0..eb8cc4d914fee 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -932,9 +932,6 @@ nfsd(void *vrqstp)
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 	int err;
 
-	/* Lock module and set up kernel thread */
-	mutex_lock(&nfsd_mutex);
-
 	/* At this point, the thread shares current->fs
 	 * with the init process. We need to create files with the
 	 * umask as defined by the client instead of init's umask. */
@@ -954,7 +951,6 @@ nfsd(void *vrqstp)
 	allow_signal(SIGINT);
 	allow_signal(SIGQUIT);
 
-	mutex_unlock(&nfsd_mutex);
 	atomic_inc(&nfsdstats.th_cnt);
 
 	set_freezable();
@@ -983,7 +979,6 @@ nfsd(void *vrqstp)
 	flush_signals(current);
 
 	atomic_dec(&nfsdstats.th_cnt);
-	mutex_lock(&nfsd_mutex);
 
 out:
 	/* Take an extra ref so that the svc_put in svc_exit_thread()
@@ -995,10 +990,11 @@ nfsd(void *vrqstp)
 	svc_exit_thread(rqstp);
 
 	/* Now if needed we call svc_destroy in appropriate context */
+	mutex_lock(&nfsd_mutex);
 	nfsd_put(net);
+	mutex_unlock(&nfsd_mutex);
 
 	/* Release module */
-	mutex_unlock(&nfsd_mutex);
 	module_put_and_kthread_exit(0);
 	return 0;
 }
-- 
2.43.0




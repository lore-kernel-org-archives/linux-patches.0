Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE4F13CF82;
	Tue, 18 Jun 2024 13:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716584; cv=none; b=FEqhzHhlyM48QUfUwse42GqURwjPkE6/7GXEa9qQdgyRbfYyx3N/y0RzTkr94exgkK8zTPrffLPAJPo3NtWloYl1z/kvnVXomleGenguTh7LncF/t8q2yg5g8BHcSHElnMHnzzs3PUm/6AWhtzH7NjKTCy27tTYJyi9lZkVM0PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716584; c=relaxed/simple;
	bh=e/wvQyXKHBHy6TW4TxRy0DMLW8bUtM4icoaOTUWR+Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MafGBQU9PMMcTZLLJhMjL5iSvBIbNIVn5Xht5pe5tyUUX9lB8UqaWL/cg3aWNhxbcPzsievdp8XizebEsdR7YkcWuoY4PPXXnmxd/K9dFCd3+4f4d2W0cI0NsOgcZEMq6HzkBvXr4f2+OtQligeKzfaKLbnOHoPOHIjnI07L91Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTnLBebf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTnLBebf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34494C3277B;
	Tue, 18 Jun 2024 13:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716584;
	bh=e/wvQyXKHBHy6TW4TxRy0DMLW8bUtM4icoaOTUWR+Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTnLBebfFWIVpyO3fDd3fX7ROiQR+RO1X9uVDJLkf5YaMwaEJUS1Az7TQQSKwmy0T
	 wRRPLhV1iReO9RLvsrxvmPFnCR6sGGlXrYGHWaDSI/xBM4Blr2js7FHDOeGKfVC+7h
	 YWe+noey9rN9i63U5/IOeH2NvFNLDw1qsi1OdZLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 695/770] NFSD: Trace stateids returned via DELEGRETURN
Date: Tue, 18 Jun 2024 14:39:08 +0200
Message-ID: <20240618123434.104293430@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 20eee313ff4b8a7e71ae9560f5c4ba27cd763005 ]

Handing out a delegation stateid is recorded with the
nfsd_deleg_read tracepoint, but there isn't a matching tracepoint
for recording when the stateid is returned.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 1 +
 fs/nfsd/trace.h     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 80d8f40d1f126..a40a9a836fb1e 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6929,6 +6929,7 @@ nfsd4_delegreturn(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	if (status)
 		goto put_stateid;
 
+	trace_nfsd_deleg_return(stateid);
 	wake_up_var(d_inode(cstate->current_fh.fh_dentry));
 	destroy_delegation(dp);
 put_stateid:
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 03722414d6db8..fe76d3b2c9286 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -517,6 +517,7 @@ DEFINE_STATEID_EVENT(layout_recall_release);
 
 DEFINE_STATEID_EVENT(open);
 DEFINE_STATEID_EVENT(deleg_read);
+DEFINE_STATEID_EVENT(deleg_return);
 DEFINE_STATEID_EVENT(deleg_recall);
 
 DECLARE_EVENT_CLASS(nfsd_stateseqid_class,
-- 
2.43.0




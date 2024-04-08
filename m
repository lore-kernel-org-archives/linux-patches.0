Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B3D7BAF0;
	Mon,  8 Apr 2024 13:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584641; cv=none; b=u9t/VYjt0vNZebJ/YlaX/xNkTooh6irtZKD9IvC7p/b3oNKwkyVKoR2vFqllQc5FoWAzQad5n+PSWafUwwkq1iPKtsYq9ZBxtINVUJmq00gQAVe6lqFODr01DO515PYTOIdcYrZnpN86QK3iG9YeB3w4xpsAT79dTa0MSwbTdc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584641; c=relaxed/simple;
	bh=3AeY/NFdlZIaq4Dt/ppE2RKSuPq4RMnnSswm97X/bog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZrhNmQ66CEx+2h31cjG9eJhw5OHWsDbosM+tZYz1K+/07YZZXwg/BIf9Eg9FZTGwr0Ywl7RsssNdg+wmsiVldq1sZORlBH9UhJr0WDsLsq3U2qXa96nEYXYta43kigB0Ahj6Z4rxJS2SJT4hhwA0PhSJNSoOHobBw6pjFkgmX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fvP0i4M6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fvP0i4M6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EB9C433C7;
	Mon,  8 Apr 2024 13:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584641;
	bh=3AeY/NFdlZIaq4Dt/ppE2RKSuPq4RMnnSswm97X/bog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fvP0i4M6nE4EJWx7By1uHPblNQvMeSiBaXisTASEVlq+D8q0J0UAnjNP5Zbq0vaHf
	 1z1vfxapjt8tWBCmkf8WD1jxkXtppULcOom2/fTbvxYyXPOmTCsgc/mFx5PNJdizkd
	 QEumHAreSkyatn+C7RFR+BaV0eJC+fbSdv/V9xTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 507/690] NFSD: Use only RQ_DROPME to signal the need to drop a reply
Date: Mon,  8 Apr 2024 14:56:13 +0200
Message-ID: <20240408125418.017404706@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 9315564747cb6a570e99196b3a4880fb817635fd ]

Clean up: NFSv2 has the only two usages of rpc_drop_reply in the
NFSD code base. Since NFSv2 is going away at some point, replace
these in order to simplify the "drop this reply?" check in
nfsd_dispatch().

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfsproc.c | 4 ++--
 fs/nfsd/nfssvc.c  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 52fc222c34f26..a5570cf75f3fd 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -211,7 +211,7 @@ nfsd_proc_read(struct svc_rqst *rqstp)
 	if (resp->status == nfs_ok)
 		resp->status = fh_getattr(&resp->fh, &resp->stat);
 	else if (resp->status == nfserr_jukebox)
-		return rpc_drop_reply;
+		__set_bit(RQ_DROPME, &rqstp->rq_flags);
 	return rpc_success;
 }
 
@@ -246,7 +246,7 @@ nfsd_proc_write(struct svc_rqst *rqstp)
 	if (resp->status == nfs_ok)
 		resp->status = fh_getattr(&resp->fh, &resp->stat);
 	else if (resp->status == nfserr_jukebox)
-		return rpc_drop_reply;
+		__set_bit(RQ_DROPME, &rqstp->rq_flags);
 	return rpc_success;
 }
 
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 429f38c986280..325d3d3f12110 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -1060,7 +1060,7 @@ int nfsd_dispatch(struct svc_rqst *rqstp, __be32 *statp)
 	svcxdr_init_encode(rqstp);
 
 	*statp = proc->pc_func(rqstp);
-	if (*statp == rpc_drop_reply || test_bit(RQ_DROPME, &rqstp->rq_flags))
+	if (test_bit(RQ_DROPME, &rqstp->rq_flags))
 		goto out_update_drop;
 
 	if (!proc->pc_encode(rqstp, &rqstp->rq_res_stream))
-- 
2.43.0




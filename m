Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E791C68C;
	Sun,  1 Sep 2024 16:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208656; cv=none; b=icSqyRgV8p0BnIoRYm4Xk0+ipBwwbHJXqRACfrGROib1ZVDlEPZJtDUiJI7Z2x75J6OSkWeAzxrp/d5tVYmgi638WnPhFVjld0sdlpcADz3s1evoGvPzaTO5JPoUmvE6Cl8ly2COTgcWKPW4bPCt+92q528bfJIhcjs1hyG5Qpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208656; c=relaxed/simple;
	bh=E5907xIhxg3SCP8CY4QKO1UlaSj3oO7hzU25ihyVXQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RmROtpAtJugEzfIWqhldhsLeidQCTcDi3L3vBNZTtPemMHIK8hI6t0v+OuPjTInPGg4gvL36AUSzs/Q2+6C3h608yyo9V25ojCEa41uWGhwJ1FpCruz0FVvnd4q6uc/BTXBjvMEVV541B7xNlNBYjTiCWe9X3lDI+hZvEQwLHuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhohs0qq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhohs0qq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6097C4CEC3;
	Sun,  1 Sep 2024 16:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208656;
	bh=E5907xIhxg3SCP8CY4QKO1UlaSj3oO7hzU25ihyVXQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bhohs0qqH86EVJ9xvKKarx+BD5x1goO0h7q0h0UYugs6iUQH7LwiQAEtvbsWblUue
	 LHmRaijmNFJODfJYCpHFa8UtHk86jS/KQjrBAIKjzTgg3YrrXQ2uIBEcLvIHdIPZKN
	 R2ddL4lRhrY56HVU677rsEH/BjwL7FfvSbimq/4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 149/149] nfsd: fix nfsd4_deleg_getattr_conflict in presence of third party lease
Date: Sun,  1 Sep 2024 18:17:40 +0200
Message-ID: <20240901160823.049123999@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 40927f3d0972bf86357a32a5749be71a551241b6 ]

It is not safe to dereference fl->c.flc_owner without first confirming
fl->fl_lmops is the expected manager.  nfsd4_deleg_getattr_conflict()
tests fl_lmops but largely ignores the result and assumes that flc_owner
is an nfs4_delegation anyway.  This is wrong.

With this patch we restore the "!= &nfsd_lease_mng_ops" case to behave
as it did before the change mentioned below.  This is the same as the
current code, but without any reference to a possible delegation.

Fixes: c5967721e106 ("NFSD: handle GETATTR conflict with write delegation")
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 07f2496850c4c..a366fb1c1b9b4 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -8859,7 +8859,15 @@ nfsd4_deleg_getattr_conflict(struct svc_rqst *rqstp, struct dentry *dentry,
 			 */
 			if (type == F_RDLCK)
 				break;
-			goto break_lease;
+
+			nfsd_stats_wdeleg_getattr_inc(nn);
+			spin_unlock(&ctx->flc_lock);
+
+			status = nfserrno(nfsd_open_break_lease(inode, NFSD_MAY_READ));
+			if (status != nfserr_jukebox ||
+			    !nfsd_wait_for_delegreturn(rqstp, inode))
+				return status;
+			return 0;
 		}
 		if (type == F_WRLCK) {
 			struct nfs4_delegation *dp = fl->c.flc_owner;
@@ -8868,7 +8876,6 @@ nfsd4_deleg_getattr_conflict(struct svc_rqst *rqstp, struct dentry *dentry,
 				spin_unlock(&ctx->flc_lock);
 				return 0;
 			}
-break_lease:
 			nfsd_stats_wdeleg_getattr_inc(nn);
 			dp = fl->c.flc_owner;
 			refcount_inc(&dp->dl_stid.sc_count);
-- 
2.43.0




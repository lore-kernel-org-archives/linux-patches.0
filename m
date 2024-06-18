Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EA016EB5D;
	Tue, 18 Jun 2024 12:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715396; cv=none; b=R2/S4v0nBiKCbC4q+EWJN6exmmAUtAwmetBU7Em3PMFhzZLaRSqZtgm4LfQLwmK7enRSb7uxqD3/14OoK3StVozj9oJdzPcfodKig+qZMJwLAaDgYLwbe2Zf4E3+vyoNqZ4LByTb8u7FrK2IO+lvn6q2NeqawWZYxPwEUrcynzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715396; c=relaxed/simple;
	bh=D2J9fpqwA9Pw7Pl7g7lNwOtx//Cj/qXtk9M37Pi6H7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfoiIr1c5/38v+sSF5PNOb1ZS+mb+aX/ixG9bPBxv1ojm+Ai5C+YsDIdHz2o2muZJ6i899CGpup61ldnEAn7GVfosv0WuUXXuPlDcspYpkiM/bbr06ntdqO6fSwMUskELCTMPkxDMFTR+whIxpW3oM753yGG6tLEP7ch4oFA/IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pSIaEvsE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pSIaEvsE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFD5C3277B;
	Tue, 18 Jun 2024 12:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715396;
	bh=D2J9fpqwA9Pw7Pl7g7lNwOtx//Cj/qXtk9M37Pi6H7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pSIaEvsEdWV8ZMUaysgJZLbGZshau4iI8cudJPuYbBKwYBhst/nNhRbDwytD7SpsS
	 3QqF2kMxf0plWZOX6nhNHmbkaBJorm8X73+7E3lJjTG4/WkCTDKpe/qppJ3yThnWyt
	 bkJnXGQfncU3jjbQav8991kKb2TT/zSmoLFh+bVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 294/770] nfsd: move fsnotify on client creation outside spinlock
Date: Tue, 18 Jun 2024 14:32:27 +0200
Message-ID: <20240618123418.611721887@linuxfoundation.org>
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

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 934bd07fae7e55232845f909f78873ab8678ca74 ]

This was causing a "sleeping function called from invalid context"
warning.

I don't think we need the set_and_test_bit() here; clients move from
unconfirmed to confirmed only once, under the client_lock.

The (conf == unconf) is a way to check whether we're in that confirming
case, hopefully that's not too obscure.

Fixes: 472d155a0631 "nfsd: report client confirmation status in "info" file"
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 3dd6e25d5d90f..4e14a9f6dfd39 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2846,11 +2846,8 @@ move_to_confirmed(struct nfs4_client *clp)
 	list_move(&clp->cl_idhash, &nn->conf_id_hashtbl[idhashval]);
 	rb_erase(&clp->cl_namenode, &nn->unconf_name_tree);
 	add_clp_to_name_tree(clp, &nn->conf_name_tree);
-	if (!test_and_set_bit(NFSD4_CLIENT_CONFIRMED, &clp->cl_flags)) {
-		trace_nfsd_clid_confirmed(&clp->cl_clientid);
-		if (clp->cl_nfsd_dentry && clp->cl_nfsd_info_dentry)
-			fsnotify_dentry(clp->cl_nfsd_info_dentry, FS_MODIFY);
-	}
+	set_bit(NFSD4_CLIENT_CONFIRMED, &clp->cl_flags);
+	trace_nfsd_clid_confirmed(&clp->cl_clientid);
 	renew_client_locked(clp);
 }
 
@@ -3509,6 +3506,8 @@ nfsd4_create_session(struct svc_rqst *rqstp,
 	/* cache solo and embedded create sessions under the client_lock */
 	nfsd4_cache_create_session(cr_ses, cs_slot, status);
 	spin_unlock(&nn->client_lock);
+	if (conf == unconf)
+		fsnotify_dentry(conf->cl_nfsd_info_dentry, FS_MODIFY);
 	/* init connection and backchannel */
 	nfsd4_init_conn(rqstp, conn, new);
 	nfsd4_put_session(new);
@@ -4129,6 +4128,8 @@ nfsd4_setclientid_confirm(struct svc_rqst *rqstp,
 	}
 	get_client_locked(conf);
 	spin_unlock(&nn->client_lock);
+	if (conf == unconf)
+		fsnotify_dentry(conf->cl_nfsd_info_dentry, FS_MODIFY);
 	nfsd4_probe_callback(conf);
 	spin_lock(&nn->client_lock);
 	put_client_renew_locked(conf);
-- 
2.43.0




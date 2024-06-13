Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C34FDDB1;
	Thu, 13 Jun 2024 11:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278663; cv=none; b=Lix/Ei7OQT+TJeC69yvPB/doLzWUxXsynRfR40PdYNzBGyjBZ6HkEPyiseCY/xag15uOMHoZ8WBysm9wOVlpEyXMmee4pVmeMCPrzXt8duSnS51gMZOHOVg9OnkfPttQ76AWv7zq0bi9fU3M4a8b6NU6StdTSRbiNJfJzHxV7iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278663; c=relaxed/simple;
	bh=7yFY/53Q42Ki3+u6XMmG/+dcbI3XHvzNIr+HNq8FgSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VcKFMDCOcuo/0SALUEEYRmDk85r88hUlVPcjT2py0wufeh/7Qpn/dZvwFa2Ic7o+EGSfuUYTAD4KuOWiNSEuMBSjKK86V1k3+fCGnq2lJbLqPBOChoz2vas413tHNM+Cjk3cL2i08YZoWgaYGQYc/RAMaWhwBnH3R//aHcVDJHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BQCbbDMx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BQCbbDMx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93FFC2BBFC;
	Thu, 13 Jun 2024 11:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278663;
	bh=7yFY/53Q42Ki3+u6XMmG/+dcbI3XHvzNIr+HNq8FgSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BQCbbDMx6ToP1W447vpChXoMGRC/YntmxX6N3kXmfI9rXDr1eBzsA89v7rf9bWbEL
	 JO9h8CUzerT8P10Q4WdwbPrcN6RnttsxYNReibSYcmcO6A4IhRMQaGfQvr/AV9cXtS
	 zOjkhaMejangq90TlMeXJ7uE3vvX2b09b+2Wfzes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 028/213] nfsd: drop st_mutex before calling move_to_close_lru()
Date: Thu, 13 Jun 2024 13:31:16 +0200
Message-ID: <20240613113229.082769729@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 56c35f43eef013579c76c007ba1f386d8c2cac14 ]

move_to_close_lru() is currently called with ->st_mutex held.
This can lead to a deadlock as move_to_close_lru() waits for sc_count to
drop to 2, and some threads holding a reference might be waiting for the
mutex.  These references will never be dropped so sc_count will never
reach 2.

There can be no harm in dropping ->st_mutex before
move_to_close_lru() because the only place that takes the mutex is
nfsd4_lock_ol_stateid(), and it quickly aborts if sc_type is
NFS4_CLOSED_STID, which it will be before move_to_close_lru() is called.

See also
 https://lore.kernel.org/lkml/4dd1fe21e11344e5969bb112e954affb@jd.com/T/
where this problem was raised but not successfully resolved.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 5c241e510888d..7ac644d64ab1d 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5482,7 +5482,7 @@ nfsd4_open_downgrade(struct svc_rqst *rqstp,
 	return status;
 }
 
-static void nfsd4_close_open_stateid(struct nfs4_ol_stateid *s)
+static bool nfsd4_close_open_stateid(struct nfs4_ol_stateid *s)
 {
 	struct nfs4_client *clp = s->st_stid.sc_client;
 	bool unhashed;
@@ -5496,11 +5496,11 @@ static void nfsd4_close_open_stateid(struct nfs4_ol_stateid *s)
 			put_ol_stateid_locked(s, &reaplist);
 		spin_unlock(&clp->cl_lock);
 		free_ol_stateid_reaplist(&reaplist);
+		return false;
 	} else {
 		spin_unlock(&clp->cl_lock);
 		free_ol_stateid_reaplist(&reaplist);
-		if (unhashed)
-			move_to_close_lru(s, clp->net);
+		return unhashed;
 	}
 }
 
@@ -5516,6 +5516,7 @@ nfsd4_close(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	struct nfs4_ol_stateid *stp;
 	struct net *net = SVC_NET(rqstp);
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
+	bool need_move_to_close_list;
 
 	dprintk("NFSD: nfsd4_close on file %pd\n", 
 			cstate->current_fh.fh_dentry);
@@ -5538,8 +5539,10 @@ nfsd4_close(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	 */
 	nfs4_inc_and_copy_stateid(&close->cl_stateid, &stp->st_stid);
 
-	nfsd4_close_open_stateid(stp);
+	need_move_to_close_list = nfsd4_close_open_stateid(stp);
 	mutex_unlock(&stp->st_mutex);
+	if (need_move_to_close_list)
+		move_to_close_lru(stp, net);
 
 	/* v4.1+ suggests that we send a special stateid in here, since the
 	 * clients should just ignore this anyway. Since this is not useful
-- 
2.43.0




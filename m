Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCF015217A;
	Tue, 18 Jun 2024 12:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715150; cv=none; b=qEZnSQBjChqfPRU+hrmXLFmNbwtovrfb1wtpx1r4O6IksqzhQ0RJ2W8ePZV+msQ9RFlE+Wg9Jf3RBpxqPd2hl+DKDRyDO3V5FtqkaEKwiDnZqP92BkJd0Pt93uJXvSYpW2J6sihNfJ3mlVhqxkzPZN84W3IPtR7ecxue5A7Nnmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715150; c=relaxed/simple;
	bh=VYruwWNdI6Csi7khOTZKY1opN2cK+isPHbC2IRl+Gk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AsAYq/xsbsI0YV2epLTU0JuxK4Z4lhsGBUC8qrRvr6ZdgCepo2FzB/n+RRZyKFWJL3VsQbbAM7fncGW3R3ga5D6bUbnaFOrxp26HKBFxnZt0BRuj+g5wwttsJrz0PcAo3ybUqwGAbzkGE3JpC/OHE0xAbsp6M3aA/51IPXeELLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dTI0ka3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dTI0ka3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85BFC3277B;
	Tue, 18 Jun 2024 12:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715150;
	bh=VYruwWNdI6Csi7khOTZKY1opN2cK+isPHbC2IRl+Gk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dTI0ka3igS2jaApe9WWNy6q6dRcg9czqOmPFYxkAcajz3K1zx2r+dwf62ZEpYiJwu
	 S63x9KMMi+14BLXtpdctRg/JDndQGubXzKVFKysgvb8iLF0PifoIc/n3Qz8eXPo8FE
	 jSF6gxGb4dY361QIiYpe94gzpFNAMjpSeICdvDgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 180/770] nfsd: simplify nfsd_renew
Date: Tue, 18 Jun 2024 14:30:33 +0200
Message-ID: <20240618123414.221821126@linuxfoundation.org>
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

[ Upstream commit b4587eb2cf4b6271f67fb93b75f7de2a2026e853 ]

You can take the single-exit thing too far, I think.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 15ed72b0ef55b..574c88a9da268 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5322,15 +5322,12 @@ nfsd4_renew(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	trace_nfsd_clid_renew(clid);
 	status = lookup_clientid(clid, cstate, nn, false);
 	if (status)
-		goto out;
+		return status;
 	clp = cstate->clp;
-	status = nfserr_cb_path_down;
 	if (!list_empty(&clp->cl_delegations)
 			&& clp->cl_cb_state != NFSD4_CB_UP)
-		goto out;
-	status = nfs_ok;
-out:
-	return status;
+		return nfserr_cb_path_down;
+	return nfs_ok;
 }
 
 void
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291857BAF5;
	Mon,  8 Apr 2024 13:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584568; cv=none; b=VgP+bqN5bfYuiSylnMakFYj+k7CWM9K9AgMWkH4maXuFAHAYph00LuwUii/jo0Xg0MXjwxnQWB75nB79RrGUnk24nhlFpb7IGM/vEO797k6n/4cJXfw36N5qxmvQZTZjOqsdLmgpLt4bV++26JGE8lpf05+tF1teeImkHRAEqBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584568; c=relaxed/simple;
	bh=JhfUDxrqIph1nAsCAR6jbXS5BwRpS6x8uhEBOQew+yM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+xfNOkS0kJLLvGxMheSDfYle3URWa3x75zzvkJ02t9RpE/82ThOkHW7FIHOlM64LjeNwq1sP1RAHWV5tpUxgwCf2iNaAXg7R+tYHW6e0gGR+6i1EFoAIVuey2AHeNjHcAF+9dqq3cCSurLEIrqTrrHf/BXz9vPyCSsgH3GNLs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUVoTRCL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUVoTRCL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B93C433F1;
	Mon,  8 Apr 2024 13:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584568;
	bh=JhfUDxrqIph1nAsCAR6jbXS5BwRpS6x8uhEBOQew+yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cUVoTRCLtuiysz9ipJ676U/ohv/bP7xjQE+tRtxhv0MPxZevXGbQN9J4Y/wSiHV77
	 GIwEci6ix74/IzfZJClXuKA0tXjfQ44fM+HRDGI+eIzAGcMGbSWpRWAwXGfnNfbkvI
	 M0xcXCqI8ggNgbQK8y5xRVUX1AlcQBxmaNlWz8MU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 452/690] nfsd: only fill out return pointer on success in nfsd4_lookup_stateid
Date: Mon,  8 Apr 2024 14:55:18 +0200
Message-ID: <20240408125416.024462260@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 4d01416ab41540bb13ec4a39ac4e6c4aa5934bc9 ]

In the case of a revoked delegation, we still fill out the pointer even
when returning an error, which is bad form. Only overwrite the pointer
on success.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4state.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index f427f95ab934e..1e9245303c0f2 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6279,6 +6279,7 @@ nfsd4_lookup_stateid(struct nfsd4_compound_state *cstate,
 		     struct nfs4_stid **s, struct nfsd_net *nn)
 {
 	__be32 status;
+	struct nfs4_stid *stid;
 	bool return_revoked = false;
 
 	/*
@@ -6301,15 +6302,16 @@ nfsd4_lookup_stateid(struct nfsd4_compound_state *cstate,
 	}
 	if (status)
 		return status;
-	*s = find_stateid_by_type(cstate->clp, stateid, typemask);
-	if (!*s)
+	stid = find_stateid_by_type(cstate->clp, stateid, typemask);
+	if (!stid)
 		return nfserr_bad_stateid;
-	if (((*s)->sc_type == NFS4_REVOKED_DELEG_STID) && !return_revoked) {
-		nfs4_put_stid(*s);
+	if ((stid->sc_type == NFS4_REVOKED_DELEG_STID) && !return_revoked) {
+		nfs4_put_stid(stid);
 		if (cstate->minorversion)
 			return nfserr_deleg_revoked;
 		return nfserr_bad_stateid;
 	}
+	*s = stid;
 	return nfs_ok;
 }
 
-- 
2.43.0




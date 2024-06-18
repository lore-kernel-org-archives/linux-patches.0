Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F01C158DD0;
	Tue, 18 Jun 2024 13:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716496; cv=none; b=K7YNVLErrxCvveWjvbh0oKm2ZRNRftXpGU8kqkPAVHlenNNGBbS0MbUJaN3wf/bI5uzNmNHxb4wvAqaA8JhXauMRV3HGqH28PY0ZgewmP/ul7C1hO/UWb7S16uUu7ZoFCyPXXgLtmE514vOpPadz77DkG7W9VMqbGsMvvFO0mPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716496; c=relaxed/simple;
	bh=vclMQCzRiQsRxTFOdBgFStngHNsDolhNN+B4n4vPlDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0YCoRNBcIS967cmYYG/6ichpXOUsL/VBG67s//xHKYAlrmUJ9Z5zpFWPVPK7QXIXyr1VTF+FhXVpCBv/2CBn4hmdX069XMuym1CqFJwgHjnZ3kniSwM4Q6EzLckU6FTvyKvFcIQHvo0IZoAw1TkT3SL82wSl1dl3v+hViTQSWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ITYQrPIC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ITYQrPIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4A4C3277B;
	Tue, 18 Jun 2024 13:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716496;
	bh=vclMQCzRiQsRxTFOdBgFStngHNsDolhNN+B4n4vPlDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ITYQrPIC9hJWPoKHPHvvijgV6UqQor3RY1yQg+e1oezoESdKXrG/qqjZb1k9j8pDj
	 Sx926BawzYmPcOnAtd4Zk6ESCnd5TRALPemJTq1z1OPZYrYteuQY0AQ71tGzJrMhqQ
	 9KfcYrtSQqrptah1cLObOLuCU4M+4FYL9mR7Y5zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 665/770] nfsd: only fill out return pointer on success in nfsd4_lookup_stateid
Date: Tue, 18 Jun 2024 14:38:38 +0200
Message-ID: <20240618123432.952704999@linuxfoundation.org>
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

[ Upstream commit 4d01416ab41540bb13ec4a39ac4e6c4aa5934bc9 ]

In the case of a revoked delegation, we still fill out the pointer even
when returning an error, which is bad form. Only overwrite the pointer
on success.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index f207c73ae1b58..1dc3823f3d124 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6289,6 +6289,7 @@ nfsd4_lookup_stateid(struct nfsd4_compound_state *cstate,
 		     struct nfs4_stid **s, struct nfsd_net *nn)
 {
 	__be32 status;
+	struct nfs4_stid *stid;
 	bool return_revoked = false;
 
 	/*
@@ -6311,15 +6312,16 @@ nfsd4_lookup_stateid(struct nfsd4_compound_state *cstate,
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




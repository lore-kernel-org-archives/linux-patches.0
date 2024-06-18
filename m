Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B7B14F13D;
	Tue, 18 Jun 2024 12:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715064; cv=none; b=mWAZbjaJ5f8DShfq1C7rHqPlP5JD5dKZjdRyOV+ahM+pqRc8H55CG7xeZiEsLGdSQmkRqm7LdZYi+Y1m18/FbQ6QQ4HIyZLG8K5ejxZTopScUMEBj9NLuzLoovCNHWiFPoMRZd6dt77fM0vAdfWh8psFEyzQe7IfpgzdpZt3tBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715064; c=relaxed/simple;
	bh=0K0etz4wZiy/BDTpKnBb5QLO+oaiB/CN1XKPINaBPv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elPbSgR5JpMzZqUz+WlFW5DeGqbgV9QrlGS9fTwRlkiwdmpU4lIJvMKGfmC1Xu+OdbRPWRxZTQSW+4aMlrE0XlA3aTBy2jX48s3i6I33+3H7J7+0aLC2eVExpTmYhr/llwt82E4s5jhuiaL67w9p7Vv12VRR/60i99nG3W6WDg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HuP/KO24; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HuP/KO24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40652C3277B;
	Tue, 18 Jun 2024 12:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715064;
	bh=0K0etz4wZiy/BDTpKnBb5QLO+oaiB/CN1XKPINaBPv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HuP/KO24PP5k+TxIIif9iIBCl0NL97HJpFP0+hvsmY/wQbOCizKmJURVMw1TjRTZo
	 35M7zWGLEz648Z6O4mKj100WHGKo5lKuUdfLYTRbwnuRIyLDbVkoTSwHOYiTwJ+a/Z
	 3D/1cijS77PBRQP5Njia/rYRrox/TDD/fuV1x8z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 183/770] nfsd: find_cpntf_state cleanup
Date: Tue, 18 Jun 2024 14:30:36 +0200
Message-ID: <20240618123414.339858736@linuxfoundation.org>
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

[ Upstream commit 47fdb22dacae78f37701d82a94c16a014186d34e ]

I think this unusual use of struct compound_state could cause confusion.

It's not that much more complicated just to open-code this stateid
lookup.

The only change in behavior should be a different error return in the
case the copy is using a source stateid that is a revoked delegation,
but I doubt that matters.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[ cel: squashed in fix reported by Coverity ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index c4e9f807b4a1b..b05598e5bc168 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5832,21 +5832,27 @@ static __be32 find_cpntf_state(struct nfsd_net *nn, stateid_t *st,
 {
 	__be32 status;
 	struct nfs4_cpntf_state *cps = NULL;
-	struct nfsd4_compound_state cstate;
+	struct nfs4_client *found;
 
 	status = manage_cpntf_state(nn, st, NULL, &cps);
 	if (status)
 		return status;
 
 	cps->cpntf_time = ktime_get_boottime_seconds();
-	memset(&cstate, 0, sizeof(cstate));
-	status = set_client(&cps->cp_p_clid, &cstate, nn, true);
-	if (status)
+
+	status = nfserr_expired;
+	found = lookup_clientid(&cps->cp_p_clid, true, nn);
+	if (!found)
 		goto out;
-	status = nfsd4_lookup_stateid(&cstate, &cps->cp_p_stateid,
-				NFS4_DELEG_STID|NFS4_OPEN_STID|NFS4_LOCK_STID,
-				stid, nn);
-	put_client_renew(cstate.clp);
+
+	*stid = find_stateid_by_type(found, &cps->cp_p_stateid,
+			NFS4_DELEG_STID|NFS4_OPEN_STID|NFS4_LOCK_STID);
+	if (*stid)
+		status = nfs_ok;
+	else
+		status = nfserr_bad_stateid;
+
+	put_client_renew(found);
 out:
 	nfs4_put_cpntf_state(nn, cps);
 	return status;
-- 
2.43.0




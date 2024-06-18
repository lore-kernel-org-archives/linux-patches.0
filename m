Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3E813F431;
	Tue, 18 Jun 2024 12:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715062; cv=none; b=icraysR+C2Y21GeCnqQj3ubKqJfCa3AAtP5U79LAyXxSC3hSZuijXje6fjnYE/He+lvUMPGe0O8bfG6NowCcsBwkjLpMBETH2Ww2wAHHoAz61NMgHOYbmMRtuVfUfeP8DULGmgSo62B0Q5NnhSkVGk0xtg1NzunLVed7MdsLick=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715062; c=relaxed/simple;
	bh=9xvYc/cr16Nem3+owfNUzut/+2KI2qa0J0kXJ3CIpsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjuY7YK7RY0yXip3Qulvjl4LfAZNtTLtV9t3Uuo1z62b+WkglpOMEykZ5yfME/gwl8Y/z5WXPwpSTM/Nq1dW7fR7emgjInFAC83eUjURdI4GvsqMUFo776oKUGrMUvn9kZkfG2GnBWazniXJhFjU3UeEjTVawW448tGdUe33vZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gc3sVVAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gc3sVVAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E058C3277B;
	Tue, 18 Jun 2024 12:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715061;
	bh=9xvYc/cr16Nem3+owfNUzut/+2KI2qa0J0kXJ3CIpsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gc3sVVALyVf4JB9z6On5JfGyCmThGM5L9cpM4q5xCpkL20BIqKzISEWUUEJLkDxz7
	 JLxvh3iGVOX0iccqKNe5ZxGtKpaz8mHRWURAKFFKz8Vo6i162s1UXMnpSZPjV+IjqD
	 v8ZnEvw0H+F/gsCYek7hBZqzAiWK41hxH2sTC4PU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 182/770] nfsd: refactor set_client
Date: Tue, 18 Jun 2024 14:30:35 +0200
Message-ID: <20240618123414.300635238@linuxfoundation.org>
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

[ Upstream commit 7950b5316e40d99dcb85ab81a2d1dbb913d7c1c8 ]

This'll be useful elsewhere.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 60c66becbc876..c4e9f807b4a1b 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4675,40 +4675,40 @@ static __be32 nfsd4_check_seqid(struct nfsd4_compound_state *cstate, struct nfs4
 	return nfserr_bad_seqid;
 }
 
+static struct nfs4_client *lookup_clientid(clientid_t *clid, bool sessions,
+						struct nfsd_net *nn)
+{
+	struct nfs4_client *found;
+
+	spin_lock(&nn->client_lock);
+	found = find_confirmed_client(clid, sessions, nn);
+	if (found)
+		atomic_inc(&found->cl_rpc_users);
+	spin_unlock(&nn->client_lock);
+	return found;
+}
+
 static __be32 set_client(clientid_t *clid,
 		struct nfsd4_compound_state *cstate,
 		struct nfsd_net *nn,
 		bool sessions)
 {
-	struct nfs4_client *found;
-
 	if (cstate->clp) {
-		found = cstate->clp;
-		if (!same_clid(&found->cl_clientid, clid))
+		if (!same_clid(&cstate->clp->cl_clientid, clid))
 			return nfserr_stale_clientid;
 		return nfs_ok;
 	}
-
 	if (STALE_CLIENTID(clid, nn))
 		return nfserr_stale_clientid;
-
 	/*
 	 * For v4.1+ we get the client in the SEQUENCE op. If we don't have one
 	 * cached already then we know this is for is for v4.0 and "sessions"
 	 * will be false.
 	 */
 	WARN_ON_ONCE(cstate->session);
-	spin_lock(&nn->client_lock);
-	found = find_confirmed_client(clid, sessions, nn);
-	if (!found) {
-		spin_unlock(&nn->client_lock);
+	cstate->clp = lookup_clientid(clid, sessions, nn);
+	if (!cstate->clp)
 		return nfserr_expired;
-	}
-	atomic_inc(&found->cl_rpc_users);
-	spin_unlock(&nn->client_lock);
-
-	/* Cache the nfs4_client in cstate! */
-	cstate->clp = found;
 	return nfs_ok;
 }
 
-- 
2.43.0




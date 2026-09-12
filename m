Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A033F24CEEA;
	Sat, 12 Sep 2026 08:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202931; cv=none; b=Kg2Vi0iebh7YpMfmHUsGcc9/z4VNlkhRla68TVNYRJrDr/eG6nwvlMMR/n83XKK/Zp3/KWxr8323+WxQ2Sv8ufxBpEXKqdK1xWgwT/LMglO0VbZKqJQsrPhImyBZn7g6/Hk1Gia/U1bpx1ARv5T/HVZeNzZwbhbRyYHtrS305nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202931; c=relaxed/simple;
	bh=iiJoKX33wveEECpRkOPOpO/fvdt+mFIb076I7aPsfag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DhLK4kZPf67F0CBBFfrceaZZSFTiQxFLFDy/BkGDk/4H7KI/nvmI2AxiLVq9KCsa4/11/ZxxrWSPxpgQlZqgpkpICI5p8PwQVVnbLxSk/M8BzNC+6CjKmjS9TTj5QQnx9ujXLV3mXhHDL5WG3VfiIzGDlH9K05VMa+Uc+iszfdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wk3OuAzu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wk3OuAzu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55741F000FF;
	Sat, 12 Sep 2026 08:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202922;
	bh=KZtiRL4dt+9KQBm9d/G6HocbXoNSqMVhCidZeah/0J8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wk3OuAzuhGnWEcenfRfepOxtv6Pk67BOs0fb0jnqxrRC5ijrxamidC2O52TUGYH4U
	 unTjE9McU6R2PFVd92C5VRGuotMV2h7obN1FEATaX7HaxWgSUI5pY3sAmwLAAsitPy
	 36UI9JgL/BexNNqfsTpk5Fx6LEhhGZTacb9ECi/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1303/1815] NFSD: Release the export reference when reaping open stateids
Date: Sat, 12 Sep 2026 08:50:53 +0200
Message-ID: <20260912065719.606677487@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 6480bd703684ed3f760e9e36c4a699033c0806ae ]

nfs4_put_stid() releases the svc_export tracked in
nfs4_stid.sc_export, but free_ol_stateid_reaplist() frees open and
lock stateids by calling ->sc_free() directly, bypassing that path.
An open stateid takes an sc_export reference in nfs4_open() and a
lock stateid takes its own in init_lock_stateid(); both reach
free_ol_stateid_reaplist() through their normal teardown, the open
stateid via release_open_stateid() and the lock stateid via
nfsd4_release_lockowner(), each through put_ol_stateid_locked().
The reference is therefore never dropped, pinning the export and
blocking unmount for the lifetime of the stateid.

Release sc_export in free_ol_stateid_reaplist() the way
nfs4_put_stid() does. ->sc_free() runs once per stateid, and a
stateid reaches free_ol_stateid_reaplist() or nfs4_put_stid() but
never both, so the reference is dropped exactly once. Revoked
stateids reach this path with sc_export already cleared by
drop_stid_export(), so they are skipped rather than double-freed.

nfs4_put_stid() itself read sc_export before acquiring cl_lock.
drop_stid_export() clears that field and releases the reference
under cl_lock, so a concurrent revocation could drop the export in
the window between the read and the final put, releasing the same
reference twice. Read sc_export while cl_lock is held so the two
paths serialize and the reference is released exactly once.

Fixes: ba0cde5dc81d ("NFSD: Track svc_export in nfs4_stid")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260707-cel-v3-0-7c0cc16fd54f@kernel.org?part=9
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260709-cel-v4-9-1d519d9be0cb@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 6180f6dc8995b..258621750eb7f 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1276,9 +1276,9 @@ alloc_init_deleg(struct nfs4_client *clp, struct nfs4_file *fp,
 void
 nfs4_put_stid(struct nfs4_stid *s)
 {
-	struct svc_export *exp = s->sc_export;
 	struct nfs4_file *fp = s->sc_file;
 	struct nfs4_client *clp = s->sc_client;
+	struct svc_export *exp;
 
 	might_lock(&clp->cl_lock);
 
@@ -1289,6 +1289,8 @@ nfs4_put_stid(struct nfs4_stid *s)
 	idr_remove(&clp->cl_stateids, s->sc_stateid.si_opaque.so_id);
 	if (s->sc_status & SC_STATUS_ADMIN_REVOKED)
 		atomic_dec(&s->sc_client->cl_admin_revoked);
+	/* Read under cl_lock to serialize with drop_stid_export(). */
+	exp = s->sc_export;
 	nfs4_free_cpntf_statelist(clp->net, s);
 	spin_unlock(&clp->cl_lock);
 	s->sc_free(s);
@@ -1745,6 +1747,7 @@ static void
 free_ol_stateid_reaplist(struct list_head *reaplist)
 {
 	struct nfs4_ol_stateid *stp;
+	struct svc_export *exp;
 	struct nfs4_file *fp;
 
 	might_sleep();
@@ -1754,7 +1757,10 @@ free_ol_stateid_reaplist(struct list_head *reaplist)
 				       st_locks);
 		list_del(&stp->st_locks);
 		fp = stp->st_stid.sc_file;
+		exp = stp->st_stid.sc_export;
 		stp->st_stid.sc_free(&stp->st_stid);
+		if (exp)
+			exp_put(exp);
 		if (fp)
 			put_nfs4_file(fp);
 	}
-- 
2.53.0




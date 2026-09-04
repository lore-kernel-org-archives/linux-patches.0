Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D35372B4B;
	Fri,  4 Sep 2026 05:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500635; cv=none; b=PzfGhDVU8ouLftQ2dlkuKKOVR4tAmWOF3qz9uqyCSfWpeJQsVW+Snau04Iqh8yMnLClsD17q7x3tblXtLqUxqoHInfILoYHVScm46AuVVgSlt9XWchPj9Aym9My5xFFYX/tOSM5XPg7vLsrUHk3E62t8YfGxQLznzDjHr6W3xVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500635; c=relaxed/simple;
	bh=yCnTS+Ptf4fDy+Wi6mvN7SHx3wx2cQf1AWy4iR164BA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0swAI0i/9ESW5tiHESUcGR+6XXp4EfcGP/IVpWj00al/qyGoFhGe/gTJ6k+AlP8St3Sc9WJUImzFzytnhWdpzxORkxgfhxqR3TAlQQO8nHRibJvh+f+4AWp6mR3ZplRWK0XlkFvBG1nYw4wzViBnbBGGg2+Z5wfUpC7tGSeqJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQ/lOSN5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQ/lOSN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC941F00A3D;
	Fri,  4 Sep 2026 05:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500634;
	bh=hgMD38FYh55nrdFwqpZxXIdpewREviwo5QBXPiNh1fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQ/lOSN599dJgnpcnE/caXH/HBxdGJUNDlVXPplTEV4YcNBAmfYg189Vja9tD+/PJ
	 9d/auExHNm+nmadkCj8R4icpG4iKp4KTB9FrI+cI7BLvG+8YKVi89hXSyNFgqYVe/7
	 5fZQGgRuKN+J9PnZjLhsCOKy3VmMvXDJgTNINiG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 127/552] nfsd: drop the stateid, not the stateowner, on seqid_op replay retry
Date: Fri,  4 Sep 2026 06:54:44 +0200
Message-ID: <20260904045751.150072487@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 5e4627d3513e60accfce9d5f4c7fa95251ef93d6 upstream.

In nfs4_preprocess_seqid_op() the stateid is obtained from
nfsd4_lookup_stateid(), which holds a reference on the nfs4_stid
(sc_count) but takes no reference on the stateowner. openlockstateid()
merely casts that stid and likewise takes no reference.

When nfsd4_cstate_assign_replay() returns -EAGAIN (the replay owner is
being torn down, RP_UNHASHED) it has not taken a stateowner reference on
that path. The error handling nevertheless called
nfs4_put_stateowner(stp->st_stateowner), dropping an so_count reference
the function never acquired -- risking a stateowner refcount underflow and
use-after-free -- while leaking the sc_count reference held on the stid.
The leaked stid reference can also stall a concurrent
nfsd4_close_open_stateid() waiting for sc_count to drop.

Drop the reference actually held -- the stid -- before retrying. The
stateowner stays alive through the reference held by the stid. This mirrors
the open path in nfsd4_process_open1(), where the put balances a reference
that path explicitly holds on the stateowner.

Fixes: eec762080008 ("nfsd: replace rp_mutex to avoid deadlock in move_to_close_lru()")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-21-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7700,7 +7700,7 @@ retry:
 		return status;
 	stp = openlockstateid(s);
 	if (nfsd4_cstate_assign_replay(cstate, stp->st_stateowner) == -EAGAIN) {
-		nfs4_put_stateowner(stp->st_stateowner);
+		nfs4_put_stid(&stp->st_stid);
 		goto retry;
 	}
 



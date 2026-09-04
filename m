Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C1F358378;
	Fri,  4 Sep 2026 06:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502115; cv=none; b=fZcgqsGu+2ajR1A0h5y0LvREiALYcNp6WqYxzVV4W0QfawwZiOU9bskX/cKxp0q6TW/EpQ9Kw54GQXBZlgIdlf8yu2uWIgycLsol2jY4TJHw3ApY2HE8yI1DUlpOIGJSlil5QW0pND/GVcDv5hftTPMoUfSETBZvjC2pJsvbnUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502115; c=relaxed/simple;
	bh=XfygIbPK30HvagMInFegeIt8QNEptN5NC+wSMb0pyS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjSm52VqGB8dzBiAqL4/eQIQZMvDubD72hHCdfgCYbx+a2L6wZr4Vqdu8IQZ5JpggKtEZYNg9Nt5pob2sy4gGSHj+UmrZlJIdVHVtst46XsOPQYuRuvnORL8N3cxL7jUVj8a4WJMG+sHyEiMyQTqumGGsMOsxC0qFgLxqlqGB8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNcZqRrA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNcZqRrA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E7C1F00A3D;
	Fri,  4 Sep 2026 06:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502114;
	bh=TaiAIVo4IRh6dHtE5Mr2LyUEahV/R0f+mhmoeYu4FY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wNcZqRrA9BRsi+o3UGpGj4HcT9YiZjI+lSnTcMTy45jI3iRm4NfgA3BIdjfKQIT+G
	 QStBFnpicqfI2V7bqTLlzQWE10gXIlvYPz2PIFuM8VaNDmG84b9MTfoUlfDUIxi4QO
	 cSvUgkUC4a8qR98VOWFqlg94cpbvve/RCNzUtg9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 087/403] nfsd: check client ownership when cancelling a copy-notify stateid
Date: Fri,  4 Sep 2026 06:58:10 +0200
Message-ID: <20260904045736.814127938@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 6bdbfab96e0cf25e5f57dac5c09dc1749751a4bf upstream.

On the OFFLOAD_CANCEL path (clp != NULL), manage_cpntf_state() freed the
target cpntf state without checking ownership. The lookup key
st->si_opaque.so_id is allocated cyclically (guessable) and the embedded
clientid is the fixed per-net nn->s2s_cp_cl_id, so any authenticated
NFSv4.2 client could cancel and free another client's copy-notify
stateid.

Compare the creating clientid recorded in state->cp_p_clid against the
requesting client's cl_clientid and return nfserr_bad_stateid on a
mismatch instead of freeing the entry.

Fixes: ce0887ac96d3 ("NFSD add nfs4 inter ssc to nfsd4_copy")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260710-nfsd-testing-v3-5-a0ff7db6aa3e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7105,10 +7105,20 @@ __be32 manage_cpntf_state(struct nfsd_ne
 			state = NULL;
 			goto unlock;
 		}
-		if (!clp)
+		if (!clp) {
 			refcount_inc(&state->cp_stateid.cs_count);
-		else
+		} else if (memcmp(&clp->cl_clientid, &state->cp_p_clid,
+				  sizeof(clientid_t))) {
+			/*
+			 * OFFLOAD_CANCEL: only the creating client may cancel.
+			 * so_id is guessable, so without this check any client
+			 * could free another's cpntf state.
+			 */
+			state = NULL;
+			goto unlock;
+		} else {
 			_free_cpntf_state_locked(nn, state);
+		}
 	}
 unlock:
 	spin_unlock(&nn->s2s_cp_lock);



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F0547C10C;
	Sat, 12 Sep 2026 17:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232596; cv=none; b=mJPJPzncH+bGm1C5Nx0MhY3n47D7QFNuBAtcm68DNsFvZ6IIv8zYsPOdjT5rs6j5NQw1fn/lozj5xhNlr5fC8alWSOTk+PiQ0Pg2Vgk9PcZj9RAQUDlTWC1JWyWiLcYMr2TPuMUOiHIwUpxCB9YfXFX2UvfugGFYoRK0ECVE0Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232596; c=relaxed/simple;
	bh=My1QhSkM7Iw8fxMwnnNvuh9qlStfLDASlxJTUUb/pf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4vg+lD4PDqbkCrIgG8xq1/h2bPbhMbaGf1flui/zpfbqg2+wwcrIgNlCW2oMsSmXLGOrrq3m0CZYhbHS+Kee5GUqXRrFChLk0bhYgD/evN7QMB7T86RDR0ZgrzuPfW/MbJUXkqr46Zmb9GWa3cLGow0Kg7anluGyG2RqYbYbns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eWvP6XOk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eWvP6XOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129271F000FF;
	Sat, 12 Sep 2026 17:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232594;
	bh=w8lz+Jm3agXyNrWcJaGAtzTYi59QiMPoteK4N0eVdeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eWvP6XOkKuoo5cE835rrmiKhtAiF2UyxIlwWwrls7CqoJniix3c/P8olRUuY5kPxG
	 xYu+MBc8mRp/qwRTTTbo52I52TRzHawkZm04qm4Ks/L2Bh8NqAQFtxbd8HTv4ECI06
	 tXXcOlQmCZikYhL4C6eaYaVcJfT6FWhLEshW9oUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.15 043/935] nfsd: check client ownership when cancelling a copy-notify stateid
Date: Sat, 12 Sep 2026 08:51:13 +0200
Message-ID: <20260912065527.824723178@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6616,10 +6616,20 @@ __be32 manage_cpntf_state(struct nfsd_ne
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



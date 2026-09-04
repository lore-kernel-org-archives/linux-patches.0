Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BCA3905F4;
	Fri,  4 Sep 2026 05:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500743; cv=none; b=XQ9z3aSamcW4Tx3Do6I4kLFR+JHeChuiYCao0Kx4ACwQDSWZPpi5fqXfKQpQoenIBswsbEQvPy77P3Lsx2v0cCUA3hQbcQI835ILkKiCYwz+kGKBnYgJu3Gn9xGJElG5Q11xEP13vbcecw83OLHMHlGKBItGGC/LtD3iNLkXjgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500743; c=relaxed/simple;
	bh=FwYEG+84gzF5Hg8AXYsHGR3b25gaPqEL0g7z4Vlyb/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RLyEijundacy3bJeAUuxDSt/dumBcTmXkl44GQaw7H+XUmorZdgNKWi3n07KvNXSOYU+SJfA9FYdDfVQYMLtTOq0AEzeAqXWKaU7M31UlzJyzioF6kDNCUgzVaCdPd7ZC01DLayGakQGRKJDqxJkxiK/86eHyuC0rzocVpmSgdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2L/gjhLt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2L/gjhLt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB9E1F00A3D;
	Fri,  4 Sep 2026 05:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500742;
	bh=TnUE/s3/Z3Cz74D8XvOXgn8oa+Y1EZqwCyGn1Qexgzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2L/gjhLtQpPQlNfx427WlOUd3B6VzZxHMRCiZbD3OsxTA0HK1CZXhJoaJIzKyKUgG
	 WrNRZXt3FFRf1kt6AMdJe3krYBQ7nH+nzeD+bkPME3FwhDo5ibSxjTs0ZkyIlwyv8Z
	 cnY0JrB3MjYVoHZYpJGjNvIHrN7ATMK5T/YkRyZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 121/552] nfsd: check client ownership when cancelling a copy-notify stateid
Date: Fri,  4 Sep 2026 06:54:38 +0200
Message-ID: <20260904045750.814851343@linuxfoundation.org>
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
@@ -7383,10 +7383,20 @@ __be32 manage_cpntf_state(struct nfsd_ne
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



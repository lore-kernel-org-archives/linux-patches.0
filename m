Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4223438BE;
	Sat, 12 Sep 2026 19:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240970; cv=none; b=K8QmY4zZncfKxkccYdgdbf2c+MzRWY1i/p28Z8cZ4yeeVrzAmgjyrZ8YAmYxeeLQz1xtUWN9CR527wUv+rDi5Co6GbDHYkWfqmOom8fk2AH4TEDtN2fj9CVpuEP3V6GuZHLgOwk3iAjo9oqTW/9DWb3je4p58irHTSp8n7TdnJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240970; c=relaxed/simple;
	bh=QeXaws4t3nKbd/+aobEYCyd4UXa1F5if4ghNRCjg5dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOs8zkw/UyPykdno0bsrSPyJVh6SBn8C8cr0aWNgNAHScsZ1xMvhruWNb+bYcaxZkSf9udNXxTmCJpBuGfElchHtSSR/sNk2f74sye4PVDkywK0JZLmmz7zLpC6HLAuHmF2zqf4Xi7/u8JkPTemkWqkPdEHzbNDy19Y1Sc6EOqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bwa4OMkN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bwa4OMkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008771F000FF;
	Sat, 12 Sep 2026 19:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240968;
	bh=chmg7aajiIhH44mM+9sr1X1RyEin6j0DhH6odR/Am2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bwa4OMkNi7D+GkbnUk9+hCKh7NOUUlfG1HFc6GFYtd3jGDqMSW+RsT7TGTA01NYt+
	 PraGIqbGf7Cl92u00TrFsli5kUFjsYnuL4c80fs6fFrWOP4JU7NfoymPKRvpJl8g4l
	 u4JpkJAuMi6mG1DY6INbvbMLpXOgbL+KNUOPDK7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.10 039/798] nfsd: check client ownership when cancelling a copy-notify stateid
Date: Sat, 12 Sep 2026 08:54:27 +0200
Message-ID: <20260912065517.859090999@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6621,10 +6621,20 @@ __be32 manage_cpntf_state(struct nfsd_ne
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



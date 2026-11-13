Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590827;
	b=A/aEM0XMK5HXJUCQsr5gkrxyGrAyMnYf7BJeNvlSmV47PwstavYTbQ1RRX/Ml0wAmXhP
	 dVc6SIyk+SFwHPTmdsQ6Ji/txBOTBG/ypBtyWTTsIYjd6JN2A/6j1Eb8AXNaRqP6bYRvX
	 jUXbWvf/VcbWpQJ+bYhL5DXIvhi/r4HHWZnJhqkdiCCIy8J5N4xZnDBGtZZzvb+LJvS9z
	 MADXpAwb75juPpfJdMoD1aIqfcoPmBfbyD5sn8tuG65Uz2+eWbHg5qaIsfsTXf8VCaI8s
	 SO2QVv2kGAyxo4MeiFTXXD90L8RXHbNfNRFvqiQbhkeY0Qh6KUTzXMse3gn+D4keLqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HFMc4S6qlK65npjqufl5WEhaYynxQuSjUZj9zJ0TTpI=;
	b=a7mURNOSEu3Qkss2PxqJVPNLK1fTaKfi5LBj54jPJlojbwY5EeIbQhfMh/DidH2Q298P
	 9Ekkj1tnN5XxaXCR5RwCicnxuNIgaqWMM34xvpQ6snRKRHThha5PIwNbgpd6oFRArUN/1
	 u3ksx6nhRcnVZA5uvKFA7T6qJ1EXEKQHnT6B9UQDAWWcayt/3CgGB/UPkZ523Vg9U0cIP
	 g9G5l2p+BuFS0QqXGwoomEmdz3UMThNhqvrFvFCLB2ANL3vXwB/evIeA98EZWzfJ30tYA
	 bDBX0eScVeQIynZ23N4HOTvCzXaUBsjUaq8yq+65vircS33peSOa/OR23YuGSjagPog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hKFc2U9o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F877607E066;
	Fri, 13 Nov 2026 17:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hKFc2U9o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6771F000C4;
	Fri, 13 Nov 2026 17:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590827;
	bh=HFMc4S6qlK65npjqufl5WEhaYynxQuSjUZj9zJ0TTpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hKFc2U9oy4/nUPDFbTGP+QCm9mIcr2YvXEEwKk5fvndT+Xg/5iaDX2dgq/CbBfsmw
	 6d1/kdrWNvbf/IUZuhUq6p9SfjIV29/4Uhf14chjx4e6ufENqbAijzexEkAtdNx+6+
	 V5FegNIx0ol8jwGJuyPn4gyLyKjZWH4y1u3wlUBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/670] NFSD: Count the delegations held by each client
Date: Fri, 13 Nov 2026 10:43:16 -0500
Message-ID: <20261113153812.254804555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 5d5a6e996e7c36bc2f7b035743c16f2bf03a227d ]

struct nfs4_client records the delegations it holds on cl_delegations
but keeps no count of them. deleg_reaper() walks nn->client_lru under
nn->client_lock, but cl_delegations is serialized by nn->deleg_lock,
which nests outside nn->client_lock. A caller there cannot take
nn->deleg_lock to count the list. The cost tells against the walk as
well: an O(n) count per client, on a pass that already visits every
client.

Add cl_deleg_count, maintained at the two sites that mutate
cl_delegations. Both hold nn->deleg_lock, so the counter is already
serialized against itself and needs no atomic of its own. The decrement
sits below the delegation_hashed() test, next to the list_del_init it
pairs with, so it runs only when the delegation really leaves the list.

A reader that holds only nn->client_lock is not synchronized against
either update site, so it can see a count that does not match the
list. Such a reader marks the access with data_race() and may not
depend on the value for correctness.

No functional change.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260817-recall-any-keep-count-v5-2-3b2cffce701e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Stable-dep-of: 9af39c0773ef ("NFSD: Send a meaningful CB_RECALL_ANY keep count")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 2 ++
 fs/nfsd/state.h     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index d2878bf1e7181..43755bce08f95 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1420,6 +1420,7 @@ hash_delegation_locked(struct nfs4_delegation *dp, struct nfs4_file *fp)
 	dp->dl_stid.sc_type = SC_TYPE_DELEG;
 	list_add(&dp->dl_perfile, &fp->fi_delegations);
 	list_add(&dp->dl_perclnt, &clp->cl_delegations);
+	clp->cl_deleg_count++;
 	return 0;
 }
 
@@ -1451,6 +1452,7 @@ unhash_delegation_locked(struct nfs4_delegation *dp, unsigned short statusmask)
 	++dp->dl_time;
 	spin_lock(&fp->fi_lock);
 	list_del_init(&dp->dl_perclnt);
+	dp->dl_stid.sc_client->cl_deleg_count--;
 	list_del_init(&dp->dl_recall_lru);
 	list_del_init(&dp->dl_perfile);
 	spin_unlock(&fp->fi_lock);
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index 4e0e36b81b203..1909d744d4ac5 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -457,6 +457,8 @@ struct nfs4_client {
 
 	unsigned int		cl_state;
 	atomic_t		cl_delegs_in_recall;
+	/* Length of cl_delegations, updated under nn->deleg_lock */
+	unsigned int		cl_deleg_count;
 
 	struct nfsd4_cb_recall_any	*cl_ra;
 	time64_t		cl_ra_time;
-- 
2.53.0




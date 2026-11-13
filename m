Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794586013;
	b=0SPY9ASPFtTHXEVvlJx3qaUWgam27rMkBo9LmDyfLyc7G0THTk58vslRDa6v78twVZya
	 39htfo4HighGp6vrpQADGyn0LWM1vNR9e6L9GKT2AjGgQCmI9Lwq5QZIRXVPKtkTEhxvj
	 L0yZtt02kggbYVHGB+5D76oqxWe/YlA4aDmACCos4EtxGzENtioF2Ow53waNJKfdNXTFB
	 qwMbcwyWCbJgzv38U3ZnJ8wCYyfuHUy367+mIvtymJO2oS9bf8ueBt1UxonuDKpzZ2FXP
	 a9/GNVQFidgyLeB3Z7OBXstn29JaNNwX5aGK8OUOz30nVtl28e7GublrjDY1oOmqr3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794586013;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ebo5e9PuHU9LDXT6zUtv3JZLMN8lL+TZAmeAS5Jw8YQ=;
	b=nEfneeYSS+2J3uAbfsUTCyf+LmTQxTQMpaUIW55Fq7Z4un5vprrn1l2+GT42oHer7En/
	 myK5sNNe+rvFlbTgn51Nr4Q/X3dzMsa2QX7NveWkd7IflPJxiJmVk7SceHBtukmEc/Epp
	 yXmI+2F5fuiSL33q6dj3In07FGQOXPWGHiJuXt9pKeT2ZW3LXyjpgPzBQBCl15ANF6TXK
	 eUvA0KFzzcJ/41OZovTkiUT/wQIaJe5gZopGbeHz/rJ0WQ6/wOBGY4dtbvdc/j8ON7sOR
	 uMr+C9PegjdROxUQ+8KRX5c1HFdUbBQZRQdJ/O1JuZkOe8sC3b99Ec2IEbH5Bpn2THA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aPfHBrUo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB3D606B5D5;
	Fri, 13 Nov 2026 16:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aPfHBrUo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE671F000C4;
	Fri, 13 Nov 2026 16:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794586013;
	bh=ebo5e9PuHU9LDXT6zUtv3JZLMN8lL+TZAmeAS5Jw8YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aPfHBrUoKxO9FoX8/UcaD2JynhYwGfNGiv3RPg0F62WKQyEY5Gl7wnY4M3iLUfZsa
	 TGKsh0xeQWlH9d1EjZh0AdDRK6aSKWjSYLDlTnEyofA3pPF2LvCXZ95avFe6OaJpkS
	 r2GGAb/6vX/cvzcaoEYu0I50wLf88xj6R68YSE/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 045/686] NFSD: Count the delegations held by each client
Date: Fri, 13 Nov 2026 10:42:58 -0500
Message-ID: <20261113153822.490873211@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 42035bfebda7a..222f2aadaafad 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1423,6 +1423,7 @@ hash_delegation_locked(struct nfs4_delegation *dp, struct nfs4_file *fp)
 	dp->dl_stid.sc_type = SC_TYPE_DELEG;
 	list_add(&dp->dl_perfile, &fp->fi_delegations);
 	list_add(&dp->dl_perclnt, &clp->cl_delegations);
+	clp->cl_deleg_count++;
 	return 0;
 }
 
@@ -1454,6 +1455,7 @@ unhash_delegation_locked(struct nfs4_delegation *dp, unsigned short statusmask)
 	++dp->dl_time;
 	spin_lock(&fp->fi_lock);
 	list_del_init(&dp->dl_perclnt);
+	dp->dl_stid.sc_client->cl_deleg_count--;
 	list_del_init(&dp->dl_recall_lru);
 	list_del_init(&dp->dl_perfile);
 	spin_unlock(&fp->fi_lock);
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index 926e4e8063b33..fd61bac52721d 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -525,6 +525,8 @@ struct nfs4_client {
 
 	unsigned int		cl_state;
 	atomic_t		cl_delegs_in_recall;
+	/* Length of cl_delegations, updated under nn->deleg_lock */
+	unsigned int		cl_deleg_count;
 
 	struct nfsd4_cb_recall_any	*cl_ra;
 	time64_t		cl_ra_time;
-- 
2.53.0




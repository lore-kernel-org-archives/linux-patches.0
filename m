Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019216;
	b=HeJfv3I9HxYpjwWoYLpDoQOXimrJKjxqbMJyQf6IbyWzqnIo6pk2JkmX3N+RY7MW19dO
	 diKZ0GAifIseK6v4VXKkrGsJ+FLwcH6amVTYE+jAVHN+KcTvwayDnMyfwLkMuDzzRilWL
	 OXMgSJAwFrn93gk8GV5v4kExmTvOmbpoolzoPARAB3Jf7icnxC76nmchX2+qktqqwfY8R
	 M205Tu9i73VoJ52k/4XasvaI7XGiIgcgzjGupiQTJ53GotKph+1pcFbOYOptL6B9QRZ6T
	 9cIZxsFwxhFiukxv9X8991rkwcTUeiF6LZ4XiU6vfCpkZyIGxig1M4bgVAEj8MUcwTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=37j5L49c3ET7kxCOe51kqqOWBBN2pOsNlTzw+XH428c=;
	b=JvH1n6KVeC6Auo3Bi5Bka9vdMHSuz/0pYLY5lVOxPrwsFCKQv+QFeDTXtJTHpbuZni5f
	 9u5H18n2a6jJhXwCENr6Y7ttis6PKt6F8zRH458Eo7jyqU8ASgdC7IHpYh+JP6iUQcGeM
	 CLGBN6llCGaXja2P+yqzlGivES2qYqnHTLdWJzz+ef2hd340eXaGFqjBkAtS+74E04AMr
	 I2erLts94x79PuovXePHfhR2Z3XNGq3D4pQJ/5h4lo4fdKE/6rqVDoc3vGAQ0OsrmehDu
	 XlTVE2S6eHDmAMnasBEG27ThOGQ6x4bbc9dxXFNJplGMPR4MDMJyyY7znxo2kBVZAdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QeFGW8OA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79729606A31C;
	Wed, 18 Nov 2026 16:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QeFGW8OA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909721F000C4;
	Wed, 18 Nov 2026 16:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019216;
	bh=37j5L49c3ET7kxCOe51kqqOWBBN2pOsNlTzw+XH428c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QeFGW8OArI9lswm4GzHWkhiCHz1k8LOZASiHj/3UYwyp4qLeGCwX9BxIDoktGF92l
	 CEgDH6O6ro+sfgcAKYngjl6sWEa2m82EiQGt/D5VYB3OEkVRDGBKBOBk5ZaD3bZ83k
	 ARxPbTlcaYgl88QJiyUJdMJVprwajX8H5mcI5t4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1516/2651] ALSA: seq: Drop the bogus RCU guard from clientptr()
Date: Wed, 18 Nov 2026 15:45:56 +0100
Message-ID: <20261118150342.579068559@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 8bd561f8a6051f4e287dd0d076f17a1af5bff009 ]

In the recent refactoring with RCU, clientptr() takes guard(rcu)()
around the client table lookup, but the RCU read-side section ends as
soon as the function returns, so the returned pointer isn't protected
at all.  This gives a false impression as if that the callers were
safe, and confuse reviewers including Sashiko.

Actually, the callers (snd_seq_delete_kernel_client(),
snd_seq_kernel_client_ctl() and snd_seq_kernel_client_write_poll())
never relied on any lock; the caller is the owner of the client (a
kernel client passing its own id, or a user client via its opened
file), hence the client can't be released concurrently by others.

So just drop the confusing and useless RCU guard, read the table via
rcu_dereference_protected(), and document the lifetime rule.  Along
with it, fold __clientptr() into its only user client_use_ptr(); the
id range is already checked there, and it's never called with
clients_lock held, so a plain rcu_dereference() suffices.

Fixes: 7a287e4615d6 ("ALSA: seq: Use RCU for the client table")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261007172051.13240-2-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_clientmgr.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index 239809ce48d72..ba5619d0b0b0b 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -95,23 +95,18 @@ static inline int snd_seq_write_pool_allocated(struct snd_seq_client *client)
 	return snd_seq_total_cells(client->pool) > 0;
 }
 
-/* return pointer to client structure for specified id; call under RCU read-lock */
-static struct snd_seq_client *__clientptr(int clientid)
+/* return pointer to client structure for specified id;
+ * the caller must guarantee the client's lifetime by itself, as neither RCU
+ * nor a use_lock reference is taken here.
+ */
+static struct snd_seq_client *clientptr(int clientid)
 {
 	if (clientid < 0 || clientid >= SNDRV_SEQ_MAX_CLIENTS) {
 		pr_debug("ALSA: seq: oops. Trying to get pointer to client %d\n",
 			   clientid);
 		return NULL;
 	}
-	return rcu_dereference_check(clienttab[clientid],
-				    lockdep_is_held(&clients_lock));
-}
-
-/* return pointer to client structure for specified id */
-static struct snd_seq_client *clientptr(int clientid)
-{
-	guard(rcu)();
-	return __clientptr(clientid);
+	return rcu_dereference_protected(clienttab[clientid], true);
 }
 
 static struct snd_seq_client *client_use_ptr(int clientid, bool load_module)
@@ -124,7 +119,7 @@ static struct snd_seq_client *client_use_ptr(int clientid, bool load_module)
 		return NULL;
 	}
 	scoped_guard(rcu) {
-		client = __clientptr(clientid);
+		client = rcu_dereference(clienttab[clientid]);
 		if (client)
 			return snd_seq_client_ref(client);
 		if (clienttablock[clientid])
@@ -159,7 +154,7 @@ static struct snd_seq_client *client_use_ptr(int clientid, bool load_module)
 			}
 		}
 		scoped_guard(rcu) {
-			client = __clientptr(clientid);
+			client = rcu_dereference(clienttab[clientid]);
 			if (client)
 				return snd_seq_client_ref(client);
 		}
-- 
2.53.0




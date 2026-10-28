Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208043;
	b=SkMPIhXN9mM4l4p8vjJoBmME9Jr2mndb4mGiifCvzmbMNl/JI5EFOQZAfyLbl/jKqkN2
	 m7A67D2dTwUMMEIx8Milf5lCyCTx+UHbGKV/v6ShsaRHGqFQN64wFTLFZfvQzlEJtJWBF
	 g/KuyT1+YPRpIgerNm9EWFb6cAk8KCm0PIIWPfcxLkHT10s8g1fvYo8HyQSuweX1Qbcj8
	 g5Yvx0RUU65IR3q1ImxhzOC72JI7d316M2MzTi0pdbrliMUY6Uy4XtSWOUZltHJpY0mQs
	 IS9kUOb82uJV+kmdIA9nHEG0FJAUMQNRe7oyhvyo+a4/lb8MHLyvFaAn7ZogjwJICqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208043;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vaNVVkav9eTl72gE9/A+5fqaGhttZj231edAq2YnMAo=;
	b=vZj0877W2UVU2vWEJzrfsbA5nUNYCrcpPByTt5oXDMZQ0BMqU5J8uyPdIpgLHmhJzjXq
	 qii7Rfv9Y5gWNhAxHJZrh3i8WiYENHXgHalE3NKUQDKVr3bl1Bwf66wQ2ihfJG1sqwNUl
	 Fg2h7XjUO8PDsndIl8o+ZqnIg4JnTURu7w/j+E8scS3fl/plUx6zH3e0uxKDf9y778raW
	 gsUYIOFs2xRS2bkJuwpLe56IHWPIHnwNxZR8lQlW6pswKdhcJCDuIEJFu0jtSU2NZUrSJ
	 rb0ZLzYuXBUu6yqU2YeoPlq+X/gd9qesYU0cKpBUhnROvo1Z3DLyFqObVPbmEsf/8Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HH+q9WGe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83035606A31A;
	Wed, 28 Oct 2026 17:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HH+q9WGe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1CC71F01825;
	Wed, 28 Oct 2026 17:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208043;
	bh=vaNVVkav9eTl72gE9/A+5fqaGhttZj231edAq2YnMAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HH+q9WGe41HT8c+ExTw521vdKRs2xMCqcjHgtNoLYDboOd/gEBKvRfxoPgXlNgYrY
	 NBN3+3Iv+3RI5rI6ySVVYZNY/iypKk3F+FPdd0O97MG9OTk+UTwnXIO7JwsRoxLpCZ
	 7Z/CPdExardzx7JFhiFwsLhNkb5NeVMLgE4wW/3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.12 230/247] keys: Avoid the owner account dereference in named keyring lookup
Date: Wed, 28 Oct 2026 18:00:33 +0100
Message-ID: <20261028165952.867587613@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

commit 51409aaa01f8602552c336009fd22b226b0cdf1d upstream.

Named keyring lookup must keep the storage containing the owner UID
alive through the namespace mapping check.  find_keyring_by_name()
reads keyring->user->uid under keyring_name_lock, but that lock protects
the keyring's name entry and allocation, not its separate key_user.

A named session-keyring join can overlap a privileged KEYCTL_CHOWN on
another CPU.  If the keyring holds the last reference to its old dynamic
key_user and the ownership transfer succeeds, the following ordering is
possible:

    Named join                         Chown
    find_keyring_by_name()              keyctl_chown_key()
      read_lock(keyring_name_lock)       down_write(key->sem)
      load old keyring->user
                                         replace key->user and key->uid
                                         up_write(key->sem)
                                         key_put(key)
                                         key_user_put(old user): free
      read old user->uid
      read_unlock(keyring_name_lock)

Chown neither takes keyring_name_lock nor key_session_mutex, so it can
free the old account between the pointer load and the UID read.  The
lookup then reads freed memory even though the keyring itself is alive.

Use keyring->uid for the mapping check.  key_alloc() initializes this
inline owner UID and keyctl_chown_key() updates it on chown.
The existing name lock keeps its containing keyring allocated throughout
the check, so lookup no longer depends on the account's lifetime.  This
also matches the owner UID used by the permission check.

KASAN report as below:

    BUG: KASAN: slab-use-after-free in find_keyring_by_name+0x577/0x5d0
    Read of size 4 at addr ffff8881128ae2ec by task keycase/500

Cc: stable@vger.kernel.org
Fixes: 2ea190d0a006 ("keys: skip keys from another user namespace")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/pm-key-management-objects-candidate-0002-v3-2baa8cad2bb554364e10@gmail.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/keyring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -1158,7 +1158,7 @@ struct key *find_keyring_by_name(const c
 	 * grants Search permission and that hasn't been revoked
 	 */
 	list_for_each_entry(keyring, &ns->keyring_name_list, name_link) {
-		if (!kuid_has_mapping(ns, keyring->user->uid))
+		if (!kuid_has_mapping(ns, keyring->uid))
 			continue;
 
 		if (test_bit(KEY_FLAG_REVOKED, &keyring->flags))



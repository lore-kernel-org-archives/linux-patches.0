Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210378;
	b=hPgycGaOxxw/yciXcmc2bgfRW3skmbHtuDmxWW0WnwtfB6syXlJCnkxWPR1gAQhoB29O
	 S4nnTTyTIu6rqPqq16XpxlUBR1WNFya50LoEzToueHwChgVWAe/6/6K9sJsEHRINGCTqR
	 /ClDXeJ8brSJipXzWcsqdM8wOgiXzE44INLYD1pPk0QeiuQhg2hdyJ6oFqTAkD4MRYqEC
	 gw3kG2WJZk4NBBFPX4xzOFNWvDysiNWfs1UI+wzUQD+RnJKg3qEO8DCG3ZJmvj3RzT1TV
	 nQEME6clDNvz9Q7OjaCg5SPnvn4kKSoB1zQIcRR6SCiH4Om4L6YxBnMuBE/wwQB2yXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+baKTzbYzmDU4f6ZlowqCHUvCm2cOtrnhiOD/DuPBkI=;
	b=4poCQW22yXNUQ80+hI9wOXLzmtvzeIWskE84dhvfiKFdwyRNt5A5e7oCPW8A1ZDNMHt2
	 M9rNadpfhBG3BOKViYLciz0lsewXOT+N5HeMMGtf9W3dNYC3zsSDZzvBiIoOAwNgr/wTj
	 An8hAFFCF5J3LjvEslVt1jcrEHnR7ludKMNo4/hE20Sdbe/ENa6u29/w5z/jeI7w2tR3O
	 FmPXwMpRO2c2/mQQO96U1FitWDyYUUtPSmHquqMSbm/ilX/pklsdcLtpZBv1jh3OWjdua
	 gpZV6z8kioZYEYMeXfz1/w+Y5fraSHPhLQDzv4FX3pPosEX88Ltdwi9ivPjvWFZ1gHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jXtOo0Fn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDA8606A31A;
	Wed, 28 Oct 2026 17:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jXtOo0Fn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C93B1F01825;
	Wed, 28 Oct 2026 17:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210377;
	bh=+baKTzbYzmDU4f6ZlowqCHUvCm2cOtrnhiOD/DuPBkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jXtOo0Fn/VeBXZ+E3q2qnZx+eoAGNDNrEu8NXjb7JGAlpuEOYQlTWy9ZJxOWixT2B
	 0lMNHdYOlMOJTLkhatpV49Fjk0p+MhXT8MrG9QOqYxeVqPXqX7YUqqMX/BodSTRpv2
	 1vW4Q0/v8D4hcZLodOp7LRsfETbuQtiih7JXhUaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.6 153/168] keys: Avoid the owner account dereference in named keyring lookup
Date: Wed, 28 Oct 2026 18:01:29 +0100
Message-ID: <20261028165946.707547143@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



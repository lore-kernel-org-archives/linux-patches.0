Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217148;
	b=QgbiLCcbHURluJXSu2qPcUAKIqZ33YOLg9Koz1O7XUFIadubJPnlFu0y6znYdOZQm1y2
	 XInoNxl2wO90mCBTS2jCz/UcTtVcIn+jYW5yvy8EvYDwg1xJdiNt5zAFV2ovY6BbliQb6
	 a/Khc/tybXMRy3DT9Z8DkFnxs+Umdz6ivItpLrxGmVFKeHGmlTT97SJuoBRPjeGb8jIFC
	 4rLQ7WwDVUoWuorYHDd0c0+fZal9Y3t3AsrSuEGvL6QkHTI81gCl0Abo1RszUNc0aRnkh
	 XonmdIDDAd9539MDUiqZVD4XFOf0Vdb/EZL5c/5ktPR+DU4cZoG3iaHZemnpZphjEIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217148;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1YYmqEcwa9LpTADnJNeqXlXqO6coJfIjKyqS1KmHz+Y=;
	b=sga2BfFsTCd8UDICGi5k0UP+p4o0gzs9mEOjXfS5DkQCWuKG8a31R2Jq5lpFJP4Al+tV
	 Rcl4MTEx8aKS5AoYgZE5EE5o8CDyl+bHSvidyfRAQZD4h6hRdAPgmR7ov4ViuOjYezNuk
	 oUguPjtUZjR+pFZKtGUilQLE+O7i0n84VtlRcwsL5rEGIofHbcQkSg7nNKFkwQDXKhTE0
	 muKHuJR5/ZL0W9W2jMRO2r3LvWuCCuZstgtlOyO4FiGmzFtRBv5k7fU3riPUHBY+pMRsu
	 42N0rhzFFM3RedF53iqT/laI1g90Ux2LWQ1oLomvqEY8HUmA1mothhq8MmfSmSMIZNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uFM9w4Ks;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A05606A31F;
	Wed, 28 Oct 2026 19:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uFM9w4Ks
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BB01F01825;
	Wed, 28 Oct 2026 19:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217148;
	bh=1YYmqEcwa9LpTADnJNeqXlXqO6coJfIjKyqS1KmHz+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uFM9w4KsVI6SjxKCfFMxpoL71hB6QFW6Y0VbRNAFyK3l009W/1hFjjI0FnIG11zSy
	 kuNOVrfa6Y/YeW86ij1bWKCqP1mFYnswgZLJ3Jm/vDwo129ZCeeLxKxeuuBAX8Qt3Z
	 gRj1EqFZcQMv3OZUt3Y9ICM46K7NroEIkSA8YtH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.1 1805/1887] keys: Avoid the owner account dereference in named keyring lookup
Date: Wed, 28 Oct 2026 18:05:01 +0100
Message-ID: <20261028170540.524186216@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



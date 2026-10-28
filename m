Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207397;
	b=Ntv27akialLSDjWaBxJ6mbjYZIGjjedvD9SVzrQO5bsp5sOkcDLP2/7wDFot/0kvv/05
	 OeqV9BSeg+x0qFQFV5IaespDRZf/7YqBa7hn7tM/SdGs5VWmQAYkD/9ecDIUDda6Uj4rh
	 MKZGUk/A9UQcDBRETNNCaVHtjMRlwXTydrwRw1JVFsM9Q/es5Y32f3u3zqkW+01mg6XFq
	 oTrTW8vLnLVxEdVzAPR4om1xc146YQlbFj7QGqrYzUgzu0Lup6RGk2iBMRUH1hmO34kAD
	 RLuWJs1pxnVplqMJQgxEC/2q6JEL3XTLRy+JtYVoWxNawaVRRvCgmMeSiTYczPdYvXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vfVqMfymGXMs3Jg4HuGNw8tic4IU77kNbUz+WwmhpbE=;
	b=yVIllrJKb9eq8Wvlt3SEoODFwBRPwLlqyV3IbPG+6iZDAyntFi1L2rum0sOAAtnLZCw7
	 PwH0t2H9MSxp/YqJA0EYaac3cbODqYGikvQSICE7gzMmWL93rNsNOAqz3PyAVPlLJ63G9
	 ntPS9sM2pIZ6q+umfTZKkAYAAe+6WwdFVZ9bX1RUpPJ+Y5Ikt4/apy07zdMkdNP1WihpU
	 BgNyQbcAh155JfWEBTtZNgWODtaHlGa8eCe5GGJ8K1pnivm5qwx1M5ygg/z2VdwqZdD5G
	 Du1EbmS3G+GnPaWDU/P/2NBIoTWop6zx0JPENAX2x8vPsCIuR6MVglvsoE/p4pTbUbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hzWq0sEK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BE1606A31C;
	Wed, 28 Oct 2026 17:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hzWq0sEK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B1F1F01825;
	Wed, 28 Oct 2026 17:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207396;
	bh=vfVqMfymGXMs3Jg4HuGNw8tic4IU77kNbUz+WwmhpbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hzWq0sEKkk9IvwpcFZV+oaYeZN6p86kOM7veeJJ2Hl6rkhdumriZwotXlZO5iBADY
	 VGQ+RbjZxUDBpvoHWQAR6yf+oUtIQsrji+kFafT02lGSsXef5ig5Fz1txcKXj2ui0I
	 j3iMpCsk8PMJ5Lo8/zcJ6LFvyRPWZpajjfrd0QJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 7.2 70/88] keys: Avoid the owner account dereference in named keyring lookup
Date: Wed, 28 Oct 2026 18:00:18 +0100
Message-ID: <20261028165943.762620698@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



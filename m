Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209048;
	b=guH5gykkNUVMseCb9DqQvA9NNBlIprn5wI9ZZDc2u8Z2kw6DEAInurRj2gUJWa4HdmHk
	 APm6G/wuzDW//i0vDsz1f18ceXaUmSmdZINdJ+J6jb0cMaySSr8g8VZMV7zHzDVQCId0l
	 VwOl6xHnsqyQKrdVD8t4324r2jKOKm01fvEYJsPEZe9Ivb3ARv2khyMBcer3eV0jRhF4G
	 zQP8PGSU0iQSZA4q739RAzXI0mEKlMDJwk/9S4h9+TQduUUsYelQdyRt4umUA/4P3xuNB
	 NB7LpIdJYV31LkLS0bZY4rEhlpBpnc32sfzAr31Na3ztYyAL7J/gPKH9cnQq/ZxH5mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209048;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FB6qjKot/oMwVO/iyHvWcDEP3ABXMXlJM5euMSygbh0=;
	b=chM+1gZnKMNhrPbl5mxNTrMwxCk9KJzX6Flr4dhq6+QPc07p2t7Z6z0Yrtwb8A34O9YQ
	 mJkCI9ONbHwPEjpbxStQTJP/XyIgZ8bt/VPo3kNP7f6Rzw4B/3K/E8iC/Qv4/Bd3zLgDa
	 PViV7ZKI5DEEtpNVXE5T2rp1jHwlHPsEueCpQfDCajmopBFyOOK2Fi0Ept3/kyLRAEyxn
	 ut26Ne92H78fraA0k+uo0UWALurbqarOuX8LRF1OjJrWE5ZxYfe7NOFTAiASQW8iLbVTm
	 prZpZEvZPNNnVpgK5xDbgQSU/fO/xajebeB2CFJ2atJTjfmH1x8UFfI5d7wjp8Z9jog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Snb0ku3t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7794060A263C;
	Wed, 28 Oct 2026 17:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Snb0ku3t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCFC1F01825;
	Wed, 28 Oct 2026 17:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209048;
	bh=FB6qjKot/oMwVO/iyHvWcDEP3ABXMXlJM5euMSygbh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Snb0ku3tB7F5zMTdbfwc838a211GutueCbLjk3fmvsuBfPRCr3cDaDo9VoVvC9l4U
	 oGCTSqHkxpBYH06vpkbz0RGIQYImFsVhBwA/j1af7qbhF4HbvqH8eHSVj7n2KXplfh
	 wNbkCtnGoXlXcthwMS+Awyuluumh6AOy0icD02n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.10 327/516] keys: finalize persistent keyring timeout after link attempt
Date: Wed, 28 Oct 2026 17:57:59 +0100
Message-ID: <20261028170011.233896673@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

commit 25bf14f817168079f731975b8998fc2af380f29e upstream.

When no keyring exists for the requested UID, KEYCTL_GET_PERSISTENT
creates and registers one before linking it to the requested destination.
The configured timeout is set only after the destination link succeeds.

A destination restricted with KEYCTL_RESTRICT_KEYRING makes that link fail
with -EPERM. With persistent_keyring_expiry set to 60 seconds, /proc/keys
still reports the registered keyring's expiry as "perm".
The failed call therefore leaves a quota-exempt keyring in the namespace's
hidden register, where it may remain until namespace teardown.

Rename the write-locked helper to key_get_or_create_persistent() and return
the key reference through a result parameter. Return 0 when it creates a
keyring and 1 when the retry finds an existing one. Return a negative error
on failure. Another caller may create the keyring between the initial
read-locked lookup and the retry under the write lock.

Set the timeout after permission checking and linking. Do this on success,
or on failure if the call allocated the keyring. This leaves a new keyring
collectible after failure without starting its timeout while linking is
still in progress.

Cc: stable@vger.kernel.org # v5.10+
Fixes: f36f8c75ae2e ("KEYS: Add per-user_namespace registers for persistent per-UID kerberos caches")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://lore.kernel.org/r/20260912095440.79864-1-kmehltretter@gmail.com
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/persistent.c |   55 ++++++++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 23 deletions(-)

--- a/security/keys/persistent.c
+++ b/security/keys/persistent.c
@@ -33,25 +33,31 @@ static int key_create_persistent_registe
 }
 
 /*
- * Create the persistent keyring for the specified user.
+ * Get or create the persistent keyring for the specified user.
  *
  * Called with the namespace's sem locked for writing.
+ *
+ * Returns a boolean indicating whether the keyring already existed,
+ * or a negative error. On success, *persistent_ref holds a reference
+ * to the keyring.
  */
-static key_ref_t key_create_persistent(struct user_namespace *ns, kuid_t uid,
-				       struct keyring_index_key *index_key)
+static int key_get_or_create_persistent(struct user_namespace *ns, kuid_t uid,
+					struct keyring_index_key *index_key,
+					key_ref_t *persistent_ref)
 {
 	struct key *persistent;
-	key_ref_t reg_ref, persistent_ref;
+	key_ref_t reg_ref;
 
 	if (!ns->persistent_keyring_register) {
-		long err = key_create_persistent_register(ns);
+		int err = key_create_persistent_register(ns);
+
 		if (err < 0)
-			return ERR_PTR(err);
+			return err;
 	} else {
 		reg_ref = make_key_ref(ns->persistent_keyring_register, true);
-		persistent_ref = find_key_to_update(reg_ref, index_key);
-		if (persistent_ref)
-			return persistent_ref;
+		*persistent_ref = find_key_to_update(reg_ref, index_key);
+		if (*persistent_ref)
+			return 1;
 	}
 
 	persistent = keyring_alloc(index_key->description,
@@ -61,9 +67,10 @@ static key_ref_t key_create_persistent(s
 				   KEY_ALLOC_NOT_IN_QUOTA, NULL,
 				   ns->persistent_keyring_register);
 	if (IS_ERR(persistent))
-		return ERR_CAST(persistent);
+		return PTR_ERR(persistent);
 
-	return make_key_ref(persistent, true);
+	*persistent_ref = make_key_ref(persistent, true);
+	return 0;
 }
 
 /*
@@ -78,6 +85,7 @@ static long key_get_persistent(struct us
 	key_ref_t reg_ref, persistent_ref;
 	char buf[32];
 	long ret;
+	bool created = false;
 
 	/* Look in the register if it exists */
 	memset(&index_key, 0, sizeof(index_key));
@@ -100,23 +108,24 @@ static long key_get_persistent(struct us
 	 * also need to create the register.
 	 */
 	down_write(&ns->keyring_sem);
-	persistent_ref = key_create_persistent(ns, uid, &index_key);
+	ret = key_get_or_create_persistent(ns, uid, &index_key,
+					   &persistent_ref);
 	up_write(&ns->keyring_sem);
-	if (!IS_ERR(persistent_ref))
-		goto found;
-
-	return PTR_ERR(persistent_ref);
+	if (ret < 0)
+		return ret;
+	created = ret == 0;
 
 found:
+	persistent = key_ref_to_ptr(persistent_ref);
 	ret = key_task_permission(persistent_ref, current_cred(), KEY_NEED_LINK);
-	if (ret == 0) {
-		persistent = key_ref_to_ptr(persistent_ref);
+	if (ret == 0)
 		ret = key_link(key_ref_to_ptr(dest_ref), persistent);
-		if (ret == 0) {
-			key_set_timeout(persistent, persistent_keyring_expiry);
-			ret = persistent->serial;
-		}
-	}
+
+	if (ret == 0 || created)
+		key_set_timeout(persistent, persistent_keyring_expiry);
+
+	if (ret == 0)
+		ret = persistent->serial;
 
 	key_ref_put(persistent_ref);
 	return ret;



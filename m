Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC9B23EAAD;
	Thu,  2 Jul 2026 16:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011326; cv=none; b=Dq0spaKnAXrbjY1Wn/7UxOGk+4n0ylbIKuhbaLgRRI1vciEvdFWcwt1UYYQ0nq6jxztZyb3+eh5a3nYVckI7haXyeHJL5yaWudpvZwvMKO3PFiNy9A/AqQ2sqrUljVV8l86j7bLSvbsh8N060IFSv9s/IQm3KICbf/hAGmJOYE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011326; c=relaxed/simple;
	bh=D78jI4CHID5Dzsm8b2N8DoiOzK7zndsw2zeLQ9FW/YU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J6i1O3scPr6eRG9htZqu8miZnzq1j/7FD8zZdagaVjSqRaoJMkQqkdCeZBAyNqUngXwbWqcLaQjBVqWEzvEA2Ko8/mPECczBNyi1HOGpTzkRqku9xsEjz0F9Unn+76TZSP7PNEnzGSwQ69awecRFYizc7B02gVBYoshZBZczJM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JfsLB69q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JfsLB69q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9FA1F000E9;
	Thu,  2 Jul 2026 16:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011325;
	bh=klHa2S/6kYyH+GQTSIaaJumwBarHAfVkgBur6r8KeH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JfsLB69qb8XuFLayN5NgWbDkt5KH+lxesmUFgLk7laczIKZ8eNNBmI/L+31393FTD
	 +0CTzfSQohuq6XWZJ4uJtTTRWU7xf/7Q3dp7yAZlYf9GBweWBmzy3DWtrgfQ/CtRWE
	 vFgWEnb8t/nrmBRu922jxCO+zq6nJDFb+/tlzQWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shaomin Chen <eeesssooo020@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.18 049/108] keys: Pin request_key_auth payload in instantiate paths
Date: Thu,  2 Jul 2026 18:20:46 +0200
Message-ID: <20260702155113.124995881@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

From: Shaomin Chen <eeesssooo020@gmail.com>

commit fd15b457a86939c38aa12116adabd8ff686c5e51 upstream.

A: request_key()       B: KEYCTL_INSTANTIATE_IOV
================       =========================

create auth key
store rka in auth key
wait for helper
                       get auth key
                       load rka from auth key
                       copy user payload
                       sleep on #PF

helper completed
detach and free rka
destroy auth key
                       wake up
                       use rka->target_key
                       **USE-AFTER-FREE**

Give request_key_auth payloads a refcount.  Take a payload reference while
authkey->sem stabilizes the payload and revocation state.  Hold that
reference across the instantiate and reject paths.  Drop the auth key
owning reference from revoke and destroy.

[jarkko: Replaced the first two paragraphs of text with an actual
 concurrency scenario.]
Cc: stable@vger.kernel.org # v5.10+
Fixes: b5f545c880a2 ("[PATCH] keys: Permit running process to instantiate keys")
Reported-by: Shaomin Chen <eeesssooo020@gmail.com>
Closes: https://lore.kernel.org/r/20260519144403.436694-1-eeesssooo020@gmail.com
Signed-off-by: Shaomin Chen <eeesssooo020@gmail.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/keys/request_key_auth-type.h |    2 ++
 security/keys/internal.h             |    2 ++
 security/keys/keyctl.c               |   24 ++++++++++++++++++------
 security/keys/request_key_auth.c     |   33 +++++++++++++++++++++++++++++++--
 4 files changed, 53 insertions(+), 8 deletions(-)

--- a/include/keys/request_key_auth-type.h
+++ b/include/keys/request_key_auth-type.h
@@ -9,12 +9,14 @@
 #define _KEYS_REQUEST_KEY_AUTH_TYPE_H
 
 #include <linux/key.h>
+#include <linux/refcount.h>
 
 /*
  * Authorisation record for request_key().
  */
 struct request_key_auth {
 	struct rcu_head		rcu;
+	refcount_t		usage;
 	struct key		*target_key;
 	struct key		*dest_keyring;
 	const struct cred	*cred;
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -208,6 +208,8 @@ extern struct key *request_key_auth_new(
 					const void *callout_info,
 					size_t callout_len,
 					struct key *dest_keyring);
+struct request_key_auth *request_key_auth_get(struct key *authkey);
+void request_key_auth_put(struct request_key_auth *rka);
 
 extern struct key *key_get_instantiation_authkey(key_serial_t target_id);
 
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1197,9 +1197,13 @@ static long keyctl_instantiate_key_commo
 	if (!instkey)
 		goto error;
 
-	rka = instkey->payload.data[0];
-	if (rka->target_key->serial != id)
+	rka = request_key_auth_get(instkey);
+	if (!rka) {
+		ret = -EKEYREVOKED;
 		goto error;
+	}
+	if (rka->target_key->serial != id)
+		goto error_put_rka;
 
 	/* pull the payload in if one was supplied */
 	payload = NULL;
@@ -1208,7 +1212,7 @@ static long keyctl_instantiate_key_commo
 		ret = -ENOMEM;
 		payload = kvmalloc(plen, GFP_KERNEL);
 		if (!payload)
-			goto error;
+			goto error_put_rka;
 
 		ret = -EFAULT;
 		if (!copy_from_iter_full(payload, plen, from))
@@ -1234,6 +1238,8 @@ static long keyctl_instantiate_key_commo
 
 error2:
 	kvfree_sensitive(payload, plen);
+error_put_rka:
+	request_key_auth_put(rka);
 error:
 	return ret;
 }
@@ -1358,15 +1364,19 @@ long keyctl_reject_key(key_serial_t id,
 	if (!instkey)
 		goto error;
 
-	rka = instkey->payload.data[0];
-	if (rka->target_key->serial != id)
+	rka = request_key_auth_get(instkey);
+	if (!rka) {
+		ret = -EKEYREVOKED;
 		goto error;
+	}
+	if (rka->target_key->serial != id)
+		goto error_put_rka;
 
 	/* find the destination keyring if present (which must also be
 	 * writable) */
 	ret = get_instantiation_keyring(ringid, rka, &dest_keyring);
 	if (ret < 0)
-		goto error;
+		goto error_put_rka;
 
 	/* instantiate the key and link it into a keyring */
 	ret = key_reject_and_link(rka->target_key, timeout, error,
@@ -1379,6 +1389,8 @@ long keyctl_reject_key(key_serial_t id,
 	if (ret == 0)
 		keyctl_change_reqkey_auth(NULL);
 
+error_put_rka:
+	request_key_auth_put(rka);
 error:
 	return ret;
 }
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -23,6 +23,7 @@ static void request_key_auth_describe(co
 static void request_key_auth_revoke(struct key *);
 static void request_key_auth_destroy(struct key *);
 static long request_key_auth_read(const struct key *, char *, size_t);
+static void request_key_auth_rcu_disposal(struct rcu_head *);
 
 /*
  * The request-key authorisation key type definition.
@@ -116,6 +117,31 @@ static void free_request_key_auth(struct
 }
 
 /*
+ * Take a reference to the request-key authorisation payload so callers can
+ * drop authkey->sem before doing operations that may sleep.
+ */
+struct request_key_auth *request_key_auth_get(struct key *authkey)
+{
+	struct request_key_auth *rka;
+
+	down_read(&authkey->sem);
+	rka = dereference_key_locked(authkey);
+	if (rka && !test_bit(KEY_FLAG_REVOKED, &authkey->flags))
+		refcount_inc(&rka->usage);
+	else
+		rka = NULL;
+	up_read(&authkey->sem);
+
+	return rka;
+}
+
+void request_key_auth_put(struct request_key_auth *rka)
+{
+	if (rka && refcount_dec_and_test(&rka->usage))
+		call_rcu(&rka->rcu, request_key_auth_rcu_disposal);
+}
+
+/*
  * Dispose of the request_key_auth record under RCU conditions
  */
 static void request_key_auth_rcu_disposal(struct rcu_head *rcu)
@@ -136,8 +162,10 @@ static void request_key_auth_revoke(stru
 	struct request_key_auth *rka = dereference_key_locked(key);
 
 	kenter("{%d}", key->serial);
+	if (!rka)
+		return;
 	rcu_assign_keypointer(key, NULL);
-	call_rcu(&rka->rcu, request_key_auth_rcu_disposal);
+	request_key_auth_put(rka);
 }
 
 /*
@@ -150,7 +178,7 @@ static void request_key_auth_destroy(str
 	kenter("{%d}", key->serial);
 	if (rka) {
 		rcu_assign_keypointer(key, NULL);
-		call_rcu(&rka->rcu, request_key_auth_rcu_disposal);
+		request_key_auth_put(rka);
 	}
 }
 
@@ -174,6 +202,7 @@ struct key *request_key_auth_new(struct
 	rka = kzalloc(sizeof(*rka), GFP_KERNEL);
 	if (!rka)
 		goto error;
+	refcount_set(&rka->usage, 1);
 	rka->callout_info = kmemdup(callout_info, callout_len, GFP_KERNEL);
 	if (!rka->callout_info)
 		goto error_free_rka;



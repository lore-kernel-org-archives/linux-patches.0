Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211850;
	b=ZrqKN/cjvo2nWCuznT/KcDFwEOifFjgkYp6EUlbmyP0cGKo/uTrGq/CvErvz+kfNiRYz
	 BEy4jKGZdCgB8IHLsng+/Ufl8Acidzd5vT6WMhfbHBOSqpLsgZUZ+Io3U3xiT8N2YjK91
	 xT3Xo18fJP0bO4pv83Rq0RZTX3CoM8hpZf7xXHIm5uSN9l4ObE1b+wDvOZOaEBT5ZqYKz
	 t9dSBWZgnMinyNhfYuQP+WmTr7WIS+9hOlp429M7Tn3SqZX7xzEZeifLXW5KWnxbxcZ32
	 Wpl27kU61dHS/lOvkIOdSsR+Jfje++s8cenFQMK0woxVfYqDGL+XqP1D7eszdD+i/5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q2w8jR4Q/7c5YZCMiUjisrIl5w86mPwJixCwvKKloa0=;
	b=tm3M11r39FuPgipEnTgs6rTrQj1O8y3a3BQBgDNYiYIA2c5TaGptmsxsSMUdl0IDJgCr
	 Ov7YKXx4kL1Mn4X5o6yHMLrW3HYMfDhfoGteG9auidJAsJP0E0F18BT9xrbt/7fcSys+/
	 0n6aMSHaG/2KYg0FKRdDD14OQxE/98xX4GAZWFaMq5HTW15V9Nu0g3LUHRslVjzZBvX0b
	 X6Z3W0DwMDqTPr6yidNiMm9rmL6oPN8xqJLkj6XVHXwn3AR7vwYax41DBEqVopdbvRXC9
	 7XnvMyU1BU3QM6Rq71rvOa2a6RzKA7HAaJZFSAXpZ0maMT1RLTWmocMbOTrhjIlxqHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PuPO8MCc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DA7606A31D;
	Wed, 28 Oct 2026 18:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PuPO8MCc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068571F01825;
	Wed, 28 Oct 2026 18:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211849;
	bh=q2w8jR4Q/7c5YZCMiUjisrIl5w86mPwJixCwvKKloa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PuPO8MCcTylOL/smyKEhuVBAUvJ0rty1a228vrGgttvP/Qh4gKwa4I3X8kmzua8mq
	 OKSY32bmTNXkLJSza7dNMhQIgfEKFJNnfYzrvllqWL9KzBWzZNcqjWIpZ2Xszc2LM1
	 gkt9/B7U8GzS0nAT+yGglqw2qN+WwlKb0AmVC8uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Paul Moore <paul@paul-moore.com>,
	James Morris James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 523/571] security/keys: fix missed RCU read section on lookup
Date: Wed, 28 Oct 2026 18:01:10 +0100
Message-ID: <20261028170020.440738910@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 43a1e3744548e6fd85873e6fb43e293eb4010694 upstream.

Nicholas Carlini reports that the keyring code calls assoc_array_find()
in find_key_to_update() without holding the RCU read lock, while the
assoc_array_gc() code really is designed around removing the node from
the tree and then freeing it after an RCU grace-period.

The regular key handling doesn't see this because holding the keyring
semaphore hides any lifetime issues, but the persistent key handling
uses a different model.

Instead of extending the keyring locking, just do the simple RCU locking
that the assoc_array was designed for.

[ Moved the guard at the top of the function to solve a compilation
issue ]

Reported-by: Nicholas Carlini <npc@anthropic.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: James Morris James Morris <jmorris@namei.org>
Cc: Serge E. Hallyn <serge@hallyn.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/keys/keyring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index fc26d339a962b..5b366911aac58 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -1105,6 +1105,7 @@ key_ref_t find_key_to_update(key_ref_t keyring_ref,
 {
 	struct key *keyring, *key;
 	const void *object;
+	guard(rcu)();
 
 	keyring = key_ref_to_ptr(keyring_ref);
 
-- 
2.53.0




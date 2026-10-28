Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209452;
	b=d73idWqG2fhggssGnHuPINg1phGJfwbWkMxsdYdSq9XApA+EV2U1V3dx8TGgiuIQXE2H
	 Jc/rMDhdV9WAH/bviKn/LVneDxxXVwCdeH2vOEMO93aP+UJ2iyP5lcsH9erjTDk2IYoLF
	 B1zBLe1KXZUrnMBIf+14ABLta0KLpFtOE12InyQMo8UA0MoSTTHMB58fo5B5+swxZdMvI
	 xmrlthOGgeJ5OQkixcixCTFbji7esphf6C6lJ2xzZevEZSWE2NE8RLzQR6iYVJf+O5NwL
	 vs8dFygVc1fgZF+vkzFLE7Bj2iGyugLsV6F+Ung9n091h+Ojxu/nZE1IiNNewtvgnTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209452;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bWQaoWKSzvDV74OYEIh8UnO2WU8B5tKIrZjcmJeg7fc=;
	b=qBgn94jAV/nZBl1+5K/uRMk5ALaHdh3lys7+ddmHxz7rXEYI5q3yrRj6qGVeylCO26sh
	 sGvdpLb+lKDeH7wi+qdZONCfrPTyMrzthmA+mFXj0sxiVkyULzGMravzrANrPHrwRsHkX
	 FDGk3vipa96AVLm18/VLaexRKsNhSyYxMDxw1qSE3e8WG6uryC7cVx/lQcGVuWPin/AbT
	 dCTbepH3gLQ9Oihnzws7TrWQcDfc11LCPPfdtaav8S3EEOAdCk1qgq0NJAKXipot861O6
	 V1V7S45E37VYdrfhd1IozKEA05zj/7kfNOA58R74y/zPQ8+pkNFdojjkRBD1WAsrEZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LUVIFdcO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464E4606A31A;
	Wed, 28 Oct 2026 17:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LUVIFdcO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1E41F01825;
	Wed, 28 Oct 2026 17:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209452;
	bh=bWQaoWKSzvDV74OYEIh8UnO2WU8B5tKIrZjcmJeg7fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LUVIFdcO1HtM79jimJaURySqOjbJCyxdnfvwOBEpTtFIly2Wk8Azr6UQsGjjLmPzi
	 MT5Voos9RmGv+R+nb8iE96pZsFe9pCFvUWsGXStfjD9bCLLersJxcNCwUrOQ7BEqpX
	 uP10fz+XNelRxK/e50dGT0Yo61awRJ80Iz0ZkQD4=
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
Subject: [PATCH 5.10 477/516] security/keys: fix missed RCU read section on lookup
Date: Wed, 28 Oct 2026 18:00:29 +0100
Message-ID: <20261028170014.782136383@linuxfoundation.org>
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
index 8b938e61ecd8d..241b96addcf38 100644
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




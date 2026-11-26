Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704506;
	b=GWT9k6+QSPw21OBN6jxufDYOI5EA+/QAT0UPnLH41m01v9b0l5RqgFqehXQbSm2egOat
	 iQfjXosDpBlpjaVDKmjkvZsnT8YnMbEMveWmc7Wg3ONdp4LmwJeuTIOC0iLEMBTqHuJpd
	 xh9w7TluStatLcNGy5q7c1C3m7lhfLcP84v7ihgkFBqJwHqaHzBE5gHMJtV3oXUk95HT7
	 VjMj0eCO3bwrO50AS977P2YJdH24wj4fmvvXUjQnLkfn/hHprUP267c319k6cm4Mj6XaT
	 VU9WiHVpWMyBqfwW3CcnKGbeekWYyxJH99Yd+KJktv7R3rF1gbgPntBOBZ8ku+RdOpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M5Ta/ayhR2xAULHW1Z0+nUuoYSRH4iZPvzClTTyzePk=;
	b=BcphlXiliLC1/IxUfTdhAFZBneJgLZ0vVP1bhKeCUamTwuIJdQ9D9uZ0adSlxFC9z+o3
	 Wfwzjrc7e06irGPnhfO2swykGc/HL+eZecKSnoJV0Zi1GOvmAktD3Bg7OsMTN7ZvFeAqW
	 VUh5j3vaUYFBklU+teEX21fpQhdX6MEIaYqxYlL4I2o7moRS787W5ORPNW9fokhlnvMFe
	 NCXtcdgd1miaXPPI8cMLlc280KD0q0f76kj3CLzleH8Wca/L6wd+M/EYnJNlQaVAJSuDF
	 3eGwpp26BXEXd4DQPe43NY4AS0qOA9dN0jlF5LgKIT4YnYDl2L8U5tnCRwETc1dmOQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LAPTWkXO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D8B606A32C;
	Thu, 26 Nov 2026 14:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LAPTWkXO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C521F000C6;
	Thu, 26 Nov 2026 14:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704505;
	bh=M5Ta/ayhR2xAULHW1Z0+nUuoYSRH4iZPvzClTTyzePk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LAPTWkXOfeFH3y7ZKoRjfJs/A1tRDndJmMPhdTjtwAc3K54h1m4kgeDos3kDbivN/
	 BMRDe5I6XXnlgjP3SDnW+DhqZS0iyqTvcSMyF08XPydi93xbsmqulHL2/QlzRZ+XDq
	 eJWbq37Nb9jTeWooTRqaBshZvkrK1qTP7IU2DR4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.10 141/265] KEYS: Verify the key identity in __key_unlink_begin
Date: Thu, 26 Nov 2026 15:37:51 +0100
Message-ID: <20261126143614.877754076@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

From: Jarkko Sakkinen <jarkko@kernel.org>

commit 7a7f70ff7b26519c98b339a3e0cd9ee3c8d17f77 upstream.

When two keys have identical type and description, linking the second key
replaces the first in a keyring. However, attempting to unlink the first
key (no longer in the keyring) unlinks the second key.

This happens because __key_unlink_begin() calls assoc_array_delete() with
&key->index_key, matching only on type and description rather than the
key's identity.

Example:

  keyctl new_session >/dev/null
  keyctl newring ring_a @s
  keyctl newring ring_b @s
  A=$(keyctl add user A ss %:ring_a)
  B=$(keyctl add user A qq %:ring_b)
  keyctl newring R @s
  keyctl link $A %:R
  keyctl link $B %:R
  keyctl unlink $A %:R
  keyctl show

Verify the key identity before unlinking, and return -ENOENT on mismatch,
instead of unlinking the key with the wrong identity.

Cc: stable@vger.kernel.org
Fixes: b2a4df200d57 ("KEYS: Expand the capacity of a keyring")
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Link: https://lore.kernel.org/r/20261020174325.2229448-4-jarkko@kernel.org
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/keyring.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -1506,9 +1506,15 @@ static int __key_unlink_begin(struct key
 			      struct assoc_array_edit **_edit)
 {
 	struct assoc_array_edit *edit;
+	const void *object;
 
 	BUG_ON(*_edit != NULL);
 
+	object = assoc_array_find(&keyring->keys, &keyring_assoc_array_ops,
+				  &key->index_key);
+	if (!object || keyring_ptr_to_key(object) != key)
+		return -ENOENT;
+
 	edit = assoc_array_delete(&keyring->keys, &keyring_assoc_array_ops,
 				  &key->index_key);
 	if (IS_ERR(edit))



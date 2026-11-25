Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625548;
	b=iYRx3MCXZj7rkUJ9TW+mN5lkzlK0o5undSTldtRSlDn/x6WJxyVEYH3E3+e5G4ZR57mC
	 PF2r4uPn0FWwNqCfJGZc7o7pKDdPBYUeeX1vDroxfr/5RuAAi+Q4+L59NyZCfRkdWVHwf
	 /FwhMdD5AFcTvFJdToBnGfqlTMJTFu87N85iLxFZC4YyoILYBdt9MaO2I82R0vchcGVrC
	 D4njdAlFCFLquyLcJtCm9gdXpB/76/uEM48DbIuP/rJParklrmtSoM8Dy93NEfIisgFZp
	 bsWrfDdzq8e4loaussHcPHn9JxYe/Kndnwir8YE2ucigcgi8942NNz72rXPHguA7AaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625548;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H0RQFGhe9NNkC4uvceHLqHpQwio0/pVyGJfqte1hTCM=;
	b=TN/8WS7etxRSFBd+SS3LzYSOzpoBL1gh8bA9EhK17wh63KHLGKbnfRJiJ5BfZB/Zw1dF
	 9gwusO67IM0A945PY+UkKDZGrsvcKR8PqYgHRZrvWMlVemYnDLsD/HdwRiVkKhfBzsRE+
	 VX1BZrPzGJV0Ilot9Y7lFxa0so9YV5+Ivd6p0CUx4mmfKEg+yKptsUuejXNI2tEVzABK7
	 K6gL2pTTLU4hULwqMHfNWOgEQhsKvXhKTcy5eqZ5dxZejivVIdakal8ArZ+ABSH3mvv1e
	 XtrcWjezVyIUmr6Q8Vf3BO3eKRMxlu2UhGEz3nHs+Fn62sgmDeChngNq3/ntygLDBsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wX3wLC4W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9F7606A321;
	Wed, 25 Nov 2026 16:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wX3wLC4W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5FA1F000C4;
	Wed, 25 Nov 2026 16:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625548;
	bh=H0RQFGhe9NNkC4uvceHLqHpQwio0/pVyGJfqte1hTCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wX3wLC4WbMvvtebye6IycL1utnC6i/ewfCXjmjTVBlsdPtgw+PBAG7ZMJxvWb0UR7
	 i6U5nyt6aAQDEtKNpoTV0hk3wA+wkDZnZ0N5mo+BXhI2ZXhr4glm9YmH0vh2CztU+1
	 4dEl0gzZfp+dotj8yg7xDR3sxyNpaFVddWlRFiMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.12 551/816] KEYS: Verify the key identity in __key_unlink_begin
Date: Wed, 25 Nov 2026 15:34:59 +0100
Message-ID: <20261125143901.937955434@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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



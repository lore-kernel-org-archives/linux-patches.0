Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705359;
	b=bd/Gh3gdYsMo+yp5R/yU16rYSvpX2DZ+ml6kItEVM5GaUv0dVSs6Fo0csDRvZ0LvR5i2
	 uBfAtO80Sjb33FjUIRJeYbj9yzYfuKmZXOTftGZvb76u3aJn7hGRxUcsDOkyVbBdwFNUP
	 rWgrAtgZ18CA+0RLsOizFBBqp9ohz1d6opoZYDVZ0UZnvBeXPq+7GYtf7zlNZj2Mzuam/
	 b4urt6sEMLxhybG87QSaifw6YWvtfxa9hFRYxBcRog7wWItABZni/YvA9PJSK5dzoWSK/
	 jqYigDtZHbD++Oh8dPkPQxVea/MAwarpRK41g7QYi8s454z7sa8Gwc8w/vvsZnvn0/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705359;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aGV/2slVzbbh7eduJbCcB6H48QcaStZTys55F+bjXc4=;
	b=uQ2xbKQapAInXse7VRKJV1Ne52WuxAjFkTv4g5IfRhUVukrhcJQDity769toNRgPPWZO
	 MyoMxLCn1yNwPnzcsgHha5l4J6VuA4usybVkDMc/S9jSgwH69xY16YR7ldLwqhOgTdSRv
	 rEBIMfrOygu5iV6pDTLMXuD8VsHJYQLF76vKbYg/z4rxuWO1ZDEvsKKFCkTQvl1MogkDT
	 fwjmN23ncgp1EoCUMZj6xJ8qZa5gT6Ph54DurF50sdm8cjGJQZvVwf5xWVWaqWFZa4Vg0
	 WTX7UzWw1jUH0G+h0k4SI5T5QCJDAdnnSvTt2vEWn5BGlAFTJq/4uZeGeh0wwJwMeww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="I32Yqm/H";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90BF606A31E;
	Thu, 26 Nov 2026 15:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I32Yqm/H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A2C1F000CF;
	Thu, 26 Nov 2026 15:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705359;
	bh=aGV/2slVzbbh7eduJbCcB6H48QcaStZTys55F+bjXc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I32Yqm/HqnVdi599mSMDNfbxDUDBvcmHrWbtkq8biEi1UfXKJ0llq5OIA4piFRqfI
	 KDx0Tv60T4wEHLLsw5v/OLiHFIgHszVm0M2XWnxglbC8kyS8XImjqr6UhpfN9l76c1
	 Z3xwdghM4L9iFHfbHuHVWm1ubBl9cQch85EqMASM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.15 169/319] KEYS: Verify the key identity in __key_unlink_begin
Date: Thu, 26 Nov 2026 15:38:57 +0100
Message-ID: <20261126144010.560921392@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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



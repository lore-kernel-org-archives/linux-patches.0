Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622923;
	b=pGwl7Qq/x+npZqC3PNaFHOWSx3GINtDn6+P2S0iSjUpOhtfAl+cs/gpiUcffZ06ic+dW
	 7fzU45vi6+9WNRErHhVbvHKMOM7S4M2BIzZKFLZPEffiGyRmJPFkroek3of3JRV1ZNzD+
	 8+4tA8LPh9OMu6AX1s9gAO4x4BLCx/9aQwZ3nfG7EgahOc1lRIbIWFPGBlm7PbGjPX4mY
	 nLQ8vWZAXevsatuHytxP25GxsvD4IghwpGeoKyDDX9W1Sg8egYqxgrSGgwnGQIfH387oH
	 HMe8sl3t5EY9W5ckC2F6V9GyD6WNu1dZti3JJYrrQGmD8FmKLFd0EJFHUkogeM5GxXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622923;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cwDnCrkP0UAL50PY0XHV2LCdBgnWM7PrK0nKZqdf+jU=;
	b=UKD5zpJHtfs9mNtjVRPNhOhL8SEK9ZPzZDObjp1FYRnwOqq7YMIPBbQJZfEJ6vpBAFFV
	 44vgub0eDjhk2mpJlmfOu6IU3TjNVpwdCicxodaqxSHqRm/etCf/+13uX4qBx7gfO+Bkc
	 6+Szq3jjTeraKkrVCle78iXPgpiqzAfkty/D3WG/FkJcUheSVqL8GoDKjTl5XVE5EuDQJ
	 dmH+Hs8Kqy+lbwg3xHucTuAiV4tQgmxXPrVf7tzstuy2kvkfho7j+lvaqzQEnD5Y/p5qU
	 z7hHRE36+OR5AApra1S7IbqaGGSs7YQhe8M8jAii0nWwnKqviK/H9fZ3dgJnt7+I58w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="BTOtl/3y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380DE606A31E;
	Wed, 25 Nov 2026 16:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BTOtl/3y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7163A1F000C6;
	Wed, 25 Nov 2026 16:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622923;
	bh=cwDnCrkP0UAL50PY0XHV2LCdBgnWM7PrK0nKZqdf+jU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BTOtl/3yYTraFFwrzZefIc0htZ+drTLLJrpZASx+q1/97ifVjXfNdOdGhlqWlgp9O
	 nDBsVwlVwOWuOBWIbf85X1gQKUPCtdJ0hG8ufoSPCKhmPiLV5Euo8Q/WmEdgg1OeiC
	 wkTuZpxqz7s+atgojbOA5AeD+PDTOehNt0VJJdX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.18 649/990] KEYS: Verify the key identity in __key_unlink_begin
Date: Wed, 25 Nov 2026 15:33:36 +0100
Message-ID: <20261125143837.294346990@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



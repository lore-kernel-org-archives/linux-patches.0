Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209079;
	b=Z+JFvjpBFc9mjwVOyLsuDZHLzfv1Y5WCJCY0eYlyEZdSSXoKDEj5w2nN4t+T4S7mEdgV
	 FSEhoDInqWIzCSGSLVygzf+hWKZKIidiTH56hc7vjz7v6UJChhcMqxKXb7Z27WX4H1RXU
	 fVpgdRujAoigaEKgcL6TiHmFa/2X1BU98yvfOz6V3pcSLNu/g8eTrDJhGK1IZ/wwhACwC
	 ZtppN40YcyMm/2KXDlwhEvCEFGrCJejQ9RXt8jdemyzkmGKM3qDzW8Mfspq/f4qeGU5od
	 eynigsRF7T05II1puPLcyU9WUbbp22INMEPEBVO1TwSIp+X8bmYto1mpQWVvFDraYLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209079;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/b8xONO+q5hZv1NLXdauMz72QYPkt39xQv0ZEEx5hPE=;
	b=H0P7GeJw8xJbJUDF8sqdVkZ7IBhziLDhpuT9AfSBYV8IoGY5qQbta7JdCdik4GYx1FPJ
	 mKKjOo0zhjgRrBtHiULCXgyUWYhWtyUWLcXRdUVp4IfqIaTw7mnksJJ6OtnL40LDyC8is
	 q60D8NVR/OabRdtO0bB2Lh07qYV7JlfnAQr9Tqka/Nm6xHfnyZrRcE8oNNiSaQHcCtTxd
	 Lkmir7hlqS02w+qWXkuFORGc6Gsj2HN6QCmBwpZhdklt0TKqtqJAY0l7gSeGPAB7Yid6v
	 nkysVTf3kgo8+xk8Zn3r5fRLykyAk9cM7TaRNsEe0lbVtMv0bJ/vUjsjxyM//KqzUVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GrqaXedE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9337560A2600;
	Wed, 28 Oct 2026 17:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GrqaXedE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E391B1F01825;
	Wed, 28 Oct 2026 17:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209079;
	bh=/b8xONO+q5hZv1NLXdauMz72QYPkt39xQv0ZEEx5hPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GrqaXedELKm9dkJwnntIHl9hSOYf44ye0nDg/0dPhyLMf+thP4l+SwwZCUUhrbuFl
	 Q0wRfFvWhMXVV00bGoZvEz3Ok3+PFOTKsJV0r0dWsykoWQVO0CcL1fvktEm1XVJLVe
	 n+f1+KhSRPS1Zh/TcIw28QPKiYt7nIlr9kCQ8klo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=EC=84=B1=EB=B3=91=EC=B0=AC?= <tjdqudcks0424@naver.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.10 328/516] KEYS: Fix add_key() race with keyring restriction
Date: Wed, 28 Oct 2026 17:58:00 +0100
Message-ID: <20261028170011.258422912@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: 성병찬 <tjdqudcks0424@naver.com>

commit dd3ea3fcba7c75493760cdbccd35f029597e8d5e upstream.

__key_create_or_update() snapshots keyring->restrict_link before taking
the destination keyring's semaphore.  keyring_restrict() installs a
restriction while holding that semaphore.

This allows a writer to observe no restriction, wait for the keyring
owner to install a reject-all restriction and return successfully, and
then link a key using the stale NULL snapshot.  The writer only needs
write permission on the destination keyring.

Move the restrict_link read after __key_link_lock() and
__key_link_begin().  The read and the subsequent restriction check are
then serialized with restriction installation by keyring->sem.

The race was reproduced on v7.2.8 in 19 executions where restriction
installation returned before the link completed.  All 19 linked the key
despite the reject-all restriction.  With this change, 312 executions
reached the same ordering and every add_key() call failed with -EPERM.

The issue was found by manual concurrency analysis assisted by AI-based
analysis and independently verified with a QEMU reproducer and kernel
instrumentation.

Fixes: 5ac7eace2d00 ("KEYS: Add a facility to restrict new links into a keyring")
Cc: stable@vger.kernel.org
Signed-off-by: 성병찬 <tjdqudcks0424@naver.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/20260930041802.6114-1-tjdqudcks0424@naver.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/key.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -844,9 +844,6 @@ key_ref_t key_create_or_update(key_ref_t
 
 	key_check(keyring);
 
-	if (!(flags & KEY_ALLOC_BYPASS_RESTRICTION))
-		restrict_link = keyring->restrict_link;
-
 	key_ref = ERR_PTR(-ENOTDIR);
 	if (keyring->type != &key_type_keyring)
 		goto error_put_type;
@@ -883,6 +880,9 @@ key_ref_t key_create_or_update(key_ref_t
 		goto error_link_end;
 	}
 
+	if (!(flags & KEY_ALLOC_BYPASS_RESTRICTION))
+		restrict_link = keyring->restrict_link;
+
 	if (restrict_link && restrict_link->check) {
 		ret = restrict_link->check(keyring, index_key.type,
 					   &prep.payload, restrict_link->key);



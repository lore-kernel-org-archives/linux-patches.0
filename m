Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208055;
	b=pgRxC/SQqc025fGjX+8QgmtDHtzoCd9JhzDeGiZ27UB6TOtN6LtXfbKbLj5tBgBaexH6
	 6DQE3Km/8y8q5YaLlLIcqjrrulS7N/xJj6kKQX8GbsygYj5mZjw5+uLjH0zgc8sbNNbZn
	 /kzBp60yUeGk0OgJ801MTzsULLla41h9GSJcbhU6kHKFfrYt/gH0ek4/OtTb/zCJxTEcB
	 44KKjc+qekqxzsDzBhoh682xi9ORgJigOkmfwx4gKvGtaZQX3B9EmL6j5hCTgu+cZ3HtP
	 yBoqPD/faiwU7HP9MnJmEJXHB8tai4zkjvqyiwFx2bhu+a44cmbqc9gT+2mqrfcH6Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7m0njLKcCxMlJWQzpN1WQ5Y/oOLcDRFrOjFn3NmL8Rc=;
	b=wOfwyzGc/Utljcwk2ANavs7Ks9g8JWhwCJ//LgsTFgOoGQ3GR0fw+P84gWOktkR22lf3
	 tvYoJutf/aXKBceiH25emacaBHrmSHKYCSoksn3RIGChK1Yiu8gzIFMil1bR4MQ+4mU0c
	 oUTtNM9ZzDLnrC9E/NXef5aw1gYYRcy3+UGFHXswc5Om08rSKYUqxEZgb7xj+Xu+Kp/Lq
	 zvuYYu22A6j6w0ZHnXAMh1HYxUr6F6ZSv0UBkyyimPcfGBCVqd44OqZjGTqyhKmkJzHnC
	 F7CpL6yCUNFZD2Ms2kt+YmENpd7NAL/q8FRl8thWU1xVlmkdQO9304wG8VfGKElEmYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iLn+5jYF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C72606A31A;
	Wed, 28 Oct 2026 17:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iLn+5jYF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4304B1F01825;
	Wed, 28 Oct 2026 17:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208054;
	bh=7m0njLKcCxMlJWQzpN1WQ5Y/oOLcDRFrOjFn3NmL8Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iLn+5jYFd5hlnPYgM1n8cFS0jisp8iKEVvp7kvOiu4t21QNIQIYMWTV7lshMrA8af
	 kaF8gWbXXcGdbY46TH/VNETUhwD4fPSmbIq50IMfIfTAiyY8MOWPuj1vidCK1GoS1T
	 FGG6M1VVRLBV+2k9bEPw6zLYyA6bSAKV1vHt8Tlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Cen Zhang <zzzccc427@gmail.com>,
	David Howells <dhowells@redhat.com>
Subject: [PATCH 6.12 234/247] keys: Protect the read method check against type removal
Date: Wed, 28 Oct 2026 18:00:37 +0100
Message-ID: <20261028165952.961542167@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

commit 925c84e3cc21caf09de92d9bcafab0147790debf upstream.

keyctl_read_key() checks key->type->read without holding key->sem.
A reference keeps the key alive, but does not pin the module containing
its type. A surviving RxRPC key can therefore be read while AF_RXRPC
is being unloaded:

  KEYCTL_READ task                    Module unload and key GC
  ----------------                   ------------------------
  lookup_user_key()
  permission / possession checks
  load key->type
                                     af_rxrpc_exit()
                                       unregister_key_type()
                                         GC: down_write(key->sem)
                                         GC: retype to key_type_dead
                                         GC: up_write(key->sem)
                                       unregister_key_type() returns
                                     free_module()
  read saved type's read member

The final access can read freed module storage. The read invocation in
__keyctl_read_key() is already protected by key->sem, but the earlier
method check is outside that critical section.

Move the method check into __keyctl_read_key(), after key_validate() and
under its existing read hold on key->sem. The check and invocation then
use the same protected type for length queries and every read retry.
The GC cannot retype the key until the semaphore is released, and type
unregistration waits for that GC pass before the module can be freed.

Return -EOPNOTSUPP when validation succeeds and the type has no read
method. A temporary buffer may now be allocated before this result;
allocation and copying to userspace remain outside the semaphore.

Assisted-by: LLM
Cc: stable@vger.kernel.org # v5.10+
Fixes: d3ec10aa9581 ("KEYS: Don't write out to userspace while holding key semaphore")
Suggested-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/pm-key-management-objects-candidate-0010-v7-fc85721ff5cfb9e33ac6@gmail.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/keyctl.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -808,8 +808,12 @@ static long __keyctl_read_key(struct key
 
 	down_read(&key->sem);
 	ret = key_validate(key);
-	if (ret == 0)
-		ret = key->type->read(key, buffer, buflen);
+	if (ret == 0) {
+		if (key->type->read)
+			ret = key->type->read(key, buffer, buflen);
+		else
+			ret = -EOPNOTSUPP;
+	}
 	up_read(&key->sem);
 	return ret;
 }
@@ -863,11 +867,6 @@ long keyctl_read_key(key_serial_t keyid,
 
 	/* the key is probably readable - now try to read it */
 can_read_key:
-	if (!key->type->read) {
-		ret = -EOPNOTSUPP;
-		goto key_put_out;
-	}
-
 	if (!buffer || !buflen) {
 		/* Get the key length from the read method */
 		ret = __keyctl_read_key(key, NULL, 0);



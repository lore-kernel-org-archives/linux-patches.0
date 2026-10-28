Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207408;
	b=isJBzj0llIfy3Fjj0ZSRbVQuDg1qmfV0NWZjd8mHNF2oy8Oi274spzmbZ03RjHPooge1
	 0d06n1OZE6B1V4Ljdr99dDyui7fGlzlvXzNiu6Rvt1FGIXKb0rKC5Jp2KecrioHlrHBeJ
	 ZEpksiVNSiRVHq7bPnOB2kntJlaa5EOcFlbo5n6/SIGHSiut1HJ9VpZ/VtNi0zuGDt2Kc
	 ASaQsRohw8O8ONBdzFa9tjdTqAcCeRAUBEadu49lEiahiycKtADv8ZV3NOFviZnBTf0Uk
	 FnYyzi/fqWlUFY+XL1wK0ftkHdB+mav5VqwrO5yCIzMwoUwYgqKM50AgP+KPoX7nxoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/cTGbpp/PqgpxUyzY8RTabNN5UTElqcifl3hPV+OpMU=;
	b=zd1oiQjg2e4TDLpHxscTyYzVKUpWkaa2ORIqudckC6heg9RIfISNd2woDYizckNkXPM3
	 54kIzM9ho+kP1GMPpc85lyk0xqLmf/V2EELKrP8CMS8EkLmll84UgS+r3AuA8+VSZvA0F
	 1r9poa2GduGP2gD1HTwKJzbTyWnT2KPQcMHqwjNG4zhb0Og1z7CAHsekKNyFJiLos955v
	 FsntgS9aWWxs7MoBnPMEGdO2GwnW2aJwDVSTKOYaYvxNTw9eaLAFCHzOUzPSGSSWZzLkJ
	 f1qABFIBtrV4V0qqw6kjbOA/5uZR4IwtWwO0LBSAcaurWMoO2ATyuiOvqzcqZI91IwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p+wtfm0C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620EA606A31A;
	Wed, 28 Oct 2026 17:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p+wtfm0C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46E11F01829;
	Wed, 28 Oct 2026 17:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207408;
	bh=/cTGbpp/PqgpxUyzY8RTabNN5UTElqcifl3hPV+OpMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p+wtfm0C+ncTW/irh4WTqlnrc/OY0zqOjKiq8biJ4VhBNjfH0LpCrtm6qMoioT0rT
	 fhLg9YA8R9B2AFDPpksE5wjAgH+iFHInP5uKHUtKr6wuzYUQSJg0pFrl39sX/PoAVb
	 j4gEgU640ZLB03Eq1ZIOEJcchAS554QQfY8Xg9RI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Cen Zhang <zzzccc427@gmail.com>,
	David Howells <dhowells@redhat.com>
Subject: [PATCH 7.2 74/88] keys: Protect the read method check against type removal
Date: Wed, 28 Oct 2026 18:00:22 +0100
Message-ID: <20261028165943.858015842@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



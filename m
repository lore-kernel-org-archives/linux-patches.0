Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210329;
	b=Qct5CCb5tGZ7WMWuYkQIIbaVUEhqMu7SWtWD3nH62XizRxuIvgsIwEWqq2xpTEqS4/xv
	 3M7wOYxqKoht3RBlE0dS8eHcoGdgZ4CKcf+lSMv2B8+a3M+fSsTU1OGuc0Wlj5oHUYH2M
	 ich53UK1esNmLIqJCrESoxZULFUlk9S+fFoRN1CceXAMlAqz4zk1pa+QDvZeiurjzUjot
	 8OCfdpj1PGEK8IYB12Jvu8kjflbKi700nsaMZy9r9tjD74f315WiNHl2kce0NfrCRue1B
	 n2mmlZCzY0jqNW+CiZM/Z4IGXDAnjHb6+RvFRcd8UZ7BTalBYCfvvsiNRCUUOCzAZ/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210329;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UNIBq5RHrKX9CotemeioyvqjG4hUBTJ1iynqkKzvPiw=;
	b=nRthUWeU8RXq7Ntwjn4QfMhHJKCm/acSIdU+YMP73YBJwXefkDWMYJbBPXPAfx0vG2pL
	 jjEgbg+dtUHelH6bs8HNjCJPBHx2ZbuKQKXfJvriBOnD+rwXQ/vyIVA225IlD4OQIPRTi
	 CKZn7StGCTv/74Yv5xhU2keI47ENV51nHK6gi5v6J+SfR/ZwyHNTWecEh5ys2CWwidOUe
	 dhQGiaonRcMiiqxwR0CN/+F9L7mBM9tPuXUsldC8RTSm2QmPAfoWEhXGVcSVf2ysNY7xJ
	 5iMLS4cMwl/UWq6DfkE+XmQlKk7Qj6I8E33184+QzdC0WKPEm1wubAK1QUef7SiCAqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uMbiaGAm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729DB606A31A;
	Wed, 28 Oct 2026 17:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uMbiaGAm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D831F01825;
	Wed, 28 Oct 2026 17:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210329;
	bh=UNIBq5RHrKX9CotemeioyvqjG4hUBTJ1iynqkKzvPiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uMbiaGAmrfs59KR/n3pwQQgEdlsLsWdszCAVBS/Hx1sJWZtAgA2KSGD6I+GbnlMJM
	 Df4qiWz+VlDfbE3fXN7pORP2k8DNdqtSNqHKdCjHMHKCQVg0SH/i5yAOPUtZ7Bb0iI
	 H/CyxyO33GWRYjyAoCJGkIOcMty7pJpJXh0ZQQoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Adrian Martinez <adrimg3196@gmail.com>
Subject: [PATCH 6.6 158/168] KEYS: Fix key_reject_and_link() race with keyring restriction
Date: Wed, 28 Oct 2026 18:01:34 +0100
Message-ID: <20261028165946.826133434@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Martinez <adrimg3196@gmail.com>

commit 0b157166e612b70f98a332b6c7be7eac6f8e9593 upstream.

The restrict_link check in key_reject_and_link() is done before taking
the keyring semaphore, racing with a concurrent keyring_restrict()
that installs the restriction while holding the semaphore in write
mode.

Move the check to after __key_link_lock(), so it is done under the
semaphore, matching the pattern used in __key_create_or_update().

Cc: stable@vger.kernel.org
Fixes: 5ac7eace2d00 ("KEYS: Add a facility to restrict new links into a keyring")
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Adrian Martinez <adrimg3196@gmail.com>
Link: https://lore.kernel.org/r/CACO1+RT+m==BY+ZPkE+fo536D0qu3wog4xE1dfuXQ56g+=Qv=A@mail.gmail.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/key.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -586,11 +586,18 @@ int key_reject_and_link(struct key *key,
 	ret = -EBUSY;
 
 	if (keyring) {
-		if (keyring->restrict_link)
-			return -EPERM;
-
 		link_ret = __key_link_lock(keyring, &key->index_key);
 		if (link_ret == 0) {
+			/*
+			 * Check the restriction under the keyring semaphore.
+			 * keyring_restrict() installs it while holding the
+			 * semaphore, so testing it beforehand races with a
+			 * concurrent restriction install.
+			 */
+			if (keyring->restrict_link) {
+				__key_link_end(keyring, &key->index_key, edit);
+				return -EPERM;
+			}
 			link_ret = __key_link_begin(keyring, &key->index_key, &edit);
 			if (link_ret < 0)
 				__key_link_end(keyring, &key->index_key, edit);



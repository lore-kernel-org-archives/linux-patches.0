Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217163;
	b=uLrE6hB5f9fLhJsV+HCaQez1CUfzTKr249XzIE6zOLqaHTONYjqmxhwyAJr5gWonyrYN
	 qb/SpGeSLyh1gqdjY5vBFvqi1be/TIaED9HApSNpqEPT5Bh0BbjGOEFkwgvYW5hGC3zcb
	 deYv9iPvoOmEXmgwe1oMerCaqykRKlRetgGXL4U8BffDzlYyh7sUjBPdBrxUI3fXku7xY
	 y4yMa9jYfXkx/ihlWoRyNaBJAmQAoZBaL0u5NLXuo+OETN//JxA9KwAjyR94wUK8z1sMG
	 E2JsXNgL9j5YrYHTiIOxuVDIyFqM721+XFWeZmyKycnsrB+BBcfqtgri1MCc2/I26fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MP3zj40i8rmnntSccQsVgJ/+7/MDrhKP0gHQgbkDz+o=;
	b=WttlIl15hFCLR2Oujt6/k7X9tLbBG71+CuRXYiJT/Di/BfrXlz8Ik3M6piyowTnhxetB
	 wnbFGT3EL1EIeoUyU3B2vpG9n6Zml01r3nAV1KD12N88CeB2D1QCQAVBf0FwKQdVDnFko
	 9mPi+BXZpnx5pzKqEWOc7H3XVktzptvlCoMxDwPKF4WctRYa0eZ+ssQ03fu3cyoV7PDr6
	 Kzk+qydEP9sDUCWy4+feLtLPuq6vIIcJoHWi5VtGowhcDQKkMLi0I5v1oxYqc0kBYp9JF
	 eABGiXLYLS5rEpygelGo1DlEEc+Y7kAF5Mp804ljL81UWx0sKfErkHwYlPGVZMaO4xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z9BATHzR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A786A606A31C;
	Wed, 28 Oct 2026 19:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z9BATHzR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007BB1F01825;
	Wed, 28 Oct 2026 19:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217162;
	bh=MP3zj40i8rmnntSccQsVgJ/+7/MDrhKP0gHQgbkDz+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z9BATHzRRhzrDV1KUyj1KM8ZT5CDB7zRYJnN/beo8yDUuq0ml3GCHEG8wSz8tjlRo
	 4DDkZJKNOEavyqXEIsefKp5V2EZ5XNJyT9qrwrBijj70mHKKh2C0/JWPRh1wbo3gfo
	 FilQBxhIrhUEOuYy2yFBATcLRaleiMg7Lv0N/e/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Adrian Martinez <adrimg3196@gmail.com>
Subject: [PATCH 6.1 1810/1887] KEYS: Fix key_reject_and_link() race with keyring restriction
Date: Wed, 28 Oct 2026 18:05:06 +0100
Message-ID: <20261028170540.636782204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



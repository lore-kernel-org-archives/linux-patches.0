Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209583;
	b=Zbflb3WqTtDxCwrUIzuzqnxJsxyYFTKrTBDG/GZgQw/OVG70/1pIJwZS9UJIGxJklk3x
	 AubtnnfAAegWKuKfxUG7mnfzQMMSqcEk1Z3Qumroy1p+2P1ouSxZ9Azcebi5yHlfTOp5G
	 K5VDqoWej6zxNQi676WQmIpcZ1P3h3Q3B1lu1R1OGN/OahVLk/EIhASeB2RY2xne0hhIn
	 OExKWlctT8htCDJZ0HFWwgGfvLcemEnS4DYsyyGaBum6jJhwUiGBaIq9jo8uFplWpYH6Z
	 LnNNLqWeL41Qt9KPK710mAwl7MqTLUR3Hha70VJlKaRSZ22HpORg92b9KWoCIM0FBjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209583;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6mAl9nhEfkoQk4qRCQPxy1XYQwyYxJ/hgAdnK+VCjH8=;
	b=K5X+oWUHPjAdNgZSTS1W1pv22rTYnN8OrJD1yLWENYTtiENXlYDrPaaguth5d2IL8/E8
	 LpyzKe4aGjGx1bwOWDFeqGEMaYOrOGEowihuhdQSEyy8rly3q5GEADwoN8GT7zno3woL2
	 1QiJ8YHWwiuSDa4UspKqkMqSPTp4V6hiWeMm8SLRNITrdBk1MEIvpCnXcfURuUgNQUu7x
	 RJUuzEndyOJMPzRFvc07/OIx6/Yru1lccFxsMnWWf2qgeWgiRlPtilExF2epK+yY23Z15
	 ah4ZR1LlQFN63oOdjxAEIf4wyuPXYIuJ4sgVIIdyYG5bXKJygT/sqpgDm9m6WghW1rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BubHhmcA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0906606A31C;
	Wed, 28 Oct 2026 17:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BubHhmcA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2A91F01829;
	Wed, 28 Oct 2026 17:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209582;
	bh=6mAl9nhEfkoQk4qRCQPxy1XYQwyYxJ/hgAdnK+VCjH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BubHhmcA1DgCR2HwJJC3BOOvSir1ALBr1q5yYPxiSy5nq2tfcWaSzgRGn5y68bsWw
	 F8f5ZE7rAIIxlvigp15ADllz/Ehm2pgKAKC9TdDSiXNhEN5xr0CU885/IfK0swwUUY
	 la/7KOM8LynF+ALjIRwGvKSwzmA83MZ9toDQMpqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Adrian Martinez <adrimg3196@gmail.com>
Subject: [PATCH 5.10 515/516] KEYS: Fix key_reject_and_link() race with keyring restriction
Date: Wed, 28 Oct 2026 18:01:07 +0100
Message-ID: <20261028170015.676359775@linuxfoundation.org>
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
@@ -585,11 +585,18 @@ int key_reject_and_link(struct key *key,
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



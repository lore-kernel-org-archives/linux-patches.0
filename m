Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209900;
	b=qxfvwCD7LAayZ8eaCFzj21a/vp74Y8JdjWNxd5v/6INrLsNFf4ojcxHUDRm3DsaLWf8l
	 q54b8zTJAsf6gvnhPliQkaeBBMoqNc+lEgM7LAhO6wrg57sxaPBOFKTm7JuL1Dt9hXXjT
	 o5lYnl1BKscnBX8Xo3AhCy67VKFSYsqoRQlgqRFltGjlLufgSZf27diV9IoVNnDmtpCzO
	 Xe5ZKjW5DpB1SSGpS+93qG24g1IRbSnDdKmKwXLDzr9+WLJ/CSHJfO+giw0X7SvODMmTJ
	 RdLOShJ1SYYhveBqR7QOMmzfFNJqV11lUzQUbS89MbIwuhpRn3Q56uQvgSM2ZIRSTYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209900;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=emKq1SSvDlSCgeZOEZ74ye8QKbtcOI45dy76MKiWNAQ=;
	b=hrflngr11D33Oo3J6sDUbctQMh2/o+wmw1M9D5QATZ+bQfVeeCim5j281wH6ToeEA8Dp
	 bVhCQfPg2OkFY8ktIkpbdS7iXS7k61B/QGoQXVZpyhRb0YWnNDUXaHnCOtkoI/BfcNxFq
	 6Lp1oGq8lp8HzhkWDHZSXGke1Hi00r5XD3VeZKULk2+KNGmnuW+uvGG0WTCJcKuCADXnh
	 Qhr6PiuvLMYuvvWKNgDj6hYyqBjY3BAZOXscHV0YoYCPZvisbAYJuY0IiVSaP38yqXe1p
	 rpJNFA4Wh7rmp/az29czsdlkpl1Rr2I8h8Tz6Ngd7slBxpx1NIY3QrvqzGCyopEh2Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ke+98llG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3FC606A31D;
	Wed, 28 Oct 2026 17:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ke+98llG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4631F01825;
	Wed, 28 Oct 2026 17:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209899;
	bh=emKq1SSvDlSCgeZOEZ74ye8QKbtcOI45dy76MKiWNAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ke+98llGlsopK0+ZUKcha+cM2pWV6/5CBQV9rA+Z4PMIqLuVRtnH5N46ueyse2ygx
	 25+O1/3G3Qi/KtWN9FVgspSeLIZOUSpckzEgtiZ6Yw1UaVPrJJlIudNlybtcAFshKH
	 9D7N8j969EqJOln72sADCPiIt81KzvRGYJ9gdceg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Adrian Martinez <adrimg3196@gmail.com>
Subject: [PATCH 6.18 096/109] KEYS: Fix key_reject_and_link() race with keyring restriction
Date: Wed, 28 Oct 2026 18:01:20 +0100
Message-ID: <20261028165944.615473541@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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
@@ -588,11 +588,18 @@ int key_reject_and_link(struct key *key,
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



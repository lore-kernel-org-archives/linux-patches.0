Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208058;
	b=Yel34jlcCh8VMIk+UxRhrGr3/5LGugeUYlS0PROgbG6bATxDBL+BsGLo4wFK7N1BoQTN
	 riUicLOJDHSG2POZfvclp4cuc8+gQkmfjz2tFH2d6h30Q1Z4iWs+9DSHbMu8j+OACobx1
	 ELYX7C/vF7OYcsDkjayYeN7y7vIt8O7RAFfnvPvsLSbyWQ1PuIYEXDcI4u9NgcXm2xP0p
	 HOQaSdPnOFumwjXkMmKkTtsA4OkZNONUiLs5IxMWJWUCVIGB+nAzEdNkDjdPzr6VrzKjS
	 rleNGHWDGvqjtT+bUPO3Oketv1N096RbSmhiRkC/wdEEgagDK/LQkfvv8M1W8NesLew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208058;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AAc/hJMP83UuG7szQ/Xim/6Khx3aEx3yr4edTS4tiww=;
	b=dsue/xdFMxypQvBNRqzDXAwq5jc7CetvMsCJ13xyZG01XohVGJ6c3PpUknzn/c/aEztp
	 ogbU63MAW8NSE6Ivf4qt40EAwhXyGEkwe/WN4mjAsTjh23J+fyphe7NLIVvFMsE5JDV7p
	 WJSbLHHLIbb0Z6iZ0r4ye0uJDlgC4bl/eus7+pbPJKDnBvShI60TMgiNEaF9tXv/QWQzw
	 vs8c3Id0Iebu7LO4w17rFcVDFDjot8BVQrP5KZFjeaqRpRnb9WIaf1qukpjYz/XM4XrsW
	 VfQEEPbTvNNMRUvr2NLIv6V2yjYLG5Dc7ndoPcLUOrgePZ1dODucQ8Qj0J8jGsClSmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rjViVrZE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC25606A31D;
	Wed, 28 Oct 2026 17:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rjViVrZE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2253D1F01825;
	Wed, 28 Oct 2026 17:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208057;
	bh=AAc/hJMP83UuG7szQ/Xim/6Khx3aEx3yr4edTS4tiww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rjViVrZEbt37oOvKLGq/ldsdmvMqb0vYWQaGdY6IIwge7JquyqMYhNgKZLEW+Mae+
	 hQ7T32XSS/jtJgFiCHWwv6mmMqd9bi5phgqw+hpN2Csjo8sFc5KocGsoKnBJ79p83T
	 GSclwXoWp/GXrtXzCY3JCZJShpIjHRkz/mVJjhs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Adrian Martinez <adrimg3196@gmail.com>
Subject: [PATCH 6.12 235/247] KEYS: Fix key_reject_and_link() race with keyring restriction
Date: Wed, 28 Oct 2026 18:00:38 +0100
Message-ID: <20261028165952.985952473@linuxfoundation.org>
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
@@ -587,11 +587,18 @@ int key_reject_and_link(struct key *key,
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



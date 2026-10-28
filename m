Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207097;
	b=yhUiPKvceOcugt89JKyfoEs1ToNrOsgbgDC2KYKdzrQLtgDibYCFIqYpHd7e+ZAJ3zW9
	 DV6TPP79Uo6C4GdkqHTCzVwIwkkec5gky0IrQ+SmQu2Ryl1c1PB3VvmI6CcGKPpvlEi/I
	 GQrycwOaMOgbkrxkEd6RCR9s+Y0OLD1e1bBS3F/pMpBaH+nqbgjgUv3xBkl6GmyHX+8/Y
	 HxI82+w/GpnQBu0gzhr9As4IUv6qV3TBhKv/DafvziYk/qRUM0Hek3+1yU5qOD6XAowEP
	 jPqXW6wNq03sM0juTwMe4PppKf103nB1+Z392M0uATZRMcDQPn1cpXjZ5NqMDRJdT7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207097;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IkN1MyLXwAfeHroiXC1vbZdvCanpS7DdBApRq/SscCA=;
	b=1FncpSn3sc6i1Fy/fJ7JEuUpwx3M1KAVoyhbQ1G2551hFUIB3aDm+14engA5qPTEA6hs
	 fMMT+35EkcqUkCVp4xxbxIrLpKvgRFoUy1m292YvGKNnYMcSsbkOdSecW/C5dWsFwPDI4
	 pRJ52KaCE4ZJOQ2WBo+hfQaWD4EgVN8T7cZjA2vALXmpgVQE1MdVcLH+tU6ENSNvhCwen
	 TEqpQ6ddXqVXzq0WT5r+2Z5x1c1fkYr1oUayuGq1xumo/CYd1TXguZk+wweCYagws9e/Q
	 tGe07j8gD9S1DByIrczU61yEg4ECTb3t7DYRRDLnXTQtjXT8T86HqWcdxcqmEKMwB9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rj9zqgzL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B24E606A33C;
	Wed, 28 Oct 2026 17:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rj9zqgzL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8561F01829;
	Wed, 28 Oct 2026 17:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207097;
	bh=IkN1MyLXwAfeHroiXC1vbZdvCanpS7DdBApRq/SscCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rj9zqgzLwt+ZPXMkOIGHD1pk/MpdqvVdSddXQq+PZdeJo5dfIXuGdKQXeFVOStXAX
	 eWiHN4bKnmdtLxb2HijIhEcIotfXxJXHxlZYGhlS4lua4NgBDsV+hSeRKT9ArGirVg
	 yCBSRkS3eSOciCjUUQB+P9oKjZ80GfxgSgLBhorQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Adrian Martinez <adrimg3196@gmail.com>
Subject: [PATCH 7.3 24/38] KEYS: Fix key_reject_and_link() race with keyring restriction
Date: Wed, 28 Oct 2026 18:00:11 +0100
Message-ID: <20261028165941.020379730@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
References: <20261028165940.394092994@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



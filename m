Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212007;
	b=ejgPj1ggURFd3W+outFkjv7yPsTqPyxNt0rKtO5/cCp69ZkfdeKgN79hXM0tRt4sHKK7
	 KqS/2E1Sn5rteKa2EzScs8iALgwOsxeLQO4Xy/JG32kvKxrr2cwyyA35cEjoh9+u+gTqh
	 GDCglYStnbDQ0p0jTDleZXhOovUT2KyzqHxeZ9P0WJehaU5Wa8auriELWcxOVbGLhj+tS
	 swrtijGEanqLKif6iZ7DOQMZiO3qhGaVLDysLFsUWx4ecQ0y2CHBAkarC1ypJZL5tFPzk
	 KXqpBrfevVv/1bs3xe5aYioyxLBEPonaTILQhqvnhF49Jx+IiekBUgONZuKvh5T+9yA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212007;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WjAqw5V9ITy5vxAalGeJDlWWbZRZNFOLbH7qxFbX9jE=;
	b=G6X07GqOWk+T8kFI8+EyEobhB8kLXiSvFV9F/1Zha1LRdGcc3bQOtqSHaRLIpMtLFzoU
	 eXmLAsLX5/KOV8W/L8n4ZLqLlHQGrzzwhVPhQJ7gTnvuwvGJ9KFYoHoGXF3fpK4vhQCWM
	 XHyk6ZZIQTNcx3ZBEJOPXTfsHavlgGuHphe/UwRmalFCUN6kyn0/GOi+xX+JzOawOnkwH
	 h7AusjeFQQK1Mar/NuRVNA7nKr9MPvukszfzD3n5sGGH1SowkV+YyBUmPBUEBYGeYJLFl
	 387I8QzdAX4786w+qn0GYD3cU58AzTgMXGg39tSWYWfh5riOEX2Ce6Uphslwt3PIwJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t8nokXAs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3120E606A31E;
	Wed, 28 Oct 2026 18:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t8nokXAs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4CC1F01825;
	Wed, 28 Oct 2026 18:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212006;
	bh=WjAqw5V9ITy5vxAalGeJDlWWbZRZNFOLbH7qxFbX9jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t8nokXAshMF7v2mbJ71vVY9uJ26VRL+hU3ALC8fBaInMgZWO3bavYreoERhrcm4y+
	 ZlE4ZwbgajSRzdaUr10D0NZNOwKaWjZVI5EI7WMB6tAe8YufXKfCtQqnKLXfWaqx3g
	 1SBo54olpnlnlcGDXZ14EcMx6y3V8ifkLF06wk1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Adrian Martinez <adrimg3196@gmail.com>
Subject: [PATCH 5.15 567/571] KEYS: Fix key_reject_and_link() race with keyring restriction
Date: Wed, 28 Oct 2026 18:01:54 +0100
Message-ID: <20261028170021.490797922@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



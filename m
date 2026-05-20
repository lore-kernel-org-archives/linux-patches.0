Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAB633CEA2;
	Wed, 20 May 2026 18:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302031; cv=none; b=ixMZ78lWN8ZuhYBDFAn5nm8UC9omYAojqd9rqC+wCObwnED97IlVS+zQcT61Z/rBhbqMLFGmErCjpi7j1ZWUxb0Pp94XSTG93w2xxb6y42OvbX5ckiXR5UBxIsz/ub9KPHZg9Jgx9wGgOG80HRBz6Tfsta/9tHqGgc9av1eD3KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302031; c=relaxed/simple;
	bh=zPh8Ze659h4UJFbS0NvWN7Iq7hOBY9OCeKPNJV+LcDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZegWhu+qQvelxhDAFzJuIJbXzPDMcCL5Jnn5chDrc4FtoEFfca5ncD9qXdCd9HxXkA7/TmgbU5MlYeqrMeQv9L6PlAuDhfW0Yq2PLiOEmIwKiBvvXRs46KZIqzSgaMnWCfs5MGbuWkiASznUSKCju2dKY0LDacFsNosltttKZLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDqMS9NX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDqMS9NX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A870E1F000E9;
	Wed, 20 May 2026 18:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302030;
	bh=PPXrPUXnhpx1RkXp/kGYICwaOqOdsbWlSxQ+0SSQ6Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NDqMS9NXGDSm9jgpcCD0bfnxsHw0BgfNb7bZQXSJZ8fCxRb5yPw0SyokER1xYL1zJ
	 9m90Iw/9bgreOawY5j1BeokNKvJw6zGyvtOOt1DfK9Ger/I2yKbTpLQWu5fQSDRxpu
	 ADBEuxkAoS5Wdp1zhkDq1t77Vn6VKlCAH4VFE21M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/508] crypto: atmel-aes - guard unregister on error in atmel_aes_register_algs
Date: Wed, 20 May 2026 18:18:54 +0200
Message-ID: <20260520162101.032579476@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 57a13941c0bb06ae24e3b34672d7b6f2172b253f ]

Ensure the device supports XTS and GCM with 'has_xts' and 'has_gcm'
before unregistering algorithms when XTS or authenc registration fails,
which would trigger a WARN in crypto_unregister_alg().

Currently, with the capabilities defined in atmel_aes_get_cap(), this
bug cannot happen because all devices that support XTS and authenc also
support GCM, but the error handling should still be correct regardless
of hardware capabilities.

Fixes: d52db5188a87 ("crypto: atmel-aes - add support to the XTS mode")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-aes.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 9bd18825e1bf2..3402cf3f017f1 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2269,10 +2269,12 @@ static int atmel_aes_register_algs(struct atmel_aes_dev *dd)
 	/* i = ARRAY_SIZE(aes_authenc_algs); */
 err_aes_authenc_alg:
 	crypto_unregister_aeads(aes_authenc_algs, i);
-	crypto_unregister_skcipher(&aes_xts_alg);
+	if (dd->caps.has_xts)
+		crypto_unregister_skcipher(&aes_xts_alg);
 #endif
 err_aes_xts_alg:
-	crypto_unregister_aead(&aes_gcm_alg);
+	if (dd->caps.has_gcm)
+		crypto_unregister_aead(&aes_gcm_alg);
 err_aes_gcm_alg:
 	i = ARRAY_SIZE(aes_algs);
 err_aes_algs:
-- 
2.53.0




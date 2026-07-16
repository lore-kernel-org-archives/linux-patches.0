Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE3342CB11;
	Thu, 16 Jul 2026 14:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212319; cv=none; b=Ur7NfGgL//Y5WRsmZQf7dQsND0AT0FZuvnY8Q91ERwxiHyEHw/eow46RyiSn4Jv6q5k87quvlPY3BmqqPt0AzOtfgoeGPfLeie16KjW6/yuEOUoPoSFJG1cAYHK3g2VA/nfe7RxPdegcxuvDAceJXdmIIM8QFzn0S9gR4QOU8g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212319; c=relaxed/simple;
	bh=kYWF4YLBL3l9h/TGYJAcIqvkFc7biqtuY4f8xBbpuJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=li14igburbXP9a+18upZQR7oYQ58+nvPRKApoQ6FrfpytLnhi8CslwQtqXdMhNhHQKLeUB0yVnLab2c7fKkoZ+raIkMBRt/LQV9jJKw7R+9ABhrLCSG7tQ6WopVpQWyv2br6QTLfrQDBtqE8zwX1xHDqaSHZNpBSzG+ZF4wmpcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqEekuPO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqEekuPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8A61F00A3A;
	Thu, 16 Jul 2026 14:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212316;
	bh=zffR7h2i/5b0Pt8gKp/G8tcTx8CzqMi3NtbnF8QteMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BqEekuPO0CMe5c2eW357NkppNjhIjloM3OIbCLA6St8pAWYcpiopcBCSi+REtTlp/
	 FOwva+g5IOqv+KV2wI0k2h1IuMykX7oOhVxKYAod/eZJOne7OEjd+KrA4HaG1yVlyw
	 yPZ/Heq2vc7zVeylhD+b8Polrw5Lcz2nLd+5ZBwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 279/349] crypto: drbg - Fix returning success on failure in CTR_DRBG
Date: Thu, 16 Jul 2026 15:33:33 +0200
Message-ID: <20260716133039.584486536@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 39a31ad9e2a5ed7e9c9c6f711dca96c8c8f5f26b upstream.

drbg_ctr_generate() sometimes returns success when it fails, leaving the
output buffer uninitialized.  Fix it.

Fixes: cde001e4c3c3 ("crypto: rng - RNGs must return 0 in success case")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/drbg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -591,7 +591,7 @@ static int drbg_ctr_generate(struct drbg
 	if (addtl && !list_empty(addtl)) {
 		ret = drbg_ctr_update(drbg, addtl, 2);
 		if (ret)
-			return 0;
+			return ret;
 	}
 
 	/* 10.2.1.5.2 step 4.1 */



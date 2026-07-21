Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B002D43E068;
	Tue, 21 Jul 2026 22:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671240; cv=none; b=GwQ3EM4MSwEUqUYoH09zmWAw24ler1Z19sEd99EWcuanwaW3uWjH3MDi/7ZIGkAPM+5TWiN7EpNVLz0dVXzG/6NG25CnSgGm8vIqcmDyDC37mCXeozVgATvOAA3U5fC6ZJfhm4W+bPtC4ocQZyZso4QmHtnMTpuXEJ+MQQGAb/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671240; c=relaxed/simple;
	bh=mevcn8gv1RUwzuVba3loTJ2JiqiKwZLrrUHXESGZEHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6vJh5FL/wd8P5b2ceV2u5ZkGQYHQIa7xa9I2YdvylvDdLwMwCWp9/18DAa+ARUU5yJOBX6R4iTDc31+MZqHiFZZV9K5QIybxnW/UXByRYEgvM76Rmu+m4hCwtMuywLEQthOaz2TZlo/fSUUDpKHPOipu0SNlcqFRgRdrc7x8LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NxIdbMYK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NxIdbMYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24DD1F000E9;
	Tue, 21 Jul 2026 22:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671239;
	bh=WqUZhdDrVU3WGytWjDGC06amF7oZzSqiv4OMpj9CGxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NxIdbMYKaIAT5iRYaF0CAPDfsJ0437EIacc9SIZ1+4SsjZ9/UhpSQZVMDPv2a7CJ/
	 Df1IunOn5xq46vu5WqRnUcDvYmdnlHSJJMfSsjpqoNUM308R0LPquvklGNkezkXLae
	 R00vmfA2rIB6mdZmsIQyj8pd8lpjMvi6F1yCM5Gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 169/843] crypto: drbg - Fix the fips_enabled priority boost
Date: Tue, 21 Jul 2026 17:16:44 +0200
Message-ID: <20260721152409.820175513@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit a8a1f93080efc83a9ff8452954429ae379e9e614 upstream.

When fips_enabled=1, it seems to have been intended for one of the
algorithms defined in crypto/drbg.c to be the highest priority "stdrng"
algorithm, so that it is what is used by "stdrng" users.

However, the code only boosts the priority to 400, which is less than
the priority 500 used in drivers/crypto/caam/caamprng.c.  Thus, the CAAM
RNG could be used instead.

Fix this by boosting the priority by 2000 instead of 200.

Fixes: 541af946fe13 ("crypto: drbg - SP800-90A Deterministic Random Bit Generator")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/drbg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -2070,7 +2070,7 @@ static inline void __init drbg_fill_arra
 	 * it is selected.
 	 */
 	if (fips_enabled)
-		alg->base.cra_priority += 200;
+		alg->base.cra_priority += 2000;
 
 	alg->base.cra_ctxsize 	= sizeof(struct drbg_state);
 	alg->base.cra_module	= THIS_MODULE;



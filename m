Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0511013541B;
	Thu, 13 Jun 2024 11:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279417; cv=none; b=hRNLuPnUGM+2dyowFZ2GJfpFtZrRewQGDUyqJC8qsFczRc0ZQKhoLFZNfRnab6YI8SkKbjPB+TyR2vp0x5BDbJ1I4vpA4kXvDraq4iYx/eIxI+OHLxvbEi77ulYHqR6XxEXTD/j2BOMc86wmUbUIsPSb3UwcrLh7I3aR9Fci4qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279417; c=relaxed/simple;
	bh=akAZggdBYlZ3/8ZXDSqLwWI6wwfkxm12hG3KuxEtyC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIlnouv6ddgpbSiSHM0ufCHZTGUAhgzY/jr5vA/UMj8LRfuUKci7olt7qXUghZCoyQQGAsV39MUyfIgXIb8AChHGDgproq90ca9z0t0pqaNgNAwWZrB1HmM8mZaRCJ66weinJWuzMyaNrypAGi5RP5gu711iW43EZSm11/6rTGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cj9/wEsD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cj9/wEsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30617C2BBFC;
	Thu, 13 Jun 2024 11:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279416;
	bh=akAZggdBYlZ3/8ZXDSqLwWI6wwfkxm12hG3KuxEtyC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cj9/wEsDLXYZMms5LAhARGy8nGGa07jRqYrk7ievFMSAWWb9uu7km6szwf9fcet9D
	 qXwJN/SDk5yY0L9Z7PJ2kHdh9c/fjBhxScnACz6d9lcHZMXurITuOz2k+Nk5X/EPSj
	 zNEH7HKY5GggnOK8UbboMCT9yVpNnlT/QJEiXbnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Berger <stefanb@linux.ibm.com>,
	Vitaly Chikunov <vt@altlinux.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.9 069/157] crypto: ecdsa - Fix module auto-load on add-key
Date: Thu, 13 Jun 2024 13:33:14 +0200
Message-ID: <20240613113230.092947142@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Berger <stefanb@linux.ibm.com>

commit 48e4fd6d54f54d0ceab5a952d73e47a9454a6ccb upstream.

Add module alias with the algorithm cra_name similar to what we have for
RSA-related and other algorithms.

The kernel attempts to modprobe asymmetric algorithms using the names
"crypto-$cra_name" and "crypto-$cra_name-all." However, since these
aliases are currently missing, the modules are not loaded. For instance,
when using the `add_key` function, the hash algorithm is typically
loaded automatically, but the asymmetric algorithm is not.

Steps to test:

1. Create certificate

  openssl req -x509 -sha256 -newkey ec \
  -pkeyopt "ec_paramgen_curve:secp384r1" -keyout key.pem -days 365 \
  -subj '/CN=test' -nodes -outform der -out nist-p384.der

2. Optionally, trace module requests with: trace-cmd stream -e module &

3. Trigger add_key call for the cert:

   # keyctl padd asymmetric "" @u < nist-p384.der
   641069229
   # lsmod | head -2
   Module                  Size  Used by
   ecdsa_generic          16384  0

Fixes: c12d448ba939 ("crypto: ecdsa - Register NIST P384 and extend test suite")
Cc: stable@vger.kernel.org
Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Reviewed-by: Vitaly Chikunov <vt@altlinux.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/ecdsa.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/crypto/ecdsa.c
+++ b/crypto/ecdsa.c
@@ -373,4 +373,7 @@ module_exit(ecdsa_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Stefan Berger <stefanb@linux.ibm.com>");
 MODULE_DESCRIPTION("ECDSA generic algorithm");
+MODULE_ALIAS_CRYPTO("ecdsa-nist-p192");
+MODULE_ALIAS_CRYPTO("ecdsa-nist-p256");
+MODULE_ALIAS_CRYPTO("ecdsa-nist-p384");
 MODULE_ALIAS_CRYPTO("ecdsa-generic");



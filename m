Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AE2145A1B;
	Thu, 13 Jun 2024 12:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280488; cv=none; b=WnuM+IzEPfK5hycVu463+Zy1uJPdvHPZ6N9OCTASvH6dr9UQuF4vvL0JJOoJGDVTMDqxSpVP0AHbV/irz6A4MLN64VaScCL4eCUoJ7AyTB2pU2ml+LSKkKQlmkL0wRpVHkmlX6E5KnvgmaOeMpGWRG9mtOvhX27o+Ka6B3IryRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280488; c=relaxed/simple;
	bh=Sscp5pEw5y5vgTUJtbCKaoc+gLFR8/RJ3BCJEDVi9s4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsmBLT7yQLAXrcPZUDho/H9bPF4BD2Ue0vpu1+py9fWMY7oBj+Sp9AVGMeZueOYw4jyi6C/icSfDNi4hMehN1b07/F83lN3TqVBl5xTqPxMc/opBmIFh6qG8aWQ9PFV8Gu0ANGlL+Aeq/K0QOnX70PK7zYKz3KNg7rTokzF4Qm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LA+RQ9J/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LA+RQ9J/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315A4C2BBFC;
	Thu, 13 Jun 2024 12:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280488;
	bh=Sscp5pEw5y5vgTUJtbCKaoc+gLFR8/RJ3BCJEDVi9s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LA+RQ9J/ETbZIm4N84/oYlP1uAFk15ESdBelpYMNvHkjXA1ozLStImLGuXv6TU6MT
	 WdQ9we5H82HDVSkz3qo17Lm9oQCg7Bv8smcPb6nz/diMi/0oJV5p7feJ+s2AWwtUuw
	 C6egKKMrXYALmQJ+yN0C9ovVabXhhry+swZGpEpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Berger <stefanb@linux.ibm.com>,
	Vitaly Chikunov <vt@altlinux.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 069/137] crypto: ecdsa - Fix module auto-load on add-key
Date: Thu, 13 Jun 2024 13:34:09 +0200
Message-ID: <20240613113225.974319771@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



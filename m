Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D6814601F;
	Thu, 13 Jun 2024 12:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280251; cv=none; b=c3cj8yaNmspC5lu9CxLMrrnUK7gxjvYFiGTa1l3n0sLQ9QqP9QuUeaCtTobd4Wg+XvuzJMZ4CYV9FSp4G20tPaFuIgurGyzorCbd5QyMHfjdbm+/+8miShyZspWo0CIB5nDULl4FuwuENtOfLtCdr+pTPWS22FeNNGUnC3dVYhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280251; c=relaxed/simple;
	bh=VUx8GuVdZZIXgQSXWd6Ol4cuqgi0ww7vgh/M3/G8K3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVPSR/CIaYJpLK/1t9Ly4YOujl+Xqzw8Skxp3NmtgutsJUtiIROZXaEpLvS1eyVIGQGUPsbYJehZ08Pd5mWbyNTEOZPOktkGnyQR3X37x5y53fiC5d1rDYp12iF40pRRpfoz+IuCIRH0CFC3xJDvKqJ48y6XhyaEvyyKRJgSoLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=deIRMTKL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="deIRMTKL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3423AC2BBFC;
	Thu, 13 Jun 2024 12:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280251;
	bh=VUx8GuVdZZIXgQSXWd6Ol4cuqgi0ww7vgh/M3/G8K3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=deIRMTKLZBwFBrTQ7uA9fyD/n/5BSa7Twr8xSHKoY9TrnvMssar5q8cRtFMs/qbWC
	 bBrygcyAbrjbu3Uj5nf9fi/Ys+WuYlCW3WLjpPxxbY7ZgV5afohAc9cUPcoChsZnRY
	 MnJGSbvAOTtdDRd5xMcBTBIijyJcjHvji+rhMCVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Chikunov <vt@altlinux.org>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Paul Wolneykien <manowar@altlinux.org>
Subject: [PATCH 5.4 186/202] crypto: ecrdsa - Fix module auto-load on add_key
Date: Thu, 13 Jun 2024 13:34:44 +0200
Message-ID: <20240613113234.915920502@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Chikunov <vt@altlinux.org>

commit eb5739a1efbc9ff216271aeea0ebe1c92e5383e5 upstream.

Add module alias with the algorithm cra_name similar to what we have for
RSA-related and other algorithms.

The kernel attempts to modprobe asymmetric algorithms using the names
"crypto-$cra_name" and "crypto-$cra_name-all." However, since these
aliases are currently missing, the modules are not loaded. For instance,
when using the `add_key` function, the hash algorithm is typically
loaded automatically, but the asymmetric algorithm is not.

Steps to test:

1. Cert is generated usings ima-evm-utils test suite with
   `gen-keys.sh`, example cert is provided below:

  $ base64 -d >test-gost2012_512-A.cer <<EOF
  MIIB/DCCAWagAwIBAgIUK8+whWevr3FFkSdU9GLDAM7ure8wDAYIKoUDBwEBAwMFADARMQ8wDQYD
  VQQDDAZDQSBLZXkwIBcNMjIwMjAxMjIwOTQxWhgPMjA4MjEyMDUyMjA5NDFaMBExDzANBgNVBAMM
  BkNBIEtleTCBoDAXBggqhQMHAQEBAjALBgkqhQMHAQIBAgEDgYQABIGALXNrTJGgeErBUOov3Cfo
  IrHF9fcj8UjzwGeKCkbCcINzVUbdPmCopeJRHDJEvQBX1CQUPtlwDv6ANjTTRoq5nCk9L5PPFP1H
  z73JIXHT0eRBDVoWy0cWDRz1mmQlCnN2HThMtEloaQI81nTlKZOcEYDtDpi5WODmjEeRNQJMdqCj
  UDBOMAwGA1UdEwQFMAMBAf8wHQYDVR0OBBYEFCwfOITMbE9VisW1i2TYeu1tAo5QMB8GA1UdIwQY
  MBaAFCwfOITMbE9VisW1i2TYeu1tAo5QMAwGCCqFAwcBAQMDBQADgYEAmBfJCMTdC0/NSjz4BBiQ
  qDIEjomO7FEHYlkX5NGulcF8FaJW2jeyyXXtbpnub1IQ8af1KFIpwoS2e93LaaofxpWlpQLlju6m
  KYLOcO4xK3Whwa2hBAz9YbpUSFjvxnkS2/jpH2MsOSXuUEeCruG/RkHHB3ACef9umG6HCNQuAPY=
  EOF

2. Optionally, trace module requests with: trace-cmd stream -e module &

3. Trigger add_key call for the cert:

  # keyctl padd asymmetric "" @u <test-gost2012_512-A.cer
  939910969
  # lsmod | head -3
  Module                  Size  Used by
  ecrdsa_generic         16384  0
  streebog_generic       28672  0

Repored-by: Paul Wolneykien <manowar@altlinux.org>
Cc: stable@vger.kernel.org
Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
Tested-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/ecrdsa.c |    1 +
 1 file changed, 1 insertion(+)

--- a/crypto/ecrdsa.c
+++ b/crypto/ecrdsa.c
@@ -293,4 +293,5 @@ module_exit(ecrdsa_mod_fini);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Vitaly Chikunov <vt@altlinux.org>");
 MODULE_DESCRIPTION("EC-RDSA generic algorithm");
+MODULE_ALIAS_CRYPTO("ecrdsa");
 MODULE_ALIAS_CRYPTO("ecrdsa-generic");



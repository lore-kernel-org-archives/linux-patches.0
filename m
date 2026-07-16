Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857753BCD11;
	Thu, 16 Jul 2026 14:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210984; cv=none; b=STB9d3t7pe8wLkdHAxxTcZwIGq5DvxuYZtvgcCFS4TeyDGQqu+jHiFizCicDudFn2rWPVfsHR0L9Cp6XLHfu+TBN350gC7ODSwsaLAvFLqtQEK+WzD6pGp8ht3/vDFZTOK+vRhIxsfY11oWMXwQvNPhEGiO0RluPYE+6/NVFF+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210984; c=relaxed/simple;
	bh=fEgXk8VPUYRMIXIpRf5s6D0g0fs1eYaBnrc6MPUEnCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivH7Jq6Ss4a0ufSld7mNWcNeyw/gj/fZWjkt6SA3Xpv/Uls/dyX232miM6+zrHzJMBAFqBCSqYub+jzsWnifDrf4v8P7rdmrZg3h8RG7c0g90S2xvCfgiqplmnckitcsid5Azrc71FUb4T9Ari+MPcoFSRpsV5LNuxwks0BiphI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uiVm8dy4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uiVm8dy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC421F00A3A;
	Thu, 16 Jul 2026 14:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210983;
	bh=olCxpJL3N48JJ5+BBI1nypYWcug59qbiiTySplXSkW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uiVm8dy4K8XiecpizNeeqJlRDXvp0BUOGfASu35v/4GLMJ+FDobweI5yd+M2Fnydj
	 3w6L6vp9aoXiGZsjsh/hm7kZ2JQLX/BWev9/VO7ioEobRJb2DpT2kIvezN3mxdcnKI
	 vIxlKXcFR8aD5oAZIrQp4+gSzUwQ5gYT6WvImU3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Alistair Francis <alistair.francis@wdc.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 255/480] X.509: Fix validation of ASN.1 certificate header
Date: Thu, 16 Jul 2026 15:30:02 +0200
Message-ID: <20260716133050.330157228@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

commit 3b626ba431c4501512ad07549310685e07fe4706 upstream.

x509_load_certificate_list() seeks to enforce that a certificate starts
with 0x30 0x82 (ASN.1 SEQUENCE tag followed by a length of more than 256
and less than 65535 bytes).

But it only enforces that *either* of those two byte values are present,
instead of checking for the *conjunction* of the two values.  Fix it.

Fixes: 631cc66eb9ea ("MODSIGN: Provide module signing public keys to the kernel")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/r/20260508033917.B5873C2BCB0@smtp.kernel.org/
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v3.7+
Reviewed-by: Ignat Korchagin <ignat@linux.win>
Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/asymmetric_keys/x509_loader.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/asymmetric_keys/x509_loader.c
+++ b/crypto/asymmetric_keys/x509_loader.c
@@ -20,7 +20,7 @@ int x509_load_certificate_list(const u8
 		 */
 		if (end - p < 4)
 			goto dodgy_cert;
-		if (p[0] != 0x30 &&
+		if (p[0] != 0x30 ||
 		    p[1] != 0x82)
 			goto dodgy_cert;
 		plen = (p[2] << 8) | p[3];



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B93345CDA;
	Thu, 16 Jul 2026 13:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209741; cv=none; b=fyp0caCdjd9Zyx8m+RZdu8r23FqUATl1pyEtG+VsKLGrkVsv3RxODr1wEoizzOGDASV+rPuMlVjeUXSxQ0IAbTlh7FsYLArdZ9WspOmtkPJHBrQ2/sc7tGxPUlFG1udAhKAMG/SkeUUVFetXXGimPyCdpSh6laLyH8YOjCjI3jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209741; c=relaxed/simple;
	bh=+/DWX3AerYCCpCEYB5PGWknTbfPRZoNIWjtfRP0q3go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3gnFz1eKf4LhN0PdrEM0TaDh4xHWkjliTsQ/EUEOAeEEaeV2nz/ecZPkyeGo1zMUAXjeGNLX016/aXloZerryxVeZnm9ooAorHQEeNsCP4AGbjMdqRtiBMQIzY9Fx1bTXu6RUnBdv0nVKELprGuuHZH3eExrNVsHK6G9JXX45k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AQyWuf0G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQyWuf0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4073F1F00A3A;
	Thu, 16 Jul 2026 13:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209733;
	bh=c2Y1+ZDMen70MbcI/AIS1op7LYCDPPn99TFRKMLHeNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AQyWuf0GDkSZfZq6+M7SzsvnwEe8lTKP7tDxwh139KyTxoFlv+dbACzK7uzq51Dr2
	 +Q1tCP40L1B04ZIQpZM9xSPH7Dnpn4OUNPcuXWVAJSrTKQ1PTNn7EIaHVhy1o0ddp6
	 QMkJwXKoTMi4sR398zRbszH3VtOPU8cHdKpy9iRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Alistair Francis <alistair.francis@wdc.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 261/518] X.509: Fix validation of ASN.1 certificate header
Date: Thu, 16 Jul 2026 15:28:49 +0200
Message-ID: <20260716133053.530629104@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E8522301;
	Thu, 16 Jul 2026 14:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212100; cv=none; b=AqZGnxRK6L2v5qZXBtpHAVbZ8OGCkl+T47FElryl7HtlLbM7bBHLLsKL+u3IyRkW7BGT2gz2gkPkLO7vv24K2rArgvTznwloI6gpfp3ML0nJRgCEslPZVuiYgxmDx2C/iWcfhCtVhHIOmT+2ZHywf2FRgc2G6aDJU+iwRXad1zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212100; c=relaxed/simple;
	bh=KuGg5jAeiK6BbKCvIBsDjCSNT5UPVHqvHEPx3EA5UP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dm14NntfXejWtlkszvUrgNd24DWQ8IXSqNXmyNyMHN/kzwzbcLFSxDFYEh3/qyJZyQF8ynJhgRVXKIfxBXunEb5Wa+aRsecRMEH+XscM0oNXU6aJ2bbsoj2hcXHplpTcSQeNwBM94pfjTU1Zu2DYnp/GZ13KSB5vL8TYZSjml7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qyb+WUKY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qyb+WUKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E106D1F00A3D;
	Thu, 16 Jul 2026 14:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212094;
	bh=AbCfmSGMCH9wcplcj0wQCawtuM1tHa3PBuK9WE1VV9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qyb+WUKYC32fmRKc7XtkWvDmB+qwoCq2x1scbqk45pCXlOJ8uD3peYtpjapG7hjl/
	 VVerBLtsOK+e7ANbuu1y+8nADecbBOnN360SUU0uw4f4bENSuYkFkuwqVrLZMehNok
	 aAvqR8p8YKjHsyVSZuxQtA5KbCVXOqAdpz8tGQDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Alistair Francis <alistair.francis@wdc.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 198/349] X.509: Fix validation of ASN.1 certificate header
Date: Thu, 16 Jul 2026 15:32:12 +0200
Message-ID: <20260716133037.801884909@linuxfoundation.org>
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



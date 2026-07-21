Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2255F43634C;
	Tue, 21 Jul 2026 20:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665192; cv=none; b=IchHZ3m7jkt8qla2HB5fJW24iU+1tq1MKtE6aFoqL6zPUysXOcvUGImHzldu/HDu2oRZU3YE6yuV9WpS1esdGqVvX2KolTxb2GR9wo2UNhoEQeJZKJgUSoWb+ANHjS6MDsJAwqNzsPbLwSIivAI/M243IlbV/vcjOsLcFtj6bUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665192; c=relaxed/simple;
	bh=8dZ4synRVosFp1OOx92PpirXAY5JglJcaZVXE4dkEnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fuawwe+1fBoM0S6wQxU1E6/CXq7ihLKJXmaM5hKM7iMJsObVO9obOYXqDJFDOn4rZDFRu/SpQkNm34Ce1Cm60hELZ++zQo+gmmRjl7xOZIR7iQZLyjI1iZAhjvduseA1jpMah39Ccxoyye5wugvsPHG6NyRe7GoCOE2WqJcbrGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vbfx23UU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vbfx23UU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B001F000E9;
	Tue, 21 Jul 2026 20:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665191;
	bh=NbWZr0nfed536/BPq5gYmxe6CM/TgJNcf6PZm1GMsn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vbfx23UUCdqqSQ3JLtruER5G7YUWKrf6duS4n8OnR6dj5iZkcTR44Vs1Bfg10mdt7
	 P3TMwbPg0rDvDkZ7Y+dV6xBCmT/p+ZBCL50qPF+D0J0bKytVjpnqou3cMEbPr5Mo1K
	 yE8hHZusEd2J8/LyUD4jPhBvUKLAQ097j00Y1ts8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Alistair Francis <alistair.francis@wdc.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 0210/1266] X.509: Fix validation of ASN.1 certificate header
Date: Tue, 21 Jul 2026 17:10:47 +0200
Message-ID: <20260721152446.512109077@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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



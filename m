Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047882;
	b=Lote2teLj8MEeaTFrE8VajrofM/a0KKmcwzyGETrAXX1jyiRfRsFyQN742dAByfyn7+b
	 XCIXWK3vzjl2HARpX8d+SBfzKRRgrxKu1Ucr8I69HWRrG0sREqPD7kw3KoK+x7UISWZI4
	 CqLsxqQMiA//BTsJ01oIbkwTJudW0gnnweWe37TQQTjz/hRPszsXXFOjrC35QON5mKPz6
	 K9Bwgv7TydJkT72cJq64ZdwYI3qFpxn0LDujZ+tqOp8ktphX9FUfk7sFHRmnkfdqApprS
	 dY9vNCepSV3d3QwOXsNRqFJkeUyxbrCC4tp0hbx2b/6huYVI1h1VQSVC5+NrUN0UHOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047882;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eUQDqCnnfky9qFHl0/Ir0s93hIwfZdoCc2dpkzmrfIY=;
	b=eir2sxruACPb96iKKdWt5dO5BNrvkatgRW63fbmQZ85SmSCY1a1gFUt+AUn3nXZfJqLG
	 GdraIxA15qjQMeqT1miOp02mOBCrPHLiR1YDHqwUUjbRtgxW2amZelwQ8dE1K0E+iHZzD
	 9lNeem81SynSnmu94oRauSZ/SM7UBNKMNMvi7H5KGkRFojDI6Aua45RzkTxKDEDt6doyL
	 hECBxZGoAC06ijs2Kkmuv5ug0o804LIoqvo6rtHLVbccpxnsYQDOP3RWUTjk490FXR6GK
	 XYHd5NCw4ExpxcC9M9KvMPqV9VcO/0JS7EaP0EHeq1GOqzqdEUD58B2PkfehjfU9h4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TUcoK8Lt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C03606A31C;
	Thu, 19 Nov 2026 00:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TUcoK8Lt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649731F000C4;
	Thu, 19 Nov 2026 00:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047881;
	bh=eUQDqCnnfky9qFHl0/Ir0s93hIwfZdoCc2dpkzmrfIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TUcoK8Ltejzrh6PWJibhux3KVeAe0HNOS42HX2t1bnyNyVjnGLzQZM3Q2Ez2fdURL
	 5KBBx8mq7oYkXAG82J3IJ1pq5KTyuM5MbPrtmeWGue/isMSgsQ1alaVvtiAGuwfv8H
	 EhJgCpMzD/Ykn3C4epQ6S+EOPcp3CBoHDIzHiDyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrice Derepas <fabrice.derepas@canonical.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1797/2857] crypto: asymmetric_keys - fix OOB read in pefile_parse_binary
Date: Wed, 18 Nov 2026 15:47:11 +0100
Message-ID: <20261118150305.963671187@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabrice Derepas <fabrice.derepas@canonical.com>

[ Upstream commit 37d550172c2d3cdb3a5ace3e6cb0625967d86349 ]

pefile_parse_binary() reads the size field of the certificate table's
data-directory entry, which sits at fixed index 4 of the PE optional
header's data directory:

	ctx->certs_size = ddir->certs.size;

but nothing ensures index 4 is present. n_data_dirents (the untrusted
NumberOfRvaAndSizes) is only upper-bounded against header_size and may be
0, and header_size need only satisfy cursor < header_size < datalen. A
crafted PE with n_data_dirents = 0 and a tiny header_size therefore causes
the ddir->certs.size read to land past the end of the image (CWE-125). The
chkaddr() that bounds the certificate blob runs only after this read.

verify_pefile_signature() is reached from kexec_file_load() (the
lockdown/secure-boot enforced PE-image signature path), and the image is
parsed before its signature is checked. The trigger needs CAP_SYS_BOOT and
the access is out-of-bounds read only (no write).

Require the certificate table's data-directory entry (index 4) to be
present; the existing upper-bound check then keeps ddir->certs within
[cursor, header_size).

Fixes: 26d1164be37f ("pefile: Parse a PE binary to find a key and a signature contained therein")
Assisted-by: copilot-cli:claude-opus-4-6 frama-c
Signed-off-by: Fabrice Derepas <fabrice.derepas@canonical.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/asymmetric_keys/verify_pefile.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_keys/verify_pefile.c
index 7e5b392dcac79..320397f78b40e 100644
--- a/crypto/asymmetric_keys/verify_pefile.c
+++ b/crypto/asymmetric_keys/verify_pefile.c
@@ -87,6 +87,11 @@ static int pefile_parse_binary(const void *pebuf, unsigned int pelen,
 	if (ctx->n_data_dirents > (ctx->header_size - cursor) / sizeof(*dde))
 		return -ELIBBAD;
 
+	/* the certificate table entry must be present in the data directory */
+	if (ctx->n_data_dirents <=
+	    offsetof(struct data_directory, certs) / sizeof(*dde))
+		return -ELIBBAD;
+
 	ddir = pebuf + cursor;
 	cursor += sizeof(*dde) * ctx->n_data_dirents;
 
-- 
2.53.0




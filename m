Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054743;
	b=4w1JAfD1HdHIjyXjQkqIkGhHhSF2ahzODdY+VxBRQJJJOnSY5FSeOSEyP5Cvp/foGlBo
	 7sDkUQioWXJdf279DgskXb0fZysncM2w0fdzGqBA6/g4xMszOrnxHlznuQUkf57JHHMiZ
	 seZM+urXqtcBBTEy9N+rYBScH3fXFyTg9Mlcv7yK0biMnLfwhtZjfK58Nz9Qd4Tj9fcSg
	 L98kWwWVQwJmoy/vQ9C5nr5mdPFRkLKyiJryi0BUE7fH/tKQNH5KMTpR13dKZwEq/InEA
	 nvA2k8E8SJZ0us4IpsWWjSaQNdne8ELffiaukci6wB8gQvFj8VQ8lI0GgHN+9uIEgeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tjubGu9PNEVYrAZntaczat/6IdJe3gG/9S9yjuQQ8mU=;
	b=zNZPjc0dhssGv7i4dr4A2nII2xztrDN3UC7NfhGXN386KBeFSZbHCmmYiF9Yhl3bSeFg
	 QMM7OHnLNRZJV2Vinxk70xFSoL+Ir1FIYssUMmERUboL9pbNGr1Cc7NNLQ0kpX1pPlH4U
	 atLT85hDFIe0ksS14utUoXAvTYaW39okbCszk6ZgFKBDFxYjRx0Qkb+7BbExJkSYP7XIA
	 JtU+W4qdbnu282h9B6bNpRBmy3yogS2AlQ3Ek3WK5FAK3A0BfLevUmfNMy/XnhyHt5n8j
	 RWMa8X1ob1EucmWxe4yR54VrJvCwGr3N3cupH0mlgK9WzWTEa1gNUVPljKBWqsJw4nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1F8FqVYC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F092606A325;
	Thu, 19 Nov 2026 02:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1F8FqVYC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777A51F000C4;
	Thu, 19 Nov 2026 02:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054743;
	bh=tjubGu9PNEVYrAZntaczat/6IdJe3gG/9S9yjuQQ8mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1F8FqVYClPnurIY7n3deymyf8/RkD7SkkSwutJUfNyB5m4oMJBT5/FKRZV8L7JDsb
	 /pWAAPqltvQ/KEoZ9ND84nvC32K5S/H/skP8oOLjnvIOlLXymclWxrYSLaWFyOFWh7
	 QqKEx9TvnsNHvDvuC3xRcFPydehg7J99R58de+ZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrice Derepas <fabrice.derepas@canonical.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1384/2214] crypto: asymmetric_keys - fix OOB read in pefile_parse_binary
Date: Wed, 18 Nov 2026 15:51:00 +0100
Message-ID: <20261118150106.722738382@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039410;
	b=BZsWMwIue5iLZUzGN5EuZQYyQ8i7ZxcLqbdhKucRNFBJ6gRFgOxogIeFtCTHLxK4oT7D
	 6L7s4eHM1poMsstwrIp56+LCGFfhFYlmC6xV/l2E6bbBRLjtRIMLbwiJWwaYFF+2rmE9Q
	 z4w7XtSCqKkOsHNxWTCMt/Am9FDbASF28zN/5LZol/Kw2eOYVx5ka49I9VuKrH1SbNvYN
	 WJUlzF9bih4NF8FzBGbfHd06M2OI0ZjEnNdkP9EY5e+KPJugGdjW6aaH5XUVv+sAAPGEa
	 PeIB//mhIKuO2Q80sTxj74GFAZ6DApBWU/Ug79UUHGpmfEbntDRamEKDl1he4/Ye6Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039410;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7nWGJR1KeN1/TrdWo9Zv4ku4n/vwA+gtb2YxGLtPm84=;
	b=l8oyG3+r2sbSMaQ47C00pWywnRF0U5Gs3Jf1/Y/8tknf54OJax5BhSoHXcLCKUhgBh2B
	 oYcJJ2hIr095wP8A8O+ipEEYganNKnUK/OvwANuLERycwM17ksOIap+deFBx5QHmA4pZm
	 1cTE9EVRSIlM3xUpPAm4kVx8O5+X2CK1Uaosg7qiDHPHZmDwP0OHhOCged/1B8g3SK/h5
	 40iudJlRUC/ChoQGS31acVWbE4cXKbYWjDlJQYlZpZ7mjDurn0/oZuBNFx5JAgYkaZ1UB
	 YHRKO7go+hRkaXRoJQOC/1GQdV1THYb4O6CMLykoM0seC/GtvLKbCWRVwyB694Abdwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pUjHDK5L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365D0606A31C;
	Wed, 18 Nov 2026 22:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pUjHDK5L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CEB1F000C5;
	Wed, 18 Nov 2026 22:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039410;
	bh=7nWGJR1KeN1/TrdWo9Zv4ku4n/vwA+gtb2YxGLtPm84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pUjHDK5LRSqwRuRL2jiQe23o3wGyEyfaB7fDFaXjY0FGV9AtPE04Ukvg4UQf+hKUo
	 fhMDP95lFM15OKbgREHsG9dU+F0CXuavwqxVhl/TU4Ek22eWN6SfsE0DXp4Xdac2sw
	 3YhvCC1kVCecFD6t9/PR2+HMkfriY7JoGJ/KP0OY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrice Derepas <fabrice.derepas@canonical.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2053/3318] crypto: asymmetric_keys - fix OOB read in pefile_parse_binary
Date: Wed, 18 Nov 2026 15:44:35 +0100
Message-ID: <20261118150423.647052091@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e20a106e7443c..e21495613c373 100644
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




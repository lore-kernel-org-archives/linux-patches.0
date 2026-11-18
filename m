Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029092;
	b=2+cPQ4EYS/Qmn7v2bxPbSphd/4f8FoMhC89Q/NH/9Tj+mYYL5pqx2WwMdnXuY8sdLycC
	 9/nWaiFYEzPn0y6x097hn4K/K3krJIZDP7dr6N3zKAbiZ3KfXYUrQXW5LKrAAxdhP9gc5
	 TdVzsgzHShtOGUXVikgrecqdZcQ4GEmK1x9TzsAES3tuWJGc84CUTAaQvL0y50inF6G3w
	 CG7o3bATB0QH5dVCKnKkW2APG/IfF5sg/VFmwXTbSsAgd+IxAIeutfUPo6vA8SQov45S5
	 v1F4iEPzE8J3RkydcPSug5K0Y14uXwd+hm6frqsXunI7ItmJmP52xPqJ4UiyT8fmLeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VH9Zjkmrs3JueojfkUD62efPPz8u+O47tCzNePW1L1g=;
	b=YXyCP/OZHqukWsJqWRSjxKm0HTd4SkyZxKKeqdWTr0pUZDWM4DlEE6I9wYysHKECc9FO
	 PrBgihmWgl+A6bj5DfTjQXmU41o8Mu+uwHNT8Hm+IUnD/mAAnJiyyGz1r/mWxAB8tCFPn
	 ZyboatNAEh1NOEtzY3I3W+vvdhenwOPK8+nvetgWfmX3ozbPVEYKeGQXeOxlPEAHxl4se
	 tk4dda56d7oPBj3h8vKnsVt1MN7Ybr9ysdC3NO1JUnuJIGK1DLQMagFU5fEvf+OuPWjNJ
	 VOTPkQWCpOY7vmlPSf/8wJLy9vrWiiQbqjykV2QReNXYpBsBo79x0+eNleKC2Zxq8gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OdpYQyfD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1F0606A332;
	Wed, 18 Nov 2026 19:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OdpYQyfD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C401F000C4;
	Wed, 18 Nov 2026 19:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029092;
	bh=VH9Zjkmrs3JueojfkUD62efPPz8u+O47tCzNePW1L1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OdpYQyfDEeO89cewTnBYy1KvuKcp6z8cytJQdIwdxzb8lN7roN0wtcLNObs2WN0Az
	 jR641lnqz9SkmDJoQXg3rwbaM+rB+QAiCF86D7po5m0/LCy0KO9wvpu38WuM9vubuy
	 gV5zrGLwHkRrfRxijsjCwcy2l9oI4FdSRTYAuCoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrice Derepas <fabrice.derepas@canonical.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0228/1756] crypto: asymmetric_keys - fix OOB read in pefile_parse_binary
Date: Wed, 18 Nov 2026 15:39:15 +0100
Message-ID: <20261118150017.356353471@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 95ba0a91dbbdd..2bc32d1ae99f2 100644
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




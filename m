Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD33BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB79C433EF;
	Tue,  7 Mar 2023 17:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209238;
	bh=/CiLiZ4ZhIUoIABFC7/F5Aq1DKQhCCrH8EVglSmFoNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mKLOVVXkG97GgwHlQmIDVrokXp2HOCcAHx1CWtCLvxBnAItzsaz3RL6xEZev/mdxS
	 Voc1Tt2kaneod0jhnVmEqeQshrUfyQVy5gNdcq3VpeAw1s1+e14A/ttaRYXy7hglQV
	 SlXn8V+5gouIjhGCHPJ9cNV594saMpO6Opmw8dp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Kenzior <denkenz@gmail.com>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0124/1001] KEYS: asymmetric: Fix ECDSA use via keyctl uapi
Date: Tue,  7 Mar 2023 17:48:16 +0100
Message-Id: <20230307170027.459853336@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Denis Kenzior <denkenz@gmail.com>

[ Upstream commit 10de7b54293995368c52d9aa153f3e7a359f04a1 ]

When support for ECDSA keys was added, constraints for data & signature
sizes were never updated.  This makes it impossible to use such keys via
keyctl API from userspace.

Update constraint on max_data_size to 64 bytes in order to support
SHA512-based signatures. Also update the signature length constraints
per ECDSA signature encoding described in RFC 5480.

Fixes: 299f561a6693 ("x509: Add support for parsing x509 certs with ECDSA keys")
Signed-off-by: Denis Kenzior <denkenz@gmail.com>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/asymmetric_keys/public_key.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 2f8352e888602..eca5671ad3f22 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -186,8 +186,28 @@ static int software_key_query(const struct kernel_pkey_params *params,
 
 	len = crypto_akcipher_maxsize(tfm);
 	info->key_size = len * 8;
-	info->max_data_size = len;
-	info->max_sig_size = len;
+
+	if (strncmp(pkey->pkey_algo, "ecdsa", 5) == 0) {
+		/*
+		 * ECDSA key sizes are much smaller than RSA, and thus could
+		 * operate on (hashed) inputs that are larger than key size.
+		 * For example SHA384-hashed input used with secp256r1
+		 * based keys.  Set max_data_size to be at least as large as
+		 * the largest supported hash size (SHA512)
+		 */
+		info->max_data_size = 64;
+
+		/*
+		 * Verify takes ECDSA-Sig (described in RFC 5480) as input,
+		 * which is actually 2 'key_size'-bit integers encoded in
+		 * ASN.1.  Account for the ASN.1 encoding overhead here.
+		 */
+		info->max_sig_size = 2 * (len + 3) + 2;
+	} else {
+		info->max_data_size = len;
+		info->max_sig_size = len;
+	}
+
 	info->max_enc_size = len;
 	info->max_dec_size = len;
 	info->supported_ops = (KEYCTL_SUPPORTS_ENCRYPT |
-- 
2.39.2




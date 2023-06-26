Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E282614A96
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D81EC433C8;
	Mon, 26 Jun 2023 18:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804241;
	bh=QnsAWiIGc5DFg3WiUAfmD8ul+vWcK0urVQdZLVTnyVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XqVU0OEW5GAMUmS+HBIRJeCf26eHKbsHBYEayzkoC1dtfXtg/VUcJi8GL3cPLVUwY
	 GFpePb9Q7XxFk+cuBooXuo8tQ1O3zArXaIWoYxUwDedvJHjSpCxgkGQU6W9N+Ibqx4
	 Tf26VDQY3UAvpt8/LdGQONIDskQZzNkCx80b3fLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Magali Lemes <magali.lemes@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/170] selftests: net: tls: check if FIPS mode is enabled
Date: Mon, 26 Jun 2023 20:10:59 +0200
Message-ID: <20230626180804.597870124@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Magali Lemes <magali.lemes@canonical.com>

[ Upstream commit d113c395c67b62fc0d3f2004c0afc406aca0a2b7 ]

TLS selftests use the ChaCha20-Poly1305 and SM4 algorithms, which are not
FIPS compliant. When fips=1, this set of tests fails. Add a check and only
run these tests if not in FIPS mode.

Fixes: 4f336e88a870 ("selftests/tls: add CHACHA20-POLY1305 to tls selftests")
Fixes: e506342a03c7 ("selftests/tls: add SM4 GCM/CCM to tls selftests")
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Magali Lemes <magali.lemes@canonical.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tls.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 2cbb12736596d..c0ad8385441f2 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -25,6 +25,8 @@
 #define TLS_PAYLOAD_MAX_LEN 16384
 #define SOL_TLS 282
 
+static int fips_enabled;
+
 struct tls_crypto_info_keys {
 	union {
 		struct tls12_crypto_info_aes_gcm_128 aes128;
@@ -235,7 +237,7 @@ FIXTURE_VARIANT(tls)
 {
 	uint16_t tls_version;
 	uint16_t cipher_type;
-	bool nopad;
+	bool nopad, fips_non_compliant;
 };
 
 FIXTURE_VARIANT_ADD(tls, 12_aes_gcm)
@@ -254,24 +256,28 @@ FIXTURE_VARIANT_ADD(tls, 12_chacha)
 {
 	.tls_version = TLS_1_2_VERSION,
 	.cipher_type = TLS_CIPHER_CHACHA20_POLY1305,
+	.fips_non_compliant = true,
 };
 
 FIXTURE_VARIANT_ADD(tls, 13_chacha)
 {
 	.tls_version = TLS_1_3_VERSION,
 	.cipher_type = TLS_CIPHER_CHACHA20_POLY1305,
+	.fips_non_compliant = true,
 };
 
 FIXTURE_VARIANT_ADD(tls, 13_sm4_gcm)
 {
 	.tls_version = TLS_1_3_VERSION,
 	.cipher_type = TLS_CIPHER_SM4_GCM,
+	.fips_non_compliant = true,
 };
 
 FIXTURE_VARIANT_ADD(tls, 13_sm4_ccm)
 {
 	.tls_version = TLS_1_3_VERSION,
 	.cipher_type = TLS_CIPHER_SM4_CCM,
+	.fips_non_compliant = true,
 };
 
 FIXTURE_VARIANT_ADD(tls, 12_aes_ccm)
@@ -311,6 +317,9 @@ FIXTURE_SETUP(tls)
 	int one = 1;
 	int ret;
 
+	if (fips_enabled && variant->fips_non_compliant)
+		SKIP(return, "Unsupported cipher in FIPS mode");
+
 	tls_crypto_info_init(variant->tls_version, variant->cipher_type,
 			     &tls12);
 
@@ -1820,4 +1829,17 @@ TEST(tls_v6ops) {
 	close(sfd);
 }
 
+static void __attribute__((constructor)) fips_check(void) {
+	int res;
+	FILE *f;
+
+	f = fopen("/proc/sys/crypto/fips_enabled", "r");
+	if (f) {
+		res = fscanf(f, "%d", &fips_enabled);
+		if (res != 1)
+			ksft_print_msg("ERROR: Couldn't read /proc/sys/crypto/fips_enabled\n");
+		fclose(f);
+	}
+}
+
 TEST_HARNESS_MAIN
-- 
2.39.2




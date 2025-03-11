Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813062405F9;
	Tue, 11 Mar 2025 15:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706061; cv=none; b=uCJDxP8NlBVMmvcRAt1iWPYfVTksQm8lvJaQqwduPAJq+Ul4YPt03EIx3X5KVZhJWBSHTPq+baIbOcZqu0lTFfARLtdY8wqTOXqkHj93jKyh3rk5UQ8df21HW4J6Sy2voxw9yMEqG3eQxr5x8k2is5qS/nCZwgxJtqq6kk6g3QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706061; c=relaxed/simple;
	bh=sMJJe0FbUu8b30U/KM+u+WFbLVv26tT2IGuzde4lQdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drmj/j4wvj2aEC/FcOVVwXTwAHTYIL7Iz4kaaGT4ne+3iW/rJHI1jH8Z9Kc91UW5Af7Eru/hPuaFC8QPkWBhxqG0N5ntjq20hGMBgW7RCrr+gwSlj0D7m1D+g5/9SFaqak6oVvggnZOEwLmAyOIInWmoJL0Qk8bjJPmkXJvtMMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QbZc9CvP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QbZc9CvP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2238C4CEEA;
	Tue, 11 Mar 2025 15:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706061;
	bh=sMJJe0FbUu8b30U/KM+u+WFbLVv26tT2IGuzde4lQdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbZc9CvP/Ll1NoL7/Qif1DYDFAbvRT3nB1tjiMYfFFdiy2aK1SRyLB6Dszneu3LGZ
	 A9RHpjfB9Ljk7gwlR9HFQLXgYoE3R+5rRzlKpAa6MmQ8otXkwp6sUkGBMc781NXxNX
	 +kW5AliwYfTQBL0dJmsNGzR5WcqmAUPS4ftCCyL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei He <helei.sig11@bytedance.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 229/328] crypto: testmgr - Fix wrong test case of RSA
Date: Tue, 11 Mar 2025 15:59:59 +0100
Message-ID: <20250311145724.008945588@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lei He <helei.sig11@bytedance.com>

[ Upstream commit a9887010ed2da3fddaff83ceec80e2b71be8a966 ]

According to the BER encoding rules, integer value should be encoded
as two's complement, and if the highest bit of a positive integer
is 1, should add a leading zero-octet.

The kernel's built-in RSA algorithm cannot recognize negative numbers
when parsing keys, so it can pass this test case.

Export the key to file and run the following command to verify the
fix result:

  openssl asn1parse -inform DER -in /path/to/key/file

Signed-off-by: Lei He <helei.sig11@bytedance.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/testmgr.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 27ce9f94a3246..7cda2f88ef434 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -251,9 +251,9 @@ static const struct akcipher_testvec rsa_tv_template[] = {
 	}, {
 #endif
 	.key =
-	"\x30\x82\x02\x1F" /* sequence of 543 bytes */
+	"\x30\x82\x02\x20" /* sequence of 544 bytes */
 	"\x02\x01\x01" /* version - integer of 1 byte */
-	"\x02\x82\x01\x00" /* modulus - integer of 256 bytes */
+	"\x02\x82\x01\x01\x00" /* modulus - integer of 256 bytes */
 	"\xDB\x10\x1A\xC2\xA3\xF1\xDC\xFF\x13\x6B\xED\x44\xDF\xF0\x02\x6D"
 	"\x13\xC7\x88\xDA\x70\x6B\x54\xF1\xE8\x27\xDC\xC3\x0F\x99\x6A\xFA"
 	"\xC6\x67\xFF\x1D\x1E\x3C\x1D\xC1\xB5\x5F\x6C\xC0\xB2\x07\x3A\x6D"
@@ -293,7 +293,7 @@ static const struct akcipher_testvec rsa_tv_template[] = {
 	"\x02\x01\x00" /* exponent1 - integer of 1 byte */
 	"\x02\x01\x00" /* exponent2 - integer of 1 byte */
 	"\x02\x01\x00", /* coefficient - integer of 1 byte */
-	.key_len = 547,
+	.key_len = 548,
 	.m = "\x54\x85\x9b\x34\x2c\x49\xea\x2a",
 	.c =
 	"\xb2\x97\x76\xb4\xae\x3e\x38\x3c\x7e\x64\x1f\xcc\xa2\x7f\xf6\xbe"
-- 
2.39.5




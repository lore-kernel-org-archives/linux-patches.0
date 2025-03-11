Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6523C0B;
	Tue, 11 Mar 2025 15:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707309; cv=none; b=lqr9Kfrkua4vzbwi0a0cWkXeQ29x6MDK0mZN9s1gP/MaFORDpquI7FPNCJyc0Lj9nnXpmezpYRhcJB+TKUVmWgsmTShQu65qkwGvF6AXGH5eobFcR3uXzssFmSQasII61+F5FmqTQhvowm8FyoPfHs/06QWV4s7E1NxEmIi4/uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707309; c=relaxed/simple;
	bh=92moPOtfdfSXNMPuR2zsJbU/87nVFTnitbqdetWtutQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lr+Npv+nlvaA3YWmz1yEwLKsj9Qfm5dqKFulQPbYc0I0qg+tlo0aO0FpK0ewnCr9zLJwfC7FpOwY37m4P6teU1C4FOMnhjFAk+ot8fF5X+uA0MtrH2Z1/K/HDTv3m8Kye3V+8wJw1pwUpgNfoeupuzGWA8GZdtmUq5m1DypWYFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ThZGmRvK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ThZGmRvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6922C4CEEA;
	Tue, 11 Mar 2025 15:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707309;
	bh=92moPOtfdfSXNMPuR2zsJbU/87nVFTnitbqdetWtutQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ThZGmRvKZTVmo3B55CfoWT7swB6fmy1IegovoXJ8DVrP2n2jqp/WxYaEXwzuTGs70
	 hZIlti/MimnMXflrlZ/K+RvOqiXr76TZxgVeGyPudk8lVTOVXUFAlA2RSII36xec+j
	 13mjPi/FSAm8tDRqk2cC4la1wORwBvkncBS2c7Qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei He <helei.sig11@bytedance.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 314/462] crypto: testmgr - Fix wrong test case of RSA
Date: Tue, 11 Mar 2025 15:59:40 +0100
Message-ID: <20250311145810.766386264@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b04e9943c8c7f..24bc1924edb72 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -257,9 +257,9 @@ static const struct akcipher_testvec rsa_tv_template[] = {
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
@@ -299,7 +299,7 @@ static const struct akcipher_testvec rsa_tv_template[] = {
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




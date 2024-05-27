Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63D1168C4;
	Mon, 27 May 2024 19:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837702; cv=none; b=CwS/VslYa9woZnUxZZYuvMpT7ROcJyJgKynvHQpx5cl4dPvy63enPNU7Unx8YuuOxlLgj7P5d3Gq9qe2LnIZaDzB1RfB1muUFDT1BjbsmSuoZDpa8Uqs0XUj9xDz+vp0q51xiRLNMLref6YBQb4H7eNKL7CYjU6iNhGCuLPqmxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837702; c=relaxed/simple;
	bh=lgsJW8Bpu7JdwnztrF8tULJdsB9ceJdzdBUJ+B3LmxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPuWboqEeDl08T0tSI1du5vI2ejca/hV5jXL7M0eF6B67pgVxzGWKgD7wZaXtt7w8i5z7JQFOwd64A6ltUJ/7+e5+kGy6aNQLUpn1ulQEMDyd6xNfvUpEwQwrh2J6qGvbB9Qa0T/4s2BOwr7Za4NTFqpekDJqjKUHNp3vS0bZ+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHnRvelD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHnRvelD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C24AC2BBFC;
	Mon, 27 May 2024 19:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837701;
	bh=lgsJW8Bpu7JdwnztrF8tULJdsB9ceJdzdBUJ+B3LmxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EHnRvelDwsyNQLPMNW2PNnIZOI7R37PU7SoSnjennpFVHf6Tj5oee40gXOW8JeuRK
	 1oyt+GyjORax98k7WjNdKu+Wdtu9LTyhhSOIOxTxR2Kf68v4UcQ84kJnpVsTYig2Bk
	 yrPmCcvkO92C/ltoRvaiZSYRxT7XVSxY27Q/NcLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 111/493] crypto: bcm - Fix pointer arithmetic
Date: Mon, 27 May 2024 20:51:53 +0200
Message-ID: <20240527185634.155357095@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit 2b3460cbf454c6b03d7429e9ffc4fe09322eb1a9 ]

In spu2_dump_omd() value of ptr is increased by ciph_key_len
instead of hash_iv_len which could lead to going beyond the
buffer boundaries.
Fix this bug by changing ciph_key_len to hash_iv_len.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 9d12ba86f818 ("crypto: brcm - Add Broadcom SPU driver")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/bcm/spu2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/bcm/spu2.c b/drivers/crypto/bcm/spu2.c
index 07989bb8c220a..3fdc64b5a65e7 100644
--- a/drivers/crypto/bcm/spu2.c
+++ b/drivers/crypto/bcm/spu2.c
@@ -495,7 +495,7 @@ static void spu2_dump_omd(u8 *omd, u16 hash_key_len, u16 ciph_key_len,
 	if (hash_iv_len) {
 		packet_log("  Hash IV Length %u bytes\n", hash_iv_len);
 		packet_dump("  hash IV: ", ptr, hash_iv_len);
-		ptr += ciph_key_len;
+		ptr += hash_iv_len;
 	}
 
 	if (ciph_iv_len) {
-- 
2.43.0




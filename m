Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDF66EB56;
	Thu, 13 Jun 2024 12:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281733; cv=none; b=gj0vbwBPdKKHQXdhuCglPnVJt11eZXyVePMmVMY0JpkWdKFMcYFJCyVm+9tZ6MeF8ob9/GWxCU4GcKrCAJ43OuFzleCSQxmFUiPFNl6cSjkFQV7FIeiippeNrs/0gJQiC9L7DVSEalaMR5f9cLgHiyH+ZHDQ3EXVq5EA7xovHPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281733; c=relaxed/simple;
	bh=7UYxMHyg6aJxTE5uyOd/q8f5wg3giOmlVZVohODBCOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hD3TkluArOyyTnWvnw+ebl7wKSBZ1ryRvDUlgQWRgrlr+K9buAPM6judials1zqld0xzIiZEJbwrTuPJU55CpW+m8n+936Dv3BM5Lvmu42txPH4+BuX3WJXqxpqScwb1q2zcxptwjRgC/Y0RS+d4h81dShB45+3j4IGLCP21uKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/+Wb25O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/+Wb25O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECAB9C2BBFC;
	Thu, 13 Jun 2024 12:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281733;
	bh=7UYxMHyg6aJxTE5uyOd/q8f5wg3giOmlVZVohODBCOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/+Wb25O40sTmV7yMUV+qm1r/2d0EQdIwSBAkXIVOBNOqPV8BcVnhf8whGD+kUJ+9
	 Z9/y7LMLBRuJe5NM3fEOwownifzQ2mRy1nagV9sLhksOd/0P3Gr01Bnhe3BarvRn9t
	 z4H2rLSaVCfIlxWoU18UxVjLQaoS1LAUKPgAAzS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/402] crypto: bcm - Fix pointer arithmetic
Date: Thu, 13 Jun 2024 13:29:54 +0200
Message-ID: <20240613113303.584630224@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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




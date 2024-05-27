Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C7F167DA7;
	Mon, 27 May 2024 19:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836548; cv=none; b=PbawYRzc4oDLxy2yjSdPzXi6JtGNddzu+fHKabmLMG8XUiZkh+XkaP6MB9uI1hrTpkownx3k5ME7E9ljBpKkYy6P2ELdkbO992owW5fa79c/Qy4+qCFSWhTBuoF9mYP+Qtp8x2Y5Z+fWvjiI/8EvkNdNw29FpCqW3cQl6AK10cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836548; c=relaxed/simple;
	bh=Q8rGwDCbpnsZtwdZfNNUhihYERVC8E+ci1JntanBIPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSDwornYfAQQlqWokUPVyVn6g/QFBDnkcNJ3BqJOTn82JPQ2hbgHDq5FYnmt+ykYOk7X99cebi4gbtMpeA29QeOEk4OCQp8RDADWzd5zhZp6PROWl1cNhYmwOCY5dYVfiXXDsAO/LGm3ZGhqLF7tP1SAdC3mrZ7WdjYCt4AW99c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ff6dEIhH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ff6dEIhH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353F4C2BBFC;
	Mon, 27 May 2024 19:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836546;
	bh=Q8rGwDCbpnsZtwdZfNNUhihYERVC8E+ci1JntanBIPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ff6dEIhHP6naks+hvRORjUxDSqegq5RWAJp6X1VURntQNFrphheXI6rbyg6YzpFn1
	 HJXnncjOB67A/+zmtGQuea4epFl0B587cuPcJcxMN+7lAYiewE8FE7XHTj1y+3j9vM
	 zfLsN2SiPxPWJdOslUTPlGimi54Y6vt8OnzlbeLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 044/427] crypto: bcm - Fix pointer arithmetic
Date: Mon, 27 May 2024 20:51:31 +0200
Message-ID: <20240527185605.878908284@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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




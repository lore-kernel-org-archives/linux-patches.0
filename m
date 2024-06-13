Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A5244C6F;
	Thu, 13 Jun 2024 12:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280751; cv=none; b=rxYHuKjl8SF74NHpfHNuvidYXNDBKru98YRrt5omM0WOXryEjm4irwrwhIW90QFSUBzOsRokJsPI+xmvTEtphr4NzmOeHzmyK6t4a1sDUk09yLyl2MCtxB+kSmv8LEh+DNe+M8UTi+jHt5FrOJ4pdJVhzK2DDtffnnenalx6SNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280751; c=relaxed/simple;
	bh=FuDCdxQzBvs6+acHn3P9Hjj5p5pY0CpHyHOSV0FRmJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NgL0JfYxHx2XjWqHBkjcjeUQ4uklVdsLLuAfpTeOIRDECMY6c9PYERpFsOeTVw5fkQTDMZrSb7P/ARtpPEUj31g0n8p/hyqKjOodtygNtOBy6FcyZzeiFJHxRIaB+BkFLpwJkt07pR08886sCZH93vQ9nKJeZKwqTqi9xZYXF1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wW8xSrw8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wW8xSrw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED8DC2BBFC;
	Thu, 13 Jun 2024 12:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280750;
	bh=FuDCdxQzBvs6+acHn3P9Hjj5p5pY0CpHyHOSV0FRmJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wW8xSrw8uXw0XC1y1DRK85UHss+pgq06mG1oUyJbx1+U7tQiM3f/xxAGgivh+P11z
	 lBNbk4UNvb9TsInRZPQjPQkY8cANc6q2pBvbsyOdgeU0fb9ulUvcBt22omMe93UF6d
	 QGRMn8p7acfOL3eR7prPYOnAYPjvZ8kGc7irHycU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/317] crypto: bcm - Fix pointer arithmetic
Date: Thu, 13 Jun 2024 13:30:39 +0200
Message-ID: <20240613113248.362066562@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c860ffb0b4c38..670d439f204c5 100644
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




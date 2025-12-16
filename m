Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865F3341645;
	Tue, 16 Dec 2025 11:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884329; cv=none; b=osgxBZNSy9VFK2ptfJPuTb92/oDIEmfKWhCogQ9L7EUPFyQdyfVqOouZHthUXHqSBG2CRugPuDbAEgt60Gx4qiEAzUTBIAArpyyNbljqteU8uYiOz3jLwuyKPTDujtkkIICT9Td4LRJH9BCLAD+RO1Aj3X+hVjFPH/E/fC/NLPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884329; c=relaxed/simple;
	bh=8WWcHjrhqb12owofp7MEgb9c7rHIc4zCYYwDwlF0boA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YXJdzVl1zYpod3R3e/wzyin7HpEdh6/AbKLOPdCSJpbb6Sml/P40cv7A04T1mVhUlh9JamPZAzvO6KyBZWGFlv9uj7oCY+4+RAgEgdMwEDJEXckGe59OqiXY++hUBgjo5pFpe6MlTlqj8HdonpgUv3+1zyGHQzRB/5ZPme/SNj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xVgamN9S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xVgamN9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09DEC4CEF1;
	Tue, 16 Dec 2025 11:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884329;
	bh=8WWcHjrhqb12owofp7MEgb9c7rHIc4zCYYwDwlF0boA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xVgamN9SKRwbIe2dx+G9arF6sU8VcBZtoZSBbOUvHpV44Ty8fb2OXcZmmPdP6tztT
	 glswqGQ2GqRgLqyHJpaXi9/wMj2EXRNa+6UHZxlBWeMMIv/5OBpRQGCb3fhJkw8hD2
	 /HB5mKh1BjRTjcasSvIq0hMbCNirwT07x14W6VOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 160/354] crypto: iaa - Fix incorrect return value in save_iaa_wq()
Date: Tue, 16 Dec 2025 12:12:07 +0100
Message-ID: <20251216111326.710805957@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 76ce17f6f7f78ab79b9741388bdb4dafa985b4e9 ]

The save_iaa_wq() function unconditionally returns 0, even when an error
is encountered. This prevents the error code from being propagated to the
caller.

Fix this by returning the 'ret' variable, which holds the actual status
of the operations within the function.

Fixes: ea7a5cbb43696 ("crypto: iaa - Add Intel IAA Compression Accelerator crypto driver core")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index df2728cccf8b3..e9391cf2c397c 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -807,7 +807,7 @@ static int save_iaa_wq(struct idxd_wq *wq)
 	if (!cpus_per_iaa)
 		cpus_per_iaa = 1;
 out:
-	return 0;
+	return ret;
 }
 
 static void remove_iaa_wq(struct idxd_wq *wq)
-- 
2.51.0




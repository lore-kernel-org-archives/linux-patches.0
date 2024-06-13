Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B952145336;
	Thu, 13 Jun 2024 11:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279729; cv=none; b=YZw9PMgC0Nyo+07JMluETJ0xxOoSpfk/8L+26yZt93+mgk/5Kw4CmmOA43N7OAggnuNHMDqWej1C1xDudfMWXdVHvkVLhAn+2YCq6jMeaj0hu74v7U9KgVQb0PEzY9mThsNhWFS01GUWIoOdoNRLhYZ3pWnqGTYtg9pDUXFnVFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279729; c=relaxed/simple;
	bh=7FboQwXyIm3LRfrCnUqo/7BIkP0IURudBLR7gfBsmrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B8n5q70cbGKmszZm6AryHaYrTTS8EWt/1SeLbqDLiTm4p6LMfEGRS/eS16htTYIkzUnTqa+b7A9wd1Uy0oyNnOYEGC9oSQGY6DHNBpPM/QDLZaJhXXphwKzfCz1xkvbzxdP4kGFj0UIgUNPItIl8hL2iwSSc8DOCWqD+ZpGT79k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UAFwrWPk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UAFwrWPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB438C2BBFC;
	Thu, 13 Jun 2024 11:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279729;
	bh=7FboQwXyIm3LRfrCnUqo/7BIkP0IURudBLR7gfBsmrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UAFwrWPkxymX5RwgkliFDWLrnjNwe6YUm/WCohAxwnXiSUvDJDuvrbO/jh2kqLTc6
	 Q3UOO0eiSli51isZi5BPaPnA4F6qk6Vc6lmSsSfjWHqVkmCulinAIokizzoJONvUfH
	 4pcqUjytqaiiV07NoHqe3sEy08abdibIzLYistys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 017/202] crypto: bcm - Fix pointer arithmetic
Date: Thu, 13 Jun 2024 13:31:55 +0200
Message-ID: <20240613113228.430224376@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 2add51024575c..a8d4cbc8d3f9f 100644
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




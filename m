Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5938A2F531B;
	Sat, 12 Sep 2026 12:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215638; cv=none; b=iObkTpvD7cf8OHIv3OsU7a71vz9IqDg/LYt+MKA++G/uhZKgtzuI0ktOC3jmP7xpAZE66Z257Lagpo4ZIIr8FVNX3sgRkrmrT8RU8vf1fbTc3/C2Hm9cuYzkOargRZ4YlH0eYpBtObPALDTZpOvHp9MqAXip5x9Wf+i9cMzGTFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215638; c=relaxed/simple;
	bh=4TB/RQnpoDUHBV/lT6eczO9Z39LadF+sTORyp55kgk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osvrHDl2ewfFSJXwpnIWIRw/z5eGenHuncOVRFoxL1UhYSXKiXbJ9j5Fl7hvgPkz0Pa4namK9rnTln+16wk/TqIqA7UfIliFpPg0iO9UBXZDkJmEuMZvZF1PYdMi1BVc8vPrjtZSfHOnLzKO1ozM8GMwZAdVR5lUfWUmkWSAGwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rfMioT+Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rfMioT+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4741F000FF;
	Sat, 12 Sep 2026 12:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215634;
	bh=Yy/tHbgSJ5a+djJ/0rv8dVPxfMwFH2Vcl0zUZaHI0sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rfMioT+Qhvfl0xf7jErW8INv4byUoH1TekHt2Gb1iDngycBDe7wkUkVHyrbVq+3WV
	 frFNM6ch4G8IQQT9/O6K340HYkJ9fNHJD28BxyasYpY3Kk4BKO3kEcvjCOBAHHbNZh
	 sMqymKv11QF+8+Ru4f7eJ2Vao4ksvvI92agUTmRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Linus Walleij <linusw@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0573/1376] crypto: sl3516 - drop invalid sg_dma_len checks before DMA mapping
Date: Sat, 12 Sep 2026 08:49:59 +0200
Message-ID: <20260912065620.300756656@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 3ae59a2eba64b3648f069aa52eeaaeefdfe4bb2f ]

sg_dma_len() is only valid after mapping the scatterlist with
dma_map_sg(). However, sl3516_ce_need_fallback() checks it before the
source and destination scatterlists are mapped. Thus, a stale DMA length
that is not a multiple of 16 could incorrectly force a software fallback
when CONFIG_NEED_SG_DMA_LENGTH=y.

Remove the invalid checks; the existing scatterlist length checks are
sufficient.

Fixes: 46c5338db7bd ("crypto: sl3516 - Add sl3516 crypto engine")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Acked-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/gemini/sl3516-ce-cipher.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/crypto/gemini/sl3516-ce-cipher.c b/drivers/crypto/gemini/sl3516-ce-cipher.c
index 583010b2d0071..02ec4282333b6 100644
--- a/drivers/crypto/gemini/sl3516-ce-cipher.c
+++ b/drivers/crypto/gemini/sl3516-ce-cipher.c
@@ -56,10 +56,6 @@ static bool sl3516_ce_need_fallback(struct skcipher_request *areq)
 			ce->fallback_mod16++;
 			return true;
 		}
-		if ((sg_dma_len(sg) % 16) != 0) {
-			ce->fallback_mod16++;
-			return true;
-		}
 		if (!IS_ALIGNED(sg->offset, 16)) {
 			ce->fallback_align16++;
 			return true;
@@ -72,10 +68,6 @@ static bool sl3516_ce_need_fallback(struct skcipher_request *areq)
 			ce->fallback_mod16++;
 			return true;
 		}
-		if ((sg_dma_len(sg) % 16) != 0) {
-			ce->fallback_mod16++;
-			return true;
-		}
 		if (!IS_ALIGNED(sg->offset, 16)) {
 			ce->fallback_align16++;
 			return true;
-- 
2.53.0




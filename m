Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB883F23C5;
	Wed, 20 May 2026 18:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301108; cv=none; b=X/pPrvcuoBClgnkLaxDCw5DaQIBo5G1iFnDZvLbVIOPVbKxfj3p+7Roy+x+IXVvZTgJjEPugSctSBhb1ESjJFGYK9n0w+zEM8aCwytJ5B45Ou/qKbmJLneBFa/3xwpzGBaK7L80vwcmws6CDRa8drFLbf5o9dKXrp9uvKIXPQe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301108; c=relaxed/simple;
	bh=irF7/Wual0BRRs9qdm+V+wU487vGovF03cVY89Jj1J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=arcFvy6Xzil8KKT7OvvhiiPlSLsEc4t4styGDY9YHojiTT0UEBkzJUPqGNH6KLm7bEIMXhEz7DYxFgUYUfNu42q+4EBsy4I8e3b3yoTnbDoMjuqJQdcSNOejj0owadaB3t7KFEY1EV5pBPWWMapVOsCaKLm3F54gqXL0YbEtrjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wta1FfFk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wta1FfFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9FA1F000E9;
	Wed, 20 May 2026 18:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301106;
	bh=sCx1jS3t99y3GNx+uu0G7pDuiQ3aezCayBlZ+BBL3eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wta1FfFkODHJ+0pt2KDa+8xRbbe1hzx1XXdGtPsS8UzH0rFvh4NCy7wbLY10+i1ta
	 Ba0jf66V1enCJgtddLvEYi0EA3J8dkAWsmD9gybAJ1Y2oMHG0Bw/5bbLLCrcr9UvjX
	 6/v0BfJOTv1jGaBirac741QKe2Tg6dG4ejMS8Yy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	T Pratham <t-pratham@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 427/666] crypto: sa2ul - Fix AEAD fallback algorithm names
Date: Wed, 20 May 2026 18:20:38 +0200
Message-ID: <20260520162120.527071032@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: T Pratham <t-pratham@ti.com>

[ Upstream commit 8451ab6ad686ffdcdf9ddadaa446a79ab48e5590 ]

For authenc AEAD algorithms, sa2ul is trying to register very specific
-ce version as a fallback. This causes registration failure on SoCs
which do not have ARMv8-CE enabled/available. Change the fallback
algorithm from the specific driver name to generic algorithm name so
that the kernel can allocate any available fallback.

Fixes: d2c8ac187fc92 ("crypto: sa2ul - Add AEAD algorithm support")
Signed-off-by: T Pratham <t-pratham@ti.com>
Reviewed-by: Manorit Chawdhry <m-chawdhry@ti.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sa2ul.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 461eca40e8789..d1c2d129ad418 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1775,13 +1775,13 @@ static int sa_cra_init_aead(struct crypto_aead *tfm, const char *hash,
 static int sa_cra_init_aead_sha1(struct crypto_aead *tfm)
 {
 	return sa_cra_init_aead(tfm, "sha1",
-				"authenc(hmac(sha1-ce),cbc(aes-ce))");
+				"authenc(hmac(sha1),cbc(aes))");
 }
 
 static int sa_cra_init_aead_sha256(struct crypto_aead *tfm)
 {
 	return sa_cra_init_aead(tfm, "sha256",
-				"authenc(hmac(sha256-ce),cbc(aes-ce))");
+				"authenc(hmac(sha256),cbc(aes))");
 }
 
 static void sa_exit_tfm_aead(struct crypto_aead *tfm)
-- 
2.53.0




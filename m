Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F9F1A2564;
	Thu,  6 Jun 2024 14:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683193; cv=none; b=m7Ks/2fc1GKzB88RUN8qiiBQjrvGdV/6+ze76w9cx9aRRMffrZmVL+CHxPIJGgJlTN5xNLvEZrIeRtw3C0Ld6IIkGG/tSz570K0rvdm/eWZZAINmZEDYZ/B2YQzOy7Rl0wR6baDx/BIkB9eie7go9bUwNJsu0O3x3vw1s9QfBpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683193; c=relaxed/simple;
	bh=OcxxCcrQkwjO/qLR7AzifQEBl4mWn1rD9y8Z9jbZ16I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BX4dxARqvb/+YcXyDTTBdli5LJYGJuEhGsraEFzGLZXtpkYP03C/sQxDE9LtbSaduPbVWtjkY0X7ki5hFkb0kBRGb9U6UC4AMVPb3RtP3qnq3172pCtvnUFdvuWS1877KhUR9XIW4Hyd2DzwGj6c+4G8bANOgis5c/qSAzG0tJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KY9HZ3P7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KY9HZ3P7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46594C32781;
	Thu,  6 Jun 2024 14:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683193;
	bh=OcxxCcrQkwjO/qLR7AzifQEBl4mWn1rD9y8Z9jbZ16I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KY9HZ3P75KgAHFqG+S4DFt5erZo5u1GSxwoEruHRGY6T47cj4Fuipq15saZL4ms7o
	 dFk8KDnh8vtR1CEBTqzm1nm0reGUWzrZ4ksHLPxBUTm3WuFWzK7hrDU9H6u4M4Lv6D
	 igsctdm9J0zmtgqC0bWynbyeqqYrH+uZyi5CXnjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/473] crypto: bcm - Fix pointer arithmetic
Date: Thu,  6 Jun 2024 15:59:56 +0200
Message-ID: <20240606131702.094665322@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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




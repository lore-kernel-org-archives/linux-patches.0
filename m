Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A044F24678E;
	Mon, 23 Jun 2025 13:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684980; cv=none; b=ZZG1joNwbwEbL0ZpXRVrzHvYro2DDsU4pKXCG38wKtRU84WJU45z+DBEy5e/tiyN18dh3MXYXyM+yANikoYPn+CDHqobFpV+030vx12zPvBAfZG+JE21vzpnrPQqrVBx4vT6p6/sG2DBqw8BaRTacmH/Mu+toVZaJS+2t43Ipkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684980; c=relaxed/simple;
	bh=elK6aZLEObEhS+Sdj6ZKSgLVMQVPpjNBLLhpbnS4zbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/m8bN9PdNw+YMKpJtHsMwNGpri+m7TPi46/tEf1iccXiPtuL5Mu2fd5GA6ZZKT5PI5Tu6QU9THCPreQ/XvvMnooxLHR7dG2rLuTtbbrta+FGE2GP7VdTt7fLJSyK87l+HnxBnqnZYWnbDVxgiAITNOlYJ+VuasTDWH4+FIlXdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sz7n0c3g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sz7n0c3g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3339AC4CEF1;
	Mon, 23 Jun 2025 13:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684980;
	bh=elK6aZLEObEhS+Sdj6ZKSgLVMQVPpjNBLLhpbnS4zbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sz7n0c3gJmY17xaLL/Eu+pEjahTCgmwGagA3RlNeWP3Wl4DC264I38WaHTerli/Oq
	 bqfANuFtBV82mLRLeKDBBflrp4OQF5F62Za132Cryw2r5Hxsdb+liEa979WRDsAOA1
	 cAdqmsMNOzjN2vL095J6noyw+ImbmCFyPw78kcKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/355] crypto: sun8i-ce - move fallback ahash_request to the end of the struct
Date: Mon, 23 Jun 2025 15:03:39 +0200
Message-ID: <20250623130627.337998636@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>

[ Upstream commit c822831b426307a6ca426621504d3c7f99765a39 ]

'struct ahash_request' has a flexible array at the end, so it must be the
last member in a struct, to avoid overwriting other struct members.

Therefore, move 'fallback_req' to the end of the 'sun8i_ce_hash_reqctx'
struct.

Fixes: 56f6d5aee88d ("crypto: sun8i-ce - support hash algorithms")
Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 558027516aed1..0cacbd51b480d 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -295,8 +295,8 @@ struct sun8i_ce_hash_tfm_ctx {
  * @flow:	the flow to use for this request
  */
 struct sun8i_ce_hash_reqctx {
-	struct ahash_request fallback_req;
 	int flow;
+	struct ahash_request fallback_req; // keep at the end
 };
 
 /*
-- 
2.39.5




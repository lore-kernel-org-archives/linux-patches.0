Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524ED253359;
	Mon, 23 Jun 2025 13:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684710; cv=none; b=Rh/fT7rlbkPOArnr0GXA3o5Ax3PNi0e2mZnsxcIap5ptTxLpKvzzS6ploakjLk8VE6nUUt+ByBWmnSt5+hWjoS09MN4Ncw65Y8BsEVUPIo5BrQSurGggTvXhgIJb+8XrTX4lIGRSCRK4ZG8kurxr+IvQ/r0SnHnD1fgyaRuNheI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684710; c=relaxed/simple;
	bh=hN9j08jTKyI0k0FLerbeH7Vt/AcvgbW+WgHPUHw3t1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ggR9VlO88hwBE1s0gWWGyt1Ux5CzNSkP00v+cPn9fInwGhJ5r2ojq0WKNM9rDJZdznflEhCbbQOh0ZiGRowf+Pj7uAoa2+44WthpN6DRAdHO+xpP6UiUoHfY9NE4iZeUWoAkV8zAm9Iu+dJQ3r2r3iqQ0iTxrn+sUS0yUKJ9ins=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTLwtLSr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTLwtLSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA87DC4CEEA;
	Mon, 23 Jun 2025 13:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684710;
	bh=hN9j08jTKyI0k0FLerbeH7Vt/AcvgbW+WgHPUHw3t1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTLwtLSr//iGys13mNYJaaW4MdPqT6EmuZU1CrVm9hkO/yc3bXfrN08pA54rWZ5ll
	 U2r+ndOVk1L99e20vML2C8Owe52oIdJ0tS85hlClE9+X4ZybUugyIPHWe/T119KAvq
	 tL47/eshoAz1hT0y+6qPjfikPcCPq+Z8vAUBByyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 013/222] crypto: marvell/cesa - Avoid empty transfer descriptor
Date: Mon, 23 Jun 2025 15:05:48 +0200
Message-ID: <20250623130612.296538732@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 1bafd82d9a40cf09c6c40f1c09cc35b7050b1a9f ]

The user may set req->src even if req->nbytes == 0.  If there
is no data to hash from req->src, do not generate an empty TDMA
descriptor.

Fixes: db509a45339f ("crypto: marvell/cesa - add TDMA support")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index a2b35fb0fb890..de1599bca3b75 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -630,7 +630,7 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 	if (ret)
 		goto err_free_tdma;
 
-	if (iter.src.sg) {
+	if (iter.base.len > iter.src.op_offset) {
 		/*
 		 * Add all the new data, inserting an operation block and
 		 * launch command between each full SRAM block-worth of
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770F9235071;
	Tue, 17 Jun 2025 16:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178262; cv=none; b=aQNTZzynwfAETR/bia6OTqER8ZHyQ0QmR3ubKa22oRmzyeEQc83zb2DZcGTdOONQWIlAX7U9Cj/Ao/EYZ65hZjLirKD9WgtngaYQBQmgra0vpklpSnXVxqPEu74Nqt+A55JHZG5v+w/KOb97cLvVt81FXj44eu40x5QHCdnW5vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178262; c=relaxed/simple;
	bh=f7KRrr692difgai4LJzx8nFLMNyG9ANfAfTtodQadyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skvoPmaou4hCsWj26OhyUbYdL61RJZav8Cfmp5ajSVnoksjA4tNum3ZzvxSPOYc9IlvHJBUp+CcOgBzsd/0BpCgFc3jSnECE0R+D508EuawjODrYNhl1ai299k9ZhnxYmXzEVVB6R0dBEba21nP+91xmfq5cOYhdZ9GIEoLffzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FIdEPPL/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FIdEPPL/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9506C4CEE3;
	Tue, 17 Jun 2025 16:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178262;
	bh=f7KRrr692difgai4LJzx8nFLMNyG9ANfAfTtodQadyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FIdEPPL/pmn3Dq8kAWe5y4TjxKyfIwrMmXwbJ716v3q/wYqZtS0jDISy200MBTCsW
	 r2MMgIKI2TDfDTV6WqxlU1iX+e7o0LJ3jMC1gEm/Hbppdq1H4M93V2ilncR3uMm6Ry
	 hFxv1SJRYEgoWRJjODQJfgnZpd5OZo5fw3mC26Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Arkhipov <m.arhipov@rosa.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 435/780] mtd: nand: ecc-mxic: Fix use of uninitialized variable ret
Date: Tue, 17 Jun 2025 17:22:23 +0200
Message-ID: <20250617152509.181017514@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Arkhipov <m.arhipov@rosa.ru>

[ Upstream commit d95846350aac72303036a70c4cdc69ae314aa26d ]

If ctx->steps is zero, the loop processing ECC steps is skipped,
and the variable ret remains uninitialized. It is later checked
and returned, which leads to undefined behavior and may cause
unpredictable results in user space or kernel crashes.

This scenario can be triggered in edge cases such as misconfigured
geometry, ECC engine misuse, or if ctx->steps is not validated
after initialization.

Initialize ret to zero before the loop to ensure correct and safe
behavior regardless of the ctx->steps value.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 48e6633a9fa2 ("mtd: nand: mxic-ecc: Add Macronix external ECC engine support")
Signed-off-by: Mikhail Arkhipov <m.arhipov@rosa.ru>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/ecc-mxic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/ecc-mxic.c b/drivers/mtd/nand/ecc-mxic.c
index 56b56f726b998..1bf9a5a64b87a 100644
--- a/drivers/mtd/nand/ecc-mxic.c
+++ b/drivers/mtd/nand/ecc-mxic.c
@@ -614,7 +614,7 @@ static int mxic_ecc_finish_io_req_external(struct nand_device *nand,
 {
 	struct mxic_ecc_engine *mxic = nand_to_mxic(nand);
 	struct mxic_ecc_ctx *ctx = nand_to_ecc_ctx(nand);
-	int nents, step, ret;
+	int nents, step, ret = 0;
 
 	if (req->mode == MTD_OPS_RAW)
 		return 0;
-- 
2.39.5




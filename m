Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034BE31985C;
	Tue, 26 Aug 2025 14:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217383; cv=none; b=orbqbstVPo6pdK8fV5Qw56yU8IgtOoV3UOcERwt66qcgXdt1obm2mS/0GHHmI6mAseqOzbQZrWWaW/hCiJFpTNC3LXXGw+RG/1d1Aqu4F1Cq7dVnPW6cVvopZdhKoLEbGYrfozN/d9x7t6DKqjy18P7o7HLNOv6wtazQA6e5FRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217383; c=relaxed/simple;
	bh=57lwfYnpUvCUBnXKILc7bu8frADmXcnyBDD3PZoT9Xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l8j8K/pMM1c+4i0VoBKvb1ad4HEK2+QbFly+w2ET3ua/6olV3sTJOjOMuUv7VPfgqfRRJNb3fBFzXOS3W/G5eqTW2Nd9Q/tlOLs+1C8bhuMaFT9SsbkUvYmeRkagE+u/Y1xPMQRvDJOfFnsP99hLDoZYnqU90nLdH1aqau5ByHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zkZCkS43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zkZCkS43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED5EC4CEF1;
	Tue, 26 Aug 2025 14:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217382;
	bh=57lwfYnpUvCUBnXKILc7bu8frADmXcnyBDD3PZoT9Xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zkZCkS4317QZvM4K/PDt5qOeiNDbiLECRWgX9xdzrl4sZXteIGMO9FjtTSrQ9Pfqm
	 zp//T2IGbNQlA3H6FSCJnpJCFR31xSnLEc8Dxrp0qubi79ZPhTYQamYLakuPrldWqs
	 CD7ZzYzZotvEJYnifqAmRQz98rC44wHcGaWn6MzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Stepchenko <sid@itb.spb.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/523] mtd: fix possible integer overflow in erase_xfer()
Date: Tue, 26 Aug 2025 13:05:32 +0200
Message-ID: <20250826110927.525548643@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

From: Ivan Stepchenko <sid@itb.spb.ru>

[ Upstream commit 9358bdb9f9f54d94ceafc650deffefd737d19fdd ]

The expression '1 << EraseUnitSize' is evaluated in int, which causes
a negative result when shifting by 31 - the upper bound of the valid
range [10, 31], enforced by scan_header(). This leads to incorrect
extension when storing the result in 'erase->len' (uint64_t), producing
a large unexpected value.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Ivan Stepchenko <sid@itb.spb.ru>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ftl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/ftl.c b/drivers/mtd/ftl.c
index 2578f27914ef..ffe89209cf4b 100644
--- a/drivers/mtd/ftl.c
+++ b/drivers/mtd/ftl.c
@@ -344,7 +344,7 @@ static int erase_xfer(partition_t *part,
             return -ENOMEM;
 
     erase->addr = xfer->Offset;
-    erase->len = 1 << part->header.EraseUnitSize;
+    erase->len = 1ULL << part->header.EraseUnitSize;
 
     ret = mtd_erase(part->mbd.mtd, erase);
     if (!ret) {
-- 
2.39.5




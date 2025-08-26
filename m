Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882E2319867;
	Tue, 26 Aug 2025 13:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215873; cv=none; b=gJQnYyWeQg9PMhE/kZKHdurCU15sDqRg0JkmpbiEcL4wpewyqfGZiW2gZrycfAeNAJOs+GRGwDsG0sGy9yi32Wc4ktlNNBONuqanK0WP2UL1U8M3OirVXkb1JwcdzfW39muzE/YB3SATDDs3ghUeEB4h/L65NLGOQBcUW6Fseyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215873; c=relaxed/simple;
	bh=TqMSUsIfUZZsLrtk9sgxVnh9hGnHPwB2QCbpYLWAbwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ge0NBNfUIZhWQZ6VDyNu4B0jlh53RF0ImX8faKH9UnBDINY0KFHrZXg6GLD255czxHymJSZBYwjYP/ArZLNYdUHOm6CKtbix8w/lSve8Yz0a2LlAQDm5l8IDibVU14HjgyUka1bRBnF52hZN0Jivese5Uu5uo7icv66STIQoXjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCsqknj7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCsqknj7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1879CC4CEF1;
	Tue, 26 Aug 2025 13:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215873;
	bh=TqMSUsIfUZZsLrtk9sgxVnh9hGnHPwB2QCbpYLWAbwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eCsqknj7/UpoBuPDJxPFJb0UY9rBo5l7JlUq7ZnsE3PsqXNHAKXkVZmeytZVktjDm
	 xRAr7cJSqK8OIAsC+R7PtzjKMnsv8qvRL3kdQKJd5tcPCjf7N4SU3GwyAVXG4myuDO
	 OP1m6XVVGO6RWomkCifCbjs5qix0kzMlIxk7aZh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Stepchenko <sid@itb.spb.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 167/644] mtd: fix possible integer overflow in erase_xfer()
Date: Tue, 26 Aug 2025 13:04:18 +0200
Message-ID: <20250826110950.619081012@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f655d2905270..243d7faa128a 100644
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




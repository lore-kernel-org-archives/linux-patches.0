Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8395260583;
	Tue, 12 Aug 2025 19:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026083; cv=none; b=BeLrZfKUNZ24qHq1lJuYESeZcCtvbfUoTqyaydgkeQAmMkeu8M23FzcnSULam2s72QWc2TjgHS+ukiQpM3A8rUPvV2s0Y0gXvcfoq78/VN9S7o2JKY6Xx8UAH94GTQSIwENw20x/1R2llOzJGxBEwpORK26R5nYMXAKnzDSeAUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026083; c=relaxed/simple;
	bh=wxnNKQc7o8+kK+m00gxGDgmbjyQvnOcmMJbGltkRc6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1114RbCJQovaalss1QcR3jM+nIIEWLEuQN7fgWkRjG2vQMVF95CtqFyh3PrAvhYqtaEJyHQqL2PgnskV67A5mfpLpbD/s5298i9Ctxx7z+6elC1bI0IApmx+t5Vv7cn40F99jkbPEShtrRqs8Z4xtMN+Nmj+Q9xQscjjl0IOUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rNq4jXkT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rNq4jXkT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB567C4CEF0;
	Tue, 12 Aug 2025 19:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026083;
	bh=wxnNKQc7o8+kK+m00gxGDgmbjyQvnOcmMJbGltkRc6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rNq4jXkTwos2z5LK+w8Ixg38xfFGLE4NcdPpny6MPrF+rYxjYDLojUtwUpHbBM0zx
	 SRLHXcQyT0y/Q3feTufGXsum38j6ev3/VpwuoSLDMpm2qS6JRXWpQ/gzmsUmkYuxJl
	 y9M2NpTHTb93WfMwj38xuA/xu1NgoD4IqQtHbp/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Stepchenko <sid@itb.spb.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 232/480] mtd: fix possible integer overflow in erase_xfer()
Date: Tue, 12 Aug 2025 19:47:20 +0200
Message-ID: <20250812174407.013985814@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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
index 8c22064ead38..f2bd1984609c 100644
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




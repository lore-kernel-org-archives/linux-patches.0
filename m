Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F79632ED5C;
	Thu, 28 May 2026 20:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000977; cv=none; b=mNEaptD3+luoqlR6DKU3J+L1uuWWRpPC1k16tHeOr1oz3MMI0ZW8hGNqSSO0bmXm5AA6kPo3QenOzKnQmdUhcL0f6B5LdsZgONE13ZKv/SPZm8/jYRm8FL/XuFIW17rrym698h5TB7yIrEG84PiiaXCXQvy7zvkmNMwiSjB6gOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000977; c=relaxed/simple;
	bh=r16XMtFqNdA2apvVbtgi8FeS+WsawJfP27i9iI5Jn9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQvL/X17Bm9H+4+rtCP9E93wXNAWknE7qKxnC+5ellM06S1mz0NuTW6rhjrtC6XSM7eUwTxp1nbM0WfriFNfDb6TgF0r5JwSxVLbYZFaOMCI5kkQPIxc5Upzt7UXLv7HcSYixzza3bSYhT8I8V/3KFkbJSOy4wyZ12IZbxHI1yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2DPzdJUM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2DPzdJUM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4691F000E9;
	Thu, 28 May 2026 20:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000976;
	bh=D/LtNd2B6QjR+pOB83rb4NjEb/5b4GE6ikpHROdcY9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2DPzdJUMUJ9eM/6a9RGziTE81g5pZgzgZXmPqRd9d+DnUa3/nyKKp1jPOQ23luJmb
	 AtNuaSrcKUa6d13OHe9FkzP6bxT9gYA7iyEbo2XEpOK9dtEY1BopNxhlLn+skXcq7+
	 /EFHChAR8J7x437rhoFb1VDFcjJlHZdFdmV83Zd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 235/272] spi: mtk-snfi: Fix resource leak in mtk_snand_read_page_cache()
Date: Thu, 28 May 2026 21:50:09 +0200
Message-ID: <20260528194635.741797889@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 496ba79b9496b8b3747cbc764ebd33ee7325e806 ]

When DMA read times out in mtk_snand_read_page_cache(), the original code
erroneously jumped to cleanup label which skips DMA unmapping and ECC
disable, causing a resource leak.

Fixes: 764f1b748164 ("spi: add driver for MTK SPI NAND Flash Interface")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260510-snfi-v1-1-bc375cf1af8e@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mtk-snfi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-mtk-snfi.c b/drivers/spi/spi-mtk-snfi.c
index 8234064921f36..20260f577f056 100644
--- a/drivers/spi/spi-mtk-snfi.c
+++ b/drivers/spi/spi-mtk-snfi.c
@@ -961,7 +961,7 @@ static int mtk_snand_read_page_cache(struct mtk_snand *snf,
 		    &snf->op_done, usecs_to_jiffies(SNFI_POLL_INTERVAL))) {
 		dev_err(snf->dev, "DMA timed out for reading from cache.\n");
 		ret = -ETIMEDOUT;
-		goto cleanup;
+		goto cleanup2;
 	}
 
 	// Wait for BUS_SEC_CNTR returning expected value
-- 
2.53.0




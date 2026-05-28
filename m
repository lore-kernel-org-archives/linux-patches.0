Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0203E1C3318;
	Thu, 28 May 2026 20:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000113; cv=none; b=LPA2ScS9r+BHs+ggw5Ae8P/crGcJ8LBx/ZXiJrOrP3LdbP/P0Ui1tE7C/N43DaRhuq4GO2plySmBkSjL8M8yS0/ZFC9eZiwWVqLH6nxNMhsz5E0qOdmKlx4tn7atRDFrKTPLOBZH3Usw2etTqQasZAJKynaUEgR1ElfBT5fC+Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000113; c=relaxed/simple;
	bh=uwAyvRNs97aNQU9s4rEf6iexqRKrzqYsuy/2lk/H5z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JiiaOsRfcRbXUS8dAwv8O5s3xS67iM80xFOGF6+a1gMc2C5bgi/bUq+M/EdWlwTwZbpknXkWchVQ3yxNuUVQyCSK+/A6KW1YERddapDYXrgrxcEv081+CmN6q/mPFc5/OYTClekl9FfVRAAzTPGyP2vTQWOimYLuxJEt14p7LEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qReXWDV3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qReXWDV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D5B1F000E9;
	Thu, 28 May 2026 20:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000112;
	bh=q4kDVw7zwk1/l5ZvxszR3x3pARjRkBkzZEactHDhZU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qReXWDV3pAoyFwjKz0JxD+L87jAXw4/P4OLbfr8McUlLUCk/vf7zszhHbmksZbZti
	 vFjqvSpDGgKyV2+LQckkzwtcMWY20iMrosr+PfNUvOiA5WP1FXlYZn9vo7eXr9S7D9
	 sEOoDuPvNSLZdGc7/HcRy9Ui9CWQZafLe3o0aanY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 306/377] spi: mtk-snfi: Fix resource leak in mtk_snand_read_page_cache()
Date: Thu, 28 May 2026 21:49:04 +0200
Message-ID: <20260528194647.226023777@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a026b0e61994b..9e6038a5a2ad0 100644
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




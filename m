Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29851C5799;
	Sat, 30 May 2026 17:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162507; cv=none; b=u2lhl/cK/qTZhguS09EbVOShNEoI+MwJYz7f4mfWE+xLpaoIbyHCv4Sp0KtBA+Qy9eoBY70nha7R+2GXBavs4gtXagDF+LuIGooykUTsiY28+MTTus/UV+BC7Qqxgkc1wrdZMY1NuDRf5RIvGEJm55wtGcJrYl2C6j215E42acU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162507; c=relaxed/simple;
	bh=tQUiBl1KFk4UrOQxpXH1M2ptqHJzeZOe4W0WARnYPWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwBC7MDNtR4n9o3yHG8UfXrEQcY0/aAa92hwyTknqZJudcWP5q4/52bbkshaK24sK/TrSIhhtVc/YKjW9H0QmXTS+NrTdq9MfIr0kJLxo5OBOHsaJavdYQT81FWy6vv60dtSNRjE8nzB+lJr4gkRjsI28R92tUw0ykH1s5+e6WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8kGAzPJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8kGAzPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C4D1F00893;
	Sat, 30 May 2026 17:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162506;
	bh=nl+RyUF0fjzCmhTdo03JjCIuWKeBUPKycKd3xJMYb0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a8kGAzPJmvJP56RenwOE1c0Qh71Rf/bcPn/64MbjORyH6h+msnWEro0N6JEkpNC4i
	 OuOHxFNKYYqLILt47f0/KI3jz5bE9+7fDjRBp5QFcbf9yLyPcu+XSYUD1Ff2hR98TC
	 n5GdzZ8rbpADB2VfF4vpen3n4fJ3U+cX5osG4+gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 940/969] spi: mtk-snfi: Fix resource leak in mtk_snand_read_page_cache()
Date: Sat, 30 May 2026 18:07:44 +0200
Message-ID: <20260530160326.711527588@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7afb2202b2d95..ef14ef31eac1d 100644
--- a/drivers/spi/spi-mtk-snfi.c
+++ b/drivers/spi/spi-mtk-snfi.c
@@ -930,7 +930,7 @@ static int mtk_snand_read_page_cache(struct mtk_snand *snf,
 		    &snf->op_done, usecs_to_jiffies(SNFI_POLL_INTERVAL))) {
 		dev_err(snf->dev, "DMA timed out for reading from cache.\n");
 		ret = -ETIMEDOUT;
-		goto cleanup;
+		goto cleanup2;
 	}
 
 	// Wait for BUS_SEC_CNTR returning expected value
-- 
2.53.0




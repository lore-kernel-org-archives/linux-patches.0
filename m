Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E1732ABC0;
	Thu, 28 May 2026 20:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998937; cv=none; b=ix5AAkNWgJrcDBayx8jJx6CHxtYZuI8uuUkYJ2q2eCG5wtK/IIMMOP1ZiwK8f5p9uGLe/ji4ToX/Wzthr6CsRtWZDTPKx0fj8mwDqwVuLjShdDuNAkJ9spBejJJt4G9JduASd4/iHif1/16HOkwl2ltw7V2BPGcwwrMj8PFovJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998937; c=relaxed/simple;
	bh=hzP1Txps5NbEtKZcTHHtSY/n7UHtisNWcxVheOoYSNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMHit12Emlr7kt8JJSY8hq8QSQYWP3yyUpbg0yxtM8wgOBmQsogZXPwhxjj+WF1Ww5G8xpdFQE6q4WS6NtW03V72WDqyxdCl/70/7xWacssXyCVUXi7CePQFy8XxbFNdY7buRM+GhjAdZqxghPqUIjfU2N0yTFunCVKu121rQU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PgqvwuGU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PgqvwuGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97F31F00A3A;
	Thu, 28 May 2026 20:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998936;
	bh=L9EmEoMRhzGOgHmwtkjWcI/nAE+/PwiJneP8KN1pXMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PgqvwuGUUoBy4sWw7rlqih3choY2seEArmxov/lx4mfroo7e0YZjJR+3Y4dK32Tqw
	 DiPCDv8fML8YVUXB7RnIIhjnsvYx408s3RPeOqlv4H2rvj6G5kyLo27cSdn8odA1aw
	 9DAwVYM3kFz9iNRWIhf3Ran5tb6oRRzLLNkW6+Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 349/461] spi: mtk-snfi: Fix resource leak in mtk_snand_read_page_cache()
Date: Thu, 28 May 2026 21:47:58 +0200
Message-ID: <20260528194657.491383388@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 73fa84475f0e4..7725748cab2a7 100644
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




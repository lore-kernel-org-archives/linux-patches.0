Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593B1213E97;
	Thu, 12 Dec 2024 15:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015872; cv=none; b=h7kcyj52gUyzLj8aZLGOyuUbktErPbwfvevC0RvQO/Vk59pMxioFPHujZRsAZlpQb2e0DeHpUwOt+78YBl/qBPZoyq2G58jpHpdQmieX27AgZlAJc1qPbSAR3V9DJVg8wcpD/N7lwjrFjKtVPUG0ypiZGKJEf63e+wOjgEAcIo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015872; c=relaxed/simple;
	bh=JwXlcLHPLNH0zqolCrKEa2KJrUGveMfy/4+NiqLKmZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8YoPW/Zbne8Fcx7jFFw8k+5udGEqd/Y0lAJEZo/s1nZpy2ShzM9S8LYj1BHfHnueSyHrLrGl9UwuJ7p12q/U9CSO8Aw3omEmEW1iNR6vnDT+04PGggRv0Ry2aKBReLcW5+FugV7jg81ob/+8AZbjYrHXg5CSHX1lfBIvH9jQSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UmkkYF+/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UmkkYF+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD7BC4CECE;
	Thu, 12 Dec 2024 15:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015872;
	bh=JwXlcLHPLNH0zqolCrKEa2KJrUGveMfy/4+NiqLKmZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UmkkYF+/DF9qSWtUmBfEUvSgda6xzZwsClf5XwawoSC/r5t4FLeckGHpp+cXmAC+m
	 277DRtOwgj78Ai99hjGgMAqljeXU3+UXSMS8B+wlNwiqGvhA2b5SN4hwgXwSqa916v
	 0UL53+w2pAyAJih4pSbIt+7BJVN29GXZVn2xKTjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Avri Altman <avri.altman@wdc.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/466] mmc: core: Use GFP_NOIO in ACMD22
Date: Thu, 12 Dec 2024 15:53:58 +0100
Message-ID: <20241212144309.541209700@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Avri Altman <avri.altman@wdc.com>

[ Upstream commit 869d37475788b0044bec1a33335e24abaf5e8884 ]

While reviewing the SDUC series, Adrian made a comment concerning the
memory allocation code in mmc_sd_num_wr_blocks() - see [1].
Prevent memory allocations from triggering I/O operations while ACMD22
is in progress.

[1] https://lore.kernel.org/linux-mmc/3016fd71-885b-4ef9-97ed-46b4b0cb0e35@intel.com/

Suggested-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: 051913dada04 ("mmc_block: do not DMA to stack")
Signed-off-by: Avri Altman <avri.altman@wdc.com>
Cc: stable@vger.kernel.org
Message-ID: <20241021153227.493970-1-avri.altman@wdc.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/block.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 64ae6116b1fa0..1d08009f2bd83 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -995,6 +995,8 @@ static int mmc_sd_num_wr_blocks(struct mmc_card *card, u32 *written_blocks)
 	u32 result;
 	__be32 *blocks;
 	u8 resp_sz = mmc_card_ult_capacity(card) ? 8 : 4;
+	unsigned int noio_flag;
+
 	struct mmc_request mrq = {};
 	struct mmc_command cmd = {};
 	struct mmc_data data = {};
@@ -1018,7 +1020,9 @@ static int mmc_sd_num_wr_blocks(struct mmc_card *card, u32 *written_blocks)
 	mrq.cmd = &cmd;
 	mrq.data = &data;
 
+	noio_flag = memalloc_noio_save();
 	blocks = kmalloc(resp_sz, GFP_KERNEL);
+	memalloc_noio_restore(noio_flag);
 	if (!blocks)
 		return -ENOMEM;
 
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4F422FAF8;
	Mon, 10 Mar 2025 17:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629198; cv=none; b=sR9lRGtYZOw1xXvVLAQtU+BQPqH2pjJ5FNw/lDarJEbM///8vST8eYaHh9gfk3UCby8QQU29Y0/60aF8c5OGFd+mVbyEx5WjUTMQ9jfNeKWiT/vMsU5SxjDs01BvOH+mxfuR4xxMcjDcDTrQi1Kor/ZFn3zTach8y2S8dZ0Uf20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629198; c=relaxed/simple;
	bh=MZP9IX0js0Bkc4EsCQaDHpXEJh0xTcb/ONPyWZr8VuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4LN/ayOe3iar8MwhTtPv0s8RIx9PviGCV0vmHt3Kuq5eisUT9POUvqoET5MAguRAql9gyL39LkrjCNsPVuJdUiC8EbBxm6/M4c+sejkoPhIzFqAyMw+4B67HRG5FIwyoXJojhs1ZzOwQdjbjcEV1y0Q4zWrksScPmQJzMxWC+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lV7EtrTs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lV7EtrTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08950C4CEE5;
	Mon, 10 Mar 2025 17:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629198;
	bh=MZP9IX0js0Bkc4EsCQaDHpXEJh0xTcb/ONPyWZr8VuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lV7EtrTsrSBoVqetDaeJlpp8LKrTvVo+OEBBwBy6BTkMSW4ENisniOjKwq3Kk4eil
	 1AQc23i7GqC9IucDCxFKp4sjEeN7up9+hn1wjDxKEQdzM5YeHElVoYfAdrJ+v4FCd3
	 b3yTOdB3dJG2Mamda1DKurQkEJV7vjLp+WWx1utE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 210/620] mmc: core: Respect quirk_max_rate for non-UHS SDIO card
Date: Mon, 10 Mar 2025 18:00:56 +0100
Message-ID: <20250310170553.915310975@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit a2a44f8da29352f76c99c6904ee652911b8dc7dd ]

The card-quirk was added to limit the clock-rate for a card with UHS-mode
support, although let's respect the quirk for non-UHS mode too, to make the
behaviour consistent.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Message-ID: <1732268242-72799-1-git-send-email-shawn.lin@rock-chips.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/sdio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index eda2dbd965392..a0cac8c87ef2f 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -443,6 +443,8 @@ static unsigned mmc_sdio_get_max_clock(struct mmc_card *card)
 	if (card->type == MMC_TYPE_SD_COMBO)
 		max_dtr = min(max_dtr, mmc_sd_get_max_clock(card));
 
+	max_dtr = min_not_zero(max_dtr, card->quirk_max_rate);
+
 	return max_dtr;
 }
 
-- 
2.39.5




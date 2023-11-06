Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B0F200A5
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ou7slfrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1C9C433C7;
	Mon,  6 Nov 2023 13:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276157;
	bh=nnr8fvpKBxgQ3UN65rmjivZEC1giELQlNkHGYW3keKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ou7slfrRJDz0ytRVcfDuBX0pcKjtsafk3k0SwxWuVfgyctNA7s8ERyywGtWyduqW/
	 FDcSg7kn+5Z003FFv97rDY9ntv+GSGAXyc3/j3HO8JSuRCyaijo2T5+VU89PZgLiBv
	 19aVhfFpvKA4emKDisQfmgsgqgOLehKV3EhUtM30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 01/61] mmc: sdio: Dont re-initialize powered-on removable SDIO cards at resume
Date: Mon,  6 Nov 2023 14:02:57 +0100
Message-ID: <20231106130259.620572008@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130259.573843228@linuxfoundation.org>
References: <20231106130259.573843228@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 6ebc581c3f9e6fd11a1c9da492a5e05bbe96885a ]

It looks like the original idea behind always doing a re-initialization of
a removable SDIO card during system resume in mmc_sdio_resume(), is to try
to play safe to detect whether the card has been removed.

However, this seems like a really a bad idea as it will most likely screw
things up, especially when the card is expected to remain powered on during
system suspend by the SDIO func driver.

Let's fix this, simply by trusting that the detect work checks if the card
is alive and inserted, which is being scheduled at the PM_POST_SUSPEND
notification anyway.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Stable-dep-of: 32a9cdb8869d ("mmc: core: sdio: hold retuning if sdio in 1-bit mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/sdio.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 5f1ee88aa7615..5f6865717c9b4 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -963,7 +963,11 @@ static int mmc_sdio_resume(struct mmc_host *host)
 	/* Basic card reinitialization. */
 	mmc_claim_host(host);
 
-	/* Restore power if needed */
+	/*
+	 * Restore power and reinitialize the card when needed. Note that a
+	 * removable card is checked from a detect work later on in the resume
+	 * process.
+	 */
 	if (!mmc_card_keep_power(host)) {
 		mmc_power_up(host, host->card->ocr);
 		/*
@@ -977,12 +981,8 @@ static int mmc_sdio_resume(struct mmc_host *host)
 			pm_runtime_set_active(&host->card->dev);
 			pm_runtime_enable(&host->card->dev);
 		}
-	}
-
-	/* No need to reinitialize powered-resumed nonremovable cards */
-	if (mmc_card_is_removable(host) || !mmc_card_keep_power(host)) {
-		err = mmc_sdio_reinit_card(host, mmc_card_keep_power(host));
-	} else if (mmc_card_keep_power(host) && mmc_card_wake_sdio_irq(host)) {
+		err = mmc_sdio_reinit_card(host, 0);
+	} else if (mmc_card_wake_sdio_irq(host)) {
 		/* We may have switched to 1-bit mode during suspend */
 		err = sdio_enable_4bit_bus(host->card);
 	}
-- 
2.42.0




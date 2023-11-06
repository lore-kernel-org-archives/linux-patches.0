Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CE420B00
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AfFPNHfl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2C0C433C7;
	Mon,  6 Nov 2023 13:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276188;
	bh=6szEX9qgj06joVwolLlQTKlXJOqq8OLWsTOsQPw17sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AfFPNHflIY+QJ3WSXP+AJ75noI5N0vUy9vvZBaNeIVdrYmkMa0BreRumcyoSvIokC
	 UaP++cW7uSmhr11Igzc84qUlyVtHk4Y6dqRcBZtjhMCWRHRKn0jYzpQx3V3lv877/8
	 1e/3HKFA2FLTuWq1boMKgcYsWvZNtVaz63+xjUFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 02/61] mmc: core: sdio: hold retuning if sdio in 1-bit mode
Date: Mon,  6 Nov 2023 14:02:58 +0100
Message-ID: <20231106130259.649377155@linuxfoundation.org>
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

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 32a9cdb8869dc111a0c96cf8e1762be9684af15b ]

tuning only support in 4-bit mode or 8 bit mode, so in 1-bit mode,
need to hold retuning.

Find this issue when use manual tuning method on imx93. When system
resume back, SDIO WIFI try to switch back to 4 bit mode, first will
trigger retuning, and all tuning command failed.

Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: dfa13ebbe334 ("mmc: host: Add facility to support re-tuning")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230830093922.3095850-1-haibo.chen@nxp.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/sdio.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 5f6865717c9b4..4fdb5dd9748fa 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -983,8 +983,14 @@ static int mmc_sdio_resume(struct mmc_host *host)
 		}
 		err = mmc_sdio_reinit_card(host, 0);
 	} else if (mmc_card_wake_sdio_irq(host)) {
-		/* We may have switched to 1-bit mode during suspend */
+		/*
+		 * We may have switched to 1-bit mode during suspend,
+		 * need to hold retuning, because tuning only supprt
+		 * 4-bit mode or 8 bit mode.
+		 */
+		mmc_retune_hold_now(host);
 		err = sdio_enable_4bit_bus(host->card);
+		mmc_retune_release(host);
 	}
 
 	if (err)
-- 
2.42.0




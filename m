Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7B612B7A
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8jh42oI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD612C433C7;
	Mon, 23 Oct 2023 11:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059483;
	bh=OzOXlNAqqA9vaN8jC54Na6VhqB4vW28UKKJ5uWBzzm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x8jh42oI+M0+QzzSyP0jrPIfI869xQsNlWQecWiMLpiqvP/nV265CGHt8MhmDVbk0
	 pMWNAIpEjv6MtYp1y/rXRWLMFfjEgv0zJ4RGHnd7oSorTxW9uccqLE6hLkz1KEVL8A
	 4Jo9BgADu+BftuA2fCLS/gJYRpdAvWBienFjDu1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.5 175/241] mmc: core: sdio: hold retuning if sdio in 1-bit mode
Date: Mon, 23 Oct 2023 12:56:01 +0200
Message-ID: <20231023104838.152437084@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibo Chen <haibo.chen@nxp.com>

commit 32a9cdb8869dc111a0c96cf8e1762be9684af15b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/sdio.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -1089,8 +1089,14 @@ static int mmc_sdio_resume(struct mmc_ho
 		}
 		err = mmc_sdio_reinit_card(host);
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599A2129EC7;
	Mon, 18 Dec 2023 14:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xVibD4F4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0264C433C7;
	Mon, 18 Dec 2023 14:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908591;
	bh=v+kfDNWMiEp4qJDDmhXVc/mCnGAt+4f2HqS6jGRKXJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xVibD4F4wx/bmUSek97WUtSzCOewCPB97mzTaCGh9NsY4m9M8Vwef7N4nktAmEsfx
	 bQRezgk6NzuHXaAkUheSEAIspXuJgAJmzrNo5YW+fwyZjjD/QacwIQV/Z4LROF90Yi
	 2xSrK/pGOlBFxdypAND3spD99r/MB2SeiS4U2mmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 48/62] soundwire: stream: fix NULL pointer dereference for multi_link
Date: Mon, 18 Dec 2023 14:52:12 +0100
Message-ID: <20231218135048.369726725@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135046.178317233@linuxfoundation.org>
References: <20231218135046.178317233@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit e199bf52ffda8f98f129728d57244a9cd9ad5623 upstream.

If bus is marked as multi_link, but number of masters in the stream is
not higher than bus->hw_sync_min_links (bus->multi_link && m_rt_count >=
bus->hw_sync_min_links), bank switching should not happen.  The first
part of do_bank_switch() code properly takes these conditions into
account, but second part (sdw_ml_sync_bank_switch()) relies purely on
bus->multi_link property.  This is not balanced and leads to NULL
pointer dereference:

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
  ...
  Call trace:
   wait_for_completion_timeout+0x124/0x1f0
   do_bank_switch+0x370/0x6f8
   sdw_prepare_stream+0x2d0/0x438
   qcom_snd_sdw_prepare+0xa0/0x118
   sm8450_snd_prepare+0x128/0x148
   snd_soc_link_prepare+0x5c/0xe8
   __soc_pcm_prepare+0x28/0x1ec
   dpcm_be_dai_prepare+0x1e0/0x2c0
   dpcm_fe_dai_prepare+0x108/0x28c
   snd_pcm_do_prepare+0x44/0x68
   snd_pcm_action_single+0x54/0xc0
   snd_pcm_action_nonatomic+0xe4/0xec
   snd_pcm_prepare+0xc4/0x114
   snd_pcm_common_ioctl+0x1154/0x1cc0
   snd_pcm_ioctl+0x54/0x74

Fixes: ce6e74d008ff ("soundwire: Add support for multi link bank switch")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20231124180136.390621-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soundwire/stream.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/soundwire/stream.c
+++ b/drivers/soundwire/stream.c
@@ -724,14 +724,15 @@ error_1:
  * sdw_ml_sync_bank_switch: Multilink register bank switch
  *
  * @bus: SDW bus instance
+ * @multi_link: whether this is a multi-link stream with hardware-based sync
  *
  * Caller function should free the buffers on error
  */
-static int sdw_ml_sync_bank_switch(struct sdw_bus *bus)
+static int sdw_ml_sync_bank_switch(struct sdw_bus *bus, bool multi_link)
 {
 	unsigned long time_left;
 
-	if (!bus->multi_link)
+	if (!multi_link)
 		return 0;
 
 	/* Wait for completion of transfer */
@@ -827,7 +828,7 @@ static int do_bank_switch(struct sdw_str
 			bus->bank_switch_timeout = DEFAULT_BANK_SWITCH_TIMEOUT;
 
 		/* Check if bank switch was successful */
-		ret = sdw_ml_sync_bank_switch(bus);
+		ret = sdw_ml_sync_bank_switch(bus, multi_link);
 		if (ret < 0) {
 			dev_err(bus->dev,
 				"multi link bank switch failed: %d\n", ret);



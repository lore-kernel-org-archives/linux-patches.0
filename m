Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D734F15ACF
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:02:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58068C433C8;
	Tue, 25 Jul 2023 11:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282943;
	bh=tyVYMwMumKtaqlIMvtr5hfSYyjDLh+shq2qE6IxNkEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jrM6etMA6p9Uix8sCUZqtyRaiFm/2wch8MC9WDrSnaex09OmTF4oJwhsFsFaicMlt
	 zYU0WmYTxHC8f+HLbDINOxyox8uwmJfCjW1i0BCPIIdWj+ad+hYnoBtjUeH0zHUKKq
	 7ellZ9am7jeo/0qaH7Af+Qe0c3EvYyvHv7oq2cBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/183] ASoC: amd: acp: fix for invalid dai id handling in acp_get_byte_count()
Date: Tue, 25 Jul 2023 12:45:10 +0200
Message-ID: <20230725104510.917945316@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 85aeab362201cf52c34cd429e4f6c75a0b42f9a3 ]

For invalid dai id, instead of returning -EINVAL
return bytes count as zero in acp_get_byte_count() function.

Fixes: 623621a9f9e1 ("ASoC: amd: Add common framework to support I2S on ACP SOC")

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://lore.kernel.org/r/20230626105356.2580125-6-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/amd.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/soc/amd/acp/amd.h b/sound/soc/amd/acp/amd.h
index 5f2119f422715..12a176a50fd6e 100644
--- a/sound/soc/amd/acp/amd.h
+++ b/sound/soc/amd/acp/amd.h
@@ -173,7 +173,7 @@ int snd_amd_acp_find_config(struct pci_dev *pci);
 
 static inline u64 acp_get_byte_count(struct acp_dev_data *adata, int dai_id, int direction)
 {
-	u64 byte_count, low = 0, high = 0;
+	u64 byte_count = 0, low = 0, high = 0;
 
 	if (direction == SNDRV_PCM_STREAM_PLAYBACK) {
 		switch (dai_id) {
@@ -191,7 +191,7 @@ static inline u64 acp_get_byte_count(struct acp_dev_data *adata, int dai_id, int
 			break;
 		default:
 			dev_err(adata->dev, "Invalid dai id %x\n", dai_id);
-			return -EINVAL;
+			goto POINTER_RETURN_BYTES;
 		}
 	} else {
 		switch (dai_id) {
@@ -213,12 +213,13 @@ static inline u64 acp_get_byte_count(struct acp_dev_data *adata, int dai_id, int
 			break;
 		default:
 			dev_err(adata->dev, "Invalid dai id %x\n", dai_id);
-			return -EINVAL;
+			goto POINTER_RETURN_BYTES;
 		}
 	}
 	/* Get 64 bit value from two 32 bit registers */
 	byte_count = (high << 32) | low;
 
+POINTER_RETURN_BYTES:
 	return byte_count;
 }
 
-- 
2.39.2




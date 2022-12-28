Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406BD1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F03C433EF;
	Wed, 28 Dec 2022 15:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241194;
	bh=iOnKgnpLiisyLkJcXxs/tBEg9qzO+wCqirrBoqs5nbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=daX/TB3nPwBVWe05JX/ez5pV07RVtcAw8I79fbxh8GtLdsWU5p375AlKuDPju3ZGg
	 zFYUGVx+iQ8Ptup2ODFg8HK41KtwOVjwQFxm6cS8CcORM4/2tgWEymy6eWOSDQG2HD
	 oprbkeyk990nP4tIvVFS7wHLf61LFwuctc/FeWm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	CoolStar <coolstarorganization@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0218/1146] ASoC: Intel: avs: Fix potential RX buffer overflow
Date: Wed, 28 Dec 2022 15:29:17 +0100
Message-Id: <20221228144336.067627844@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 23ae34e033b2c0e5e88237af82b163b296fd6aa9 ]

If an event caused firmware to return invalid RX size for
LARGE_CONFIG_GET, memcpy_fromio() could end up copying too many bytes.
Fix by utilizing min_t().

Reported-by: CoolStar <coolstarorganization@gmail.com>
Fixes: f14a1c5a9f83 ("ASoC: Intel: avs: Add module management requests")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20221010121955.718168-3-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/ipc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/avs/ipc.c b/sound/soc/intel/avs/ipc.c
index 020d85c7520d..77da206f7dbb 100644
--- a/sound/soc/intel/avs/ipc.c
+++ b/sound/soc/intel/avs/ipc.c
@@ -192,7 +192,8 @@ static void avs_dsp_receive_rx(struct avs_dev *adev, u64 header)
 		/* update size in case of LARGE_CONFIG_GET */
 		if (msg.msg_target == AVS_MOD_MSG &&
 		    msg.global_msg_type == AVS_MOD_LARGE_CONFIG_GET)
-			ipc->rx.size = msg.ext.large_config.data_off_size;
+			ipc->rx.size = min_t(u32, AVS_MAILBOX_SIZE,
+					     msg.ext.large_config.data_off_size);
 
 		memcpy_fromio(ipc->rx.data, avs_uplink_addr(adev), ipc->rx.size);
 		trace_avs_msg_payload(ipc->rx.data, ipc->rx.size);
-- 
2.35.1




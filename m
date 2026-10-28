Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207781;
	b=TW+liARQd58eXRCtZrDL9fF33/2Ud8MS4oyLFteuKBj/WNW1KEwiof3RLHhlfLRD76in
	 r6Gp2k3ZwKSUPeEMG0rPCBlueXvFZwXrpwcM0BV3YeGK+V/SMWIqvtSroDF+G0WucRm+J
	 YuIyYP0nyEE7xqGnJI55DXJaugHPgVDbtN+R0/RLne2HYgxVhcAcnHRF2O7zpjSsDQezr
	 ekv/MCpprGjui308KGAUa6m1G5YhI83TaDAjThv9POQYNq2IOm0zsr3s5XZwdnGz0NNTD
	 kvgdX8iQo5h32tADLAma6CrBzNey6/1QFnkTUZU5jEpP0Lb2P2l4PDL1LzatiIK3XxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0nT+AByM9oDMbGEv0B7gGYHh3vvpx7ysQmynIG//6rY=;
	b=bgfVoesmOBiO8VYkGki8kFc7TkFlU+l1Zj5S0LXAYfg+bacD0nvRGXG3FVrNJAN8d81a
	 qRCcr8CnjRsjYciXRTQ7nugr+MP1qRNXzVOL5AumS8/bhPIfAgiLeeAz1ol/CXZCBhaZY
	 Arddi6t7qQmbuEzAGy2DSVeU8VtPWUvNj7/9ABqPEq7T01c+r5tnnQyUCbDE1BG0BIgaA
	 4Q3O4V8Io1H2dpbeR/Of1rZJpqwXIbvYjb6E2EMj7st72ZyAkYs/M4e3Zxvn53n6NA+Bt
	 7k4Hg1kmDOLGelrT3OIhEpHNvJAHatzkotg4yLroTXZF2c748QPKmsJHSmMYuRyxwSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b8F6AkaS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CCF606A326;
	Wed, 28 Oct 2026 17:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b8F6AkaS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87DF1F01828;
	Wed, 28 Oct 2026 17:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207781;
	bh=0nT+AByM9oDMbGEv0B7gGYHh3vvpx7ysQmynIG//6rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b8F6AkaS+QCaKp9AcXzH4kjTdXujuofIKnH0ZL2nuGkmz1+tc1/c9L88vILwIz9Mg
	 GlOCQQcSAj5sUgovA66nmrzIa2+tpsv282O5CmVOf3kaNTgVJ1L1zkkCj7nTZKpuZ+
	 5fR4VRCHC06isuQErI4JHx6/sYf1rzGAS/RFB6jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 138/247] ASoC: SOF: ipc4-topology: Fix shift-out-of-bounds for aggregated ALH capture
Date: Wed, 28 Oct 2026 17:59:01 +0100
Message-ID: <20261028165950.676495244@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 746de48c3a250f0c264105dcbfcdf0c5001e970b ]

When ch_count is smaller than blob->alh_cfg.device_count (e.g. a mono
capture stream, such as a SmartMic, aggregated across multiple SDW
links), step = ch_count / blob->alh_cfg.device_count truncates to 0.
The subsequent GENMASK(step - 1, 0) then underflows step - 1 (u32) to
UINT_MAX, causing GENMASK()'s internal shift to use an out-of-bounds
exponent:

  UBSAN: shift-out-of-bounds in sound/soc/sof/ipc4-topology.c:2363:13
  shift exponent 18446744069414584384 is too large for 64-bit type 'long unsigned int'

Treat ch_count < device_count the same way as the existing "channels
equal to output reference channels" case: apply the same ch_mask to
every aggregated device instead of trying to split channels that
can't be evenly divided.

Fixes: 0390a102cc18 ("ASoC: SOF: ipc4-topology: use different channel mask for each sdw amp feedback")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20261008090130.15135-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[ sashal: used a standalone condition because the playback-specific channel check is absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-topology.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/ipc4-topology.c b/sound/soc/sof/ipc4-topology.c
index 6af0cc154f3d7..5cf272fe93ff6 100644
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -1973,8 +1973,20 @@ sof_ipc4_prepare_copier_module(struct snd_sof_widget *swidget,
 				ch_map >>= 4;
 			}
 
-			step = ch_count / blob->alh_cfg.device_count;
-			mask =  GENMASK(step - 1, 0);
+			if (ch_count < blob->alh_cfg.device_count) {
+				/*
+				 * When there are fewer channels than aggregated devices
+				 * (e.g. a mono capture stream split across multiple links),
+				 * set step = 0 to ensure all the ch_mask is applied to all
+				 * alh mappings.
+				 */
+				mask = ch_mask;
+				step = 0;
+			} else {
+				step = ch_count / blob->alh_cfg.device_count;
+				mask =  GENMASK(step - 1, 0);
+			}
+
 			/*
 			 * Set each gtw_cfg.node_id to blob->alh_cfg.mapping[]
 			 * for all widgets with the same stream name
-- 
2.53.0




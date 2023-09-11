Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAE311706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:44:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1B3C433C8;
	Mon, 11 Sep 2023 14:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443481;
	bh=4ISgRWk6GRz/5xUROiycCl7+XwjomI5At3gjzBDmarM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fcr2Dibx6FA+VW6A9D1xQCu9ZcIPUrbi9r6UcT1Zbmf3IWIpqYr+DgsNQgMTC1RNd
	 34zqVRM8gLDeVI75f0pxBL9ql0b1NBvXaKvGbdvofzhoHC0IkhfMGE2ZKu8t0yDrJ+
	 PR6dhN8JQFsmHg3lnFcKQuRIXxqg5naxkVgz02pI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 365/737] ASoC: SOF: Intel: hda-mlink: fix off-by-one error
Date: Mon, 11 Sep 2023 15:43:44 +0200
Message-ID: <20230911134700.733956597@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 7075b0c91b3cd5d32b4ac7403f771a3253d3fbf6 ]

The HCHAN parameter should be the highest channel number, not the
channel count.

While we're at it, handle LCHAN with the dual __ffs helper.

Fixes: ccc2f0c1b6b6 ("ASoC: SOF: Intel: hda-mlink: add helper to program SoundWire PCMSyCM registers")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Link: https://lore.kernel.org/r/20230807210959.506849-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-mlink.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/intel/hda-mlink.c b/sound/soc/sof/intel/hda-mlink.c
index b7cbf66badf5b..acad3ea2f4710 100644
--- a/sound/soc/sof/intel/hda-mlink.c
+++ b/sound/soc/sof/intel/hda-mlink.c
@@ -781,6 +781,8 @@ int hdac_bus_eml_sdw_map_stream_ch(struct hdac_bus *bus, int sublink, int y,
 {
 	struct hdac_ext2_link *h2link;
 	u16 __iomem *pcmsycm;
+	int hchan;
+	int lchan;
 	u16 val;
 
 	h2link = find_ext2_link(bus, true, AZX_REG_ML_LEPTR_ID_SDW);
@@ -791,9 +793,17 @@ int hdac_bus_eml_sdw_map_stream_ch(struct hdac_bus *bus, int sublink, int y,
 		h2link->instance_offset * sublink +
 		AZX_REG_SDW_SHIM_PCMSyCM(y);
 
+	if (channel_mask) {
+		hchan = __fls(channel_mask);
+		lchan = __ffs(channel_mask);
+	} else {
+		hchan = 0;
+		lchan = 0;
+	}
+
 	mutex_lock(&h2link->eml_lock);
 
-	hdaml_shim_map_stream_ch(pcmsycm, 0, hweight32(channel_mask),
+	hdaml_shim_map_stream_ch(pcmsycm, lchan, hchan,
 				 stream_id, dir);
 
 	mutex_unlock(&h2link->eml_lock);
-- 
2.40.1




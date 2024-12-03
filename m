Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A95D1F75A4;
	Tue,  3 Dec 2024 15:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240756; cv=none; b=WV+iLtE3TT2XJVxUNl1N6+CHkD4ufsExV/0CLdHzJVyHskV4YoDh3GO6UY1aREO659TWek2jYZZmIDZZJeZdvNvo96gaQ/kJ3COZt+knnVLHVJmkdfrrXDOCNQLRayW1u2CUcBes8QE3MloadeJQSKGwwngKJ5oo0SLT8ceXkl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240756; c=relaxed/simple;
	bh=PlbRX2f8fsjfbdRdlCbqu3+RM4vrf3xw8pNKtZOdzOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSMdbNcdw8RJbIZT42yYPdZqA71N4NgBOxrT1uMSTQ/RH8o4nMsSteCjgPkw52mKtpqOp/ExWrpAV15F7UEg0Ok2ZNXLWyKzar0lXvozCV6wD751weNBed9FHZe9RzSQ+OxPQwrk67QQ3zfzylgCq+0wnqZ1oDu1zpk/I8Z/KII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zUn/LkRY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zUn/LkRY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABEBC4CECF;
	Tue,  3 Dec 2024 15:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240755;
	bh=PlbRX2f8fsjfbdRdlCbqu3+RM4vrf3xw8pNKtZOdzOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zUn/LkRY834nVktgXSQBhD2dFQV31clHXs154M8/kHZsVKr7riQX1scqfyiL5fUSn
	 3hzfp/UiUwcDTxomfBL6Jjw7FElwV34eDlsYzBLvDDtQ6LZtcODWcv9Bo2IdeuZUqv
	 +oH96Zi5X90nqvKaLHjhP7l417fMFau/A9V0JEz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 225/826] ASoC: amd: acp: fix for cpu dai index logic
Date: Tue,  3 Dec 2024 15:39:12 +0100
Message-ID: <20241203144752.516125713@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 7ce8e4d380d68f34edc96c7efcf95b1476e7f033 ]

Multi link aggregation is not supported for acp6.3 platform.
Below combinations are supported.
- one sdw BE DAI <---> one-cpu DAI <---> one-codec DAI
- one sdw BE DAI  <---> one-cpu DAI <---> multi-codec DAIs
As Single cpu dai is going to be created, In create_sdw_dailink() function
cpu dai index won't be incremented.
Refactor cpu dai index logic to fix below smatch static checker warning.
sound/soc/amd/acp/acp-sdw-sof-mach.c:157 create_sdw_dailink()
warn: iterator 'i' not incremented.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/a201e871-375e-43eb-960d-5c048956c2ff@amd.com/T/
Fixes: 6d8348ddc56e ("ASoC: amd: acp: refactor SoundWire machine driver code")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20241007085321.3991149-3-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-sdw-sof-mach.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/sound/soc/amd/acp/acp-sdw-sof-mach.c b/sound/soc/amd/acp/acp-sdw-sof-mach.c
index acab2675d1f5c..3be401c722704 100644
--- a/sound/soc/amd/acp/acp-sdw-sof-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-sof-mach.c
@@ -154,7 +154,7 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 		int num_cpus = hweight32(sof_dai->link_mask[stream]);
 		int num_codecs = sof_dai->num_devs[stream];
 		int playback, capture;
-		int i = 0, j = 0;
+		int j = 0;
 		char *name;
 
 		if (!sof_dai->num_devs[stream])
@@ -213,14 +213,14 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 
 			int link_num = ffs(sof_end->link_mask) - 1;
 
-			cpus[i].dai_name = devm_kasprintf(dev, GFP_KERNEL,
-							  "SDW%d Pin%d",
-							  link_num, cpu_pin_id);
-			dev_dbg(dev, "cpu[%d].dai_name:%s\n", i, cpus[i].dai_name);
-			if (!cpus[i].dai_name)
+			cpus->dai_name = devm_kasprintf(dev, GFP_KERNEL,
+							"SDW%d Pin%d",
+							link_num, cpu_pin_id);
+			dev_dbg(dev, "cpu->dai_name:%s\n", cpus->dai_name);
+			if (!cpus->dai_name)
 				return -ENOMEM;
 
-			codec_maps[j].cpu = i;
+			codec_maps[j].cpu = 0;
 			codec_maps[j].codec = j;
 
 			codecs[j].name = sof_end->codec_name;
-- 
2.43.0




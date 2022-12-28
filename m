Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F2A1875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232A4C433D2;
	Wed, 28 Dec 2022 15:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243146;
	bh=TePuMiNa2pNC63XpVcgQ1xVINJebu79XDAKz+0GVs9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u3t7m5LehrV9tKR13OVerPt6xGw0/ZaoKoIc1PXsrwmceS0h6kvVyBAz2rizrAPju
	 IEB/Seq8UN25jwve1LPCdIgPrzpTn/uyka3A8GDISHdfPrYDj6rug525f5YbqBBKIW
	 FNFISW6PNmDF4hEVyuB63XFUNA+hWyEj2w2Vq7s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Lukasz Majczak <lma@semihlaf.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 688/731] ASoC: Intel: Skylake: Fix driver hang during shutdown
Date: Wed, 28 Dec 2022 15:43:15 +0100
Message-Id: <20221228144316.408959382@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

[ Upstream commit 171107237246d66bce04f3769d33648f896b4ce3 ]

AudioDSP cores and HDAudio links need to be turned off on shutdown to
ensure no communication or data transfer occurs during the procedure.

Fixes: c5a76a246989 ("ASoC: Intel: Skylake: Add shutdown callback")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Tested-by: Lukasz Majczak <lma@semihlaf.com>
Link: https://lore.kernel.org/r/20221205085330.857665-6-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/skylake/skl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/skylake/skl.c b/sound/soc/intel/skylake/skl.c
index 148ddf4cace0..46bb3b8bd5af 100644
--- a/sound/soc/intel/skylake/skl.c
+++ b/sound/soc/intel/skylake/skl.c
@@ -1096,7 +1096,10 @@ static void skl_shutdown(struct pci_dev *pci)
 	if (!skl->init_done)
 		return;
 
-	snd_hdac_stop_streams_and_chip(bus);
+	snd_hdac_stop_streams(bus);
+	snd_hdac_ext_bus_link_power_down_all(bus);
+	skl_dsp_sleep(skl->dsp);
+
 	list_for_each_entry(s, &bus->stream_list, list) {
 		stream = stream_to_hdac_ext_stream(s);
 		snd_hdac_ext_stream_decouple(bus, stream, false);
-- 
2.35.1




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E411171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FDDC433C7;
	Mon, 21 Aug 2023 20:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648060;
	bh=85L6Tos4DsyWhbEnuD+s05A+HDHYZljGn+kwIUbvBn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=touObif+EC8FjMeapi3v3k6nUPPcBoKsWQJ0pN/otbIUwiRup4iWRxJgEL64B5+Av
	 /reBRe/5HG512ixq79uHazDI91J4uiez8gbAUlP5iUYOw/3njula5TUkTnaOPGUuYB
	 SMI97a90M1taWe+j/p3/WJ/4/h04yhgLeQb+ZGOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 041/234] ASoC: SOF: core: Free the firmware trace before calling snd_sof_shutdown()
Date: Mon, 21 Aug 2023 21:40:04 +0200
Message-ID: <20230821194130.544707041@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit d389dcb3a48cec4f03c16434c0bf98a4c635372a ]

The shutdown is called on reboot/shutdown of the machine.
At this point the firmware tracing cannot be used anymore but in case of
IPC3 it is using and keeping a DMA channel active (dtrace).

For Tiger Lake platforms we have a quirk in place to fix rare reboot issues
when a DMA was active before rebooting the system.
If the tracing is enabled this quirk will be always used and a print
appears on the kernel log which might be misleading or not even correct.

Release the fw tracing before executing the shutdown to make sure that this
known DMA user is cleared away.

Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20230616100039.378150-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/core.c b/sound/soc/sof/core.c
index 9a9d82220fd0d..30db685cc5f4b 100644
--- a/sound/soc/sof/core.c
+++ b/sound/soc/sof/core.c
@@ -504,8 +504,10 @@ int snd_sof_device_shutdown(struct device *dev)
 	if (IS_ENABLED(CONFIG_SND_SOC_SOF_PROBE_WORK_QUEUE))
 		cancel_work_sync(&sdev->probe_work);
 
-	if (sdev->fw_state == SOF_FW_BOOT_COMPLETE)
+	if (sdev->fw_state == SOF_FW_BOOT_COMPLETE) {
+		sof_fw_trace_free(sdev);
 		return snd_sof_shutdown(sdev);
+	}
 
 	return 0;
 }
-- 
2.40.1




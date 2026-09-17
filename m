Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485EA4E01E3;
	Thu, 17 Sep 2026 18:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670387; cv=none; b=Ruzlh/V86dU5hgOY0O64nOkCsojbW4Ktvxtw6s4DO2+UELBBEXegXZp7txrrtlzbG7ees887yqBaaedhSVARmBydaNX4Ounk1UrBwmPl+hleCDJNg8m+i9l6/xwjdqqxNSGxpED2kMlPSENKED9dDk2ToD+EQJBPEWeskx3W21w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670387; c=relaxed/simple;
	bh=iyLraBaU7TaAI2qh90/Wf3IApjk8ehjYhZ/q0TTD+h4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dHTeWO+3R+aC1HkhDfr8qlePvmBMJnvbEaE1UzFgIu5yCDERQ3XICLNn2FiTbjSE9uFXgQicXnXfrEBlHJYgbxXKYHeqCIFfjtSSByNDxSLuKCnt/vpL/uHJyjqtaOazygdTqggiwHjgh0SvZByJGyGzECeH47i5FAOrdjLQsOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NzF8nKpn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NzF8nKpn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87CF11F00893;
	Thu, 17 Sep 2026 18:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670385;
	bh=qfwhafVjVLdYJshGjl+Hu3quQnX3yy4pv16tDcEtt64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NzF8nKpn4DPb+NcTS7lM7PHTkUZU4VyOS/Xre7qzyHGvX/drtw5F2kc14Yw7AVLf8
	 XDRHdeRkWWchHZQkjXlkY5Z40O80iBN6RvfsuQrP3j3+H+R9WDCwKuD+qd1pzEmTpn
	 4DO0XvbrN30/UdExuEJZWdTVCMdh/ns7tPfvxjOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0648/1102] ASoC: Intel: avs: Clean up the bus when fetching ML caps fails
Date: Thu, 17 Sep 2026 16:09:51 +0100
Message-ID: <20260917151556.424901541@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 559ea14b7ae7c7562b48759fa545b64958f35b73 ]

snd_hdac_ext_bus_get_ml_capabilities() may fail and its return code
shall be checked and accounted for. Address the issue by updating the
error-path for avs_pci_probe().

At the same time, if the function in question succeeds but the next part
of avs_pci_probe() fails, the hlink list shall be cleaned up before
leaving the scope.

Fixes: 1affc44ea5dd ("ASoC: Intel: avs: PCI driver implementation")
Co-developed-by: Amadeusz Sławiński <amade@asmblr.net>
Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260902081814.1590883-5-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/avs/core.c b/sound/soc/intel/avs/core.c
index 80b526554bbf4..cf7adf67e34a1 100644
--- a/sound/soc/intel/avs/core.c
+++ b/sound/soc/intel/avs/core.c
@@ -467,8 +467,13 @@ static int avs_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	}
 
 	snd_hdac_bus_parse_capabilities(bus);
-	if (bus->mlcap)
-		snd_hdac_ext_bus_get_ml_capabilities(bus);
+	if (bus->mlcap) {
+		ret = snd_hdac_ext_bus_get_ml_capabilities(bus);
+		if (ret < 0) {
+			dev_err(dev, "failed to get ml capabilities: %d\n", ret);
+			goto err_ml_cap;
+		}
+	}
 
 	if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64)))
 		dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
@@ -510,6 +515,8 @@ static int avs_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	snd_hdac_bus_free_stream_pages(bus);
 	snd_hdac_ext_stream_free_all(bus);
 err_init_streams:
+	snd_hdac_ext_link_free_all(bus);
+err_ml_cap:
 	iounmap(adev->dsp_ba);
 err_remap_bar4:
 	iounmap(bus->remap_addr);
-- 
2.53.0




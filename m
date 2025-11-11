Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBC54C97;
	Tue, 11 Nov 2025 00:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822186; cv=none; b=exYD1fNM7hK7dXCPYn41wgOes08T2hLDyma1hqsCZXJ0mHycq9iX0AhQrXyztop3Lu2moV/IgWLQ+8LONT/5QgN80DiB/kKSUwa2emw0Zk91+aTkfgRMFC6/o2BndZrrbXmv8rZiZNLcrcEqYKOyvUZ+GYkxTlfdJwJsMFEGinc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822186; c=relaxed/simple;
	bh=gKGNAA3wi8K/dnGRUfc4/K9QQ2VyoWCpnAqqQe9Digs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kCfqzHWaZGTTKtGoa/pS+/r1xNn1KpUyuiQGKDNQNsIEV1e0/III02lXqb9qg54ydC5CyHVhFGJ8QQeKQWPh1WpuBmsHeozS+vl4t34Yu185Qla+tmo32ZY6yjtXlwlG5eBjMfefyHgwZ0hRD+ddyFiz0vU7TGv2Dgn32RvbzeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cOhbFfaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cOhbFfaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A196CC4CEF5;
	Tue, 11 Nov 2025 00:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822185;
	bh=gKGNAA3wi8K/dnGRUfc4/K9QQ2VyoWCpnAqqQe9Digs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cOhbFfaJYM9jyLLhFRz0HwS44yRphVLtkvEyR1sHED7/YMs7u46Bmp+oRVlla3CGT
	 VXTuHJPibY4TxeNTWeWjIRb4DwL03BEG1UoavxEped/+5Ex7Nyw4bLIveJB7Jci/PK
	 TAh+ZbSIMFtWzrbf46poAmo9p0ue0RGJKQ/IY4Wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 051/849] ASoC: Intel: avs: Disable periods-elapsed work when closing PCM
Date: Tue, 11 Nov 2025 09:33:41 +0900
Message-ID: <20251111004537.670436521@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 845f716dc5f354c719f6fda35048b6c2eca99331 ]

avs_dai_fe_shutdown() handles the shutdown procedure for HOST HDAudio
stream while period-elapsed work services its IRQs. As the former
frees the DAI's private context, these two operations shall be
synchronized to avoid slab-use-after-free or worse errors.

Fixes: 0dbb186c3510 ("ASoC: Intel: avs: Update stream status in a separate thread")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20251023092348.3119313-3-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/pcm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/avs/pcm.c b/sound/soc/intel/avs/pcm.c
index 0d7862910eedd..0180cf7d5fe15 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -651,6 +651,7 @@ static void avs_dai_fe_shutdown(struct snd_pcm_substream *substream, struct snd_
 
 	data = snd_soc_dai_get_dma_data(dai, substream);
 
+	disable_work_sync(&data->period_elapsed_work);
 	snd_hdac_ext_stream_release(data->host_stream, HDAC_EXT_STREAM_TYPE_HOST);
 	avs_dai_shutdown(substream, dai);
 }
-- 
2.51.0




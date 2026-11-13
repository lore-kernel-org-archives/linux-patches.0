Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585459;
	b=sPaKhMlS73J1Ob2c2esOPIhOPRstisEJ2DV6gNKWPtb4rxpZWPlDp4SsonIbNWfeZkUW
	 UCNDpr7kWc+QFRJjvXiOasc6BGwILKYLpJpJMpQC5DMxKe0zoHMeDbKdDZ/cF5ooNtFn2
	 AygfTGN5Z6pW91L4vN/LC47XtApZBOvN+ZolxyA6yOQU7Bcj1oSRPAWU3f1lWqbDU+he1
	 gjhhFZwyfUURlTydYeRE+5ZpAlxTM5DKt05NaoSNnjoXFZE6JiXnEeaKkuwwwbnmRkWxj
	 Ly2FJTZIDVqv7NbMx0CDAjGXGNotgQC2NcGVqs6GzDP948qA/EEpwB0b5FjWA+IgbXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585459;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y8LoC8f7UJHH2jesiAgz0KPPS6tUY50BijfIY9Ia4xg=;
	b=blESngkfYVi+n4FAyEbWRn+UFtBfAiMNGhCuMMq1yYhZPbqssZHl2ZzUvMHdYg05P1h2
	 QK2pXBYYdcZm/H6Dy9vRcyGih/fHRU7/07G6vTdYp4WwitpdICxHq3fwu60wkdOvYxOCJ
	 io9l/wa7cGQwuiaaSZv+MvF2vGyGbYjptWqIO8Nh3kCfFsDPuLufQ3XUIlIjD0fjXVteM
	 JzH+RApUN04SV/zmWVOoQdl9u6PD4kmHAIuzbechtyYSRTVQMIBhK5NGAJRjewtW2dHjo
	 c28YnLJ7KuOuNkO/kbT33/mtTWBxjxiVhuxeFN7y53nFL8cpWph0uvRdrpujB5bpLZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mMti1SaW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9679D606A884;
	Fri, 13 Nov 2026 15:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mMti1SaW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423581F000C7;
	Fri, 13 Nov 2026 15:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585459;
	bh=Y8LoC8f7UJHH2jesiAgz0KPPS6tUY50BijfIY9Ia4xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mMti1SaWe4PDZqsplI0xoIF+9m+J1yfa7Yt02In18SBR3oAE1HYGRJacaM9iw82cx
	 PWEC7hXDBAS1PiiDg75fqbl+6J6E0MViRaOy6bQcnPN0MPkvfVjmpUUQ9vuvEFMqSn
	 VeWPIfsjosazYm8gPf6v+/QQTQbP/rwBFFBqRqnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 116/507] ASoC: SOF: Intel: hda-sdw-bpt: Stop active DMA before closing BPT streams
Date: Fri, 13 Nov 2026 10:47:00 -0500
Message-ID: <20261113153758.273908307@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

[ Upstream commit 348bc756d912dd8f47fd36c167075717951a515e ]

When sdw_enable_stream() fails in intel_ace2x_bpt_send_async() after
hda_sdw_bpt_send_async() has already started the TX and RX DMA streams,
intel_ace2x_bpt_close_stream() invokes hda_sdw_bpt_close() directly
without calling hda_sdw_bpt_wait().  As a result,
hda_sdw_bpt_dma_deprepare() tears down the DMA buffers and BDL while
the DMA hardware is still running.

Disable any running TX or RX BPT DMA stream at the start of
hda_sdw_bpt_close() before unmapping channels and depreparing DMA
resources.

Fixes: 4c1ce9f37d8a ("soundwire: intel_ace2x: add BPT send_async/wait callbacks")
Closes: https://sashiko.dev/#/bug/linux-ff0012de-abdd-4796-875e-b1fbbf47235f
Cc: stable@vger.kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Acked-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20261030104840.3361217-6-lee@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-sdw-bpt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/soc/sof/intel/hda-sdw-bpt.c b/sound/soc/sof/intel/hda-sdw-bpt.c
index ba9fbd662b859..9d97d86762514 100644
--- a/sound/soc/sof/intel/hda-sdw-bpt.c
+++ b/sound/soc/sof/intel/hda-sdw-bpt.c
@@ -456,6 +456,12 @@ int hda_sdw_bpt_close(struct device *dev, int link_id, struct hdac_ext_stream *b
 	int ret;
 	int ret1;
 
+	if (bpt_rx_stream && hdac_stream(bpt_rx_stream)->running)
+		hda_sdw_bpt_dma_disable(dev, bpt_rx_stream);
+
+	if (bpt_tx_stream && hdac_stream(bpt_tx_stream)->running)
+		hda_sdw_bpt_dma_disable(dev, bpt_tx_stream);
+
 	/*
 	 * In the case of SoundWire we need to reset the PCMSyCM registers.
 	 * Need to continue depreparing the DMA buffers even if this fails.
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA7C314A75;
	Mon, 13 Oct 2025 15:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370180; cv=none; b=JvvUdVhWnZrlOddwk1i3gNKWMJGz1tlIDjLYFlPitBg+bgDazqLZuROvNbAConHbft+vZe6RqvBW04vFSh6KZ3ikM1RBZD16dVp3y1lVDHifZDyMjZ+amilaHq4nQyLhWovRqfo1r5lUTAvTv3Tk9LBwO5rRkFNLTj6p8qU/mOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370180; c=relaxed/simple;
	bh=HqUmTJJFrnCYIUsbsmCiUySl9lYbgNxwesiIlnc0NPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lxiQOr85qCNKUCgiBGAJUV1Vwn1sAwmq4VQNWxt5JoAVHMXKh0wciCAnfoO6LIqDFRUErZm1fkL+7hWwzQNeRUu7eTVYn/cx19uyKB/Ok3j9oep7o+TWnMYg3Fh232n1aefxbob+2F6lVy2BtWz5KuGe5FuHYEXUNdv2hQiK+ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BYWfTJBP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BYWfTJBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997C3C4CEE7;
	Mon, 13 Oct 2025 15:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370180;
	bh=HqUmTJJFrnCYIUsbsmCiUySl9lYbgNxwesiIlnc0NPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BYWfTJBPIdFkLY6kRn8yapWYyRPiecldkcAPFb/Uja2yPMeB406ER3SQmdrfhAWOh
	 UauBPYqy2SSnG0lCJXnFg5Tt6OWZsWTT8sW+3FfGFyF84Li1HuF2PgasFchotOI0qU
	 YKua4jEBxKWMqun7OIfIHoO/4j9c6Htr0GeRxoXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.17 506/563] ASoC: SOF: ipc4-pcm: fix start offset calculation for chain DMA
Date: Mon, 13 Oct 2025 16:46:07 +0200
Message-ID: <20251013144429.639546574@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

commit bace10b59624e6bd8d68bc9304357f292f1b3dcf upstream.

Assumption that chain DMA module starts the link DMA when 1ms of
data is available from host is not correct. Instead the firmware
chain DMA module fills the link DMA with initial buffer of zeroes
and the host and link DMAs are started at the same time.

This results in a small error in delay calculation. This can become a
more severe problem if host DMA has delays that exceed 1ms. This results
in negative delay to be calculated and bogus values reported to
applications. This can confuse some applications like
alsa_conformance_test.

Fix the issue by correctly calculating the firmware chain DMA
preamble size and initializing the start offset to this value.

Cc: stable@vger.kernel.org
Fixes: a1d203d390e0 ("ASoC: SOF: ipc4-pcm: Enable delay reporting for ChainDMA streams")
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20251002074719.2084-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-pcm.c      |   14 ++++++++++----
 sound/soc/sof/ipc4-topology.c |    1 -
 sound/soc/sof/ipc4-topology.h |    2 ++
 3 files changed, 12 insertions(+), 5 deletions(-)

--- a/sound/soc/sof/ipc4-pcm.c
+++ b/sound/soc/sof/ipc4-pcm.c
@@ -1052,7 +1052,7 @@ static int sof_ipc4_get_stream_start_off
 		return -EINVAL;
 	} else if (host_copier->data.gtw_cfg.node_id == SOF_IPC4_CHAIN_DMA_NODE_ID) {
 		/*
-		 * While the firmware does not supports time_info reporting for
+		 * While the firmware does not support time_info reporting for
 		 * streams using ChainDMA, it is granted that ChainDMA can only
 		 * be used on Host+Link pairs where the link position is
 		 * accessible from the host side.
@@ -1060,10 +1060,16 @@ static int sof_ipc4_get_stream_start_off
 		 * Enable delay calculation in case of ChainDMA via host
 		 * accessible registers.
 		 *
-		 * The ChainDMA uses 2x 1ms ping-pong buffer, dai side starts
-		 * when 1ms data is available
+		 * The ChainDMA prefills the link DMA with a preamble
+		 * of zero samples. Set the stream start offset based
+		 * on size of the preamble (driver provided fifo size
+		 * multiplied by 2.5). We add 1ms of margin as the FW
+		 * will align the buffer size to DMA hardware
+		 * alignment that is not known to host.
 		 */
-		time_info->stream_start_offset = substream->runtime->rate / MSEC_PER_SEC;
+		int pre_ms = SOF_IPC4_CHAIN_DMA_BUF_SIZE_MS * 5 / 2 + 1;
+
+		time_info->stream_start_offset = pre_ms * substream->runtime->rate / MSEC_PER_SEC;
 		goto out;
 	}
 
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -33,7 +33,6 @@ MODULE_PARM_DESC(ipc4_ignore_cpc,
 
 #define SOF_IPC4_GAIN_PARAM_ID  0
 #define SOF_IPC4_TPLG_ABI_SIZE 6
-#define SOF_IPC4_CHAIN_DMA_BUF_SIZE_MS 2
 
 static DEFINE_IDA(alh_group_ida);
 static DEFINE_IDA(pipeline_ida);
--- a/sound/soc/sof/ipc4-topology.h
+++ b/sound/soc/sof/ipc4-topology.h
@@ -247,6 +247,8 @@ struct sof_ipc4_dma_stream_ch_map {
 #define SOF_IPC4_DMA_METHOD_HDA   1
 #define SOF_IPC4_DMA_METHOD_GPDMA 2 /* defined for consistency but not used */
 
+#define SOF_IPC4_CHAIN_DMA_BUF_SIZE_MS 2
+
 /**
  * struct sof_ipc4_dma_config: DMA configuration
  * @dma_method: HDAudio or GPDMA



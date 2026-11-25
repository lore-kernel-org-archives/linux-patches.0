Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622840;
	b=POOnkFQ+SBWDl5D5HKz7xS4zxX4eHRNOFuKWEmBIaNIhB0ugIu4qq8YoF1PS+MNvmsJa
	 7tz2BX3zsG9vrAxcogeV7ydoybjS7WTLt6GrC76G3HG8ErZZzAChBqKkKdKszp+MKNt14
	 foxw9W5EfjwDxTixz+BombXETvexQazWBUqQv13VjWmNbcuI4x22atiLJOOTiYh5vEGF0
	 vXPoNRw5DdaFpvZse2t5t7RSgf88TORE3I1PGLIv29EI7T7aFHn08th9hD+iOCAPvqZPr
	 wW7p5mSiIjoRq8E0mzclOdRP7rPD+hkmZlwpPDstk6iAvcWyHVWAFcWN0iz4V2Vr5bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622840;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1ENrdzSNnQWzsy1CERHWjQhcuJ4jCuyCNgu8cAx+2q4=;
	b=uTd+lge6cxI8hlZfaVpd37h2By9QOcC79YB4xuqFimORz8tGSJKc8bUEDtolzO4exvNZ
	 uCdmRvEZ70zkMD9n/4mQ4o5ZKBXkE4FDRcGCkzri48BsKm73ObX5nW469rpOxz4K3swmk
	 cRbLy1EmCWh7SnAGI2PWftqdmicZ1BqFo8wKVc3i0/ajzGP2M13NwA2pGqF0rfoCJZ9Gl
	 aHgbji+VYnNCfNBXfGUsRokAxqqjYHvaWl58otiHm6IbBgsrl0ZQnI92us6N31Ao83yCA
	 g0nHm86EbD/+zgt1jgpw9mI+ibsVvGUqWND9OJudUElAyQlQtAdDzusQ8RwF1NtdnqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bBZeeQz5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA680606A32A;
	Wed, 25 Nov 2026 16:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bBZeeQz5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3691F00A01;
	Wed, 25 Nov 2026 16:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622840;
	bh=1ENrdzSNnQWzsy1CERHWjQhcuJ4jCuyCNgu8cAx+2q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bBZeeQz5Cp72YzRIMnn07PZNsNFpb3U2visBY+yrA54LJc7l3ntWqsLRV/4phVTL3
	 EZwCIfUUtBU73nibTi6I5U4U158ExMw/epkzsl9NR+RBHkjQ6HbM0daUTvFOQRlizU
	 lmqxWwIoCw8H8sj33cEz/XB+btQYu5CMYGmww7vA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 666/990] mmc: meson-gx: honour the busy timeout for R1b commands
Date: Wed, 25 Nov 2026 15:33:53 +0100
Message-ID: <20261125143837.689615583@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Velkov <iav@iav.lv>

commit 7e3cc541aa5855bc36e6cbffa82efc2795955a10 upstream.

For a command without data the driver programs a fixed 1024 ms into the
CMD_CFG timeout field, and for R1b the controller waits for the card to
release busy within that time. The core sends erase and cache flush as
R1b with busy timeouts of up to 60 s and 30 s, and the controller gives
up after one second:

  mmc_erase: erase error -110, status 0x0
  mmc1: cache flush error -110

Program the timeout from cmd->busy_timeout, kept between 1024 ms, the
fixed value until now, and 32768 ms, the most the field holds, and
rounded up to a power of two. The clamp comes first: MMC_IOC_CMD passes
cmd_timeout_ms from user space straight into busy_timeout, and
roundup_pow_of_two() of a value above 2^31 does not fit in unsigned
int. sdhci takes its command timeout from cmd->busy_timeout in the
same way.

Fixes: 51c5d8447bd7 ("MMC: meson: initial support for GX platforms")
Cc: stable@vger.kernel.org
Signed-off-by: Igor Velkov <iav@iav.lv>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/meson-gx-mmc.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -214,6 +214,20 @@ static unsigned int meson_mmc_get_timeou
 	return min(timeout, 32768U); /* max. 2^15 ms */
 }
 
+/* For R1b the controller waits for busy to be released within this timeout. */
+static unsigned int meson_mmc_get_cmd_timeout_msecs(struct mmc_command *cmd)
+{
+	unsigned int timeout = cmd->busy_timeout;
+
+	if (!timeout)
+		return SD_EMMC_CMD_TIMEOUT;
+
+	timeout = clamp_t(unsigned int, timeout, SD_EMMC_CMD_TIMEOUT,
+			  SD_EMMC_CMD_TIMEOUT_MAX);
+
+	return roundup_pow_of_two(timeout);
+}
+
 static struct mmc_command *meson_mmc_get_next_command(struct mmc_command *cmd)
 {
 	if (cmd->opcode == MMC_SET_BLOCK_COUNT && !cmd->error)
@@ -840,7 +854,7 @@ static void meson_mmc_start_cmd(struct m
 		cmd_data = host->bounce_dma_addr & CMD_DATA_MASK;
 	} else {
 		cmd_cfg |= FIELD_PREP(CMD_CFG_TIMEOUT_MASK,
-				      ilog2(SD_EMMC_CMD_TIMEOUT));
+				      ilog2(meson_mmc_get_cmd_timeout_msecs(cmd)));
 	}
 
 	/* Last descriptor */



Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704640;
	b=kK03EqiEAb2YZBGLxZ8L9OHpk4eB7+YxM/S1IXYM9CRhAmmGaHezTNRVCnfS8lYHxNbI
	 8Cgsbn3bC0+wraLsyqGgQOBm1K5LhU7gHcJPwhW/ZGHw/R3KEQBQCWCetdSlBg4glZeDX
	 f0tJUu2Wdi4J5WZbBBp2i8Ut++TFrHlMmJEoXeAMB+7lTtR8QtJxYmGD7UC56SDR0r8WL
	 biAsRjWlUq6RgjyO5VJ+021DlPDFuv6rr+4KMLt3KUmsbXoIofjtyEYuiDhRt8DX/pz0q
	 Vx8km463sX/r1U2HRt9FZvzPGmsYHLaSodDKTWv06bvmsjppyoX1oPSX+hLoTZTg7Vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704640;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YE//DQB8O9c5fN0P6KTxrPAvskkXKyNxMilaipOjy3g=;
	b=0cto02QJZO+9r25Pdxsr/SaDjVyzikV7uC+qco0QO6VN66d/6mmA/zbx9NyUrR5Rb0SE
	 irhjJolIcXn1ux7/HaGuLh3X49F9S8cTYVKcFmFmjcA6IxSgBYz7sHDg+DGOWBj6Mgqcj
	 4j/ZhnpmrRVUOz0pA+JJ2s6UhWOgMbypkINZulVI4xqovVpt/kCZhM6hLVj4qar0MrsG/
	 M3522R9UdlzYnhghe/Gnh66piMFXihyQbRsiLPwXYYrEhQ7dT/hvxWtJAsvSFhnu+Nnzj
	 gCDv/oGKLDVubSSlM/VU/rL7wND94KsOpy1KRqNYCCuF6AnHykX9PKF1jjD9AvlvuuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k3Vh0TOx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA702606A321;
	Thu, 26 Nov 2026 14:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k3Vh0TOx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32951F000C0;
	Thu, 26 Nov 2026 14:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704640;
	bh=YE//DQB8O9c5fN0P6KTxrPAvskkXKyNxMilaipOjy3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k3Vh0TOxmKgWZYRlCtYVjrFRD1ReZmz2NAKp04edBxZHoUGT8C6xk5xn64+YGtMXR
	 SiQXpX8eOnK1F5aUBrd5jvyv2BaK/aZmjKCFJeTJKOPfSCVZVMCJhcJwR30xwbSZ0D
	 /BdjxmoK9diF2S7SIKGnLQV76zVBPl33eQXJM7V0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.10 148/265] mmc: meson-gx: honour the busy timeout for R1b commands
Date: Thu, 26 Nov 2026 15:37:58 +0100
Message-ID: <20261126143615.423991869@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -212,6 +212,20 @@ static unsigned int meson_mmc_get_timeou
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
@@ -839,7 +853,7 @@ static void meson_mmc_start_cmd(struct m
 		cmd_data = host->bounce_dma_addr & CMD_DATA_MASK;
 	} else {
 		cmd_cfg |= FIELD_PREP(CMD_CFG_TIMEOUT_MASK,
-				      ilog2(SD_EMMC_CMD_TIMEOUT));
+				      ilog2(meson_mmc_get_cmd_timeout_msecs(cmd)));
 	}
 
 	/* Last descriptor */



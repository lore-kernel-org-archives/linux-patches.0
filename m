Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705506;
	b=JNmcmYjfiSpu55vi4gA0EJVCRFj7IbWOVOzcrSTQqvJ72RhkLQqsRoIcqSeFA/7G1tZ6
	 D605zpvw16IOjWnCLftatrZC0qwtOXr1Ein8r5+K80bY0o5y5le6FscTnrqUHigtoE/zy
	 Py2x/ZyEwuSkduldVmiYKu3j8U44F2olgBH+bWJDHvYSjrNv9age69/RnlEn3A3BfreLS
	 ++MkG/SfEdAZle93WnGGWuSM6EM7Qct0/2zKqwUeCP6cquFJo9YS7/ScDp+ly7RfgoUvS
	 vnRLMNLULg55dWLGS494Ay0zQTFMpJdHmrLZkC6/f8E9jLxFzm+td3tHxQMCqefRTDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q9dr5/UselDcdqOHjMrWZBlryct8GKnWH3+EMfwfyZM=;
	b=PvKsSvU21pGdHYhYJUnq6KUa5b2qpXUfl8aoVZ+Ssnqc5dvG49Zp+BRGb6FpyvtjxuOg
	 Y2WUASh2Mwcu1v16bHgbB+f3sZus6zPnuGa15OEYvXbvstm78fyp48XxSGe/NnMp/6DSt
	 NAy/71I78uWjJwWOuT7ejS9XPANhfwsUV9mw0zvhjcL2z4ksRzBJdF/UL8GngemkoJ3IK
	 v7gCxqr9O0tynJbBSiGGIXcxi8ImM07TZbsgwtz5sSwuVFh1vJ45yQ1mA2L5ze5qrZuGz
	 UlrnL56R32vVMs1LYKJWHvvLyLq1/l+DdlkXu+mBMEyZ69sZBL5k87N14vcM9mL5WzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ho5BVBHN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06248606A68F;
	Thu, 26 Nov 2026 15:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ho5BVBHN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8121F008B2;
	Thu, 26 Nov 2026 15:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705505;
	bh=q9dr5/UselDcdqOHjMrWZBlryct8GKnWH3+EMfwfyZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ho5BVBHNf7knNrBlyXQev/mW9lLnrQoQl+6sqJJwqh2CCzH4fvzvlR7WTLiD7hIs5
	 j6eI1iiKbRvxFe6Y1GNpGSvWEdr1dV1oBpjtW3F73ml4AE9i0Sbj/LicrOSIbFUQoo
	 flSeKMNj5F6zIsd5bPLEiVdgVL5Y+AfwYvXdaq8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.15 176/319] mmc: meson-gx: honour the busy timeout for R1b commands
Date: Thu, 26 Nov 2026 15:39:04 +0100
Message-ID: <20261126144010.719277783@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -850,7 +864,7 @@ static void meson_mmc_start_cmd(struct m
 		cmd_data = host->bounce_dma_addr & CMD_DATA_MASK;
 	} else {
 		cmd_cfg |= FIELD_PREP(CMD_CFG_TIMEOUT_MASK,
-				      ilog2(SD_EMMC_CMD_TIMEOUT));
+				      ilog2(meson_mmc_get_cmd_timeout_msecs(cmd)));
 	}
 
 	/* Last descriptor */



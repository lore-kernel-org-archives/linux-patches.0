Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEE21C68C;
	Sun,  1 Sep 2024 16:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208373; cv=none; b=tkbTQTOIIcA9kE/FWG7s7GIwEuUdAUVB0rop+9csv06ijaL9meLxeJWsbqJLNu/CC3A85GgpTfiqphWB01SZPG9t5gKxzS/k1SdPjlQdsdQEJ6L91n/2QFdgj7dF4GA+PPBsosOBDMipRtmDX1izikh8U7eFLLVBZv71x0Ltqsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208373; c=relaxed/simple;
	bh=Ao+FrCq7LK0LCKI8Lrvz6B6ElEIW9PjTFU0L/GTPzBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3Cf2F7O1nxK0LIBiGCwCNMmfu3qWc/rBRPoIyOePiPEu6pe7L9L77q3Wwmu5oN9O+b2KlaYjaJorZF++yMqKK66aAooyrw07Vp+//CQaYEXQ1s5EOOviTMoNqOMOm76pb+BeO/Y51+SBW5k/qLHndBbLzVnW1SJ8dt78Ye37Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GcRS0lbX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GcRS0lbX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A67BC4CEC3;
	Sun,  1 Sep 2024 16:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208373;
	bh=Ao+FrCq7LK0LCKI8Lrvz6B6ElEIW9PjTFU0L/GTPzBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GcRS0lbX2SvoUllXlxki73xuWnqxxmikdp7ycQoBavxfO7ExJpn/JSHWQuirvCeJr
	 m5mS4x23FkKFVEurzMdppPpHNv5ZlHK+t0ohbiy2DendswVUCth9ATI6n2K3m/SnhI
	 mMJsLFHjyI0ccPoe0KbCzPyEvXmg/0mYdMf7l+oE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 055/149] ASoC: SOF: amd: Fix for acp init sequence
Date: Sun,  1 Sep 2024 18:16:06 +0200
Message-ID: <20240901160819.538394234@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit a42db293e5983aa1508d12644f23d73f0553b32c ]

When ACP is not powered on by default, acp power on sequence explicitly
invoked by programming pgfsm control mask. The existing implementation
checks the same PGFSM status mask and programs the same PGFSM control mask
in all ACP variants which breaks acp power on sequence for ACP6.0 and
ACP6.3 variants. So to fix this issue, update ACP pgfsm control mask and
status mask based on acp descriptor rev field, which will vary based on
acp variant.

Fixes: 846aef1d7cc0 ("ASoC: SOF: amd: Add Renoir ACP HW support")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20240816070328.610360-1-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/acp.c | 19 +++++++++++++++++--
 sound/soc/sof/amd/acp.h |  7 +++++--
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/sound/soc/sof/amd/acp.c b/sound/soc/sof/amd/acp.c
index d95f865669a69..85b58c8ccd0da 100644
--- a/sound/soc/sof/amd/acp.c
+++ b/sound/soc/sof/amd/acp.c
@@ -433,6 +433,7 @@ static int acp_power_on(struct snd_sof_dev *sdev)
 	const struct sof_amd_acp_desc *desc = get_chip_info(sdev->pdata);
 	unsigned int base = desc->pgfsm_base;
 	unsigned int val;
+	unsigned int acp_pgfsm_status_mask, acp_pgfsm_cntl_mask;
 	int ret;
 
 	val = snd_sof_dsp_read(sdev, ACP_DSP_BAR, base + PGFSM_STATUS_OFFSET);
@@ -440,9 +441,23 @@ static int acp_power_on(struct snd_sof_dev *sdev)
 	if (val == ACP_POWERED_ON)
 		return 0;
 
-	if (val & ACP_PGFSM_STATUS_MASK)
+	switch (desc->rev) {
+	case 3:
+	case 5:
+		acp_pgfsm_status_mask = ACP3X_PGFSM_STATUS_MASK;
+		acp_pgfsm_cntl_mask = ACP3X_PGFSM_CNTL_POWER_ON_MASK;
+		break;
+	case 6:
+		acp_pgfsm_status_mask = ACP6X_PGFSM_STATUS_MASK;
+		acp_pgfsm_cntl_mask = ACP6X_PGFSM_CNTL_POWER_ON_MASK;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (val & acp_pgfsm_status_mask)
 		snd_sof_dsp_write(sdev, ACP_DSP_BAR, base + PGFSM_CONTROL_OFFSET,
-				  ACP_PGFSM_CNTL_POWER_ON_MASK);
+				  acp_pgfsm_cntl_mask);
 
 	ret = snd_sof_dsp_read_poll_timeout(sdev, ACP_DSP_BAR, base + PGFSM_STATUS_OFFSET, val,
 					    !val, ACP_REG_POLL_INTERVAL, ACP_REG_POLL_TIMEOUT_US);
diff --git a/sound/soc/sof/amd/acp.h b/sound/soc/sof/amd/acp.h
index 1af86b5b28db8..61b28df8c9081 100644
--- a/sound/soc/sof/amd/acp.h
+++ b/sound/soc/sof/amd/acp.h
@@ -25,8 +25,11 @@
 #define ACP_REG_POLL_TIMEOUT_US                 2000
 #define ACP_DMA_COMPLETE_TIMEOUT_US		5000
 
-#define ACP_PGFSM_CNTL_POWER_ON_MASK		0x01
-#define ACP_PGFSM_STATUS_MASK			0x03
+#define ACP3X_PGFSM_CNTL_POWER_ON_MASK		0x01
+#define ACP3X_PGFSM_STATUS_MASK			0x03
+#define ACP6X_PGFSM_CNTL_POWER_ON_MASK		0x07
+#define ACP6X_PGFSM_STATUS_MASK			0x0F
+
 #define ACP_POWERED_ON				0x00
 #define ACP_ASSERT_RESET			0x01
 #define ACP_RELEASE_RESET			0x00
-- 
2.43.0




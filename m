Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38341183CA3;
	Sun,  1 Sep 2024 16:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208071; cv=none; b=FZHYEhk5Z8TNXT6hGirSUjki0ozpy9lq6PiSHsdzhPDWACXZQILO6Agrt7ZVhA3VIcgZf5xaudChWd+eMozPXbQd9IQjR8sSjI2Lw7EKNDQ1zmO9cPX6QFo0ZB3ZzXyagTPlQDQN+RaDD+JdrzDqgTI7FvmwRNf1vhzHjAv6/Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208071; c=relaxed/simple;
	bh=FDBbWnCHmWDfL7t+O2VHTOchKQlqFbt+0Kl3N045Hiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XSYkPkEMd9yttug8m5f/edDzGbzH+IrvGlh6M1qzbl56qTtTB6imWskNkPY9QrtfGuge3Lk90C4ggF7s4sRWtMjgW3jIZGnWYSZrnzE6+fxSXV9xqCWhDr3Wx+e5HiB9mPq9XQEPKSFGA9VNb7da5AQh9JBzbzdmOjS72WyIpb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UjA8tPEn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UjA8tPEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99523C4CEC3;
	Sun,  1 Sep 2024 16:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208071;
	bh=FDBbWnCHmWDfL7t+O2VHTOchKQlqFbt+0Kl3N045Hiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UjA8tPEn/DFg8UeefFuCjd6LEjm5A+u8WsvmuwfZeDmfnOa/g7rgN70KrMQfVj+67
	 PpvzkIEL2CxvAzSK+0uDuL2TQelv743ZBbhph9wGPsOemMKXLS+1AIUYAl6a5PUa1D
	 B395ne3TYtnINgVyWZ6xfLagtx/pQjudjSdDHVq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 33/93] ASoC: SOF: amd: Fix for acp init sequence
Date: Sun,  1 Sep 2024 18:16:20 +0200
Message-ID: <20240901160808.607413533@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index add386f749ae9..bfed848de77c8 100644
--- a/sound/soc/sof/amd/acp.c
+++ b/sound/soc/sof/amd/acp.c
@@ -380,6 +380,7 @@ static int acp_power_on(struct snd_sof_dev *sdev)
 	const struct sof_amd_acp_desc *desc = get_chip_info(sdev->pdata);
 	unsigned int base = desc->pgfsm_base;
 	unsigned int val;
+	unsigned int acp_pgfsm_status_mask, acp_pgfsm_cntl_mask;
 	int ret;
 
 	val = snd_sof_dsp_read(sdev, ACP_DSP_BAR, base + PGFSM_STATUS_OFFSET);
@@ -387,9 +388,23 @@ static int acp_power_on(struct snd_sof_dev *sdev)
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
index 4dcceb7647694..133abed74f015 100644
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




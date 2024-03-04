Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04AE10A35;
	Mon,  4 Mar 2024 21:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587675; cv=none; b=Qi1QQQ0c1Q1qhPUCPgTSudAqMdoOICo0Qz6kNxddr2o2eqekhi3FNJxXkBWHrVJvhJkzL2Suw1wWuPUMJRFpKXmWwiFegj00JkjxAvWJhSvcKkP1rn9Vy7x6w1O3xZFUq1GjWSWw7KKWZLsyL4JDvG8r6AY7gvN+lh85Wnp3pGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587675; c=relaxed/simple;
	bh=RX9mim5+Kg/rX7bYvI2Mi4tefg4hiMPOeqL83NmsY/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLP+5gWQ+7/fG4fa3L7NRnF4HMJnh6NzEdKwzt65St2onQU6nUb0DBxWhRujABwAqhOLamfe3X78Nz6VuzrSKR4Uz6LRXoRZXo4bcbuhhzThzhHfItjhs8Q1dgG15jFVkKVBFk72DZZnvr60KsOQCXZK0BeJol4sGzLjdkQSv48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y5gxOsXd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y5gxOsXd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811CBC433F1;
	Mon,  4 Mar 2024 21:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587674;
	bh=RX9mim5+Kg/rX7bYvI2Mi4tefg4hiMPOeqL83NmsY/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y5gxOsXdAmxbL/nzQOSku2/CN8o7S8AGAUebc7KPXgcOj7TntO4LoDwGfCnlmloP9
	 1lpdOmYdqI+hIoH6yQNOUVBlurTpGUdQh/fOeSL3vP6KcvqOCu89bxPFSguRZTI4jC
	 kYNyBgTD9MdrVVTAMinRtkW08h+iT3+qAOpkRFyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 047/162] ASoC: cs35l56: Must clear HALO_STATE before issuing SYSTEM_RESET
Date: Mon,  4 Mar 2024 21:21:52 +0000
Message-ID: <20240304211553.358759426@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit e33625c84b75e4f078d7f9bf58f01fe71ab99642 ]

The driver must write 0 to HALO_STATE before sending the SYSTEM_RESET
command to the firmware.

HALO_STATE is in DSP memory, which is preserved across a soft reset.
The SYSTEM_RESET command does not change the value of HALO_STATE.
There is period of time while the CS35L56 is resetting, before the
firmware has started to boot, where a read of HALO_STATE will return
the value it had before the SYSTEM_RESET. If the driver does not
clear HALO_STATE, this would return BOOT_DONE status even though the
firmware has not booted.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 8a731fd37f8b ("ASoC: cs35l56: Move utility functions to shared file")
Link: https://msgid.link/r/20240216140535.1434933-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56-shared.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/cs35l56-shared.c b/sound/soc/codecs/cs35l56-shared.c
index 953ba066bab1e..fc99bc92aeace 100644
--- a/sound/soc/codecs/cs35l56-shared.c
+++ b/sound/soc/codecs/cs35l56-shared.c
@@ -286,6 +286,7 @@ void cs35l56_wait_min_reset_pulse(void)
 EXPORT_SYMBOL_NS_GPL(cs35l56_wait_min_reset_pulse, SND_SOC_CS35L56_SHARED);
 
 static const struct reg_sequence cs35l56_system_reset_seq[] = {
+	REG_SEQ0(CS35L56_DSP1_HALO_STATE, 0),
 	REG_SEQ0(CS35L56_DSP_VIRTUAL1_MBOX_1, CS35L56_MBOX_CMD_SYSTEM_RESET),
 };
 
-- 
2.43.0




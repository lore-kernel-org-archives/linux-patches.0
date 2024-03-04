Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC89A8F58;
	Mon,  4 Mar 2024 21:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588273; cv=none; b=CTEIROEPiueavZKGVgWk7wqktQ3k1Rsy+M5xlrzr84LlXqSht0enpcw6DgmnvtnRXmOqARvHVpt5LXVe3V4pYVRlUChYxoy7a/k4SaxDoAW0FhpBTTIeIOlQVQlvcY1+oSvc1JqkjyiEaSUH4tWKL8xzSuKnhDVbHWI4cUqSHmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588273; c=relaxed/simple;
	bh=n7g4DVu6NUzM+gbLlbNFCquxx3e3blrmENb2Qa/L6MM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFakrfQjYCaVgTCn3bfSC1opnFjUomO9bf4lnCWK0aND4S43GI62YaFMGVtYgwb4ERUZ8unPGYM4GIwDgdVFiSa1B+bC7NQMax0G/Fgq24iRprCp9QoIL0+z63+MPI40jI3wEcgrotuBnPmZYBzyMK/FxfOHmmG0TWMD8rkDgr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBw0c+cf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBw0c+cf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61138C433C7;
	Mon,  4 Mar 2024 21:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588273;
	bh=n7g4DVu6NUzM+gbLlbNFCquxx3e3blrmENb2Qa/L6MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBw0c+cftdI4zy7QUA7NN7lxsDuzT88RIAoH2oAroTSImb+Jryg2aZDwiohtFQYP9
	 Wj0R37bsjz5J+nvUcN5TZ1K1K+1IlaDFkR2QyY7a7C6E4QEOkxiJDo4mxsel3/yeCC
	 mTslf7x8Y6AXtXU/HS11m6YWU647y4vvOQxo4buE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/143] ASoC: cs35l56: Must clear HALO_STATE before issuing SYSTEM_RESET
Date: Mon,  4 Mar 2024 21:22:44 +0000
Message-ID: <20240304211551.336864707@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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
index 98b1e63360aeb..a925701f46fc6 100644
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




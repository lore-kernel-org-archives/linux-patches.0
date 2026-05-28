Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875782F260C;
	Thu, 28 May 2026 20:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999918; cv=none; b=TF6CJB8bxz9KeeOvnj8Jf/+HnjOh4LRxw1rK70hwvb/zJEKIv0BD0WqiugW3bG/YuTWyAuGdcdmgqwCmmArpO4GVcg/xtms1LaAtz2+D0cx/1u7/CfbD33K47F10dWL157jb7hQF5I2mv0wNHHqxGifSjqMpSM9KwJFENZ75jFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999918; c=relaxed/simple;
	bh=DGmnrGYiQ5WLmxf640YdoVq5gPWvXNaaHdnkoVR1uhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/2DdWhD4z6+OFLBfzFQbqtbDmvfqkv5ex1DV2peLPv4wTNKUjdp+LAoSTCfchKs5voCfoREpCeOj25Ggwr5RYwVaWePAgKgznelyfBUgSDR/41p+do6MYFsSt2gD/avZcRt7QriG+y43N4Zpfm6y6ofa2Wy2UXDc/N+4QEwrBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=olo5aR0S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="olo5aR0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E590D1F00A3E;
	Thu, 28 May 2026 20:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999917;
	bh=IJTsEyEEMCBIOmFpb6dJuvqokAKG4YrR0lCue1A9Wrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=olo5aR0S2xduhqu7ObTEB9EEnsiXtBALy1BPvlYEjujEldPTSSINGm1gteEDjOJlu
	 g++ZaHwnfxhXsTTF3k5a/k+M9m9UqP/eRrCDxMKgZH3Bddpg/MzoE5VDZuTzrDPeAV
	 lD/njHq0ZB5+B5f+n6XcmC1kMZqGlzpagTQfXXG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 230/377] ASoC: SOF: amd: Fix error code handling in psp_send_cmd()
Date: Thu, 28 May 2026 21:47:48 +0200
Message-ID: <20260528194645.050518712@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 2c7b1227e582e88db7917412dca4e752c1aff691 ]

The smn_read_register() helper returns negative error codes on failure
or the register value on success. When used with read_poll_timeout(),
the return value is stored in the 'data' variable.

Currently 'data' is declared as u32, which causes negative error codes
to be cast to large positive values. This makes the condition 'data > 0'
incorrectly treat errors as success.

Fix by changing 'data' from u32 to int, matching the pattern used in
psp_mbox_ready() which correctly handles the same helper function.

Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/linux-sound/agGES8vWrLOrBu28@stanley.mountain/
Fixes: f120cf33d232 ("ASoC: SOF: amd: Use AMD_NODE")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260511153638.724810-1-mario.limonciello@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/acp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/amd/acp.c b/sound/soc/sof/amd/acp.c
index 71a18f156de23..f615b8d1c8020 100644
--- a/sound/soc/sof/amd/acp.c
+++ b/sound/soc/sof/amd/acp.c
@@ -223,7 +223,7 @@ static int psp_send_cmd(struct acp_dev_data *adata, int cmd)
 {
 	struct snd_sof_dev *sdev = adata->dev;
 	int ret;
-	u32 data;
+	int data;
 
 	if (!cmd)
 		return -EINVAL;
-- 
2.53.0




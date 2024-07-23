Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A442156C6C;
	Tue, 23 Jul 2024 18:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759560; cv=none; b=lICwN8i1zGXqZslYkYE8nla93Zso2p9ZZ5X937eGs+a1M9tIPyo/TzoMsgfY+rV93EtgOG0E/dr4FklrRD571sU27hswc34vF+XIEq+Tg4pUUAVkLnqmd5jV7tr46ER1d06cZEqvrDzRDv4CWvOYRANT3BKoI8H/XeruNLpyvdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759560; c=relaxed/simple;
	bh=IrOdLK3F3gQM3E+J5zwpi1Kd6e9+CazzXVUG+X0Z820=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SuY2RuFuL1lsLWLL8nY/G1lrYq0WfZx0//1kueelUXUiTFfRAip+AGM2C3zKdvW0C6YtO0mI04yCBP8Klqd1SKxVincn9KLT+FqrJuevQjCVwnD8ZeX8ESfkihvNmsReE4z2L7+VEdUxvlLCSZ/1wGqstxdpuaQYmN3Qj1DQ2P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2rTUAMPj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2rTUAMPj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07ACDC4AF0A;
	Tue, 23 Jul 2024 18:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759560;
	bh=IrOdLK3F3gQM3E+J5zwpi1Kd6e9+CazzXVUG+X0Z820=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2rTUAMPjP9h2hT6DV0gmGknUpSpCMGJJOKHB8LEfDxzye3ckHI0EiDR2Mj+h+Q8hp
	 vKDVzkaZ042bmyjOBP1og2AN1NlowEip7h9HWBZfX6NB14OmyO847MJSsDnZPGthq0
	 qWfi07UYYbNsN6f1QUvzFZhE5cmpZNlAtjGZHyt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/129] ALSA: hda: cs35l56: Fix lifecycle of codec pointer
Date: Tue, 23 Jul 2024 20:23:19 +0200
Message-ID: <20240723180406.760310350@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

From: Simon Trimmer <simont@opensource.cirrus.com>

[ Upstream commit d339131bf02d4ed918415574082caf5e8af6e664 ]

The codec should be cleared when the amp driver is unbound and when
resuming it should be tested to prevent loading firmware into the device
and ALSA in a partially configured system state.

Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20240531112716.25323-1-simont@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l56_hda.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/pci/hda/cs35l56_hda.c b/sound/pci/hda/cs35l56_hda.c
index 78e2eeba49345..b84f3b3eb1409 100644
--- a/sound/pci/hda/cs35l56_hda.c
+++ b/sound/pci/hda/cs35l56_hda.c
@@ -702,6 +702,8 @@ static void cs35l56_hda_unbind(struct device *dev, struct device *master, void *
 	if (comps[cs35l56->index].dev == dev)
 		memset(&comps[cs35l56->index], 0, sizeof(*comps));
 
+	cs35l56->codec = NULL;
+
 	dev_dbg(cs35l56->base.dev, "Unbound\n");
 }
 
@@ -807,6 +809,9 @@ static int cs35l56_hda_system_resume(struct device *dev)
 
 	cs35l56->suspended = false;
 
+	if (!cs35l56->codec)
+		return 0;
+
 	ret = cs35l56_is_fw_reload_needed(&cs35l56->base);
 	dev_dbg(cs35l56->base.dev, "fw_reload_needed: %d\n", ret);
 	if (ret > 0) {
-- 
2.43.0




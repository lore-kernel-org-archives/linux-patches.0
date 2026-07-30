Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653E33806BD;
	Thu, 30 Jul 2026 15:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425693; cv=none; b=mDkPgl8jJh/c2kvsefpIOKu4YC+6bMY6v4UcNZuRzeBanwJ/O+jaU7qbJuJoVZJhJ8TDAGNhAiEDw1Qj2TJu6I6AK681soA3hlMyRnBpxD8z8vnUWVaQRrwpv9ryZTizYCVlGxwtZ/52NkOE4pEgLOTWkMCmRU8GP2eVRr843U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425693; c=relaxed/simple;
	bh=lRkf/AMPwZ5pj81RTSxwSr4jGfUzTfRBfivg95HOWd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXAVJh3lfGo7uNyu7ELmGGCxXmHB36I+AuZMJjo1sCv89DYemtf3DiX8+yP0yuEWWDhnkuhmq42UIXj9sOcREsMSsy+9BAckuLjWVUYn027N8qR3o+J1SnYVoYl3MDF1ktMBh1fOid2FqWPQhrW4humbnEpIU8OSSlyZje1/cTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XY3obtn2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XY3obtn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1D81F000E9;
	Thu, 30 Jul 2026 15:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425692;
	bh=m8EpPFN9bCPY/vxDYiTdTC8pqvGKHAVqitWkJA8VQKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XY3obtn2BvuTJygs80fb9SjpoY8P32VYmD4JDTd+OEvxY3gwKGWL9dEga5/uColS8
	 aau3i+vKb+atP5Yx+ChlSmjSP1R5+Q/7kn98DJlkghm36rWmcGjV5aPcjo2/Ihi2j/
	 ZJT8TpV0vS4z3b0WiBW/UrfHP9VW5G8aiPUXR4HQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 158/602] ASoC: cs35l56: Dont use devres to unregister component
Date: Thu, 30 Jul 2026 16:09:10 +0200
Message-ID: <20260730141439.293229600@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit bee87cf0f1248c0f20710d7a79df41fe892d9f88 ]

Manually call snd_soc_unregister_component() from cs35l56_remove()
instead of using devres cleanup. This ensures that the component is
destroyed before cs35l56_remove() starts cleanup of anything the
component code could be using.

Devres cleanup happens after the driver remove() callback, so if
snd_soc_register_component() is used, it will not be destroyed until
after cs35l56_remove() has returned. But there is some cleanup that
must be done in cs35l56_remove(), or wrapped in a custom devres
cleanup handler to ensure correct ordering. The simplest option is
to call snd_soc_unregister_component() at the start of cs35l56_remove().

Fixes: e49611252900 ("ASoC: cs35l56: Add driver for Cirrus Logic CS35L56")
Closes: https://sashiko.dev/#/patchset/20260501103002.2843735-1-rf%40opensource.cirrus.com
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260505161124.3621000-2-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 93c2a8ea2454 ("ASoC: cs35l56: Fix potential probe() deadlock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/cs35l56.c b/sound/soc/codecs/cs35l56.c
index c78f7f95f127d0..ee5357ac0ceab5 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -1330,9 +1330,9 @@ int cs35l56_common_probe(struct cs35l56_private *cs35l56)
 		goto err;
 	}
 
-	ret = devm_snd_soc_register_component(cs35l56->base.dev,
-					      &soc_component_dev_cs35l56,
-					      cs35l56_dai, ARRAY_SIZE(cs35l56_dai));
+	ret = snd_soc_register_component(cs35l56->base.dev,
+					 &soc_component_dev_cs35l56,
+					 cs35l56_dai, ARRAY_SIZE(cs35l56_dai));
 	if (ret < 0) {
 		dev_err_probe(cs35l56->base.dev, ret, "Register codec failed\n");
 		goto err_remove_wm_adsp;
@@ -1434,6 +1434,8 @@ EXPORT_SYMBOL_NS_GPL(cs35l56_init, SND_SOC_CS35L56_CORE);
 
 void cs35l56_remove(struct cs35l56_private *cs35l56)
 {
+	snd_soc_unregister_component(cs35l56->base.dev);
+
 	cs35l56->base.init_done = false;
 
 	/*
-- 
2.53.0




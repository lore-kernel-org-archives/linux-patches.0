Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD03745DF6C;
	Thu, 30 Jul 2026 16:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427440; cv=none; b=gK8DEBTnw9KYYHVOOEj2piKSoPm4D3f5vtD09hTg6XbOXTVLU4kOg+1uC+f5/+s5tY8X9Ky+9KWuLi1iJa+HmTWJ4zG8vVKv0faEwR3rQUlYQjlMqRBr5ehKjEixR+2+/tJBVZTDAzdziKPDiiMNJucuoInm5dR2P0Q42qR0KHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427440; c=relaxed/simple;
	bh=7CZ7qOyg//MYCsfIgyZxVyiNRFgFedlqDopsXqkoLOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctMm5RqEEmeT8AAR5GyUovREynijNuORUn/pBZTapIuyDegu8IAH3IyQXP3Dhaykm5fyz8wQEfZrKhRJfRJ/NTUCgcEfJsHjjLXtyG8PaWXrKGLxc3vROC0YtDCoUkh1uWlYyJh/DjcvlE5V66a1BeogzmQ/MovTIeTu8XTqq68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FoLAs/XN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FoLAs/XN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049F01F00A3A;
	Thu, 30 Jul 2026 16:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427439;
	bh=fGcfuGmVpVnvidn1Cf+9SDfVsVB+7iZWTDfECy2bwIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FoLAs/XNBZqEKkoYfgGRsXIJDK/RfCh4z/0bvaRUbI3nfR06t4eWEkvQ74NGlPkNe
	 Qut/lIHRZwgl0ASe3/XRV6DtZtxhjVp1tY7/dPGyg0ifyg78wWPjGSfgrJ8OaomWZ7
	 bc0N8DTQ34Qkwdzv4Czu1oEzaRrsJNEVKCVaFO6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 134/484] ASoC: cs35l56: Dont use devres to unregister component
Date: Thu, 30 Jul 2026 16:10:31 +0200
Message-ID: <20260730141426.368813406@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 832ff2cd3d24e9..b581e8f1576634 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -1318,9 +1318,9 @@ int cs35l56_common_probe(struct cs35l56_private *cs35l56)
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
@@ -1416,6 +1416,8 @@ EXPORT_SYMBOL_NS_GPL(cs35l56_init, SND_SOC_CS35L56_CORE);
 
 void cs35l56_remove(struct cs35l56_private *cs35l56)
 {
+	snd_soc_unregister_component(cs35l56->base.dev);
+
 	cs35l56->base.init_done = false;
 
 	/*
-- 
2.53.0




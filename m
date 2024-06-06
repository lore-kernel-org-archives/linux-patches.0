Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E261C68BF;
	Thu,  6 Jun 2024 14:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683700; cv=none; b=EHYrJwHW33YMFwFBa4try6CWtZjftNLA5aagT0VqfT4Ln3pc6IV0Oxny+8jE/Ip2iAb3KHqHzdx2bxwYOT55GxMyDxSc8esSV8VMNZoUROmzBxVqMFZ0vQM9OHeFbKaLyAjvQhQWifnu+3bNyHCzyR9J7mCwT8LmafYEkb/tkYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683700; c=relaxed/simple;
	bh=x+rrnpRa1hMj4sucEFwz2ZUbmRPPjL2s/gLymw/+JvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cf5+q1mlh0iXQzXIjvT5dYpKxwsc2F0NjZtLEKu2JHxaBzm3UIASRR1mwoZU5HZfKv29jR4QssFGMcRedjCUS/WLy8x+BolqFNOGK5XyB+3XaMPudjmFgzcodbNrf9hmb9KqKq1vm6ICkNrmyjKlW79mJ7s2RvG+G8VoBzzbrUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1DhdXX/3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1DhdXX/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00208C32781;
	Thu,  6 Jun 2024 14:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683700;
	bh=x+rrnpRa1hMj4sucEFwz2ZUbmRPPjL2s/gLymw/+JvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1DhdXX/3wLhP69IokSRinWTSFZrWOhjCGI4HKWLe2MAyGV5KUWsfUf1gZcd2t1dL2
	 ZCqVZrwl7m1711yYkZmr/HDhi6NB8auZ95AWtf+abSyxgpnUinLy8A7HFFvhAnYlj9
	 LomcyyynqKUw6M+pckP7NZGuB46RibgkRjmuWFek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 621/744] ALSA: hda: cs35l56: Fix lifetime of cs_dsp instance
Date: Thu,  6 Jun 2024 16:04:53 +0200
Message-ID: <20240606131752.417738960@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

[ Upstream commit d344873c4cbde249b7152d36a273bcc45864001e ]

The cs_dsp instance is initialized in the driver probe() so it
should be freed in the driver remove(). Also fix a missing call
to cs_dsp_remove() in the error path of cs35l56_hda_common_probe().

The call to cs_dsp_remove() was being done in the component unbind
callback cs35l56_hda_unbind(). This meant that if the driver was
unbound and then re-bound it would be using an uninitialized cs_dsp
instance.

It is best to initialize the cs_dsp instance in probe() so that it
can return an error if it fails. The component binding API doesn't
have any error handling so there's no way to handle a failure if
cs_dsp was initialized in the bind.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 73cfbfa9caea ("ALSA: hda/cs35l56: Add driver for Cirrus Logic CS35L56 amplifier")
Link: https://lore.kernel.org/r/20240508100811.49514-1-rf@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l56_hda.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/pci/hda/cs35l56_hda.c b/sound/pci/hda/cs35l56_hda.c
index e599b287f0961..15e20d9261393 100644
--- a/sound/pci/hda/cs35l56_hda.c
+++ b/sound/pci/hda/cs35l56_hda.c
@@ -699,8 +699,6 @@ static void cs35l56_hda_unbind(struct device *dev, struct device *master, void *
 	if (cs35l56->base.fw_patched)
 		cs_dsp_power_down(&cs35l56->cs_dsp);
 
-	cs_dsp_remove(&cs35l56->cs_dsp);
-
 	if (comps[cs35l56->index].dev == dev)
 		memset(&comps[cs35l56->index], 0, sizeof(*comps));
 
@@ -984,7 +982,7 @@ int cs35l56_hda_common_probe(struct cs35l56_hda *cs35l56, int id)
 			       ARRAY_SIZE(cs35l56_hda_dai_config));
 	ret = cs35l56_force_sync_asp1_registers_from_cache(&cs35l56->base);
 	if (ret)
-		goto err;
+		goto dsp_err;
 
 	/*
 	 * By default only enable one ASP1TXn, where n=amplifier index,
@@ -1010,6 +1008,8 @@ int cs35l56_hda_common_probe(struct cs35l56_hda *cs35l56, int id)
 
 pm_err:
 	pm_runtime_disable(cs35l56->base.dev);
+dsp_err:
+	cs_dsp_remove(&cs35l56->cs_dsp);
 err:
 	gpiod_set_value_cansleep(cs35l56->base.reset_gpio, 0);
 
@@ -1027,6 +1027,8 @@ void cs35l56_hda_remove(struct device *dev)
 
 	component_del(cs35l56->base.dev, &cs35l56_hda_comp_ops);
 
+	cs_dsp_remove(&cs35l56->cs_dsp);
+
 	kfree(cs35l56->system_name);
 	pm_runtime_put_noidle(cs35l56->base.dev);
 
-- 
2.43.0




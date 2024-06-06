Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05496197A83;
	Thu,  6 Jun 2024 14:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683009; cv=none; b=AiBXfNXdo24zzHcvxn/T3JRG8Sg4qEAhHHiluypqLptc1SFhq8XQB18WR1SBnxfbk/M7/sYq8oG4CQQff1m9AisX/42Bf/FNQiWanJHbEv0qCJhAR627vOxOyjy5XJYUr2msUKBz1YuzexPh0j/BtMnAoFisLYo+HgipMJGbhOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683009; c=relaxed/simple;
	bh=O33p3S69pxrSySDTJUofm4brNMdZeXSGdQ6MDoGzJWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OF+VLWW9rCa1yGzqXuC/vVwUP7vOkoNzEbCbZOhL4XiWAvq9JHccGi/tzzUCzdVDfV694hbrEPQdQA3A7H9ujsctieTjXsvKfHZhBwEJ8acrlUlgTkhzXWXfQKOvwyMbEgRM5VeaDP6GFxZZquEebBbhV7dPQ/TTtScBloX0kfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZ/VHyZ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZ/VHyZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC0EC4AF15;
	Thu,  6 Jun 2024 14:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683008;
	bh=O33p3S69pxrSySDTJUofm4brNMdZeXSGdQ6MDoGzJWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZ/VHyZ0OA/Dox/pf611YRJeGPeGnD7ibT/VEmzZfRlRWpBfYQbdsmI8q8S+M4G4D
	 5ZtC7ymcRw2THYkav0df9gtFBeHnVI9+dr+VeVvKzgUcE9OFLhWESAAflr91PbVUK7
	 jxoAXLEHzyUhpViuZCKyuae9v9B+jS604QrxwoZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 218/374] ALSA: hda: cs35l56: Fix lifetime of cs_dsp instance
Date: Thu,  6 Jun 2024 16:03:17 +0200
Message-ID: <20240606131659.100743679@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 558c1f38fe971..11b0570ff56d4 100644
--- a/sound/pci/hda/cs35l56_hda.c
+++ b/sound/pci/hda/cs35l56_hda.c
@@ -732,8 +732,6 @@ static void cs35l56_hda_unbind(struct device *dev, struct device *master, void *
 	if (cs35l56->base.fw_patched)
 		cs_dsp_power_down(&cs35l56->cs_dsp);
 
-	cs_dsp_remove(&cs35l56->cs_dsp);
-
 	if (comps[cs35l56->index].dev == dev)
 		memset(&comps[cs35l56->index], 0, sizeof(*comps));
 
@@ -1035,7 +1033,7 @@ int cs35l56_hda_common_probe(struct cs35l56_hda *cs35l56, int hid, int id)
 			       ARRAY_SIZE(cs35l56_hda_dai_config));
 	ret = cs35l56_force_sync_asp1_registers_from_cache(&cs35l56->base);
 	if (ret)
-		goto err;
+		goto dsp_err;
 
 	/*
 	 * By default only enable one ASP1TXn, where n=amplifier index,
@@ -1061,6 +1059,8 @@ int cs35l56_hda_common_probe(struct cs35l56_hda *cs35l56, int hid, int id)
 
 pm_err:
 	pm_runtime_disable(cs35l56->base.dev);
+dsp_err:
+	cs_dsp_remove(&cs35l56->cs_dsp);
 err:
 	gpiod_set_value_cansleep(cs35l56->base.reset_gpio, 0);
 
@@ -1078,6 +1078,8 @@ void cs35l56_hda_remove(struct device *dev)
 
 	component_del(cs35l56->base.dev, &cs35l56_hda_comp_ops);
 
+	cs_dsp_remove(&cs35l56->cs_dsp);
+
 	kfree(cs35l56->system_name);
 	pm_runtime_put_noidle(cs35l56->base.dev);
 
-- 
2.43.0




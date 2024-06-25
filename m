Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE98513C90B;
	Tue, 25 Jun 2024 09:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308406; cv=none; b=jJ6uMqi52L0HX86cz7T/vSk0aW4zQN9EucR4aeG1gKNJH1oS41I+Nmu1l/cNONVwj8Tjt45lA95rOhNwoclOojs+5iGafMSmSFq4SnlxA1xS0K/NYL/dnOSCh63D4yH7Yax78wwV2sYaqEpvjJ5DIF0jqyxh54+gCLKPdrjZKQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308406; c=relaxed/simple;
	bh=l7tPMYwJN2M8OcsUfKMsIfMhvDYojyQmlj0RJSYm3qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqjP9sO9Lpmzd7HpfiCXN0tGIS0IQN4ApKkJgjN35mqIeaTweTYbliRvbYsO8ivD10QZXmeDjko23C1SN/ntOeWhgqxt/0HxNR64lkm5pZJufoLZc3RzE6/ySwcaXaGqwgRAIFn8cjGmVrVA+0fDGWnFxwQfMrtuvHn7kz5iXM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2ATMDNJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2ATMDNJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD20C32781;
	Tue, 25 Jun 2024 09:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308406;
	bh=l7tPMYwJN2M8OcsUfKMsIfMhvDYojyQmlj0RJSYm3qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W2ATMDNJahjHclGhfVGiF2CHdg9LX5xbB7pY1h1ukPv0ds7fveKlOM4cxilRuMR+c
	 3/gy4R1Q9hRbdWzc6z/rMVTxHZIgwrSiLyQZhWpMwnVbxjameE2L38N625hf6c/+Ma
	 rm3zLsz+Tz8RKmWbhryeNpzTyb1TOeZ1IBiX/AvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 111/250] ALSA: hda: cs35l56: Component should be unbound before deconstruction
Date: Tue, 25 Jun 2024 11:31:09 +0200
Message-ID: <20240625085552.333415312@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

From: Simon Trimmer <simont@opensource.cirrus.com>

[ Upstream commit 721f2e6653f5ab0cc52b3a459c4a2158b92fcf80 ]

The interface associated with the hda_component should be deactivated
before the driver is deconstructed during removal.

Fixes: 73cfbfa9caea ("ALSA: hda/cs35l56: Add driver for Cirrus Logic CS35L56 amplifier")
Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20240613133713.75550-2-simont@opensource.cirrus.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l56_hda.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/cs35l56_hda.c b/sound/pci/hda/cs35l56_hda.c
index 11b0570ff56d4..6b77c38a0e155 100644
--- a/sound/pci/hda/cs35l56_hda.c
+++ b/sound/pci/hda/cs35l56_hda.c
@@ -1072,12 +1072,12 @@ void cs35l56_hda_remove(struct device *dev)
 {
 	struct cs35l56_hda *cs35l56 = dev_get_drvdata(dev);
 
+	component_del(cs35l56->base.dev, &cs35l56_hda_comp_ops);
+
 	pm_runtime_dont_use_autosuspend(cs35l56->base.dev);
 	pm_runtime_get_sync(cs35l56->base.dev);
 	pm_runtime_disable(cs35l56->base.dev);
 
-	component_del(cs35l56->base.dev, &cs35l56_hda_comp_ops);
-
 	cs_dsp_remove(&cs35l56->cs_dsp);
 
 	kfree(cs35l56->system_name);
-- 
2.43.0




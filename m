Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54963EA97
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1EHfEZCB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DDDC433C8;
	Wed, 15 Nov 2023 19:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076471;
	bh=eh1bWmoANyz79YhE5xdaAmDHSrANpUa8h3rMfxMU47A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1EHfEZCBCZP4PCN4HsryySKfMhBREUaf2M09KyCxMACXGkPD6doOvDuuljI6dC11A
	 hY0703Gxwmb+yLA3gRNpR9DCD+3gvhRgIGxleckCZLPCZjNVlYeLcpkxouFcoL4xfl
	 WY+SAjcT3gcjMeDfy5p3F4NeV1myLNx/oV6M8cn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 310/550] ALSA: hda: cs35l41: Undo runtime PM changes at driver exit time
Date: Wed, 15 Nov 2023 14:14:54 -0500
Message-ID: <20231115191622.312785923@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 85a1bf86fac0c195929768b4e92c78cad107523b ]

According to the documentation, drivers are responsible for undoing at
removal time all runtime PM changes done during probing.

Hence, add the missing calls to pm_runtime_dont_use_autosuspend(), which
are necessary for undoing pm_runtime_use_autosuspend().

Fixes: 1873ebd30cc8 ("ALSA: hda: cs35l41: Support Hibernation during Suspend")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20230907171010.1447274-11-cristian.ciocaltea@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l41_hda.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/cs35l41_hda.c b/sound/pci/hda/cs35l41_hda.c
index f9ce8567d068f..297ba795c71b9 100644
--- a/sound/pci/hda/cs35l41_hda.c
+++ b/sound/pci/hda/cs35l41_hda.c
@@ -1547,6 +1547,7 @@ int cs35l41_hda_probe(struct device *dev, const char *device_name, int id, int i
 	return 0;
 
 err_pm:
+	pm_runtime_dont_use_autosuspend(cs35l41->dev);
 	pm_runtime_disable(cs35l41->dev);
 	pm_runtime_put_noidle(cs35l41->dev);
 
@@ -1565,6 +1566,7 @@ void cs35l41_hda_remove(struct device *dev)
 	struct cs35l41_hda *cs35l41 = dev_get_drvdata(dev);
 
 	pm_runtime_get_sync(cs35l41->dev);
+	pm_runtime_dont_use_autosuspend(cs35l41->dev);
 	pm_runtime_disable(cs35l41->dev);
 
 	if (cs35l41->halo_initialized)
-- 
2.42.0




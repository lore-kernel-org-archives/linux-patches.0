Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B981E3C462
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ze5KS9Yx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677C5C433C7;
	Wed, 15 Nov 2023 19:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077490;
	bh=ir6H2/ITInqR0NdlojyeJGzoS9S7QpZ8YdKThMruzsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ze5KS9Yx7SbtsjbVmal85uGEQMHzxHojwtABJVhbpaHh6TegTxm1T79nGG1NzzbUO
	 m/ybsvn1GoLge+nkYc24qtrBbJVuqUy/z6oaMKiRts1hv/SdHARNKIFSs9yHuHS7fh
	 +qFhVtsY4kXqMdkQOANCvzGy7P8XIKO+CFSGXtSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 335/603] ALSA: hda: cs35l41: Fix unbalanced pm_runtime_get()
Date: Wed, 15 Nov 2023 14:14:40 -0500
Message-ID: <20231115191636.704331525@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 486465508f8a5fe441939a7d97607f4460a60891 ]

If component_add() fails, probe() returns without calling
pm_runtime_put(), which leaves the runtime PM usage counter incremented.

Fix the issue by jumping to err_pm label and drop the now unnecessary
pm_runtime_disable() call.

Fixes: 7b2f3eb492da ("ALSA: hda: cs35l41: Add support for CS35L41 in HDA systems")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20230907171010.1447274-10-cristian.ciocaltea@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l41_hda.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/pci/hda/cs35l41_hda.c b/sound/pci/hda/cs35l41_hda.c
index 055ebfc237352..ebf9ddbb26052 100644
--- a/sound/pci/hda/cs35l41_hda.c
+++ b/sound/pci/hda/cs35l41_hda.c
@@ -1668,8 +1668,7 @@ int cs35l41_hda_probe(struct device *dev, const char *device_name, int id, int i
 	ret = component_add(cs35l41->dev, &cs35l41_hda_comp_ops);
 	if (ret) {
 		dev_err(cs35l41->dev, "Register component failed: %d\n", ret);
-		pm_runtime_disable(cs35l41->dev);
-		goto err;
+		goto err_pm;
 	}
 
 	dev_info(cs35l41->dev, "Cirrus Logic CS35L41 (%x), Revision: %02X\n", regid, reg_revid);
-- 
2.42.0




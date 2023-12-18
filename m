Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27AD498A5;
	Mon, 18 Dec 2023 14:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HibILd5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170BCC433C7;
	Mon, 18 Dec 2023 14:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908152;
	bh=HQiph81ZCQJci884uXhvr0dKiQu1oD+ncMr7OM1wU+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HibILd5nr0euAppXPoN4X1lYfBIq5YGZlhkx/yCCziniqU1xNpd9PVTHKZFtO8RlI
	 zb87ff9dGc102VqXx3PFp4eCQ0lcOhfOmZEAo1vEYnmeE0z7XKxa7/IZHC0Q2LxK8V
	 L3EYiKQ5HWi7/V5GEo+/M4+zb9TMLfeCDC1iBhUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 072/166] ALSA: hda/tas2781: reset the amp before component_add
Date: Mon, 18 Dec 2023 14:50:38 +0100
Message-ID: <20231218135108.277664451@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

From: Gergo Koteles <soyer@irl.hu>

commit 315deab289924c83ab1ded50022e8db95d6e428b upstream.

Calling component_add starts loading the firmware, the callback function
writes the program to the amplifiers. If the module resets the
amplifiers after component_add, it happens that one of the amplifiers
does not work because the reset and program writing are interleaving.

Call tas2781_reset before component_add to ensure reliable
initialization.

Fixes: 5be27f1e3ec9 ("ALSA: hda/tas2781: Add tas2781 HDA driver")
CC: stable@vger.kernel.org
Signed-off-by: Gergo Koteles <soyer@irl.hu>
Link: https://lore.kernel.org/r/4d23bf58558e23ee8097de01f70f1eb8d9de2d15.1702511246.git.soyer@irl.hu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/tas2781_hda_i2c.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/tas2781_hda_i2c.c b/sound/pci/hda/tas2781_hda_i2c.c
index c8ee5f809c38..63a90c7e8976 100644
--- a/sound/pci/hda/tas2781_hda_i2c.c
+++ b/sound/pci/hda/tas2781_hda_i2c.c
@@ -674,14 +674,14 @@ static int tas2781_hda_i2c_probe(struct i2c_client *clt)
 
 	pm_runtime_put_autosuspend(tas_priv->dev);
 
+	tas2781_reset(tas_priv);
+
 	ret = component_add(tas_priv->dev, &tas2781_hda_comp_ops);
 	if (ret) {
 		dev_err(tas_priv->dev, "Register component failed: %d\n", ret);
 		pm_runtime_disable(tas_priv->dev);
-		goto err;
 	}
 
-	tas2781_reset(tas_priv);
 err:
 	if (ret)
 		tas2781_hda_remove(&clt->dev);
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B787711C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C0CC433C8;
	Mon, 28 Aug 2023 10:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218967;
	bh=6f2vA28Eio8sU8aQsIeik7JtD46rJO7feLcniIUMypo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gLXyxlRdHASfT/n7VLLJwNafqlCoIq3iffdU1tq/OgdO5NILVu87BrH5QD13rTwUH
	 OvXZuc5fToxHO7l+p7Ax0IxIDjTiwXhwpptQhHWOmq0pKNp/OlkURS6oaUV87mE1xP
	 y1kM+7e3NrrfzZI7DCjIDjzBvjismrgDMO9TkaAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	BassCheck <bass@buaa.edu.cn>,
	Tuo Li <islituo@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 025/158] ALSA: hda: fix a possible null-pointer dereference due to data race in snd_hdac_regmap_sync()
Date: Mon, 28 Aug 2023 12:12:02 +0200
Message-ID: <20230828101158.197678661@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
References: <20230828101157.322319621@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tuo Li <islituo@gmail.com>

[ Upstream commit 1f4a08fed450db87fbb5ff5105354158bdbe1a22 ]

The variable codec->regmap is often protected by the lock
codec->regmap_lock when is accessed. However, it is accessed without
holding the lock when is accessed in snd_hdac_regmap_sync():

  if (codec->regmap)

In my opinion, this may be a harmful race, because if codec->regmap is
set to NULL right after the condition is checked, a null-pointer
dereference can occur in the called function regcache_sync():

  map->lock(map->lock_arg); --> Line 360 in drivers/base/regmap/regcache.c

To fix this possible null-pointer dereference caused by data race, the
mutex_lock coverage is extended to protect the if statement as well as the
function call to regcache_sync().

[ Note: the lack of the regmap_lock itself is harmless for the current
  codec driver implementations, as snd_hdac_regmap_sync() is only for
  PM runtime resume that is prohibited during the codec probe.
  But the change makes the whole code more consistent, so it's merged
  as is -- tiwai ]

Reported-by: BassCheck <bass@buaa.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
Link: https://lore.kernel.org/r/20230703031016.1184711-1-islituo@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/hdac_regmap.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/sound/hda/hdac_regmap.c b/sound/hda/hdac_regmap.c
index 49780399c2849..a035a7d74ce09 100644
--- a/sound/hda/hdac_regmap.c
+++ b/sound/hda/hdac_regmap.c
@@ -596,10 +596,9 @@ EXPORT_SYMBOL_GPL(snd_hdac_regmap_update_raw_once);
  */
 void snd_hdac_regmap_sync(struct hdac_device *codec)
 {
-	if (codec->regmap) {
-		mutex_lock(&codec->regmap_lock);
+	mutex_lock(&codec->regmap_lock);
+	if (codec->regmap)
 		regcache_sync(codec->regmap);
-		mutex_unlock(&codec->regmap_lock);
-	}
+	mutex_unlock(&codec->regmap_lock);
 }
 EXPORT_SYMBOL_GPL(snd_hdac_regmap_sync);
-- 
2.40.1




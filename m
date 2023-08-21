Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942F41171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:02:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1624BC433C7;
	Mon, 21 Aug 2023 20:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648152;
	bh=cRTc8eRyLHrtCb90g9KlXfs0GJ+1q7rJi62JBEFsFQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H1X1SInKiSb7YMp5AWPE5Tr0BEGfJ/ij/aCvn27+yH+u8sF27ikh8r4JpyFxKGvWR
	 76rHL1+xKSzRL9ZPSMAVzNkQXNfFbVvfeN7i5i/OUWgEAFACN1EnbHznFEeIEHxxzk
	 41nolz4zbPhzOGMoQFzVUtcm6xy6NxjbMexvrfiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	BassCheck <bass@buaa.edu.cn>,
	Tuo Li <islituo@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 074/234] ALSA: hda: fix a possible null-pointer dereference due to data race in snd_hdac_regmap_sync()
Date: Mon, 21 Aug 2023 21:40:37 +0200
Message-ID: <20230821194132.050231426@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
index fe3587547cfec..39610a15bcc98 100644
--- a/sound/hda/hdac_regmap.c
+++ b/sound/hda/hdac_regmap.c
@@ -597,10 +597,9 @@ EXPORT_SYMBOL_GPL(snd_hdac_regmap_update_raw_once);
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




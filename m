Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278556FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361F1C433C7;
	Sun, 17 Sep 2023 19:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694978434;
	bh=SSsuwjGufr9hYPluTV8kpTmc3OvtrcM5D7DLQ34fa1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kYXfwm6gd/hr9hAXknD3b7f027BtDqBuuv07VnkM0uh56zMISYnnsOfaLxDDQcP9O
	 YuqjdDZ3JuKkvmDqN2hZJkm+sEAsxPes+C1pF1AqvPQIp7ehIjeWtLWJu9uiP9clb6
	 U7jzFeno/GUUvoqIPayKXWLhx6ESphjOJmKkcaqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gong, Sishuai" <sishuai@purdue.edu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/406] ALSA: seq: oss: Fix racy open/close of MIDI devices
Date: Sun, 17 Sep 2023 21:08:32 +0200
Message-ID: <20230917191102.678199057@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 297224fc0922e7385573a30c29ffdabb67f27b7d ]

Although snd_seq_oss_midi_open() and snd_seq_oss_midi_close() can be
called concurrently from different code paths, we have no proper data
protection against races.  Introduce open_mutex to each seq_oss_midi
object for avoiding the races.

Reported-by: "Gong, Sishuai" <sishuai@purdue.edu>
Closes: https://lore.kernel.org/r/7DC9AF71-F481-4ABA-955F-76C535661E33@purdue.edu
Link: https://lore.kernel.org/r/20230612125533.27461-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/oss/seq_oss_midi.c | 35 +++++++++++++++++++------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/sound/core/seq/oss/seq_oss_midi.c b/sound/core/seq/oss/seq_oss_midi.c
index f73ee0798aeab..be80ce72e0c72 100644
--- a/sound/core/seq/oss/seq_oss_midi.c
+++ b/sound/core/seq/oss/seq_oss_midi.c
@@ -37,6 +37,7 @@ struct seq_oss_midi {
 	struct snd_midi_event *coder;	/* MIDI event coder */
 	struct seq_oss_devinfo *devinfo;	/* assigned OSSseq device */
 	snd_use_lock_t use_lock;
+	struct mutex open_mutex;
 };
 
 
@@ -171,6 +172,7 @@ snd_seq_oss_midi_check_new_port(struct snd_seq_port_info *pinfo)
 	mdev->flags = pinfo->capability;
 	mdev->opened = 0;
 	snd_use_lock_init(&mdev->use_lock);
+	mutex_init(&mdev->open_mutex);
 
 	/* copy and truncate the name of synth device */
 	strlcpy(mdev->name, pinfo->name, sizeof(mdev->name));
@@ -319,14 +321,16 @@ snd_seq_oss_midi_open(struct seq_oss_devinfo *dp, int dev, int fmode)
 	int perm;
 	struct seq_oss_midi *mdev;
 	struct snd_seq_port_subscribe subs;
+	int err;
 
 	if ((mdev = get_mididev(dp, dev)) == NULL)
 		return -ENODEV;
 
+	mutex_lock(&mdev->open_mutex);
 	/* already used? */
 	if (mdev->opened && mdev->devinfo != dp) {
-		snd_use_lock_free(&mdev->use_lock);
-		return -EBUSY;
+		err = -EBUSY;
+		goto unlock;
 	}
 
 	perm = 0;
@@ -336,14 +340,14 @@ snd_seq_oss_midi_open(struct seq_oss_devinfo *dp, int dev, int fmode)
 		perm |= PERM_READ;
 	perm &= mdev->flags;
 	if (perm == 0) {
-		snd_use_lock_free(&mdev->use_lock);
-		return -ENXIO;
+		err = -ENXIO;
+		goto unlock;
 	}
 
 	/* already opened? */
 	if ((mdev->opened & perm) == perm) {
-		snd_use_lock_free(&mdev->use_lock);
-		return 0;
+		err = 0;
+		goto unlock;
 	}
 
 	perm &= ~mdev->opened;
@@ -368,13 +372,17 @@ snd_seq_oss_midi_open(struct seq_oss_devinfo *dp, int dev, int fmode)
 	}
 
 	if (! mdev->opened) {
-		snd_use_lock_free(&mdev->use_lock);
-		return -ENXIO;
+		err = -ENXIO;
+		goto unlock;
 	}
 
 	mdev->devinfo = dp;
+	err = 0;
+
+ unlock:
+	mutex_unlock(&mdev->open_mutex);
 	snd_use_lock_free(&mdev->use_lock);
-	return 0;
+	return err;
 }
 
 /*
@@ -388,10 +396,9 @@ snd_seq_oss_midi_close(struct seq_oss_devinfo *dp, int dev)
 
 	if ((mdev = get_mididev(dp, dev)) == NULL)
 		return -ENODEV;
-	if (! mdev->opened || mdev->devinfo != dp) {
-		snd_use_lock_free(&mdev->use_lock);
-		return 0;
-	}
+	mutex_lock(&mdev->open_mutex);
+	if (!mdev->opened || mdev->devinfo != dp)
+		goto unlock;
 
 	memset(&subs, 0, sizeof(subs));
 	if (mdev->opened & PERM_WRITE) {
@@ -410,6 +417,8 @@ snd_seq_oss_midi_close(struct seq_oss_devinfo *dp, int dev)
 	mdev->opened = 0;
 	mdev->devinfo = NULL;
 
+ unlock:
+	mutex_unlock(&mdev->open_mutex);
 	snd_use_lock_free(&mdev->use_lock);
 	return 0;
 }
-- 
2.40.1




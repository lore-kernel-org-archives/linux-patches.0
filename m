Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490E72BAF7;
	Wed, 25 Feb 2026 01:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983052; cv=none; b=pO6XjKKZ+BllRdzJBYPb+7elyoOeth75v4XB4jEArGhrUJrXa3+9rcSrvTcelYyUVYgKcRWzrXY18wNM2NU0aSTUKTsrwXG4ZNMuyjhpLO+IcS07g1FvHT+4f7AaZDXkBaUfcKGHmDnmPXEL4AgTKVxJxU2L/eVWB65bsQfa9ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983052; c=relaxed/simple;
	bh=IlcBvBTVwSxy/idFuzeaNb3oEVO65ZITZjOzu/+levA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDX6SHlZ5JXo9D1h/1GgF24U5LvBRVGGY8Oy7RJQ1h7lLFNE2D6WqRUEjfr2rJQuZWOsrpVakt2aO8ysqS/MyCJ0KkqR/VPqSiDrbdGtVjixIjq7ikBfi8zsJRqWNmJajiiT/3XBewAcQB05z5DHj3nlyzNzLVmGx4IsO1n3IkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mleHfzCk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mleHfzCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A41C116D0;
	Wed, 25 Feb 2026 01:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983052;
	bh=IlcBvBTVwSxy/idFuzeaNb3oEVO65ZITZjOzu/+levA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mleHfzCkaaAaOClW5ABn1FTx4MpzMOuODJTn4uL6MKunfP7cXzGCOmt7xfRJLwnVd
	 OBDpM5wY8WMWJJ8WNqkDd0YYb5eXhWUn5Gwitw4BZbzfYb3NTuMnwP9m4zC3K3GEeF
	 WCcwfLpyDStLI4aUDXMaemeRRr3XPHamd5v0AAww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 217/781] ALSA: seq: oss: Relax __free() variable declarations
Date: Tue, 24 Feb 2026 17:15:26 -0800
Message-ID: <20260225012405.041149244@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit df27c92753474cc8540e46a476119857ced7ae21 ]

We used to have a variable declaration with __free() initialized with
NULL.  This was to keep the old coding style rule, but recently it's
relaxed and rather recommends to follow the new rule to declare in
place of use for __free() -- which avoids potential deadlocks or UAFs
with nested cleanups.

Although the current code has no bug, per se, let's follow the new
standard and move the declaration to the place of assignment (or
directly assign the allocated result) instead of NULL initializations.

Fixes: 80ccbe91adab ("ALSA: seq: oss/synth: Clean up with guard and auto cleanup")
Fixes: 895a46e034f9 ("ALSA: seq: oss/midi: Cleanup with guard and auto-cleanup")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20251216140634.171890-6-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/oss/seq_oss_init.c  |  4 +--
 sound/core/seq/oss/seq_oss_midi.c  | 45 +++++++++++++++---------------
 sound/core/seq/oss/seq_oss_synth.c | 23 +++++++--------
 3 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/sound/core/seq/oss/seq_oss_init.c b/sound/core/seq/oss/seq_oss_init.c
index 973f057eb731f..e0c368bd09cb6 100644
--- a/sound/core/seq/oss/seq_oss_init.c
+++ b/sound/core/seq/oss/seq_oss_init.c
@@ -63,10 +63,10 @@ int __init
 snd_seq_oss_create_client(void)
 {
 	int rc;
-	struct snd_seq_port_info *port __free(kfree) = NULL;
 	struct snd_seq_port_callback port_callback;
+	struct snd_seq_port_info *port __free(kfree) =
+		kzalloc(sizeof(*port), GFP_KERNEL);
 
-	port = kzalloc(sizeof(*port), GFP_KERNEL);
 	if (!port)
 		return -ENOMEM;
 
diff --git a/sound/core/seq/oss/seq_oss_midi.c b/sound/core/seq/oss/seq_oss_midi.c
index 023e5d0a4351d..2d48c25ff4df2 100644
--- a/sound/core/seq/oss/seq_oss_midi.c
+++ b/sound/core/seq/oss/seq_oss_midi.c
@@ -65,11 +65,11 @@ static int send_midi_event(struct seq_oss_devinfo *dp, struct snd_seq_event *ev,
 int
 snd_seq_oss_midi_lookup_ports(int client)
 {
-	struct snd_seq_client_info *clinfo __free(kfree) = NULL;
-	struct snd_seq_port_info *pinfo __free(kfree) = NULL;
+	struct snd_seq_client_info *clinfo __free(kfree) =
+		kzalloc(sizeof(*clinfo), GFP_KERNEL);
+	struct snd_seq_port_info *pinfo __free(kfree) =
+		kzalloc(sizeof(*pinfo), GFP_KERNEL);
 
-	clinfo = kzalloc(sizeof(*clinfo), GFP_KERNEL);
-	pinfo = kzalloc(sizeof(*pinfo), GFP_KERNEL);
 	if (!clinfo || !pinfo)
 		return -ENOMEM;
 	clinfo->client = -1;
@@ -305,10 +305,10 @@ int
 snd_seq_oss_midi_open(struct seq_oss_devinfo *dp, int dev, int fmode)
 {
 	int perm;
-	struct seq_oss_midi *mdev __free(seq_oss_midi) = NULL;
 	struct snd_seq_port_subscribe subs;
+	struct seq_oss_midi *mdev __free(seq_oss_midi) =
+		get_mididev(dp, dev);
 
-	mdev = get_mididev(dp, dev);
 	if (!mdev)
 		return -ENODEV;
 
@@ -364,10 +364,10 @@ snd_seq_oss_midi_open(struct seq_oss_devinfo *dp, int dev, int fmode)
 int
 snd_seq_oss_midi_close(struct seq_oss_devinfo *dp, int dev)
 {
-	struct seq_oss_midi *mdev __free(seq_oss_midi) = NULL;
 	struct snd_seq_port_subscribe subs;
+	struct seq_oss_midi *mdev __free(seq_oss_midi) =
+		get_mididev(dp, dev);
 
-	mdev = get_mididev(dp, dev);
 	if (!mdev)
 		return -ENODEV;
 	guard(mutex)(&mdev->open_mutex);
@@ -399,10 +399,10 @@ snd_seq_oss_midi_close(struct seq_oss_devinfo *dp, int dev)
 int
 snd_seq_oss_midi_filemode(struct seq_oss_devinfo *dp, int dev)
 {
-	struct seq_oss_midi *mdev __free(seq_oss_midi) = NULL;
 	int mode;
+	struct seq_oss_midi *mdev __free(seq_oss_midi) =
+		get_mididev(dp, dev);
 
-	mdev = get_mididev(dp, dev);
 	if (!mdev)
 		return 0;
 
@@ -422,9 +422,9 @@ snd_seq_oss_midi_filemode(struct seq_oss_devinfo *dp, int dev)
 void
 snd_seq_oss_midi_reset(struct seq_oss_devinfo *dp, int dev)
 {
-	struct seq_oss_midi *mdev __free(seq_oss_midi) = NULL;
+	struct seq_oss_midi *mdev __free(seq_oss_midi) =
+		get_mididev(dp, dev);
 
-	mdev = get_mididev(dp, dev);
 	if (!mdev)
 		return;
 	if (!mdev->opened)
@@ -468,9 +468,9 @@ snd_seq_oss_midi_reset(struct seq_oss_devinfo *dp, int dev)
 void
 snd_seq_oss_midi_get_addr(struct seq_oss_devinfo *dp, int dev, struct snd_seq_addr *addr)
 {
-	struct seq_oss_midi *mdev __free(seq_oss_midi) = NULL;
+	struct seq_oss_midi *mdev __free(seq_oss_midi) =
+		get_mididev(dp, dev);
 
-	mdev = get_mididev(dp, dev);
 	if (!mdev)
 		return;
 	addr->client = mdev->client;
@@ -485,11 +485,11 @@ int
 snd_seq_oss_midi_input(struct snd_seq_event *ev, int direct, void *private_data)
 {
 	struct seq_oss_devinfo *dp = (struct seq_oss_devinfo *)private_data;
-	struct seq_oss_midi *mdev __free(seq_oss_midi) = NULL;
 
 	if (dp->readq == NULL)
 		return 0;
-	mdev = find_slot(ev->source.client, ev->source.port);
+	struct seq_oss_midi *mdev __free(seq_oss_midi) =
+		find_slot(ev->source.client, ev->source.port);
 	if (!mdev)
 		return 0;
 	if (!(mdev->opened & PERM_READ))
@@ -595,9 +595,9 @@ send_midi_event(struct seq_oss_devinfo *dp, struct snd_seq_event *ev, struct seq
 int
 snd_seq_oss_midi_putc(struct seq_oss_devinfo *dp, int dev, unsigned char c, struct snd_seq_event *ev)
 {
-	struct seq_oss_midi *mdev __free(seq_oss_midi) = NULL;
+	struct seq_oss_midi *mdev __free(seq_oss_midi) =
+		get_mididev(dp, dev);
 
-	mdev = get_mididev(dp, dev);
 	if (!mdev)
 		return -ENODEV;
 	if (snd_midi_event_encode_byte(mdev->coder, c, ev)) {
@@ -613,9 +613,9 @@ snd_seq_oss_midi_putc(struct seq_oss_devinfo *dp, int dev, unsigned char c, stru
 int
 snd_seq_oss_midi_make_info(struct seq_oss_devinfo *dp, int dev, struct midi_info *inf)
 {
-	struct seq_oss_midi *mdev __free(seq_oss_midi) = NULL;
+	struct seq_oss_midi *mdev __free(seq_oss_midi) =
+		get_mididev(dp, dev);
 
-	mdev = get_mididev(dp, dev);
 	if (!mdev)
 		return -ENXIO;
 	inf->device = dev;
@@ -651,10 +651,9 @@ snd_seq_oss_midi_info_read(struct snd_info_buffer *buf)
 
 	snd_iprintf(buf, "\nNumber of MIDI devices: %d\n", max_midi_devs);
 	for (i = 0; i < max_midi_devs; i++) {
-		struct seq_oss_midi *mdev __free(seq_oss_midi) = NULL;
-
 		snd_iprintf(buf, "\nmidi %d: ", i);
-		mdev = get_mdev(i);
+		struct seq_oss_midi *mdev __free(seq_oss_midi) =
+			get_mdev(i);
 		if (mdev == NULL) {
 			snd_iprintf(buf, "*empty*\n");
 			continue;
diff --git a/sound/core/seq/oss/seq_oss_synth.c b/sound/core/seq/oss/seq_oss_synth.c
index 8c4e5913c7e69..beea37ed942cb 100644
--- a/sound/core/seq/oss/seq_oss_synth.c
+++ b/sound/core/seq/oss/seq_oss_synth.c
@@ -368,7 +368,6 @@ reset_channels(struct seq_oss_synthinfo *info)
 void
 snd_seq_oss_synth_reset(struct seq_oss_devinfo *dp, int dev)
 {
-	struct seq_oss_synth *rec __free(seq_oss_synth) = NULL;
 	struct seq_oss_synthinfo *info;
 
 	info = get_synthinfo_nospec(dp, dev);
@@ -391,7 +390,8 @@ snd_seq_oss_synth_reset(struct seq_oss_devinfo *dp, int dev)
 		return;
 	}
 
-	rec = get_sdev(dev);
+	struct seq_oss_synth *rec __free(seq_oss_synth) =
+		get_sdev(dev);
 	if (rec == NULL)
 		return;
 	if (rec->oper.reset) {
@@ -415,7 +415,6 @@ int
 snd_seq_oss_synth_load_patch(struct seq_oss_devinfo *dp, int dev, int fmt,
 			    const char __user *buf, int p, int c)
 {
-	struct seq_oss_synth *rec __free(seq_oss_synth) = NULL;
 	struct seq_oss_synthinfo *info;
 
 	info = get_synthinfo_nospec(dp, dev);
@@ -424,7 +423,9 @@ snd_seq_oss_synth_load_patch(struct seq_oss_devinfo *dp, int dev, int fmt,
 
 	if (info->is_midi)
 		return 0;
-	rec = get_synthdev(dp, dev);
+
+	struct seq_oss_synth *rec __free(seq_oss_synth) =
+		get_synthdev(dp, dev);
 	if (!rec)
 		return -ENXIO;
 
@@ -440,9 +441,9 @@ snd_seq_oss_synth_load_patch(struct seq_oss_devinfo *dp, int dev, int fmt,
 struct seq_oss_synthinfo *
 snd_seq_oss_synth_info(struct seq_oss_devinfo *dp, int dev)
 {
-	struct seq_oss_synth *rec __free(seq_oss_synth) = NULL;
+	struct seq_oss_synth *rec __free(seq_oss_synth) =
+		get_synthdev(dp, dev);
 
-	rec = get_synthdev(dp, dev);
 	if (rec)
 		return get_synthinfo_nospec(dp, dev);
 	return NULL;
@@ -495,13 +496,14 @@ snd_seq_oss_synth_addr(struct seq_oss_devinfo *dp, int dev, struct snd_seq_event
 int
 snd_seq_oss_synth_ioctl(struct seq_oss_devinfo *dp, int dev, unsigned int cmd, unsigned long addr)
 {
-	struct seq_oss_synth *rec __free(seq_oss_synth) = NULL;
 	struct seq_oss_synthinfo *info;
 
 	info = get_synthinfo_nospec(dp, dev);
 	if (!info || info->is_midi)
 		return -ENXIO;
-	rec = get_synthdev(dp, dev);
+
+	struct seq_oss_synth *rec __free(seq_oss_synth) =
+		get_synthdev(dp, dev);
 	if (!rec)
 		return -ENXIO;
 	if (rec->oper.ioctl == NULL)
@@ -575,10 +577,9 @@ snd_seq_oss_synth_info_read(struct snd_info_buffer *buf)
 
 	snd_iprintf(buf, "\nNumber of synth devices: %d\n", max_synth_devs);
 	for (i = 0; i < max_synth_devs; i++) {
-		struct seq_oss_synth *rec __free(seq_oss_synth) = NULL;
-
 		snd_iprintf(buf, "\nsynth %d: ", i);
-		rec = get_sdev(i);
+		struct seq_oss_synth *rec __free(seq_oss_synth) =
+			get_sdev(i);
 		if (rec == NULL) {
 			snd_iprintf(buf, "*empty*\n");
 			continue;
-- 
2.51.0




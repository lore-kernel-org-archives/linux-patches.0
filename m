Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C7E46DFFB;
	Tue, 21 Jul 2026 17:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656027; cv=none; b=UoBvkWmN41Z8WEPS4oWMwnzZSXUfJbH90n/rVI5rMyrn5E2/M0C4hqq3iNX/KES4LmVPYtvww8Fu2v/59IGWR9o4PG4IFyHii5PKdQNfrF8V8U9jUwe2nf8AoCjfPMs2KAMyw1a64eoFX60giYZrmGANu5z4znKdJ7tzkOCvcMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656027; c=relaxed/simple;
	bh=H4UBCGEiRjifW7BpHFf72HvrNp3ICye2ofSB11P8dn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivVrh6JGYPqmBbBE7KvJZHTZ4PwmbGjwlN6wUedxB7OrOVmX1gf4F2aFig+j51opzr5fGBbeksrdcpTiND2/ZVGUPD1GgS/MoqH1eUz8i0VFSZKlJPo9XdGHLntSUjNlM8eV9GABLoX9te5zghh1ggo7cw/3NMrQrXgwtFdpKI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GLzP27bJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GLzP27bJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C510D1F000E9;
	Tue, 21 Jul 2026 17:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656025;
	bh=o4IdWNb03paL37jxag/vH9lfwFuPl3gbRd+xb/rAPnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GLzP27bJs4S2+debNiMEN6HMppvIcRZ5ZKUJVkGtnboOZUmwym1+itYdmjxirES4O
	 Epa6clejQ/hYyCscCjKC3M1EZYojcuBjL64l7Kn4jZ/c8Bm6ocrSPrrAhW6K9M/qjk
	 wDjImyCJplAzIpKlpn1GyuQD2hnQBvJO7C0MNAFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: [PATCH 6.18 0229/1611] ALSA: seq: oss: Fix UAF at handling events with embedded SysEx data
Date: Tue, 21 Jul 2026 17:05:45 +0200
Message-ID: <20260721152520.157518693@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7c349b4f2a603202fb8c363bd2774a22ac2fddf3 ]

The OSS sequencer processes the input MIDI bytes into a sequencer
event to be dispatched later (in snd_seq_oss_midi_putc() called from
snd_seq_oss_process_event()).  When it's a SysEx data, the event
record contains data.ext.ptr pointer to the original SysEx bytes, and
the referred data is copied into the pool afterwards at dispatching.
The problem is that, if the sequencer port gets closed concurrently
before the dispatch, the OSS sequencer core also releases the
resources (in snd_seq_oss_midi_check_exit_port()), while the pending
event may hold a stale pointer, eventually leading to a UAF at a later
dispatch.

Fortunately, there is already a refcounting mechanism (snd_use_lock_t)
for the OSS MIDI device access, and for addressing the issue above, we
just need to extend the refcount until the event gets dispatched.

This patch extends snd_seq_oss_process_event() to give back the
refcount object, which is in turn released after calling the sequencer
dispatcher with the given event in the caller side.

According to the original report, KASAN report as below:

KASAN slab-use-after-free in snd_seq_event_dup+0x40c/0x470
RIP: 0033:0x7f2cb66a6340
Read of size 6
Call trace:
  dump_stack_lvl+0x73/0xb0 (?:?)
  print_report+0xd1/0x650 (?:?)
  srso_alias_return_thunk+0x5/0xfbef5 (?:?)
  __virt_addr_valid+0x1a7/0x340 (?:?)
  kasan_complete_mode_report_info+0x64/0x200 (?:?)
  kasan_report+0xf7/0x130 (?:?)
  snd_seq_event_dup+0x40c/0x470 (?:?)
  kasan_check_range+0x10c/0x1c0 (?:?)
  __asan_memcpy+0x27/0x70 (?:?)
  snd_seq_event_dup+0x9/0x470 (?:?)
  snd_seq_client_enqueue_event+0x139/0x240 (?:?)
  _raw_spin_unlock_irqrestore+0x4b/0x60 (?:?)
  snd_seq_kernel_client_enqueue+0x102/0x120 (?:?)
  snd_seq_oss_write+0x416/0x4e0 (?:?)
  apparmor_file_permission+0x20/0x30 (?:?)
  odev_write+0x3b/0x60 (?:?)
  vfs_write+0x1ce/0x850 (?:?)
  lock_release+0xc8/0x2a0 (?:?)
  __kasan_check_write+0x18/0x20 (?:?)
  __mutex_unlock_slowpath+0x129/0x510 (?:?)
  ksys_write+0xe1/0x180 (?:?)
  mutex_unlock+0x16/0x20 (?:?)
  odev_ioctl+0x65/0xc0 (?:?)
  __x64_sys_write+0x46/0x60 (?:?)
  x64_sys_call+0x7d/0x20d0 (?:?)
  do_syscall_64+0xc1/0x360 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f (?:?)

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-and-tested-by: Zhang Cen <rollkingzzc@gmail.com>
Closes: https://lore.kernel.org/20260521233900.478153-1-rollkingzzc@gmail.com
Link: https://patch.msgid.link/20260526152843.617503-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/oss/seq_oss_event.c | 6 ++++--
 sound/core/seq/oss/seq_oss_event.h | 3 ++-
 sound/core/seq/oss/seq_oss_ioctl.c | 5 ++++-
 sound/core/seq/oss/seq_oss_midi.c  | 6 +++++-
 sound/core/seq/oss/seq_oss_midi.h  | 2 +-
 sound/core/seq/oss/seq_oss_rw.c    | 5 ++++-
 6 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/sound/core/seq/oss/seq_oss_event.c b/sound/core/seq/oss/seq_oss_event.c
index 76fb81077eef79..122735862044dc 100644
--- a/sound/core/seq/oss/seq_oss_event.c
+++ b/sound/core/seq/oss/seq_oss_event.c
@@ -39,8 +39,10 @@ static int set_echo_event(struct seq_oss_devinfo *dp, union evrec *rec, struct s
  */
 
 int
-snd_seq_oss_process_event(struct seq_oss_devinfo *dp, union evrec *q, struct snd_seq_event *ev)
+snd_seq_oss_process_event(struct seq_oss_devinfo *dp, union evrec *q,
+			  struct snd_seq_event *ev, snd_use_lock_t **lockp)
 {
+	*lockp = NULL;
 	switch (q->s.code) {
 	case SEQ_EXTENDED:
 		return extended_event(dp, q, ev);
@@ -69,7 +71,7 @@ snd_seq_oss_process_event(struct seq_oss_devinfo *dp, union evrec *q, struct snd
 		if (snd_seq_oss_midi_open(dp, q->s.dev, SNDRV_SEQ_OSS_FILE_WRITE))
 			break;
 		if (snd_seq_oss_midi_filemode(dp, q->s.dev) & SNDRV_SEQ_OSS_FILE_WRITE)
-			return snd_seq_oss_midi_putc(dp, q->s.dev, q->s.parm1, ev);
+			return snd_seq_oss_midi_putc(dp, q->s.dev, q->s.parm1, ev, lockp);
 		break;
 
 	case SEQ_ECHO:
diff --git a/sound/core/seq/oss/seq_oss_event.h b/sound/core/seq/oss/seq_oss_event.h
index b4f723949a1709..a4524e51d0e9d7 100644
--- a/sound/core/seq/oss/seq_oss_event.h
+++ b/sound/core/seq/oss/seq_oss_event.h
@@ -91,7 +91,8 @@ union evrec {
 #define ev_is_long(ev) ((ev)->s.code >= 128)
 #define ev_length(ev) ((ev)->s.code >= 128 ? LONG_EVENT_SIZE : SHORT_EVENT_SIZE)
 
-int snd_seq_oss_process_event(struct seq_oss_devinfo *dp, union evrec *q, struct snd_seq_event *ev);
+int snd_seq_oss_process_event(struct seq_oss_devinfo *dp, union evrec *q,
+			      struct snd_seq_event *ev, snd_use_lock_t **lockp);
 int snd_seq_oss_process_timer_event(struct seq_oss_timer *rec, union evrec *q);
 int snd_seq_oss_event_input(struct snd_seq_event *ev, int direct, void *private_data, int atomic, int hop);
 
diff --git a/sound/core/seq/oss/seq_oss_ioctl.c b/sound/core/seq/oss/seq_oss_ioctl.c
index ccf682689ec951..ce7a69d52b308b 100644
--- a/sound/core/seq/oss/seq_oss_ioctl.c
+++ b/sound/core/seq/oss/seq_oss_ioctl.c
@@ -45,14 +45,17 @@ static int snd_seq_oss_oob_user(struct seq_oss_devinfo *dp, void __user *arg)
 {
 	unsigned char ev[8];
 	struct snd_seq_event tmpev;
+	snd_use_lock_t *lock = NULL;
 
 	if (copy_from_user(ev, arg, 8))
 		return -EFAULT;
 	memset(&tmpev, 0, sizeof(tmpev));
 	snd_seq_oss_fill_addr(dp, &tmpev, dp->addr.client, dp->addr.port);
 	tmpev.time.tick = 0;
-	if (! snd_seq_oss_process_event(dp, (union evrec *)ev, &tmpev)) {
+	if (!snd_seq_oss_process_event(dp, (union evrec *)ev, &tmpev, &lock)) {
 		snd_seq_oss_dispatch(dp, &tmpev, 0, 0);
+		if (lock)
+			snd_use_lock_free(lock);
 	}
 	return 0;
 }
diff --git a/sound/core/seq/oss/seq_oss_midi.c b/sound/core/seq/oss/seq_oss_midi.c
index 023e5d0a4351da..553c405ddd71a8 100644
--- a/sound/core/seq/oss/seq_oss_midi.c
+++ b/sound/core/seq/oss/seq_oss_midi.c
@@ -593,7 +593,8 @@ send_midi_event(struct seq_oss_devinfo *dp, struct snd_seq_event *ev, struct seq
  *        non-zero : invalid - ignored
  */
 int
-snd_seq_oss_midi_putc(struct seq_oss_devinfo *dp, int dev, unsigned char c, struct snd_seq_event *ev)
+snd_seq_oss_midi_putc(struct seq_oss_devinfo *dp, int dev, unsigned char c,
+		      struct snd_seq_event *ev, snd_use_lock_t **lockp)
 {
 	struct seq_oss_midi *mdev __free(seq_oss_midi) = NULL;
 
@@ -602,6 +603,9 @@ snd_seq_oss_midi_putc(struct seq_oss_devinfo *dp, int dev, unsigned char c, stru
 		return -ENODEV;
 	if (snd_midi_event_encode_byte(mdev->coder, c, ev)) {
 		snd_seq_oss_fill_addr(dp, ev, mdev->client, mdev->port);
+		/* the caller must release this later */
+		*lockp = &mdev->use_lock;
+		snd_use_lock_use(*lockp);
 		return 0;
 	}
 	return -EINVAL;
diff --git a/sound/core/seq/oss/seq_oss_midi.h b/sound/core/seq/oss/seq_oss_midi.h
index bcc1683773dfba..4819d4170bf6d8 100644
--- a/sound/core/seq/oss/seq_oss_midi.h
+++ b/sound/core/seq/oss/seq_oss_midi.h
@@ -26,7 +26,7 @@ void snd_seq_oss_midi_open_all(struct seq_oss_devinfo *dp, int file_mode);
 int snd_seq_oss_midi_close(struct seq_oss_devinfo *dp, int dev);
 void snd_seq_oss_midi_reset(struct seq_oss_devinfo *dp, int dev);
 int snd_seq_oss_midi_putc(struct seq_oss_devinfo *dp, int dev, unsigned char c,
-			  struct snd_seq_event *ev);
+			  struct snd_seq_event *ev, snd_use_lock_t **lockp);
 int snd_seq_oss_midi_input(struct snd_seq_event *ev, int direct, void *private);
 int snd_seq_oss_midi_filemode(struct seq_oss_devinfo *dp, int dev);
 int snd_seq_oss_midi_make_info(struct seq_oss_devinfo *dp, int dev, struct midi_info *inf);
diff --git a/sound/core/seq/oss/seq_oss_rw.c b/sound/core/seq/oss/seq_oss_rw.c
index 307ef98c44c7b5..111c792bc72ca3 100644
--- a/sound/core/seq/oss/seq_oss_rw.c
+++ b/sound/core/seq/oss/seq_oss_rw.c
@@ -153,6 +153,7 @@ insert_queue(struct seq_oss_devinfo *dp, union evrec *rec, struct file *opt)
 {
 	int rc = 0;
 	struct snd_seq_event event;
+	snd_use_lock_t *lock = NULL;
 
 	/* if this is a timing event, process the current time */
 	if (snd_seq_oss_process_timer_event(dp->timer, rec))
@@ -164,7 +165,7 @@ insert_queue(struct seq_oss_devinfo *dp, union evrec *rec, struct file *opt)
 	event.type = SNDRV_SEQ_EVENT_NOTEOFF;
 	snd_seq_oss_fill_addr(dp, &event, dp->addr.client, dp->addr.port);
 
-	if (snd_seq_oss_process_event(dp, rec, &event))
+	if (snd_seq_oss_process_event(dp, rec, &event, &lock))
 		return 0; /* invalid event - no need to insert queue */
 
 	event.time.tick = snd_seq_oss_timer_cur_tick(dp->timer);
@@ -173,6 +174,8 @@ insert_queue(struct seq_oss_devinfo *dp, union evrec *rec, struct file *opt)
 	else
 		rc = snd_seq_kernel_client_enqueue(dp->cseq, &event, opt,
 						   !is_nonblock_mode(dp->file_mode));
+	if (lock)
+		snd_use_lock_free(lock);
 	return rc;
 }
 		
-- 
2.53.0




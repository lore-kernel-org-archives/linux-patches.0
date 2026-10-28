Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215606;
	b=OHd+DEb+FQwAKbQHdvlxa8q9zBsT34sFDo9rxAnQ7hR61RvvpXUSbVx710KkSQULxRRz
	 mIUTvQ3DeHpSXZVi4a3I0Q+Y6x9uOycoRJPPe+gR8bQR98vuf1osgkoya5CXUh5VJy85n
	 f6rh46sUHXsHsFkJNurBtljhvwgrz8eah9hb0yb9rttexut8710ScZRkDRNJU2deMbWFC
	 qS4ykLR7ecztVH8hErZuiGsaFnPb2rQmCqkkkdd1mdp1ZoXaUGlfS2bQ5Q/pEqAB16lpM
	 2wcGLzXczqLaDU2P0F6QG0zsksxg5eO6TDFcbj952ox2p1e+uj2LEoNkfchEDI3/pMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215606;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MYLHPa40x5IONLK6vVtDhvk2CMuWtz6PAc4QhVxXWTw=;
	b=v5eDasoW0O40tvMi0/edjJsQGf1qcS6FmtfQzHrgpXL8jp1V5Ini3wx1y9jmJfvfdYH5
	 QlxGFI9sem/NWoiLwYd9ugGx/OvN/skbJfmurT8s52TKTNiEgqEoeRDd8kNRVeahbiHhp
	 u/J0HkDSvwaecWz3+/EY0AZDJH5ObUhZHfjicZS9VGbfLU3GEaOL1haEDDNvOQLeH+lhd
	 nvcxa4PF8Fxi0sC26516vvmwL42/fIL2g8Oiv2qF3cDTXxjRq1VbAMZZGKb1k3rH4RasP
	 Cl74NSFRAXjY4rQercQF+yWIyPqSkAGSPk45+2e2xk1GGCiDdI9cI/012217tFncxCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=edz1eEY2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB86606A31D;
	Wed, 28 Oct 2026 19:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=edz1eEY2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4411F01825;
	Wed, 28 Oct 2026 19:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215606;
	bh=MYLHPa40x5IONLK6vVtDhvk2CMuWtz6PAc4QhVxXWTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=edz1eEY2t+JrSsAMBtMSi16UE4xNzhXDcDmXlgTDd8ts0W3hMEL6FGEOrj/DQe/Ny
	 NFtDE3mLpgNBMoGgL5GWMBCZj4H2AzozvHTI5YUdJlH1UFsUX8mWsifgQJXWRHc01Q
	 MFzsdw5o13uXWY1oe46LKOlnamUh7W5htZHtOH0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: [PATCH 6.1 1267/1887] ALSA: seq: oss: Fix UAF at handling events with embedded SysEx data
Date: Wed, 28 Oct 2026 17:56:03 +0100
Message-ID: <20261028170528.254215950@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 sound/core/seq/oss/seq_oss_midi.c  | 6 ++++--
 sound/core/seq/oss/seq_oss_midi.h  | 2 +-
 sound/core/seq/oss/seq_oss_rw.c    | 5 ++++-
 6 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/sound/core/seq/oss/seq_oss_event.c b/sound/core/seq/oss/seq_oss_event.c
index 7b7c925dd3aa2..4699c084d018e 100644
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
index b4f723949a170..a4524e51d0e9d 100644
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
index ccf682689ec95..ce7a69d52b308 100644
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
index f2940b29595f0..15ee97f3e907e 100644
--- a/sound/core/seq/oss/seq_oss_midi.c
+++ b/sound/core/seq/oss/seq_oss_midi.c
@@ -639,7 +639,8 @@ send_midi_event(struct seq_oss_devinfo *dp, struct snd_seq_event *ev, struct seq
  *        non-zero : invalid - ignored
  */
 int
-snd_seq_oss_midi_putc(struct seq_oss_devinfo *dp, int dev, unsigned char c, struct snd_seq_event *ev)
+snd_seq_oss_midi_putc(struct seq_oss_devinfo *dp, int dev, unsigned char c,
+		      struct snd_seq_event *ev, snd_use_lock_t **lockp)
 {
 	struct seq_oss_midi *mdev;
 
@@ -648,7 +649,8 @@ snd_seq_oss_midi_putc(struct seq_oss_devinfo *dp, int dev, unsigned char c, stru
 		return -ENODEV;
 	if (snd_midi_event_encode_byte(mdev->coder, c, ev)) {
 		snd_seq_oss_fill_addr(dp, ev, mdev->client, mdev->port);
-		snd_use_lock_free(&mdev->use_lock);
+		/* the caller must release this later */
+		*lockp = &mdev->use_lock;
 		return 0;
 	}
 	snd_use_lock_free(&mdev->use_lock);
diff --git a/sound/core/seq/oss/seq_oss_midi.h b/sound/core/seq/oss/seq_oss_midi.h
index bcc1683773dfb..4819d4170bf6d 100644
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
index 45bb458597708..b7147ac78ee8b 100644
--- a/sound/core/seq/oss/seq_oss_rw.c
+++ b/sound/core/seq/oss/seq_oss_rw.c
@@ -154,6 +154,7 @@ insert_queue(struct seq_oss_devinfo *dp, union evrec *rec, struct file *opt)
 {
 	int rc = 0;
 	struct snd_seq_event event;
+	snd_use_lock_t *lock = NULL;
 
 	/* if this is a timing event, process the current time */
 	if (snd_seq_oss_process_timer_event(dp->timer, rec))
@@ -165,7 +166,7 @@ insert_queue(struct seq_oss_devinfo *dp, union evrec *rec, struct file *opt)
 	event.type = SNDRV_SEQ_EVENT_NOTEOFF;
 	snd_seq_oss_fill_addr(dp, &event, dp->addr.client, dp->addr.port);
 
-	if (snd_seq_oss_process_event(dp, rec, &event))
+	if (snd_seq_oss_process_event(dp, rec, &event, &lock))
 		return 0; /* invalid event - no need to insert queue */
 
 	event.time.tick = snd_seq_oss_timer_cur_tick(dp->timer);
@@ -174,6 +175,8 @@ insert_queue(struct seq_oss_devinfo *dp, union evrec *rec, struct file *opt)
 	else
 		rc = snd_seq_kernel_client_enqueue(dp->cseq, &event, opt,
 						   !is_nonblock_mode(dp->file_mode));
+	if (lock)
+		snd_use_lock_free(lock);
 	return rc;
 }
 		
-- 
2.53.0




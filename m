Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049730;
	b=H+v14RUBVsnUFPus0qxxzwS7rsnmhWI/1DeE4pS80NUemsXHokx6/3JbUTlLXrTHhtOo
	 SwpZiVUfCXqgRj1ivCqm6X/B0nhO970MWZkJwVeeN0WrbIuj9XP+GClnGbrxrnBM3HbNZ
	 25KAKhGtOgaSPWXHIoPhCnTD8ftMcikQ91XkhiYRVHIEDMv0XSF8t7mVTLoIgW4SeI5a6
	 SPRQ1ItC5MCVsfoqWJ7q/58hTeOzyEKFxHWNiWdZ7ZC0gzcS7hnNNu/XnFo7FkFjt23nq
	 nX8AhI+2kyGIVS3tNzAlMHTUiONUteNccx24nEKmUWbl7W+XNNI9Eudw+FLJPWJb7SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sr30IzqSRhtUw1BpvAg+kec+TOOqgwfcRHweaR4hm4Q=;
	b=AUi8kEwCEseft3FlnFyfGBJsrHPc+Y1KcczPaeBG4Z25/BHQq9kioWr5hMErW8dep6ec
	 Gp56ThC/1gPtwc8Qrfxj0xzjYAptgG7zDCfmFZb3mNPPUpJiu+bZKksWft+bMLFFD4kuO
	 SGTpUESTPZY8Yu5kCVbGcYP/6Vp9WkADH/KXpmX1yILBrbOm4o5tNB7QskRg4Wr+5a6yw
	 5f6H8bkm9nOBrIn0mU4a8HR2wKrbSs2IMkO/cQ7sqSn0tI8Ac7QJX7pyqk9+iBsrZrBnv
	 tyqhSjNn+KkoQv5zlBtI2MDEnILeBSUaENjhwu7jpCXcgUyH+eURktfa9sU1ZHO47Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0czc6Eaa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8520C606A320;
	Thu, 19 Nov 2026 00:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0czc6Eaa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9489B1F000C5;
	Thu, 19 Nov 2026 00:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049730;
	bh=sr30IzqSRhtUw1BpvAg+kec+TOOqgwfcRHweaR4hm4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0czc6EaaHLUyuszrr471WimyEz6HKbusTZBBdimXoMXomVbCgjqAzPmsTM0xahzD4
	 5oVLfz57KBiRtUdrDrvXqYDubQzK1jdXK25DwFdcPejWxILAdi7XCBI2V0tvKM1qgU
	 0QFZbC9nNouJdFtyfLx81NfUtf1MOwmebYaUgrG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2457/2857] ALSA: vmaster: Serialize hook registration with control callbacks
Date: Wed, 18 Nov 2026 15:58:11 +0100
Message-ID: <20261118150330.032200418@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 6215cf3ff5b0ff1ca5ab66b79021f9e28b02eae1 ]

An HDA virtual-master hook must have its private argument initialized
before a control callback can invoke it. snd_hda_add_vmaster_hook()
installs the trampoline through snd_ctl_add_vmaster_hook(), which stores
master->hook before master->hook_private_data without serialization.

When a codec with a vmaster mute hook binds to an already registered
card, snd_hda_gen_build_controls() publishes and initializes the Master
Playback Switch before installing the hook. A native write that changes
the switch can then run in the following order:

  1. The codec bind path publishes and initializes the master control in
     __snd_hda_add_vmaster(), then calls snd_hda_add_vmaster_hook().
  2. The hook setter stores master->hook, but has not yet stored its
     private argument.
  3. SNDRV_CTL_IOCTL_ELEM_WRITE takes controls_rwsem and calls
     master_put() while the setter remains between those stores.
  4. master_put() sees the callback and invokes vmaster_hook() with a
     NULL argument. The trampoline dereferences it before the setter
     can complete publication.

The write lock held by snd_ctl_elem_write() does not exclude the hook
setter, so this can cause a NULL pointer dereference. Take the same
controls_rwsem for writing inside snd_ctl_add_vmaster_hook() so the
callback and its argument are installed together with respect to
native control callbacks. Pass the card into the helper and update
the HDA caller, keeping the lock in the ALSA core. Release it when
registration returns, before the caller synchronizes the hook.

KASAN report as below:

    Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
    KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
    CPU: 1 UID: 0 PID: 499 Comm: alsa-vmaster-tr Not tainted 7.2.0-rc6-pmb-bt-functional-v1+ #1 PREEMPT(lazy)
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    RIP: 0010:vmaster_hook+0x35/0xb0
    Code: f5 53 48 89 fb 48 83 ec 08 e8 57 f0 9a fc eb 50 e8 50 f0 9a fc 48 8d 7b 08 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 59 48 8d 7b 10 48 8b 43 08 48 ba 00 00 00 00 00 fc
    RSP: 0018:ffff888117647cd0 EFLAGS: 00010212
    RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff84e9ff50
    RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000008
    RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000001
    R10: ffffffff89427457 R11: ffff888115ad1d00 R12: ffffffff84e9ff30
    R13: ffff888114943ca0 R14: 0000000000000000 R15: 0000000000000001
    FS:  00007fe8167b3780(0000) GS:ffff88826b7e3000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 0000557c8c2842a8 CR3: 000000011579f005 CR4: 0000000000770ef0
    PKRU: 55555554
    Call Trace:
     <TASK>
     master_put+0x20e/0x2b0
     snd_ctl_elem_write+0x37f/0x5e0
     snd_ctl_ioctl+0x997/0xdd0
     ? __pfx_snd_ctl_ioctl+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? selinux_file_ioctl+0xaa/0x280
     ? __pfx_snd_ctl_ioctl+0x10/0x10
     __x64_sys_ioctl+0x163/0x1d0
     do_syscall_64+0x115/0x6a0
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
    RIP: 0033:0x7fe8168c291b
    Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
    RSP: 002b:00007fffab0cb150 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
    RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fe8168c291b
    RDX: 00007fffab0cb310 RSI: 00000000c4c85513 RDI: 0000000000000003
    RBP: 00007fffab0cb310 R08: 0000000000000000 R09: 0000000000000000
    R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
    R13: 00007fffab0cb1c0 R14: 0000000000000001 R15: 0000557c4f71fd10
     </TASK>
    Modules linked in:
    ---[ end trace 0000000000000000 ]---

Fixes: ee52e56e7b12 ("ALSA: hda - Fix mute-LED fixed mode")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Assisted-by: LLM

Link: https://patch.msgid.link/pm-pmb-c2667fb9cc42fbb7943c-v4-b7bc2fe90e950accb3f7@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/control.h   | 2 +-
 sound/core/vmaster.c      | 7 ++++++-
 sound/pci/hda/hda_codec.c | 2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/sound/control.h b/include/sound/control.h
index b0d4257d105c7..a299ff3cf2381 100644
--- a/include/sound/control.h
+++ b/include/sound/control.h
@@ -263,7 +263,7 @@ snd_ctl_add_follower_uncached(struct snd_kcontrol *master,
 	return _snd_ctl_add_follower(master, follower, SND_CTL_FOLLOWER_NEED_UPDATE);
 }
 
-int snd_ctl_add_vmaster_hook(struct snd_kcontrol *kctl,
+int snd_ctl_add_vmaster_hook(struct snd_card *card, struct snd_kcontrol *kctl,
 			     void (*hook)(void *private_data, int),
 			     void *private_data);
 void snd_ctl_sync_vmaster(struct snd_kcontrol *kctl, bool hook_only);
diff --git a/sound/core/vmaster.c b/sound/core/vmaster.c
index d0f11f37889b5..08dcd096044a5 100644
--- a/sound/core/vmaster.c
+++ b/sound/core/vmaster.c
@@ -435,6 +435,7 @@ EXPORT_SYMBOL(snd_ctl_make_virtual_master);
 
 /**
  * snd_ctl_add_vmaster_hook - Add a hook to a vmaster control
+ * @card: the card instance
  * @kcontrol: vmaster kctl element
  * @hook: the hook function
  * @private_data: the private_data pointer to be saved
@@ -442,13 +443,17 @@ EXPORT_SYMBOL(snd_ctl_make_virtual_master);
  * Adds the given hook to the vmaster control element so that it's called
  * at each time when the value is changed.
  *
+ * Takes the card's controls_rwsem lock internally.
+ *
  * Return: Zero.
  */
-int snd_ctl_add_vmaster_hook(struct snd_kcontrol *kcontrol,
+int snd_ctl_add_vmaster_hook(struct snd_card *card, struct snd_kcontrol *kcontrol,
 			     void (*hook)(void *private_data, int),
 			     void *private_data)
 {
 	struct link_master *master = snd_kcontrol_chip(kcontrol);
+
+	guard(rwsem_write)(&card->controls_rwsem);
 	master->hook = hook;
 	master->hook_private_data = private_data;
 	return 0;
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 70bbcdcf0f5c5..a267724f631bb 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2071,7 +2071,7 @@ int snd_hda_add_vmaster_hook(struct hda_codec *codec,
 	if (!hook->hook || !hook->sw_kctl)
 		return 0;
 	hook->codec = codec;
-	snd_ctl_add_vmaster_hook(hook->sw_kctl, vmaster_hook, hook);
+	snd_ctl_add_vmaster_hook(codec->card, hook->sw_kctl, vmaster_hook, hook);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(snd_hda_add_vmaster_hook);
-- 
2.53.0




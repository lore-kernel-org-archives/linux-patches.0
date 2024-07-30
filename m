Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBA58BE8;
	Tue, 30 Jul 2024 16:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357069; cv=none; b=bOe6ZmjX/kJFvv91i6y3hJz0RHqxw8nDbVFp4wNRVmJAbrgk7QtkpF9HPMel0DvIa8ZfI7avpuvSYNsW66dfkkdf4HVHr84Dz2+3GatvXA3wJL8ZiFzKa3yNIF9Dh/RqO5MqzM9ho7ECxUyjnbikiMK54kiMXBjf+dPiPj6yPA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357069; c=relaxed/simple;
	bh=jkeitPU/kqCdIw2RLI3r5d+bf84UBdjDFtHjEIzmzG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkfDcvIpZnjpD3uWxLJo3P8QtU/evFOMzb1a2hkQ/5PX+5+pZHOXKMSo7AJqzf4FL5fl9WY891toJiet2W3tWNPTDroM5cNgflaU0+M08+8xxqtwdJWPKHA4kqZ3JHbZjQf3ledRYkKkSVp98T81+wLXJO0evd4d3FvJMB74wls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qtoQh4WS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qtoQh4WS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1CEC32782;
	Tue, 30 Jul 2024 16:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357068;
	bh=jkeitPU/kqCdIw2RLI3r5d+bf84UBdjDFtHjEIzmzG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qtoQh4WSKBwqKrxv7yAC1uOlwSTDyqDQKuT8WBzZvmEXReF6CGims16D0sHWL42oQ
	 H8v+l2jGt16n1IIEE1UVraoyThYAlQ0iE4y1M5DDjQzL++lH5NLFyMfeFQkWjV2JhY
	 hOSXxoaOwqIR0gGkMi4aZR0xuIKrsic2NnQyIEgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 215/809] wifi: rtw89: wow: fix GTK offload H2C skbuff issue
Date: Tue, 30 Jul 2024 17:41:31 +0200
Message-ID: <20240730151733.096312026@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chih-Kang Chang <gary.chang@realtek.com>

[ Upstream commit dda364c345913fe03ddbe4d5ae14a2754c100296 ]

We mistakenly put skb too large and that may exceed skb->end.
Therefore, we fix it.

skbuff: skb_over_panic: text:ffffffffc09e9a9d len:416 put:204 head:ffff8fba=
04eca780 data:ffff8fba04eca7e0 tail:0x200 end:0x140 dev:<NULL>
------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:192!
invalid opcode: 0000 [#1] PREEMPT SMP PTI
CPU: 1 PID: 4747 Comm: kworker/u4:44 Tainted: G           O       6.6.30-02=
659-gc18865c4dfbd #1 86547039b47e46935493f615ee31d0b2d711d35e
Hardware name: HP Meep/Meep, BIOS Google_Meep.11297.262.0 03/18/2021
Workqueue: events_unbound async_run_entry_fn
RIP: 0010:skb_panic+0x5d/0x60
Code: c6 63 8b 8f bb 4c 0f 45 f6 48 c7 c7 4d 89 8b bb 48 89 ce 44 89 d1 41 =
56 53 41 53 ff b0 c8 00 00 00 e8 27 5f 23 00 48 83 c4 20 <0f> 0b 90 90 90 9=
0 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44
RSP: 0018:ffffaa700144bad0 EFLAGS: 00010282
RAX: 0000000000000089 RBX: 0000000000000140 RCX: 14432c5aad26c900
RDX: 0000000000000000 RSI: 00000000ffffdfff RDI: 0000000000000001
RBP: ffffaa700144bae0 R08: 0000000000000000 R09: ffffaa700144b920
R10: 00000000ffffdfff R11: ffffffffbc28fbc0 R12: ffff8fba4e57a010
R13: 0000000000000000 R14: ffffffffbb8f8b63 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8fba7bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007999c4ad1000 CR3: 000000015503a000 CR4: 0000000000350ee0
Call Trace:
 <TASK>
 ? __die_body+0x1f/0x70
 ? die+0x3d/0x60
 ? do_trap+0xa4/0x110
 ? skb_panic+0x5d/0x60
 ? do_error_trap+0x6d/0x90
 ? skb_panic+0x5d/0x60
 ? handle_invalid_op+0x30/0x40
 ? skb_panic+0x5d/0x60
 ? exc_invalid_op+0x3c/0x50
 ? asm_exc_invalid_op+0x16/0x20
 ? skb_panic+0x5d/0x60
 skb_put+0x49/0x50
 rtw89_fw_h2c_wow_gtk_ofld+0xbd/0x220 [rtw89_core 778b32de31cd1f14df2d6721a=
e99ba8a83636fa5]
 rtw89_wow_resume+0x31f/0x540 [rtw89_core 778b32de31cd1f14df2d6721ae99ba8a8=
3636fa5]
 rtw89_ops_resume+0x2b/0xa0 [rtw89_core 778b32de31cd1f14df2d6721ae99ba8a836=
36fa5]
 ieee80211_reconfig+0x84/0x13e0 [mac80211 818a894e3b77da6298269c59ed7cdff06=
5a4ed52]
 ? __pfx_wiphy_resume+0x10/0x10 [cfg80211 1a793119e2aeb157c4ca4091ff8e1d9ae=
233b59d]
 ? dev_printk_emit+0x51/0x70
 ? _dev_info+0x6e/0x90
 ? __pfx_wiphy_resume+0x10/0x10 [cfg80211 1a793119e2aeb157c4ca4091ff8e1d9ae=
233b59d]
 wiphy_resume+0x89/0x180 [cfg80211 1a793119e2aeb157c4ca4091ff8e1d9ae233b59d]
 ? __pfx_wiphy_resume+0x10/0x10 [cfg80211 1a793119e2aeb157c4ca4091ff8e1d9ae=
233b59d]
 dpm_run_callback+0x3c/0x140
 device_resume+0x1f9/0x3c0
 ? __pfx_dpm_watchdog_handler+0x10/0x10
 async_resume+0x1d/0x30
 async_run_entry_fn+0x29/0xd0
 process_scheduled_works+0x1d8/0x3d0
 worker_thread+0x1fc/0x2f0
 kthread+0xed/0x110
 ? __pfx_worker_thread+0x10/0x10
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x38/0x50
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1b/0x30
 </TASK>
Modules linked in: ccm 8021q r8153_ecm cdc_ether usbnet r8152 mii dm_integr=
ity async_xor xor async_tx lz4 lz4_compress zstd zstd_compress zram zsmallo=
c uinput rfcomm cmac algif_hash rtw89_8922ae(O) algif_skcipher rtw89_8922a(=
O) af_alg rtw89_pci(O) rtw89_core(O) btusb(O) snd_soc_sst_bxt_da7219_max983=
57a btbcm(O) snd_soc_hdac_hdmi btintel(O) snd_soc_intel_hda_dsp_common snd_=
sof_probes btrtl(O) btmtk(O) snd_hda_codec_hdmi snd_soc_dmic uvcvideo video=
buf2_vmalloc uvc videobuf2_memops videobuf2_v4l2 videobuf2_common snd_sof_p=
ci_intel_apl snd_sof_intel_hda_common snd_soc_hdac_hda snd_sof_intel_hda so=
undwire_intel soundwire_generic_allocation snd_sof_intel_hda_mlink soundwir=
e_cadence snd_sof_pci snd_sof_xtensa_dsp mac80211 snd_soc_acpi_intel_match =
snd_soc_acpi snd_sof snd_sof_utils soundwire_bus snd_soc_max98357a snd_soc_=
avs snd_soc_hda_codec snd_hda_ext_core snd_intel_dspcfg snd_intel_sdw_acpi =
snd_soc_da7219 snd_hda_codec snd_hwdep snd_hda_core veth ip6table_nat xt_MA=
SQUERADE xt_cgroup fuse bluetooth ecdh_generic
 cfg80211 ecc
gsmi: Log Shutdown Reason 0x03
---[ end trace 0000000000000000 ]---

Fixes: ed9a3c0d4dd9 ("wifi: rtw89: wow: construct EAPoL packet for GTK reke=
y offload")
Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20240620055825.17592-5-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless=
/realtek/rtw89/fw.c
index 044a5b90c7f4e..0e32880e81166 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -6715,10 +6715,8 @@ int rtw89_fw_h2c_wow_gtk_ofld(struct rtw89_dev *rtwd=
ev,
 	skb_put(skb, len);
 	h2c =3D (struct rtw89_h2c_wow_gtk_ofld *)skb->data;
=20
-	if (!enable) {
-		skb_put_zero(skb, sizeof(*gtk_info));
+	if (!enable)
 		goto hdr;
-	}
=20
 	ret =3D rtw89_fw_h2c_add_general_pkt(rtwdev, rtwvif,
 					   RTW89_PKT_OFLD_TYPE_EAPOL_KEY,
--=20
2.43.0




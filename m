Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AEC1CA8F;
	Mon,  1 Apr 2024 16:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987619; cv=none; b=J7MyoVbk5Jfzn0ldpOXWpRe9fhKnbPsbgcgTsV/iSbW9i17vIf96JEPpJOiWDue0Fx9aoODqneoVb5DsMmeeln5uov6oFf+qOSiIhDzIfsZ82zZX9xh6qfpeYUKZeVArGE0MhCSIo4QWWsWzEMnquKO5shVYfB4aSjfo0jXKatg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987619; c=relaxed/simple;
	bh=TlRSHhQIAVuig52fdF6hT6nrD/FaNtAB1XMqx7KN6co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3jFqO1WQK34aIyyn7WJVXfaxsjZm1SCeKC+NtalX8qecaCqyEPEkZai2gv64Nl/bozyH8YyHT+/ENDyCQOef7roZVv5qPf3/63y8Bef3kIUA+G6AQ8QK+knuFZcIZUFXNU0q8Cja1FSyK1s8cjAUHdIaugk+Q+HPQoBkQVt/JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ss7KJgCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ss7KJgCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18235C433C7;
	Mon,  1 Apr 2024 16:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987619;
	bh=TlRSHhQIAVuig52fdF6hT6nrD/FaNtAB1XMqx7KN6co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ss7KJgCe8d2yHNpgXRJ4UtFIHKocBfxohfF1EtKuuAxSP2AD+x9AYqjnASCRWqnpX
	 +ttiVK2bCkSwjfTRRLyfWaAIta3Tvc7m3uC84Ag0XJakXpuoeU38PW9czOW+K+MrJh
	 NMBGDmmo/Jkc1F7ozklLe4f+BwAC6s368W8pqtA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Deak <imre.deak@intel.com>,
	Chris Bainbridge <chris.bainbridge@gmail.com>
Subject: [PATCH 6.8 324/399] drm/dp: Fix divide-by-zero regression on DP MST unplug with nouveau
Date: Mon,  1 Apr 2024 17:44:50 +0200
Message-ID: <20240401152558.852384921@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Bainbridge <chris.bainbridge@gmail.com>

commit 9cbd1dae842737bfafa4b10a87909fa209dde250 upstream.

Fix a regression when using nouveau and unplugging a StarTech MSTDP122DP
DisplayPort 1.2 MST hub (the same regression does not appear when using
a Cable Matters DisplayPort 1.4 MST hub). Trace:

 divide error: 0000 [#1] PREEMPT SMP PTI
 CPU: 7 PID: 2962 Comm: Xorg Not tainted 6.8.0-rc3+ #744
 Hardware name: Razer Blade/DANA_MB, BIOS 01.01 08/31/2018
 RIP: 0010:drm_dp_bw_overhead+0xb4/0x110 [drm_display_helper]
 Code: c6 b8 01 00 00 00 75 61 01 c6 41 0f af f3 41 0f af f1 c1 e1 04 48 63=
 c7 31 d2 89 ff 48 8b 5d f8 c9 48 0f af f1 48 8d 44 06 ff <48> f7 f7 31 d2 =
31 c9 31 f6 31 ff 45 31 c0 45 31 c9 45 31 d2 45 31
 RSP: 0018:ffffb2c5c211fa30 EFLAGS: 00010206
 RAX: ffffffffffffffff RBX: 0000000000000000 RCX: 0000000000f59b00
 RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
 RBP: ffffb2c5c211fa48 R08: 0000000000000001 R09: 0000000000000020
 R10: 0000000000000004 R11: 0000000000000000 R12: 0000000000023b4a
 R13: ffff91d37d165800 R14: ffff91d36fac6d80 R15: ffff91d34a764010
 FS:  00007f4a1ca3fa80(0000) GS:ffff91d6edbc0000(0000) knlGS:00000000000000=
00
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000559491d49000 CR3: 000000011d180002 CR4: 00000000003706f0
 Call Trace:
  <TASK>
  ? show_regs+0x6d/0x80
  ? die+0x37/0xa0
  ? do_trap+0xd4/0xf0
  ? do_error_trap+0x71/0xb0
  ? drm_dp_bw_overhead+0xb4/0x110 [drm_display_helper]
  ? exc_divide_error+0x3a/0x70
  ? drm_dp_bw_overhead+0xb4/0x110 [drm_display_helper]
  ? asm_exc_divide_error+0x1b/0x20
  ? drm_dp_bw_overhead+0xb4/0x110 [drm_display_helper]
  ? drm_dp_calc_pbn_mode+0x2e/0x70 [drm_display_helper]
  nv50_msto_atomic_check+0xda/0x120 [nouveau]
  drm_atomic_helper_check_modeset+0xa87/0xdf0 [drm_kms_helper]
  drm_atomic_helper_check+0x19/0xa0 [drm_kms_helper]
  nv50_disp_atomic_check+0x13f/0x2f0 [nouveau]
  drm_atomic_check_only+0x668/0xb20 [drm]
  ? drm_connector_list_iter_next+0x86/0xc0 [drm]
  drm_atomic_commit+0x58/0xd0 [drm]
  ? __pfx___drm_printfn_info+0x10/0x10 [drm]
  drm_atomic_connector_commit_dpms+0xd7/0x100 [drm]
  drm_mode_obj_set_property_ioctl+0x1c5/0x450 [drm]
  ? __pfx_drm_connector_property_set_ioctl+0x10/0x10 [drm]
  drm_connector_property_set_ioctl+0x3b/0x60 [drm]
  drm_ioctl_kernel+0xb9/0x120 [drm]
  drm_ioctl+0x2d0/0x550 [drm]
  ? __pfx_drm_connector_property_set_ioctl+0x10/0x10 [drm]
  nouveau_drm_ioctl+0x61/0xc0 [nouveau]
  __x64_sys_ioctl+0xa0/0xf0
  do_syscall_64+0x76/0x140
  ? do_syscall_64+0x85/0x140
  ? do_syscall_64+0x85/0x140
  entry_SYSCALL_64_after_hwframe+0x6e/0x76
 RIP: 0033:0x7f4a1cd1a94f
 Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44=
 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <41> 89 c0 3d 00 =
f0 ff ff 77 1f 48 8b 44 24 18 64 48 2b 04 25 28 00
 RSP: 002b:00007ffd2f1df520 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
 RAX: ffffffffffffffda RBX: 00007ffd2f1df5b0 RCX: 00007f4a1cd1a94f
 RDX: 00007ffd2f1df5b0 RSI: 00000000c01064ab RDI: 000000000000000f
 RBP: 00000000c01064ab R08: 000056347932deb8 R09: 000056347a7d99c0
 R10: 0000000000000000 R11: 0000000000000246 R12: 000056347938a220
 R13: 000000000000000f R14: 0000563479d9f3f0 R15: 0000000000000000
  </TASK>
 Modules linked in: rfcomm xt_conntrack nft_chain_nat xt_MASQUERADE nf_nat =
nf_conntrack_netlink nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xfrm_user x=
frm_algo xt_addrtype nft_compat nf_tables nfnetlink br_netfilter bridge stp=
 llc ccm cmac algif_hash overlay algif_skcipher af_alg bnep binfmt_misc snd=
_sof_pci_intel_cnl snd_sof_intel_hda_common snd_soc_hdac_hda snd_sof_pci sn=
d_sof_xtensa_dsp snd_sof_intel_hda snd_sof snd_sof_utils snd_soc_acpi_intel=
_match snd_soc_acpi snd_soc_core snd_compress snd_sof_intel_hda_mlink snd_h=
da_ext_core iwlmvm intel_rapl_msr intel_rapl_common intel_tcc_cooling x86_p=
kg_temp_thermal intel_powerclamp mac80211 coretemp kvm_intel snd_hda_codec_=
hdmi kvm snd_hda_codec_realtek snd_hda_codec_generic uvcvideo libarc4 snd_h=
da_intel snd_intel_dspcfg snd_hda_codec iwlwifi videobuf2_vmalloc videobuf2=
_memops uvc irqbypass btusb videobuf2_v4l2 snd_seq_midi crct10dif_pclmul hi=
d_multitouch crc32_pclmul snd_seq_midi_event btrtl snd_hwdep videodev polyv=
al_clmulni polyval_generic snd_rawmidi
  ghash_clmulni_intel aesni_intel btintel crypto_simd snd_hda_core cryptd s=
nd_seq btbcm ee1004 8250_dw videobuf2_common btmtk rapl nls_iso8859_1 mei_h=
dcp thunderbolt bluetooth intel_cstate wmi_bmof intel_wmi_thunderbolt cfg80=
211 snd_pcm mc snd_seq_device i2c_i801 r8169 ecdh_generic snd_timer i2c_smb=
us ecc snd mei_me intel_lpss_pci mei ahci intel_lpss soundcore realtek liba=
hci idma64 intel_pch_thermal i2c_hid_acpi i2c_hid acpi_pad sch_fq_codel msr=
 parport_pc ppdev lp parport efi_pstore ip_tables x_tables autofs4 dm_crypt=
 raid10 raid456 libcrc32c async_raid6_recov async_memcpy async_pq async_xor=
 xor async_tx raid6_pq raid1 raid0 joydev input_leds hid_generic usbhid hid=
 nouveau i915 drm_ttm_helper gpu_sched drm_gpuvm drm_exec i2c_algo_bit drm_=
buddy ttm drm_display_helper drm_kms_helper cec rc_core drm nvme nvme_core =
mxm_wmi xhci_pci xhci_pci_renesas video wmi pinctrl_cannonlake mac_hid
 ---[ end trace 0000000000000000 ]---

Fix this by avoiding the divide if bpp is 0.

Fixes: c1d6a22b7219 ("drm/dp: Add helpers to calculate the link BW overhead=
")
Cc: stable@vger.kernel.org
Acked-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Chris Bainbridge <chris.bainbridge@gmail.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/ZfWLJwYikw2K7B6c@debian=
.local
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/display/drm_dp_helper.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/display/drm_dp_helper.c b/drivers/gpu/drm/disp=
lay/drm_dp_helper.c
index b1ca3a1100da..26c188ce5f1c 100644
--- a/drivers/gpu/drm/display/drm_dp_helper.c
+++ b/drivers/gpu/drm/display/drm_dp_helper.c
@@ -3982,6 +3982,13 @@ int drm_dp_bw_overhead(int lane_count, int hactive,
 	u32 overhead =3D 1000000;
 	int symbol_cycles;
=20
+	if (lane_count =3D=3D 0 || hactive =3D=3D 0 || bpp_x16 =3D=3D 0) {
+		DRM_DEBUG_KMS("Invalid BW overhead params: lane_count %d, hactive %d, bp=
p_x16 %d.%04d\n",
+			      lane_count, hactive,
+			      bpp_x16 >> 4, (bpp_x16 & 0xf) * 625);
+		return 0;
+	}
+
 	/*
 	 * DP Standard v2.1 2.6.4.1
 	 * SSC downspread and ref clock variation margin:
--=20
2.44.0




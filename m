Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8B76FDE1;
	Mon, 29 Jan 2024 17:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548495; cv=none; b=vGEX6h+Jb3bDJ35o1cVeV3NHMswbcz8nSBf91nGqZG+Hs9sBK5vGAr9p5k7kelEBgrUYo1X2NdqOawisanKyavnH+6wnHqykcc++WmH7IXWdoxrKIWOiuKOh0AuEibMqMfSsGjX5QdIXiU9J1g/va4VIeUkiz+7MD6cvhwPjnYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548495; c=relaxed/simple;
	bh=bA9VeKkP23CXlzb6kNPHjkqAZuZfmqWfB+13zFDtABE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZtxK1+OAuTvUAGBDROBrHcadkE4ru/UORuQthaEnn/vGjQdMHcgi65PCRPBDJHJT5SWzVKT+w2zpFEjU84xXwReLV1zD9jCfEUYL/C+m5uKAmK7Faiwlv3STUPJEllpaf/8c/EDInKMatj1AxEIeCXslbzwT1/QsHKD4e3aJpxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uJ1ebvu/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJ1ebvu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18ADC433C7;
	Mon, 29 Jan 2024 17:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548495;
	bh=bA9VeKkP23CXlzb6kNPHjkqAZuZfmqWfB+13zFDtABE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uJ1ebvu/W6LiReZysqZCFc83/WOMc9B6eOlmUjM9hMuBq3h142a+K6bF4sFQl2rr6
	 OTSJP5/aHR6kbw2hlwOd4ikXjjxj2w2TzBGYFw+64dzHmgfb/ge81kbyARGa4PaNmB
	 hvQbul25yDYIJBdssrSgrZUQgc5vX8+K1tZp8x30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faith Ekstrand <faith.ekstrand@collabora.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 6.6 120/331] nouveau/vmm: dont set addr on the fail path to avoid warning
Date: Mon, 29 Jan 2024 09:03:04 -0800
Message-ID: <20240129170018.446763654@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit cacea81390fd8c8c85404e5eb2adeb83d87a912e upstream.

nvif_vmm_put gets called if addr is set, but if the allocation
fails we don't need to call put, otherwise we get a warning like

[523232.435671] ------------[ cut here ]------------
[523232.435674] WARNING: CPU: 8 PID: 1505697 at drivers/gpu/drm/nouveau/nvi=
f/vmm.c:68 nvif_vmm_put+0x72/0x80 [nouveau]
[523232.435795] Modules linked in: uinput rfcomm snd_seq_dummy snd_hrtimer =
nf_conntrack_netbios_ns nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nf=
t_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject=
 nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_=
set nf_tables nfnetlink qrtr bnep sunrpc binfmt_misc intel_rapl_msr intel_r=
apl_common intel_uncore_frequency intel_uncore_frequency_common isst_if_com=
mon iwlmvm nfit libnvdimm vfat fat x86_pkg_temp_thermal intel_powerclamp ma=
c80211 snd_soc_avs snd_soc_hda_codec coretemp snd_hda_ext_core snd_soc_core=
 snd_hda_codec_realtek kvm_intel snd_hda_codec_hdmi snd_compress snd_hda_co=
dec_generic ac97_bus snd_pcm_dmaengine snd_hda_intel libarc4 snd_intel_dspc=
fg snd_intel_sdw_acpi snd_hda_codec kvm iwlwifi snd_hda_core btusb snd_hwde=
p btrtl snd_seq btintel irqbypass btbcm rapl snd_seq_device eeepc_wmi btmtk=
 intel_cstate iTCO_wdt cfg80211 snd_pcm asus_wmi bluetooth intel_pmc_bxt iT=
CO_vendor_support snd_timer ledtrig_audio pktcdvd snd mei_me
[523232.435828]  sparse_keymap intel_uncore i2c_i801 platform_profile wmi_b=
mof mei pcspkr ioatdma soundcore i2c_smbus rfkill idma64 dca joydev acpi_ta=
d loop zram nouveau drm_ttm_helper ttm video drm_exec drm_gpuvm gpu_sched c=
rct10dif_pclmul i2c_algo_bit nvme crc32_pclmul crc32c_intel drm_display_hel=
per polyval_clmulni nvme_core polyval_generic e1000e mxm_wmi cec ghash_clmu=
lni_intel r8169 sha512_ssse3 nvme_common wmi pinctrl_sunrisepoint uas usb_s=
torage ip6_tables ip_tables fuse
[523232.435849] CPU: 8 PID: 1505697 Comm: gnome-shell Tainted: G        W  =
        6.6.0-rc7-nvk-uapi+ #12
[523232.435851] Hardware name: System manufacturer System Product Name/ROG =
STRIX X299-E GAMING II, BIOS 1301 09/24/2021
[523232.435852] RIP: 0010:nvif_vmm_put+0x72/0x80 [nouveau]
[523232.435934] Code: 00 00 48 89 e2 be 02 00 00 00 48 c7 04 24 00 00 00 00=
 48 89 44 24 08 e8 fc bf ff ff 85
c0 75 0a 48 c7 43 08 00 00 00 00 eb b3 <0f> 0b eb f2 e8 f5 c9 b2 e6 0f 1f 4=
4 00 00 90 90 90 90 90 90 90 90
[523232.435936] RSP: 0018:ffffc900077ffbd8 EFLAGS: 00010282
[523232.435937] RAX: 00000000fffffffe RBX: ffffc900077ffc00 RCX: 0000000000=
000010
[523232.435938] RDX: 0000000000000010 RSI: ffffc900077ffb38 RDI: ffffc90007=
7ffbd8
[523232.435940] RBP: ffff888e1c4f2140 R08: 0000000000000000 R09: 0000000000=
000000
[523232.435940] R10: 0000000000000000 R11: 0000000000000000 R12: ffff888503=
811800
[523232.435941] R13: ffffc900077ffca0 R14: ffff888e1c4f2140 R15: ffff888103=
17e1e0
[523232.435942] FS:  00007f933a769640(0000) GS:ffff88905fa00000(0000) knlGS=
:0000000000000000
[523232.435943] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[523232.435944] CR2: 00007f930bef7000 CR3: 00000005d0322001 CR4: 0000000000=
3706e0
[523232.435945] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000=
000000
[523232.435946] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000=
000400
[523232.435964] Call Trace:
[523232.435965]  <TASK>
[523232.435966]  ? nvif_vmm_put+0x72/0x80 [nouveau]
[523232.436051]  ? __warn+0x81/0x130
[523232.436055]  ? nvif_vmm_put+0x72/0x80 [nouveau]
[523232.436138]  ? report_bug+0x171/0x1a0
[523232.436142]  ? handle_bug+0x3c/0x80
[523232.436144]  ? exc_invalid_op+0x17/0x70
[523232.436145]  ? asm_exc_invalid_op+0x1a/0x20
[523232.436149]  ? nvif_vmm_put+0x72/0x80 [nouveau]
[523232.436230]  ? nvif_vmm_put+0x64/0x80 [nouveau]
[523232.436342]  nouveau_vma_del+0x80/0xd0 [nouveau]
[523232.436506]  nouveau_vma_new+0x1a0/0x210 [nouveau]
[523232.436671]  nouveau_gem_object_open+0x1d0/0x1f0 [nouveau]
[523232.436835]  drm_gem_handle_create_tail+0xd1/0x180
[523232.436840]  drm_prime_fd_to_handle_ioctl+0x12e/0x200
[523232.436844]  ? __pfx_drm_prime_fd_to_handle_ioctl+0x10/0x10
[523232.436847]  drm_ioctl_kernel+0xd3/0x180
[523232.436849]  drm_ioctl+0x26d/0x4b0
[523232.436851]  ? __pfx_drm_prime_fd_to_handle_ioctl+0x10/0x10
[523232.436855]  nouveau_drm_ioctl+0x5a/0xb0 [nouveau]
[523232.437032]  __x64_sys_ioctl+0x94/0xd0
[523232.437036]  do_syscall_64+0x5d/0x90
[523232.437040]  ? syscall_exit_to_user_mode+0x2b/0x40
[523232.437044]  ? do_syscall_64+0x6c/0x90
[523232.437046]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8

Reported-by: Faith Ekstrand <faith.ekstrand@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240117213852.295565-1=
-airlied@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_vmm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/nouveau/nouveau_vmm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_vmm.c
@@ -108,6 +108,9 @@ nouveau_vma_new(struct nouveau_bo *nvbo,
 	} else {
 		ret =3D nvif_vmm_get(&vmm->vmm, PTES, false, mem->mem.page, 0,
 				   mem->mem.size, &tmp);
+		if (ret)
+			goto done;
+
 		vma->addr =3D tmp.addr;
 	}
=20



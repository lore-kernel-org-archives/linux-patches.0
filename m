Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E043EAC6F;
	Tue, 17 Mar 2026 16:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766357; cv=none; b=ukNUORKYRmkPXrz7D1MnJkA8t+9ZJ+KRkmmtEdTh8KsmPGLG9O4872HdQCihJs3phC+9cvg8+UxYA5TYEptcrRte0uH/PpNd3Er0BMwCqLvQS6IKCs/XbZJbnoPYZoVndTCLJYGA5mtoa+XhNj+niILo2p4692ILu8SQmm0tPzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766357; c=relaxed/simple;
	bh=/Idm8pSoSfJDHL4GuUC76p+kjTEfZPQgyqE1tqXo8b8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UfZCxCKy0z7/l8WYSHSQks9vGcqDAbF9UzFKSJeYTMpNsaKNaxKMpOyUj2pptM/rnXpETO9OLeKi61Or1a3YdpJ+Wa0VF0so/1FkJ4rem4GtZidC1opYyoDULA5D6pOyJKgdeA6AEu2l1ZrXuGUIqtSH9Tq3PFa7yYmJpkX2OC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fg5fyrP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fg5fyrP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C60C4CEF7;
	Tue, 17 Mar 2026 16:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766356;
	bh=/Idm8pSoSfJDHL4GuUC76p+kjTEfZPQgyqE1tqXo8b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fg5fyrP9GCR52Hnix1dvTDBaqkDFdbmG7kNLOvZq/CN+OYMo/dlR0DNxL0BEkd0TL
	 GeC7Ehbfx4pWrXQYxE8gdMkOU3t4vyhnS2HG6NR+cQw6NwbbkaHRHdgk2sXksyXerF
	 BSZUfHnWhuAPq51uvtqJ++c+rkcjjYSk8Z6Zh5mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Hothi <ravi.hothi@oss.qualcomm.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.19 200/378] ASoC: qcom: qdsp6: Fix q6apm remove ordering during ADSP stop and start
Date: Tue, 17 Mar 2026 17:32:37 +0100
Message-ID: <20260317163014.361035431@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ravi Hothi <ravi.hothi@oss.qualcomm.com>

commit d6db827b430bdcca3976cebca7bd69cca03cde2c upstream.

During ADSP stop and start, the kernel crashes due to the order in which
ASoC components are removed.

On ADSP stop, the q6apm-audio .remove callback unloads topology and removes
PCM runtimes during ASoC teardown. This deletes the RTDs that contain the
q6apm DAI components before their removal pass runs, leaving those
components still linked to the card and causing crashes on the next rebind.

Fix this by ensuring that all dependent (child) components are removed
first, and the q6apm component is removed last.

[   48.105720] Unable to handle kernel NULL pointer dereference at virtual =
address 00000000000000d0
[   48.114763] Mem abort info:
[   48.117650]   ESR =3D 0x0000000096000004
[   48.121526]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
[   48.127010]   SET =3D 0, FnV =3D 0
[   48.130172]   EA =3D 0, S1PTW =3D 0
[   48.133415]   FSC =3D 0x04: level 0 translation fault
[   48.138446] Data abort info:
[   48.141422]   ISV =3D 0, ISS =3D 0x00000004, ISS2 =3D 0x00000000
[   48.147079]   CM =3D 0, WnR =3D 0, TnD =3D 0, TagAccess =3D 0
[   48.152354]   GCS =3D 0, Overlay =3D 0, DirtyBit =3D 0, Xs =3D 0
[   48.157859] user pgtable: 4k pages, 48-bit VAs, pgdp=3D00000001173cf000
[   48.164517] [00000000000000d0] pgd=3D0000000000000000, p4d=3D00000000000=
00000
[   48.171530] Internal error: Oops: 0000000096000004 [#1]  SMP
[   48.177348] Modules linked in: q6prm_clocks q6apm_lpass_dais q6apm_dai s=
nd_q6dsp_common q6prm snd_q6apm 8021q garp mrp stp llc snd_soc_hdmi_codec a=
pr pdr_interface phy_qcom_edp fastrpc qcom_pd_mapper rpmsg_ctrl qrtr_smd rp=
msg_char qcom_pdr_msg qcom_iris v4l2_mem2mem videobuf2_dma_contig ath11k_pc=
i msm ubwc_config at24 ath11k videobuf2_memops mac80211 ocmem videobuf2_v4l=
2 libarc4 drm_gpuvm mhi qrtr videodev drm_exec snd_soc_sc8280xp gpu_sched v=
ideobuf2_common nvmem_qcom_spmi_sdam snd_soc_qcom_sdw drm_dp_aux_bus qcom_q=
6v5_pas qcom_spmi_temp_alarm snd_soc_qcom_common rtc_pm8xxx qcom_pon drm_di=
splay_helper cec qcom_pil_info qcom_stats soundwire_bus drm_client_lib mc d=
ispcc0_sa8775p videocc_sa8775p qcom_q6v5 camcc_sa8775p snd_soc_dmic phy_qco=
m_sgmii_eth snd_soc_max98357a i2c_qcom_geni snd_soc_core dwmac_qcom_ethqos =
llcc_qcom icc_bwmon qcom_sysmon snd_compress qcom_refgen_regulator coresigh=
t_stm stmmac_platform snd_pcm_dmaengine qcom_common coresight_tmc stmmac co=
resight_replicator qcom_glink_smem coresight_cti stm_core
[   48.177444]  coresight_funnel snd_pcm ufs_qcom phy_qcom_qmp_usb gpi phy_=
qcom_snps_femto_v2 coresight phy_qcom_qmp_ufs qcom_wdt gpucc_sa8775p pcs_xp=
cs mdt_loader qcom_ice icc_osm_l3 qmi_helpers snd_timer snd soundcore displ=
ay_connector qcom_rng nvmem_reboot_mode drm_kms_helper phy_qcom_qmp_pcie sh=
a256 cfg80211 rfkill socinfo fuse drm backlight ipv6
[   48.301059] CPU: 2 UID: 0 PID: 293 Comm: kworker/u32:2 Not tainted 6.19.=
0-rc6-dirty #10 PREEMPT
[   48.310081] Hardware name: Qualcomm Technologies, Inc. Lemans EVK (DT)
[   48.316782] Workqueue: pdr_notifier_wq pdr_notifier_work [pdr_interface]
[   48.323672] pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[   48.330825] pc : mutex_lock+0xc/0x54
[   48.334514] lr : soc_dapm_shutdown_dapm+0x44/0x174 [snd_soc_core]
[   48.340794] sp : ffff800084ddb7b0
[   48.344207] x29: ffff800084ddb7b0 x28: ffff00009cd9cf30 x27: ffff00009cd=
9cc00
[   48.351544] x26: ffff000099610190 x25: ffffa31d2f19c810 x24: ffffa31d2f1=
85098
[   48.358869] x23: ffff800084ddb7f8 x22: 0000000000000000 x21: 00000000000=
000d0
[   48.366198] x20: ffff00009ba6c338 x19: ffff00009ba6c338 x18: 00000000fff=
fffff
[   48.373528] x17: 000000040044ffff x16: ffffa31d4ae6dca8 x15: 07200774077=
5076f
[   48.380853] x14: 0765076d07690774 x13: 00313a323a656369 x12: 767265733a6=
37673
[   48.388182] x11: 00000000000003f9 x10: ffffa31d4c7dea98 x9 : 00000000000=
00001
[   48.395519] x8 : ffff00009a2aadc0 x7 : 0000000000000003 x6 : 00000000000=
00000
[   48.402854] x5 : 0000000000000000 x4 : 0000000000000028 x3 : ffff000ef39=
7a698
[   48.410180] x2 : ffff00009a2aadc0 x1 : 0000000000000000 x0 : 00000000000=
000d0
[   48.417506] Call trace:
[   48.420025]  mutex_lock+0xc/0x54 (P)
[   48.423712]  snd_soc_dapm_shutdown+0x44/0xbc [snd_soc_core]
[   48.429447]  soc_cleanup_card_resources+0x30/0x2c0 [snd_soc_core]
[   48.435719]  snd_soc_bind_card+0x4dc/0xcc0 [snd_soc_core]
[   48.441278]  snd_soc_add_component+0x27c/0x2c8 [snd_soc_core]
[   48.447192]  snd_soc_register_component+0x9c/0xf4 [snd_soc_core]
[   48.453371]  devm_snd_soc_register_component+0x64/0xc4 [snd_soc_core]
[   48.459994]  apm_probe+0xb4/0x110 [snd_q6apm]
[   48.464479]  apr_device_probe+0x24/0x40 [apr]
[   48.468964]  really_probe+0xbc/0x298
[   48.472651]  __driver_probe_device+0x78/0x12c
[   48.477132]  driver_probe_device+0x40/0x160
[   48.481435]  __device_attach_driver+0xb8/0x134
[   48.486011]  bus_for_each_drv+0x80/0xdc
[   48.489964]  __device_attach+0xa8/0x1b0
[   48.493916]  device_initial_probe+0x50/0x54
[   48.498219]  bus_probe_device+0x38/0xa0
[   48.502170]  device_add+0x590/0x760
[   48.505761]  device_register+0x20/0x30
[   48.509623]  of_register_apr_devices+0x1d8/0x318 [apr]
[   48.514905]  apr_pd_status+0x2c/0x54 [apr]
[   48.519114]  pdr_notifier_work+0x8c/0xe0 [pdr_interface]
[   48.524570]  process_one_work+0x150/0x294
[   48.528692]  worker_thread+0x2d8/0x3d8
[   48.532551]  kthread+0x130/0x204
[   48.535874]  ret_from_fork+0x10/0x20
[   48.539559] Code: d65f03c0 d5384102 d503201f d2800001 (c8e17c02)
[   48.545823] ---[ end trace 0000000000000000 ]---

Fixes: 5477518b8a0e ("ASoC: qdsp6: audioreach: add q6apm support")
Cc: stable@vger.kernel.org
Signed-off-by: Ravi Hothi <ravi.hothi@oss.qualcomm.com>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260227144534.278568-1-ravi.hothi@oss.qualc=
omm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6apm-dai.c        |    1 +
 sound/soc/qcom/qdsp6/q6apm-lpass-dais.c |    1 +
 sound/soc/qcom/qdsp6/q6apm.c            |    1 +
 3 files changed, 3 insertions(+)

--- a/sound/soc/qcom/qdsp6/q6apm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6apm-dai.c
@@ -838,6 +838,7 @@ static const struct snd_soc_component_dr
 	.ack		=3D q6apm_dai_ack,
 	.compress_ops	=3D &q6apm_dai_compress_ops,
 	.use_dai_pcm_id =3D true,
+	.remove_order   =3D SND_SOC_COMP_ORDER_EARLY,
 };
=20
 static int q6apm_dai_probe(struct platform_device *pdev)
--- a/sound/soc/qcom/qdsp6/q6apm-lpass-dais.c
+++ b/sound/soc/qcom/qdsp6/q6apm-lpass-dais.c
@@ -278,6 +278,7 @@ static const struct snd_soc_component_dr
 	.of_xlate_dai_name =3D q6dsp_audio_ports_of_xlate_dai_name,
 	.be_pcm_base =3D AUDIOREACH_BE_PCM_BASE,
 	.use_dai_pcm_id =3D true,
+	.remove_order   =3D SND_SOC_COMP_ORDER_FIRST,
 };
=20
 static int q6apm_lpass_dai_dev_probe(struct platform_device *pdev)
--- a/sound/soc/qcom/qdsp6/q6apm.c
+++ b/sound/soc/qcom/qdsp6/q6apm.c
@@ -712,6 +712,7 @@ static const struct snd_soc_component_dr
 	.name		=3D APM_AUDIO_DRV_NAME,
 	.probe		=3D q6apm_audio_probe,
 	.remove		=3D q6apm_audio_remove,
+	.remove_order   =3D SND_SOC_COMP_ORDER_LAST,
 };
=20
 static int apm_probe(gpr_device_t *gdev)



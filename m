Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37685243367;
	Tue, 20 May 2025 14:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749930; cv=none; b=lQHgmLizF7lyRraqr/LHXg19E41Zp2I1Epiw6ssuk4kPOb86AUj9jw+0BklQzdbxR+32sp5/195iH8Fb+u4ZTWKuKggDlwIxZFrt2D+O794wwaaZvP0R4oPgfC699Hjk9Lyja7nOptixW1HA0xVrj5S8AVnKPQvQ1l5wlJokkhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749930; c=relaxed/simple;
	bh=+6sak3NdfHW34OD8Zl96acWsZj8RB2arjjzomzf2haI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFqZropwj8r69E+cWj9UipcZhdm+sAKBesY7XFGXJfil4dbk/Z+RIKtsyg28PIEALcBQbZeA6jX2/Flc0F/vb9NdU/4SnzQP8qlPJXvfEDe3XNZEgJAFfXqTl7SBYTI+RZplmzGQrDU+SgPj/ShCy/jVzX8OusAujG797TLI+10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n91M7Qw1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n91M7Qw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC6FC4CEE9;
	Tue, 20 May 2025 14:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749930;
	bh=+6sak3NdfHW34OD8Zl96acWsZj8RB2arjjzomzf2haI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n91M7Qw173iLxMWUrb88sj5NC6r3EZEWtqKKfIzNOgOHyDFAus/Q1t2rycjjqDWka
	 BzH/smJ3klbVjLbZXyKNEzrt/loNF6AuYnL8mqRp2fltooo1BpH6TG4tgZIURSLDA1
	 Pavx63RtLVJBpvdCKdF8/SonH5m/+KXvYCnY2t0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Bin Lan <bin.lan.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.6 105/117] Bluetooth: btnxpuart: Fix kernel panic during FW release
Date: Tue, 20 May 2025 15:51:10 +0200
Message-ID: <20250520125808.166148965@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>

commit 1f77c05408c96bc0b58ae476a9cadc9e5b9cfd0f upstream.

This fixes a kernel panic seen during release FW in a stress test
scenario where WLAN and BT FW download occurs simultaneously, and due to
a HW bug, chip sends out only 1 bootloader signatures.

When driver receives the bootloader signature, it enters FW download
mode, but since no consequtive bootloader signatures seen, FW file is
not requested.

After 60 seconds, when FW download times out, release_firmware causes a
kernel panic.

[ 2601.949184] Unable to handle kernel paging request at virtual address 0000312e6f006573
[ 2601.992076] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000111802000
[ 2601.992080] [0000312e6f006573] pgd=0000000000000000, p4d=0000000000000000
[ 2601.992087] Internal error: Oops: 0000000096000021 [#1] PREEMPT SMP
[ 2601.992091] Modules linked in: algif_hash algif_skcipher af_alg btnxpuart(O) pciexxx(O) mlan(O) overlay fsl_jr_uio caam_jr caamkeyblob_desc caamhash_desc caamalg_desc crypto_engine authenc libdes crct10dif_ce polyval_ce snd_soc_fsl_easrc snd_soc_fsl_asoc_card imx8_media_dev(C) snd_soc_fsl_micfil polyval_generic snd_soc_fsl_xcvr snd_soc_fsl_sai snd_soc_imx_audmux snd_soc_fsl_asrc snd_soc_imx_card snd_soc_imx_hdmi snd_soc_fsl_aud2htx snd_soc_fsl_utils imx_pcm_dma dw_hdmi_cec flexcan can_dev
[ 2602.001825] CPU: 2 PID: 20060 Comm: hciconfig Tainted: G         C O       6.6.23-lts-next-06236-gb586a521770e #1
[ 2602.010182] Hardware name: NXP i.MX8MPlus EVK board (DT)
[ 2602.010185] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[ 2602.010191] pc : _raw_spin_lock+0x34/0x68
[ 2602.010201] lr : free_fw_priv+0x20/0xfc
[ 2602.020561] sp : ffff800089363b30
[ 2602.020563] x29: ffff800089363b30 x28: ffff0000d0eb5880 x27: 0000000000000000
[ 2602.020570] x26: 0000000000000000 x25: ffff0000d728b330 x24: 0000000000000000
[ 2602.020577] x23: ffff0000dc856f38
[ 2602.033797] x22: ffff800089363b70 x21: ffff0000dc856000
[ 2602.033802] x20: ff00312e6f006573 x19: ffff0000d0d9ea80 x18: 0000000000000000
[ 2602.033809] x17: 0000000000000000 x16: 0000000000000000 x15: 0000aaaad80dd480
[ 2602.083320] x14: 0000000000000000 x13: 00000000000001b9 x12: 0000000000000002
[ 2602.083326] x11: 0000000000000000 x10: 0000000000000a60 x9 : ffff800089363a30
[ 2602.083333] x8 : ffff0001793d75c0 x7 : ffff0000d6dbc400 x6 : 0000000000000000
[ 2602.083339] x5 : 00000000410fd030 x4 : 0000000000000000 x3 : 0000000000000001
[ 2602.083346] x2 : 0000000000000000 x1 : 0000000000000001 x0 : ff00312e6f006573
[ 2602.083354] Call trace:
[ 2602.083356]  _raw_spin_lock+0x34/0x68
[ 2602.083364]  release_firmware+0x48/0x6c
[ 2602.083370]  nxp_setup+0x3c4/0x540 [btnxpuart]
[ 2602.083383]  hci_dev_open_sync+0xf0/0xa34
[ 2602.083391]  hci_dev_open+0xd8/0x178
[ 2602.083399]  hci_sock_ioctl+0x3b0/0x590
[ 2602.083405]  sock_do_ioctl+0x60/0x118
[ 2602.083413]  sock_ioctl+0x2f4/0x374
[ 2602.091430]  __arm64_sys_ioctl+0xac/0xf0
[ 2602.091437]  invoke_syscall+0x48/0x110
[ 2602.091445]  el0_svc_common.constprop.0+0xc0/0xe0
[ 2602.091452]  do_el0_svc+0x1c/0x28
[ 2602.091457]  el0_svc+0x40/0xe4
[ 2602.091465]  el0t_64_sync_handler+0x120/0x12c
[ 2602.091470]  el0t_64_sync+0x190/0x194

Fixes: e3c4891098c8 ("Bluetooth: btnxpuart: Handle FW Download Abort scenario")
Fixes: 689ca16e5232 ("Bluetooth: NXP: Add protocol support for NXP Bluetooth chipsets")
Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btnxpuart.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/btnxpuart.c
+++ b/drivers/bluetooth/btnxpuart.c
@@ -601,8 +601,10 @@ static int nxp_download_firmware(struct
 							 &nxpdev->tx_state),
 					       msecs_to_jiffies(60000));
 
-	release_firmware(nxpdev->fw);
-	memset(nxpdev->fw_name, 0, sizeof(nxpdev->fw_name));
+	if (nxpdev->fw && strlen(nxpdev->fw_name)) {
+		release_firmware(nxpdev->fw);
+		memset(nxpdev->fw_name, 0, sizeof(nxpdev->fw_name));
+	}
 
 	if (err == 0) {
 		bt_dev_err(hdev, "FW Download Timeout. offset: %d",



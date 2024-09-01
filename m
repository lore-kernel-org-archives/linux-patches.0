Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999E717B50B;
	Sun,  1 Sep 2024 16:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208557; cv=none; b=r9gd9Apqtkr87IUXJVf26Ysc/daJ249MSdgMipKPjLvzWAUKHuswfGOw6Hu4HTdNMu6N2WH3xwm69GSWhKDfLg08SCSGJIPLdbyM4AB+6pTFawoHdyolywmMK88E2h0KqPz+TMYHgc7WIKGEQMpg3Q3r4nxk4sg/fWscFA1Mj/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208557; c=relaxed/simple;
	bh=Jl6L2orGbEVHYFirbzGfNqgvvfPYLYAuirA8wcv6uQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7cx0ZeTNXaFgU54vVIT+UvVrW+5ihGsuHDaipas5yQZez1D79tONcUexqg3CK847nnbIBWnrVm9+sKCCiocfywUvQhckZVe+ahUIIW++9FqPTXQy4/vt7ng6GVt6iTs4qdxKDIaZU5fiFBFtmEuYsnsxAfvM0+Inxh922R20Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fib8Zidu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fib8Zidu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196DBC4CEC3;
	Sun,  1 Sep 2024 16:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208557;
	bh=Jl6L2orGbEVHYFirbzGfNqgvvfPYLYAuirA8wcv6uQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fib8ZiduhQaHA9lnHZVQC9uSHbDSBUcxS82QAxxXDVWbiV/TvuvBHNvfUsav5n0TN
	 wB4YZFFYwGzqBAKaucOu7mzZ5nSGVg92phgo1FtomEJm/sjpOc5kb8f0F6+O3BLTxp
	 IZmZXADkRvJAjxuIgdt6E0Kcx+5LdeSXCwpnEQ5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 091/149] Bluetooth: btnxpuart: Fix random crash seen while removing driver
Date: Sun,  1 Sep 2024 18:16:42 +0200
Message-ID: <20240901160820.886857213@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>

[ Upstream commit 35237475384ab3622f63c3c09bdf6af6dacfe9c3 ]

This fixes the random kernel crash seen while removing the driver, when
running the load/unload test over multiple iterations.

1) modprobe btnxpuart
2) hciconfig hci0 reset
3) hciconfig (check hci0 interface up with valid BD address)
4) modprobe -r btnxpuart
Repeat steps 1 to 4

The ps_wakeup() call in btnxpuart_close() schedules the psdata->work(),
which gets scheduled after module is removed, causing a kernel crash.

This hidden issue got highlighted after enabling Power Save by default
in 4183a7be7700 (Bluetooth: btnxpuart: Enable Power Save feature on
startup)

The new ps_cleanup() deasserts UART break immediately while closing
serdev device, cancels any scheduled ps_work and destroys the ps_lock
mutex.

[   85.884604] Unable to handle kernel paging request at virtual address ffffd4a61638f258
[   85.884624] Mem abort info:
[   85.884625]   ESR = 0x0000000086000007
[   85.884628]   EC = 0x21: IABT (current EL), IL = 32 bits
[   85.884633]   SET = 0, FnV = 0
[   85.884636]   EA = 0, S1PTW = 0
[   85.884638]   FSC = 0x07: level 3 translation fault
[   85.884642] swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000041dd0000
[   85.884646] [ffffd4a61638f258] pgd=1000000095fff003, p4d=1000000095fff003, pud=100000004823d003, pmd=100000004823e003, pte=0000000000000000
[   85.884662] Internal error: Oops: 0000000086000007 [#1] PREEMPT SMP
[   85.890932] Modules linked in: algif_hash algif_skcipher af_alg overlay fsl_jr_uio caam_jr caamkeyblob_desc caamhash_desc caamalg_desc crypto_engine authenc libdes crct10dif_ce polyval_ce polyval_generic snd_soc_imx_spdif snd_soc_imx_card snd_soc_ak5558 snd_soc_ak4458 caam secvio error snd_soc_fsl_spdif snd_soc_fsl_micfil snd_soc_fsl_sai snd_soc_fsl_utils gpio_ir_recv rc_core fuse [last unloaded: btnxpuart(O)]
[   85.927297] CPU: 1 PID: 67 Comm: kworker/1:3 Tainted: G           O       6.1.36+g937b1be4345a #1
[   85.936176] Hardware name: FSL i.MX8MM EVK board (DT)
[   85.936182] Workqueue: events 0xffffd4a61638f380
[   85.936198] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   85.952817] pc : 0xffffd4a61638f258
[   85.952823] lr : 0xffffd4a61638f258
[   85.952827] sp : ffff8000084fbd70
[   85.952829] x29: ffff8000084fbd70 x28: 0000000000000000 x27: 0000000000000000
[   85.963112] x26: ffffd4a69133f000 x25: ffff4bf1c8540990 x24: ffff4bf215b87305
[   85.963119] x23: ffff4bf215b87300 x22: ffff4bf1c85409d0 x21: ffff4bf1c8540970
[   85.977382] x20: 0000000000000000 x19: ffff4bf1c8540880 x18: 0000000000000000
[   85.977391] x17: 0000000000000000 x16: 0000000000000133 x15: 0000ffffe2217090
[   85.977399] x14: 0000000000000001 x13: 0000000000000133 x12: 0000000000000139
[   85.977407] x11: 0000000000000001 x10: 0000000000000a60 x9 : ffff8000084fbc50
[   85.977417] x8 : ffff4bf215b7d000 x7 : ffff4bf215b83b40 x6 : 00000000000003e8
[   85.977424] x5 : 00000000410fd030 x4 : 0000000000000000 x3 : 0000000000000000
[   85.977432] x2 : 0000000000000000 x1 : ffff4bf1c4265880 x0 : 0000000000000000
[   85.977443] Call trace:
[   85.977446]  0xffffd4a61638f258
[   85.977451]  0xffffd4a61638f3e8
[   85.977455]  process_one_work+0x1d4/0x330
[   85.977464]  worker_thread+0x6c/0x430
[   85.977471]  kthread+0x108/0x10c
[   85.977476]  ret_from_fork+0x10/0x20
[   85.977488] Code: bad PC value
[   85.977491] ---[ end trace 0000000000000000 ]---

Preset since v6.9.11
Fixes: 86d55f124b52 ("Bluetooth: btnxpuart: Deasset UART break before closing serdev device")
Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btnxpuart.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btnxpuart.c b/drivers/bluetooth/btnxpuart.c
index 1bb97747c4836..eeba2d26d1cb9 100644
--- a/drivers/bluetooth/btnxpuart.c
+++ b/drivers/bluetooth/btnxpuart.c
@@ -438,6 +438,23 @@ static bool ps_wakeup(struct btnxpuart_dev *nxpdev)
 	return false;
 }
 
+static void ps_cleanup(struct btnxpuart_dev *nxpdev)
+{
+	struct ps_data *psdata = &nxpdev->psdata;
+	u8 ps_state;
+
+	mutex_lock(&psdata->ps_lock);
+	ps_state = psdata->ps_state;
+	mutex_unlock(&psdata->ps_lock);
+
+	if (ps_state != PS_STATE_AWAKE)
+		ps_control(psdata->hdev, PS_STATE_AWAKE);
+
+	ps_cancel_timer(nxpdev);
+	cancel_work_sync(&psdata->work);
+	mutex_destroy(&psdata->ps_lock);
+}
+
 static int send_ps_cmd(struct hci_dev *hdev, void *data)
 {
 	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
@@ -1307,7 +1324,6 @@ static int btnxpuart_close(struct hci_dev *hdev)
 {
 	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
 
-	ps_wakeup(nxpdev);
 	serdev_device_close(nxpdev->serdev);
 	skb_queue_purge(&nxpdev->txq);
 	kfree_skb(nxpdev->rx_skb);
@@ -1456,8 +1472,8 @@ static void nxp_serdev_remove(struct serdev_device *serdev)
 			nxpdev->new_baudrate = nxpdev->fw_init_baudrate;
 			nxp_set_baudrate_cmd(hdev, NULL);
 		}
-		ps_cancel_timer(nxpdev);
 	}
+	ps_cleanup(nxpdev);
 	hci_unregister_dev(hdev);
 	hci_free_dev(hdev);
 }
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BC5110A;
	Tue, 23 Jan 2024 02:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975771; cv=none; b=CICZ6EOhDsjZ8Eb5VPYWSGBpBBKhKVSWWlI1K0rOKrntCyGXVVFqtYb5DBwY0rYQItPhW2WPtdM6/BT2VaXmSYv0Dph6+uuUtJqc/XztQU7QU/F2Vh3cljb4ShPD643Z0S+btnGAc0yAhl3wrnR0GL/SjjSkc9gDrpr0uKN1gzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975771; c=relaxed/simple;
	bh=pCNbMlqqR64vqcs2CcazsAmh3FqKUuTlQQm4jyWkxUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VefXWw7p9nbkTaoQYChN3u2WzNyx6Y4FeK1U+RfnrwTf+2hbnIFOE0TiWJqjaQ3fj5Hvz4Zsgbr9ehO3jDR5ImVFg/fNzvyBGkNtukzVLEZEBXR+zXrsLkjT71mbSgph0Q2kDBuLyqdwRGz0YJnFMJOylp9t3jfNrNVVtqqQ6+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtH8CPp/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtH8CPp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA13C433F1;
	Tue, 23 Jan 2024 02:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975771;
	bh=pCNbMlqqR64vqcs2CcazsAmh3FqKUuTlQQm4jyWkxUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtH8CPp/VsEcrw7Q2HoCru/qBsIB4AkTrzyuNwo8DeEEZ1ncxOttU6jYtBtVqcZb7
	 7oJ/EJUE30sObCfV8uo1RS4/rgYW5lMVOXMeSzre7ub1m78K4LKEmOLph8Q/ZZ4eGs
	 mk5GYAJbnYAj7WrlaU6Cjtxa3Yk+OfYIjKeFWS78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Ma <maqianga@uniontech.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 554/583] net: stmmac: ethtool: Fixed calltrace caused by unbalanced disable_irq_wake calls
Date: Mon, 22 Jan 2024 16:00:05 -0800
Message-ID: <20240122235829.105950892@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiang Ma <maqianga@uniontech.com>

[ Upstream commit a23aa04042187cbde16f470b49d4ad60d32e9206 ]

We found the following dmesg calltrace when testing the GMAC NIC notebook:

[9.448656] ------------[ cut here ]------------
[9.448658] Unbalanced IRQ 43 wake disable
[9.448673] WARNING: CPU: 3 PID: 1083 at kernel/irq/manage.c:688 irq_set_irq_wake+0xe0/0x128
[9.448717] CPU: 3 PID: 1083 Comm: ethtool Tainted: G           O      4.19 #1
[9.448773]         ...
[9.448774] Call Trace:
[9.448781] [<9000000000209b5c>] show_stack+0x34/0x140
[9.448788] [<9000000000d52700>] dump_stack+0x98/0xd0
[9.448794] [<9000000000228610>] __warn+0xa8/0x120
[9.448797] [<9000000000d2fb60>] report_bug+0x98/0x130
[9.448800] [<900000000020a418>] do_bp+0x248/0x2f0
[9.448805] [<90000000002035f4>] handle_bp_int+0x4c/0x78
[9.448808] [<900000000029ea40>] irq_set_irq_wake+0xe0/0x128
[9.448813] [<9000000000a96a7c>] stmmac_set_wol+0x134/0x150
[9.448819] [<9000000000be6ed0>] dev_ethtool+0x1368/0x2440
[9.448824] [<9000000000c08350>] dev_ioctl+0x1f8/0x3e0
[9.448827] [<9000000000bb2a34>] sock_ioctl+0x2a4/0x450
[9.448832] [<900000000046f044>] do_vfs_ioctl+0xa4/0x738
[9.448834] [<900000000046f778>] ksys_ioctl+0xa0/0xe8
[9.448837] [<900000000046f7d8>] sys_ioctl+0x18/0x28
[9.448840] [<9000000000211ab4>] syscall_common+0x20/0x34
[9.448842] ---[ end trace 40c18d9aec863c3e ]---

Multiple disable_irq_wake() calls will keep decreasing the IRQ
wake_depth, When wake_depth is 0, calling disable_irq_wake() again,
will report the above calltrace.

Due to the need to appear in pairs, we cannot call disable_irq_wake()
without calling enable_irq_wake(). Fix this by making sure there are
no unbalanced disable_irq_wake() calls.

Fixes: 3172d3afa998 ("stmmac: support wake up irq from external sources (v3)")
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240112021249.24598-1-maqianga@uniontech.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h         |  1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 10 ++++++++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    |  1 +
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index cd7a9768de5f..b8c93b881a65 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -255,6 +255,7 @@ struct stmmac_priv {
 	u32 msg_enable;
 	int wolopts;
 	int wol_irq;
+	bool wol_irq_disabled;
 	int clk_csr;
 	struct timer_list eee_ctrl_timer;
 	int lpi_irq;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 419efe43951e..69c8c2528524 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -822,10 +822,16 @@ static int stmmac_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 	if (wol->wolopts) {
 		pr_info("stmmac: wakeup enable\n");
 		device_set_wakeup_enable(priv->device, 1);
-		enable_irq_wake(priv->wol_irq);
+		/* Avoid unbalanced enable_irq_wake calls */
+		if (priv->wol_irq_disabled)
+			enable_irq_wake(priv->wol_irq);
+		priv->wol_irq_disabled = false;
 	} else {
 		device_set_wakeup_enable(priv->device, 0);
-		disable_irq_wake(priv->wol_irq);
+		/* Avoid unbalanced disable_irq_wake calls */
+		if (!priv->wol_irq_disabled)
+			disable_irq_wake(priv->wol_irq);
+		priv->wol_irq_disabled = true;
 	}
 
 	mutex_lock(&priv->lock);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 69b9c71f0ede..1bfcf673b3ce 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3549,6 +3549,7 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
 	/* Request the Wake IRQ in case of another line
 	 * is used for WoL
 	 */
+	priv->wol_irq_disabled = true;
 	if (priv->wol_irq > 0 && priv->wol_irq != dev->irq) {
 		int_name = priv->int_name_wol;
 		sprintf(int_name, "%s:%s", dev->name, "wol");
-- 
2.43.0




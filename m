Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B640367B8F;
	Fri,  9 Oct 2026 14:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555856; cv=none; b=P/MFgtTAYZaECvDKGCoPJ1d0IhdqtmYgAQY2o6me8MCxk/wW7ystf6iPKMTLsdyHqS7TszMR7Z3ahK5rmxk7Wo1j8BHF5/H7eFAa3UpK7HUQiGis7dZLgGHpb4L5MT645g7exnfsTK2DbLmx9RyTXyS/fZUd2KfEQQqoHA+6gQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555856; c=relaxed/simple;
	bh=/RdA1vasvfuOr3APHr381uEPwXOOpWlmrcqWJJrZeMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccwhT3UmdYW3UQEEjoFwOz7mzHtKVrP5J3uTGLZnHm+L7MHvUkspKw9/a5Ctyu1L+bhjAyAsKle6EfARSq20B7NeqvjfgQcpPqF5mp626yjrNk2OIKcB4H/gLI3nnglcr/etBEmq52m/md5LxlknNPDqysYE7/eEBzxyUyThu7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ie6RTOFe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ie6RTOFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205D61F000FF;
	Fri,  9 Oct 2026 14:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555854;
	bh=zxw275SQ6m+93I4o6+RtkBIjZl8uZrzhFza04YOY2pE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ie6RTOFe+3++K1pNfscvp2Geb30zP0Ts+nKuiTh2Zu1WGZpTaJrwgPOXJgoWrI588
	 Bf9ZBmSpJQ+SNdy2EYXpr4L/LFwtj7kgKNUSxgDJckmCNvsj37htVBboH0JSHiBrJJ
	 dQ/cqPaiauMiMbjUx7lc3gY7/8txJlRHT9QNRUYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 080/428] wifi: ath11k: reset ar->num_stations on hardware start
Date: Fri,  9 Oct 2026 16:06:57 +0200
Message-ID: <20261009140947.928968080@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Escande <nico.escande@gmail.com>

[ Upstream commit 7e0ad05ebc72fffba2bdf2400400902d94ed7272 ]

When (multiple) hw restart occurs, we end up in a situation where we
cannot accept new stations / mesh peers. This seems to be the
'num_stations' in 'struct ath11k' that did not get reset properly in
this case. In ath11k_mac_op_start(), it was indeed the only accounting var
that did not get reset so let's clear it too.

This avoids problems like those:

	[1248828.088023] WARNING: CPU: 0 PID: 12281 at net/mac80211/util.c:1682 ieee80211_reconfig_stations+0x98/0xc0
	[1248828.088115] Call trace:
	[1248828.088116]  ieee80211_reconfig_stations+0x98/0xc0 (P)
	[1248828.088119]  ieee80211_reconfig+0x774/0x1438
	[1248828.088123]  ieee80211_restart_work+0x10c/0x178
	[1248828.088127]  process_one_work+0x178/0x3c0
	[1248828.088130]  worker_thread+0x280/0x440
	[1248828.088133]  kthread+0xe0/0xf8
	[1248828.088137]  ret_from_fork+0x10/0x20
	[1248828.088141] ---[ end trace 0000000000000000 ]---
	[1248836.686604] ath11k_pci 0000:04:00.0: refusing to associate station: too many connected already (128)
	[1248836.686609] ath11k_pci 0000:04:00.0: Failed to add station: xx:xx:xx:xx:xx:xx for VDEV: 1

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.9.0.1-01977-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260812-num-station-v3-1-871d20e043f6@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index ae91b57c8422f..c1fa42edd3630 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -6716,6 +6716,7 @@ static int ath11k_mac_op_start(struct ieee80211_hw *hw)
 	ar->num_started_vdevs = 0;
 	ar->num_created_vdevs = 0;
 	ar->num_peers = 0;
+	ar->num_stations = 0;
 	ar->allocated_vdev_map = 0;
 
 	/* Configure monitor status ring with default rx_filter to get rx status
-- 
2.53.0




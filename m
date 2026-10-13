Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941BE3B059F;
	Tue, 13 Oct 2026 12:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894784; cv=none; b=FjGKDoy87OJqDvPgR2V0BeewBh7UL/9BN53I4HBm+fzR4rsE3dE8wm2JTeW/UrAnO3OXkFy5I26w+8X6FYxb/ZiUilERV1ncIqAtig4mQEi3LnCMQL7+PxWfDt079HqlOkDrHe//iyeHatM77EBEBFfyAVsxnBMTCzZzR5F5ipI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894784; c=relaxed/simple;
	bh=aqJUyaK0jmAhL4KO8zRgxKu0bgVpYaXaxiHITzyPux0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F215BgmmRZgnWjNc8YQGoJWjFeZ4mOeI3qPOby68b+7UemiDkkUkRa/Xx0FyiYzB752St1b8QBE1NOwLH42eg5XSuBLX4YKKTt7xfnimQYKE2WCPpcQfeWIC+oE6xOp98+TudrvDYbcBHMA4OXHL9DspFqaS8ur/gTo4LH+fUZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TrVz1D0x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TrVz1D0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7DFA1F000FF;
	Tue, 13 Oct 2026 12:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894783;
	bh=usA3HopQWKiVrGVQKCJoN57eMe9Wt1wLDN5sPVGOt4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TrVz1D0x8UtmFvpV9Ry+HqNzDiMVvUpKqNS59kNbvKTsp+GETVUccW+xGZ2/m1IUZ
	 fHptA17ECntl/4ji7IWYBcnx4k3bdianBysdS0dKVJftm7O7qWOGtGIfdNs/X46iZB
	 1cnmzvwxjBOChNo8k3iZ8msWBuHHgHWbrdW44VU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/497] wifi: ath11k: reset ar->num_stations on hardware start
Date: Tue, 13 Oct 2026 13:33:43 +0200
Message-ID: <20261013112909.217000950@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 53bc1b90bab3c..2d0c6f9f3f763 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -6396,6 +6396,7 @@ static int ath11k_mac_op_start(struct ieee80211_hw *hw)
 	ar->num_started_vdevs = 0;
 	ar->num_created_vdevs = 0;
 	ar->num_peers = 0;
+	ar->num_stations = 0;
 	ar->allocated_vdev_map = 0;
 
 	/* Configure monitor status ring with default rx_filter to get rx status
-- 
2.53.0




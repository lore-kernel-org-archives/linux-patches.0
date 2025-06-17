Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52862FA652;
	Tue, 17 Jun 2025 16:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179264; cv=none; b=O0FXhK5gWnFjQAtUimTToUUp2bTRWvmxPlb32cqF6MHr11peIyw1km/FxgxF6NVUbi3nlo2jgxyezjVpt0JxK70kuZKcDsaTrzBqWWxSd+uakTSMacb61mSh8G35jDeUgT2kyU/CT6sJNoyoGiKPDdb8Oms97/ozgIAsqv4kq1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179264; c=relaxed/simple;
	bh=2flbqWcw44L23PspSVO3FITDG998NyKYffeZihIKmRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f99B8ORLd2vd9rOAP/42V1T49ts0j0vBi0nNpVDn5HVVsdgHlgK8rHWbSaPX2bYvLaOAAkOM8D3rSkjZN3r/lwrf1TdnSWNkxT8QPPGQXHwCyMKQ7D+15L6HYCXP67UP8shiAhlk4D6+Har2reuXsAqRJh/+0Bk88Y3798rSHss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bxrr7eJ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bxrr7eJ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16BDBC4CEE3;
	Tue, 17 Jun 2025 16:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179264;
	bh=2flbqWcw44L23PspSVO3FITDG998NyKYffeZihIKmRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bxrr7eJ5mEThPVAA3KkLsniBIpQxACP4afqojdQk1tOIeea80Ui4NdiszeJckExFZ
	 j1SWTAH7lzo9IrOnz/fgXgSe1a1SWpbArFskyNa3MrzBkcdx/wvnbeoJWxZRPXwurS
	 FIAfN/rNgMpp6hu0HoMl5Pc8O2WkgumyqA/fRupA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+846bb38dc67fe62cc733@syzkaller.appspotmail.com,
	John <john.cs.hey@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 698/780] e1000: Move cancel_work_sync to avoid deadlock
Date: Tue, 17 Jun 2025 17:26:46 +0200
Message-ID: <20250617152519.922570692@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Damato <jdamato@fastly.com>

[ Upstream commit b4a8085ceefb7bbb12c2b71c55e71fc946c6929f ]

Previously, e1000_down called cancel_work_sync for the e1000 reset task
(via e1000_down_and_stop), which takes RTNL.

As reported by users and syzbot, a deadlock is possible in the following
scenario:

CPU 0:
  - RTNL is held
  - e1000_close
  - e1000_down
  - cancel_work_sync (cancel / wait for e1000_reset_task())

CPU 1:
  - process_one_work
  - e1000_reset_task
  - take RTNL

To remedy this, avoid calling cancel_work_sync from e1000_down
(e1000_reset_task does nothing if the device is down anyway). Instead,
call cancel_work_sync for e1000_reset_task when the device is being
removed.

Fixes: e400c7444d84 ("e1000: Hold RTNL when e1000_down can be called")
Reported-by: syzbot+846bb38dc67fe62cc733@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/683837bf.a00a0220.52848.0003.GAE@google.com/
Reported-by: John <john.cs.hey@gmail.com>
Closes: https://lore.kernel.org/netdev/CAP=Rh=OEsn4y_2LvkO3UtDWurKcGPnZ_NPSXK=FbgygNXL37Sw@mail.gmail.com/
Signed-off-by: Joe Damato <jdamato@fastly.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Acked-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 3f089c3d47b23..d8595e84326db 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -477,10 +477,6 @@ static void e1000_down_and_stop(struct e1000_adapter *adapter)
 
 	cancel_delayed_work_sync(&adapter->phy_info_task);
 	cancel_delayed_work_sync(&adapter->fifo_stall_task);
-
-	/* Only kill reset task if adapter is not resetting */
-	if (!test_bit(__E1000_RESETTING, &adapter->flags))
-		cancel_work_sync(&adapter->reset_task);
 }
 
 void e1000_down(struct e1000_adapter *adapter)
@@ -1266,6 +1262,10 @@ static void e1000_remove(struct pci_dev *pdev)
 
 	unregister_netdev(netdev);
 
+	/* Only kill reset task if adapter is not resetting */
+	if (!test_bit(__E1000_RESETTING, &adapter->flags))
+		cancel_work_sync(&adapter->reset_task);
+
 	e1000_phy_hw_reset(hw);
 
 	kfree(adapter->tx_ring);
-- 
2.39.5




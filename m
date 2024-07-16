Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67FB1DDCE;
	Tue, 16 Jul 2024 16:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146058; cv=none; b=IR5PMw9Y0b/eZ9tMFYEAdcRIO5s3Hv959UinKPh3hGvucU84eBajSi/Wr5F+LJ5UtQd/TCj8wYXWhqA8cKuMHAI2D8gwSUW2MFzdjzOQOFLLDm3Wd5LNEFOvhpOCXuJUXJZQL4EVBDUPJ18di5jMWc67mCIX1Z3Uk6AYM4AeB50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146058; c=relaxed/simple;
	bh=zR6SyYH+qa31azhZ9x1UZR6cEo/h6fciHoGVOBVVa4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cq6dWKls3JODmwAyN0D3+wcCwWgMBixpEUeVEshQl1gXF4ETTRubJdl+radhSD0r3MmlBdklKIqNATH/U+abr85RorrVDMAFHWe7jY9nJCKm2DQab9Ks99EZqqIQZNt61jHCKFCxM4F2qnx/qcrOzCLVc5R2wZCNz15P8R7ejvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DmeCgMEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DmeCgMEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B656C116B1;
	Tue, 16 Jul 2024 16:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146057;
	bh=zR6SyYH+qa31azhZ9x1UZR6cEo/h6fciHoGVOBVVa4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DmeCgMEjdADwnq5x/Pn/HpJ9EhAwmh7fuvGM0Fhs/DaQWOpmGIxeh/TaXE7Kac2ql
	 Lj3340811BiUVPCkHSRwkGTKjORscwTyZnzFXnHpI/WOY7HNMaTT+EP9IWwAYXkU7X
	 lt8cD2w6WIgYe1Nxm1YZqGI0XXYAaNcrp2Dn/RdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corinna Vinschen <vinschen@redhat.com>,
	Hariprasad Kelam <hkelam@marvell.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/144] igc: fix a log entry using uninitialized netdev
Date: Tue, 16 Jul 2024 17:31:35 +0200
Message-ID: <20240716152753.545173142@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corinna Vinschen <vinschen@redhat.com>

[ Upstream commit 86167183a17e03ec77198897975e9fdfbd53cb0b ]

During successful probe, igc logs this:

[    5.133667] igc 0000:01:00.0 (unnamed net_device) (uninitialized): PHC added
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The reason is that igc_ptp_init() is called very early, even before
register_netdev() has been called. So the netdev_info() call works
on a partially uninitialized netdev.

Fix this by calling igc_ptp_init() after register_netdev(), right
after the media autosense check, just as in igb.  Add a comment,
just as in igb.

Now the log message is fine:

[    5.200987] igc 0000:01:00.0 eth0: PHC added

Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
Reviewed-by: Hariprasad Kelam <hkelam@marvell.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 6185566fbb98c..16a3d0f67ec96 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6673,8 +6673,6 @@ static int igc_probe(struct pci_dev *pdev,
 	device_set_wakeup_enable(&adapter->pdev->dev,
 				 adapter->flags & IGC_FLAG_WOL_SUPPORTED);
 
-	igc_ptp_init(adapter);
-
 	igc_tsn_clear_schedule(adapter);
 
 	/* reset the hardware with the new settings */
@@ -6696,6 +6694,9 @@ static int igc_probe(struct pci_dev *pdev,
 	/* Check if Media Autosense is enabled */
 	adapter->ei = *ei;
 
+	/* do hw tstamp init after resetting */
+	igc_ptp_init(adapter);
+
 	/* print pcie link status and MAC address */
 	pcie_print_link_status(pdev);
 	netdev_info(netdev, "MAC: %pM\n", netdev->dev_addr);
-- 
2.43.0




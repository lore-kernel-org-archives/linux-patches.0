Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DC4156F57;
	Tue,  9 Jul 2024 11:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524181; cv=none; b=e8k0jUFGOYPx5la+NzxwR6wwXvr9TSBAqsHVBfvpljThtrEKHPVGXyAZ3zBiwZe3j47MY9iT6Ezv1yiBwIbitO/2V3mljRdMz5UGidT4+jjVBEI9izcomAylwvD9y/aETvPTwdvNzN5i2uFbJBFaCtaq8Yw8obBOJ/PSg1DZ3R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524181; c=relaxed/simple;
	bh=53WNfXCyhnduuBJ5PzckXKQaD+7otavJoFwBcyFvNfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tAdlfBEW3tfzDsKACnNr3VmaNMr/f1UoN6dTQ8ktqK9R6I2ayJSu9XS2h+N7GqibaG7SEJUnrhUHTbRq/uCkOofXXYz16ZPYAczJFZCLzC46q5dMm+U+PWjBZQT+/UNxCqVEnC6plj3r2W8n2RNF+H4WRZCCXEH/S32LPURi5d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FIIcaX23; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FIIcaX23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5C5C3277B;
	Tue,  9 Jul 2024 11:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524181;
	bh=53WNfXCyhnduuBJ5PzckXKQaD+7otavJoFwBcyFvNfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FIIcaX23uvkl94jxrCNhvRfaDrhQxPOIYTxrEOCZWW/iQB9AxIbEC9exCy15HDyDg
	 cDwgPEanHN0S/TpQmA3P2Y9h+mHTNNKdrJok6jxWIJqfhGrUAErXtJ9ZfMb3MiMIPO
	 y/cawPITzmLSsUHk+d2CBBxQwTaAm+3RhxLljYPc=
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
Subject: [PATCH 6.9 066/197] igc: fix a log entry using uninitialized netdev
Date: Tue,  9 Jul 2024 13:08:40 +0200
Message-ID: <20240709110711.515762175@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 58bc96021bb4c..07feb951be749 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6932,8 +6932,6 @@ static int igc_probe(struct pci_dev *pdev,
 	device_set_wakeup_enable(&adapter->pdev->dev,
 				 adapter->flags & IGC_FLAG_WOL_SUPPORTED);
 
-	igc_ptp_init(adapter);
-
 	igc_tsn_clear_schedule(adapter);
 
 	/* reset the hardware with the new settings */
@@ -6955,6 +6953,9 @@ static int igc_probe(struct pci_dev *pdev,
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3444E3C23
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC86C433C0;
	Mon, 19 Jun 2023 10:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171186;
	bh=UxxYVwZlU89xa2aZmnLsdlv7+4Qiefbnp5hz4TBnG+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DmNEAZ2VaqB6VLtm1UoYM16mG/HQ0m967/o/rMojg7KXRsbSb2ct2L4qgsqKdG13Z
	 ySyi4AGaj9RjUJmaX9ednGG4KCD/i7CFz2PR2C89V53jP7ZwLGcjHKFPB8BOxDrC3w
	 SLoenGsNWX2KJ/ontGCzLmPcBA9MD2PoVAFRlJwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 152/187] igc: Fix possible system crash when loading module
Date: Mon, 19 Jun 2023 12:29:30 +0200
Message-ID: <20230619102204.965386952@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

[ Upstream commit c080fe262f9e73a00934b70c16b1479cf40cd2bd ]

Guarantee that when probe() is run again, PTM and PCI busmaster will be
in the same state as it was if the driver was never loaded.

Avoid an i225/i226 hardware issue that PTM requests can be made even
though PCI bus mastering is not enabled. These unexpected PTM requests
can crash some systems.

So, "force" disable PTM and busmastering before removing the driver,
so they can be re-enabled in the right order during probe(). This is
more like a workaround and should be applicable for i225 and i226, in
any platform.

Fixes: 1b5d73fb8624 ("igc: Enable PCIe PTM")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Reviewed-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index f44d9b8414567..b35f5ff3536e5 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6722,6 +6722,9 @@ static void igc_remove(struct pci_dev *pdev)
 
 	igc_ptp_stop(adapter);
 
+	pci_disable_ptm(pdev);
+	pci_clear_master(pdev);
+
 	set_bit(__IGC_DOWN, &adapter->state);
 
 	del_timer_sync(&adapter->watchdog_timer);
-- 
2.39.2




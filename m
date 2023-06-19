Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B434BE56
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AD9C433C0;
	Mon, 19 Jun 2023 10:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171710;
	bh=y4JPp/emkEflRU3LkhCsTCp7PwHbe3+a0MFhDkx6nxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3XPjy0FM9f9Uhp4DhJ7+mFYbBsJ1PLqq6UUODiox6PgnLLQ7YlqOEEw8fiL1/ytC
	 rFQ4DATWjmSXiIZt9hEvZqjzgYIb0dUD2Clt7jeJKVLmLNALgnWViAXz5RG7Y1YuK1
	 kozEm6fe5gjNtDJk14UIdJoYNldL9LxZi21+NONw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/166] igc: Fix possible system crash when loading module
Date: Mon, 19 Jun 2023 12:30:05 +0200
Message-ID: <20230619102201.013393917@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
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
index e5cb76cf2c3f1..3509974c1f8e4 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6685,6 +6685,9 @@ static void igc_remove(struct pci_dev *pdev)
 
 	igc_ptp_stop(adapter);
 
+	pci_disable_ptm(pdev);
+	pci_clear_master(pdev);
+
 	set_bit(__IGC_DOWN, &adapter->state);
 
 	del_timer_sync(&adapter->watchdog_timer);
-- 
2.39.2




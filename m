Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5933C14263
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FAAC433CA;
	Tue, 25 Jul 2023 11:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284395;
	bh=U3T8hGPr7fGnLvKHuuJk2IUejR58suIjLT5kyk5bWyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fr2fkdXg72kyPi7zyh260VdGplm/9duc6CGB6a8I0dA4DDcqH42X6jjHnuv/IR1BE
	 OX0inQm3HZuIIKXIo1A1mEs01Fw8zHAslUIta1P/3UXfhnzEKWCiWFmpDke1mfuVmA
	 y+YT6q1voOY3sGaE3I1N7kc9/As++6V3EwPkoz+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Sasha Neftin <sasha.neftin@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 339/509] igc: Remove delay during TX ring configuration
Date: Tue, 25 Jul 2023 12:44:38 +0200
Message-ID: <20230725104609.236273597@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>

[ Upstream commit cca28ceac7c7857bc2d313777017585aef00bcc4 ]

Remove unnecessary delay during the TX ring configuration.
This will cause delay, especially during link down and
link up activity.

Furthermore, old SKUs like as I225 will call the reset_adapter
to reset the controller during TSN mode Gate Control List (GCL)
setting. This will add more time to the configuration of the
real-time use case.

It doesn't mentioned about this delay in the Software User Manual.
It might have been ported from legacy code I210 in the past.

Fixes: 13b5b7fd6a4a ("igc: Add support for Tx/Rx rings")
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index a15e4b6d7fa40..2b51ee87a2def 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -600,7 +600,6 @@ static void igc_configure_tx_ring(struct igc_adapter *adapter,
 	/* disable the queue */
 	wr32(IGC_TXDCTL(reg_idx), 0);
 	wrfl();
-	mdelay(10);
 
 	wr32(IGC_TDLEN(reg_idx),
 	     ring->count * sizeof(union igc_adv_tx_desc));
-- 
2.39.2




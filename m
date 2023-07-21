Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE3E20F88
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2113C433C8;
	Fri, 21 Jul 2023 19:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966593;
	bh=O2UnranNXpQ/HYBkS19UPTfavFamObupx1rE/ZkYa54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f1pdDHRQWh0FZMXdMrNoAALBexiQJg/BXTaki9wbw4fxlkhv6X3rungltvrhbdpZ6
	 t5QhU7mlLgCn6yzenuM4EPd3jPbZFAGUyAeF0SusJpoviSG71sTv9l/mjh4GSnHKGP
	 VxzQ/wM/MWB7fBU0+EbIV03nZezuz/frRBeRmWnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Sasha Neftin <sasha.neftin@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 398/532] igc: Remove delay during TX ring configuration
Date: Fri, 21 Jul 2023 18:05:02 +0200
Message-ID: <20230721160636.052741876@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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
index abc63ca9d28bf..e5cbf867034e3 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -708,7 +708,6 @@ static void igc_configure_tx_ring(struct igc_adapter *adapter,
 	/* disable the queue */
 	wr32(IGC_TXDCTL(reg_idx), 0);
 	wrfl();
-	mdelay(10);
 
 	wr32(IGC_TDLEN(reg_idx),
 	     ring->count * sizeof(union igc_adv_tx_desc));
-- 
2.39.2




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FDA79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B882DC433D2;
	Thu, 12 Jan 2023 14:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533463;
	bh=NsKQ7cX8s43XnWuwFNk6M4yVAVwZYpw6eO3XxXVi0c8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fgS9F1NaHEUwtIsLynv2r0vqpOllEscmh8RNZ4UDqydwBx4RRD1X18XVn9vHIWIWI
	 c++wXtN/Ox/LkWXPrMXo9TkA+8j8siGNcAGztTVgDBWnTIq5eT5SDGRL+e0WwyVLWe
	 a+LJ6P4+TdymKoTUW35D/LZLrZOa3ZnQIq/yCRGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Aravindhan Gunasekaran <aravindhan.gunasekaran@intel.com>,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 469/783] igc: Use strict cycles for Qbv scheduling
Date: Thu, 12 Jan 2023 14:53:05 +0100
Message-Id: <20230112135545.966622241@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

[ Upstream commit d8f45be01dd9381065a3778a579385249ed011dc ]

Configuring strict cycle mode in the controller forces more well
behaved transmissions when taprio is offloaded.

When set this strict_cycle and strict_end, transmission is not
enabled if the whole packet cannot be completed before end of
the Qbv cycle.

Fixes: 82faa9b79950 ("igc: Add support for ETF offloading")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Aravindhan Gunasekaran <aravindhan.gunasekaran@intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_tsn.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index 174103c4bea6..2d4db2a547b2 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -92,15 +92,8 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 		wr32(IGC_STQT(i), ring->start_time);
 		wr32(IGC_ENDQT(i), ring->end_time);
 
-		if (adapter->base_time) {
-			/* If we have a base_time we are in "taprio"
-			 * mode and we need to be strict about the
-			 * cycles: only transmit a packet if it can be
-			 * completed during that cycle.
-			 */
-			txqctl |= IGC_TXQCTL_STRICT_CYCLE |
-				IGC_TXQCTL_STRICT_END;
-		}
+		txqctl |= IGC_TXQCTL_STRICT_CYCLE |
+			IGC_TXQCTL_STRICT_END;
 
 		if (ring->launchtime_enable)
 			txqctl |= IGC_TXQCTL_QUEUE_MODE_LAUNCHT;
-- 
2.35.1




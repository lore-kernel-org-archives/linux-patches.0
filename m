Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320CADF6D;
	Sat, 13 Jan 2024 10:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gGEIoIW9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AF4C433C7;
	Sat, 13 Jan 2024 10:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705140037;
	bh=ItvyajfT1IYvMlwaYu7txzEv9QxfwEzVtV6JABJKM8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gGEIoIW94pah+J4bDZ4e2RG2Ano6H6hisIGCwQy7a8sh+89IkdubdkEgOZw+7yFeU
	 rfofkRmG051HBQQt8bmqxPly+2GqTxdy2h2tf1jEx15QypYMsVhma9KKxqNZscG7H8
	 oHGC+awnCxztveCl92hFrm2Z9F03p8H1yMZG8rvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Rodrigo Cataldo <rodrigo.cadore@l-acoustics.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 33/59] igc: Fix hicredit calculation
Date: Sat, 13 Jan 2024 10:50:04 +0100
Message-ID: <20240113094210.326336599@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094209.301672391@linuxfoundation.org>
References: <20240113094209.301672391@linuxfoundation.org>
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

From: Rodrigo Cataldo <rodrigo.cadore@l-acoustics.com>

[ Upstream commit 947dfc8138dfaeb6e966e2d661de89eb203e3064 ]

According to the Intel Software Manual for I225, Section 7.5.2.7,
hicredit should be multiplied by the constant link-rate value, 0x7736.

Currently, the old constant link-rate value, 0x7735, from the boards
supported on igb are being used, most likely due to a copy'n'paste, as
the rest of the logic is the same for both drivers.

Update hicredit accordingly.

Fixes: 1ab011b0bf07 ("igc: Add support for CBS offloading")
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
Signed-off-by: Rodrigo Cataldo <rodrigo.cadore@l-acoustics.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_tsn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index 356c7455c5cee..2330b1ff915e7 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -185,7 +185,7 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 			wr32(IGC_TQAVCC(i), tqavcc);
 
 			wr32(IGC_TQAVHC(i),
-			     0x80000000 + ring->hicredit * 0x7735);
+			     0x80000000 + ring->hicredit * 0x7736);
 		} else {
 			/* Disable any CBS for the queue */
 			txqctl &= ~(IGC_TXQCTL_QAV_SEL_MASK);
-- 
2.43.0




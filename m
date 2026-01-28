Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F75A2FF178;
	Wed, 28 Jan 2026 15:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615496; cv=none; b=WJQdWAl62d3feH1SUcRmu6NMMxeEv+kn6arkxSYBOglSs+ODDZ1PRQWbvqDYCFwpiWbtCdjLFbJoowOhX6OdneWzZc/m75lgqYuYSTb1eXyf91tUYxToWc+Ni7u/x4TftXFpTp7rhiY7SMJR1fYA6tNnzYrnCNa4qj4M/IyjxGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615496; c=relaxed/simple;
	bh=26Ww30JpgaZ33Bfi11SfwtKiA8yP8hImrEy5ytVjtNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unzQ9yBR8pNwP9jNnmVDYcNFGaML/EJPwOLUgrAIC1Wu31rFw9iPjF08eZy6AAIFcY7joMVoXIQ/ILzEx3ApSywDoJwdKnPvLoun7mES7n2nvgVH94vmqIAdQMPmRG7E4U3pUL2TY0MO1g/tOGm5I57/x3MeW4anTITEuYR7X8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5e66FHs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5e66FHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEAECC4CEF1;
	Wed, 28 Jan 2026 15:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615496;
	bh=26Ww30JpgaZ33Bfi11SfwtKiA8yP8hImrEy5ytVjtNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5e66FHsKgW+eutmYlOFn7nYmIWqMFHdBB1uTHQZQkNNvPcuk2OEJkyPgNQXTnsRR
	 FqgsT3j+OuHMhp25aSmv5mHbfWBtoLlIAh3W9FVZsQKkkLTXvHrDxrKZ7tQq9bRTDh
	 eI6vIXl2ZZn6mO+IH4qxIaxUM8pkirhQAj78sDyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zdenek Bouska <zdenek.bouska@siemens.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Simon Horman <horms@kernel.org>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Chwee-Lin Choong <chwee.lin.choong@intel.com>,
	Avigail Dahan <avigailx.dahan@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 026/227] igc: Reduce TSN TX packet buffer from 7KB to 5KB per queue
Date: Wed, 28 Jan 2026 16:21:11 +0100
Message-ID: <20260128145345.287593477@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chwee-Lin Choong <chwee.lin.choong@intel.com>

[ Upstream commit 8ad1b6c1e63d25f5465b7a8aa403bdcee84b86f9 ]

The previous 7 KB per queue caused TX unit hangs under heavy
timestamping load. Reducing to 5 KB avoids these hangs and matches
the TSN recommendation in I225/I226 SW User Manual Section 7.5.4.

The 8 KB "freed" by this change is currently unused. This reduction
is not expected to impact throughput, as the i226 is PCIe-limited
for small TSN packets rather than TX-buffer-limited.

Fixes: 0d58cdc902da ("igc: optimize TX packet buffer utilization for TSN mode")
Reported-by: Zdenek Bouska <zdenek.bouska@siemens.com>
Closes: https://lore.kernel.org/netdev/AS1PR10MB5675DBFE7CE5F2A9336ABFA4EBEAA@AS1PR10MB5675.EURPRD10.PROD.OUTLOOK.COM/
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Chwee-Lin Choong <chwee.lin.choong@intel.com>
Tested-by: Avigail Dahan <avigailx.dahan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_defines.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 498ba1522ca4d..9482ab11f050f 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -443,9 +443,10 @@
 #define IGC_TXPBSIZE_DEFAULT ( \
 	IGC_TXPB0SIZE(20) | IGC_TXPB1SIZE(0) | IGC_TXPB2SIZE(0) | \
 	IGC_TXPB3SIZE(0) | IGC_OS2BMCPBSIZE(4))
+/* TSN value following I225/I226 SW User Manual Section 7.5.4 */
 #define IGC_TXPBSIZE_TSN ( \
-	IGC_TXPB0SIZE(7) | IGC_TXPB1SIZE(7) | IGC_TXPB2SIZE(7) | \
-	IGC_TXPB3SIZE(7) | IGC_OS2BMCPBSIZE(4))
+	IGC_TXPB0SIZE(5) | IGC_TXPB1SIZE(5) | IGC_TXPB2SIZE(5) | \
+	IGC_TXPB3SIZE(5) | IGC_OS2BMCPBSIZE(4))
 
 #define IGC_DTXMXPKTSZ_TSN	0x19 /* 1600 bytes of max TX DMA packet size */
 #define IGC_DTXMXPKTSZ_DEFAULT	0x98 /* 9728-byte Jumbo frames */
-- 
2.51.0




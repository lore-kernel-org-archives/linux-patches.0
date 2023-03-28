Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AEA8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:45:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B263EC433D2;
	Tue, 28 Mar 2023 14:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680014730;
	bh=MHLp96SbHz4REgQwloBCdqcQQ3cNDhkZrxjD27//ncY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WBHRIwjjszQ2QtaJkcoyHq6OuWbTMs8MAtsd8Z7ntVFVHvZfQ2iqt/OjHeqeHqhn8
	 lA0D8bG/4fLz4jLFpn5ARvMYTl2xfqCF0Ro94Y766aEBVPYPnJCprPpkVGwwulTnr3
	 UKSOzoWgYP7pVxVO0eOfy+r5uWWWB73sxz10/0EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 030/240] iavf: fix inverted Rx hash condition leading to disabled hash
Date: Tue, 28 Mar 2023 16:39:53 +0200
Message-Id: <20230328142620.883430253@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Lobakin <aleksander.lobakin@intel.com>

[ Upstream commit 32d57f667f871bc5a8babbe27ea4c5e668ee0ea8 ]

Condition, which checks whether the netdev has hashing enabled is
inverted. Basically, the tagged commit effectively disabled passing flow
hash from descriptor to skb, unless user *disables* it via Ethtool.
Commit a876c3ba59a6 ("i40e/i40evf: properly report Rx packet hash")
fixed this problem, but only for i40e.
Invert the condition now in iavf and unblock passing hash to skbs again.

Fixes: 857942fd1aa1 ("i40e: Fix Rx hash reported to the stack by our driver")
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index 18b6a702a1d6d..e989feda133c1 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -1096,7 +1096,7 @@ static inline void iavf_rx_hash(struct iavf_ring *ring,
 		cpu_to_le64((u64)IAVF_RX_DESC_FLTSTAT_RSS_HASH <<
 			    IAVF_RX_DESC_STATUS_FLTSTAT_SHIFT);
 
-	if (ring->netdev->features & NETIF_F_RXHASH)
+	if (!(ring->netdev->features & NETIF_F_RXHASH))
 		return;
 
 	if ((rx_desc->wb.qword1.status_error_len & rss_mask) == rss_mask) {
-- 
2.39.2




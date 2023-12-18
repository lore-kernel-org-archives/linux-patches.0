Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301AD37888;
	Mon, 18 Dec 2023 14:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hXNbb8S0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71F6C433C8;
	Mon, 18 Dec 2023 14:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908875;
	bh=cU0hYKW/tWMskHJfuQLoTtvdDu8ufhm1t5I+1qqn6rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hXNbb8S0gMRc+95joS79fbnxKRDdnBMTDKXKnVLQaq2xo+/ZSi1Ero+n6pRUnJ3lF
	 mDqWhvhWGC3wTturg7pgda7hplC4I9Gg4ieNPT8TWH9GfcPkT2VafwJQpNAg6U70J7
	 gfxCzF6xioo/HfnQ95kvA+wCB4Rpn5swAtJYoon8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Itzko <itzko@amazon.com>,
	David Arinzon <darinzon@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 27/83] net: ena: Destroy correct number of xdp queues upon failure
Date: Mon, 18 Dec 2023 14:51:48 +0100
Message-ID: <20231218135050.937851683@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135049.738602288@linuxfoundation.org>
References: <20231218135049.738602288@linuxfoundation.org>
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

From: David Arinzon <darinzon@amazon.com>

[ Upstream commit 41db6f99b5489a0d2ef26afe816ef0c6118d1d47 ]

The ena_setup_and_create_all_xdp_queues() function freed all the
resources upon failure, after creating only xdp_num_queues queues,
instead of freeing just the created ones.

In this patch, the only resources that are freed, are the ones
allocated right before the failure occurs.

Fixes: 548c4940b9f1 ("net: ena: Implement XDP_TX action")
Signed-off-by: Shahar Itzko <itzko@amazon.com>
Signed-off-by: David Arinzon <darinzon@amazon.com>
Link: https://lore.kernel.org/r/20231211062801.27891-2-darinzon@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 08f4c7f661214..da83580a11391 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -74,6 +74,8 @@ static void ena_unmap_tx_buff(struct ena_ring *tx_ring,
 			      struct ena_tx_buffer *tx_info);
 static int ena_create_io_tx_queues_in_range(struct ena_adapter *adapter,
 					    int first_index, int count);
+static void ena_free_all_io_tx_resources_in_range(struct ena_adapter *adapter,
+						  int first_index, int count);
 
 /* Increase a stat by cnt while holding syncp seqlock on 32bit machines */
 static void ena_increase_stat(u64 *statp, u64 cnt,
@@ -459,23 +461,22 @@ static void ena_init_all_xdp_queues(struct ena_adapter *adapter)
 
 static int ena_setup_and_create_all_xdp_queues(struct ena_adapter *adapter)
 {
+	u32 xdp_first_ring = adapter->xdp_first_ring;
+	u32 xdp_num_queues = adapter->xdp_num_queues;
 	int rc = 0;
 
-	rc = ena_setup_tx_resources_in_range(adapter, adapter->xdp_first_ring,
-					     adapter->xdp_num_queues);
+	rc = ena_setup_tx_resources_in_range(adapter, xdp_first_ring, xdp_num_queues);
 	if (rc)
 		goto setup_err;
 
-	rc = ena_create_io_tx_queues_in_range(adapter,
-					      adapter->xdp_first_ring,
-					      adapter->xdp_num_queues);
+	rc = ena_create_io_tx_queues_in_range(adapter, xdp_first_ring, xdp_num_queues);
 	if (rc)
 		goto create_err;
 
 	return 0;
 
 create_err:
-	ena_free_all_io_tx_resources(adapter);
+	ena_free_all_io_tx_resources_in_range(adapter, xdp_first_ring, xdp_num_queues);
 setup_err:
 	return rc;
 }
-- 
2.43.0




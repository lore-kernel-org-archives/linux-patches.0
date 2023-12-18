Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2932A15AC0;
	Mon, 18 Dec 2023 14:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SqtJUSyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A012FC433C8;
	Mon, 18 Dec 2023 14:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908536;
	bh=vCprard5ev8delhaAWAvhU8vDOEl5ZqNsMHlXLvkvCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SqtJUSylzug/hp6MaRiFWEKIIGARF3un0NTjnrr9oE/F1xIseg26ASzdE0Jgu9cAo
	 PbCLrvY37aP91r7I0ATAiKseyYPOh20509cxzuzvSb60qnEu1K3rFU6hTIpjA+9FP1
	 fXlAHWaLgVSEPof9EdUP5OUyOMUrJ9V5TaS3mPqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Itzko <itzko@amazon.com>,
	David Arinzon <darinzon@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 16/62] net: ena: Destroy correct number of xdp queues upon failure
Date: Mon, 18 Dec 2023 14:51:40 +0100
Message-ID: <20231218135046.952803620@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135046.178317233@linuxfoundation.org>
References: <20231218135046.178317233@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1722d4091ea3f..e13ae04d2f0fd 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -77,6 +77,8 @@ static void ena_unmap_tx_buff(struct ena_ring *tx_ring,
 			      struct ena_tx_buffer *tx_info);
 static int ena_create_io_tx_queues_in_range(struct ena_adapter *adapter,
 					    int first_index, int count);
+static void ena_free_all_io_tx_resources_in_range(struct ena_adapter *adapter,
+						  int first_index, int count);
 
 static void ena_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
@@ -388,23 +390,22 @@ static void ena_init_all_xdp_queues(struct ena_adapter *adapter)
 
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




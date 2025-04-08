Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0637264A76;
	Tue,  8 Apr 2025 11:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110943; cv=none; b=H8eQhDRaQW9YOw0FDR2TmwDgohOKQk6zms03gpJAcWlL//pyeiL7ur0S2tzG8IC6Hi4VczYm42riDfp6Dy/v3PpQn2DBSwj7oNqpatGPWfARrnePAoj7DHgrdVt+VbI1BxFwGTvkYkOTLziQUgxG6325pp7o2gCND7AlrIEEBXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110943; c=relaxed/simple;
	bh=k6cx2jQcxz77bi98ywG7dd1Y3pkUbicRL1zgx3Q52Kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFVU4Qb87hNoHnL0NggjayPkVujtOrnh8C7L2jul5IcNitrrZCfmL/DXIAWj+OWlonNZrL9fOddMs1tfwBvaDqKutJo7zK8Q0pBjVcBstW0mvrjsn22KYpZRHrHSRyj55iZfACVoHxIOQybo2FpIZwWvaraVBukFIq7omFV+uR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kB2SRjrc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kB2SRjrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B973C4CEEC;
	Tue,  8 Apr 2025 11:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110943;
	bh=k6cx2jQcxz77bi98ywG7dd1Y3pkUbicRL1zgx3Q52Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kB2SRjrcGZLlVF1pzj+Porh5t/VEy81QAIQ8cp74+PNrEw7IYviTgZi92p2UdUVCL
	 DTV+bPlVss1fy4ZRy/qG02hFe6HbHvvb92sjOBl3m4uX7eSo5R3ANnifnCJkM7hJY1
	 D0Ex+eIZCUWeeo1hys0E9OXv8iXeeJy39uZtKEv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Child <nnac123@linux.ibm.com>,
	Dave Marquardt <davemarq@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 250/731] ibmvnic: Use kernel helpers for hex dumps
Date: Tue,  8 Apr 2025 12:42:27 +0200
Message-ID: <20250408104920.099755216@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Child <nnac123@linux.ibm.com>

[ Upstream commit d93a6caab5d7d9b5ce034d75b1e1e993338e3852 ]

Previously, when the driver was printing hex dumps, the buffer was cast
to an 8 byte long and printed using string formatters. If the buffer
size was not a multiple of 8 then a read buffer overflow was possible.

Therefore, create a new ibmvnic function that loops over a buffer and
calls hex_dump_to_buffer instead.

This patch address KASAN reports like the one below:
  ibmvnic 30000003 env3: Login Buffer:
  ibmvnic 30000003 env3: 01000000af000000
  <...>
  ibmvnic 30000003 env3: 2e6d62692e736261
  ibmvnic 30000003 env3: 65050003006d6f63
  ==================================================================
  BUG: KASAN: slab-out-of-bounds in ibmvnic_login+0xacc/0xffc [ibmvnic]
  Read of size 8 at addr c0000001331a9aa8 by task ip/17681
  <...>
  Allocated by task 17681:
  <...>
  ibmvnic_login+0x2f0/0xffc [ibmvnic]
  ibmvnic_open+0x148/0x308 [ibmvnic]
  __dev_open+0x1ac/0x304
  <...>
  The buggy address is located 168 bytes inside of
                allocated 175-byte region [c0000001331a9a00, c0000001331a9aaf)
  <...>
  =================================================================
  ibmvnic 30000003 env3: 000000000033766e

Fixes: 032c5e82847a ("Driver for IBM System i/p VNIC protocol")
Signed-off-by: Nick Child <nnac123@linux.ibm.com>
Reviewed-by: Dave Marquardt <davemarq@linux.ibm.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250320212951.11142-1-nnac123@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 0676fc547b6f4..480606d1245ea 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4829,6 +4829,18 @@ static void vnic_add_client_data(struct ibmvnic_adapter *adapter,
 	strscpy(vlcd->name, adapter->netdev->name, len);
 }
 
+static void ibmvnic_print_hex_dump(struct net_device *dev, void *buf,
+				   size_t len)
+{
+	unsigned char hex_str[16 * 3];
+
+	for (size_t i = 0; i < len; i += 16) {
+		hex_dump_to_buffer((unsigned char *)buf + i, len - i, 16, 8,
+				   hex_str, sizeof(hex_str), false);
+		netdev_dbg(dev, "%s\n", hex_str);
+	}
+}
+
 static int send_login(struct ibmvnic_adapter *adapter)
 {
 	struct ibmvnic_login_rsp_buffer *login_rsp_buffer;
@@ -4939,10 +4951,8 @@ static int send_login(struct ibmvnic_adapter *adapter)
 	vnic_add_client_data(adapter, vlcd);
 
 	netdev_dbg(adapter->netdev, "Login Buffer:\n");
-	for (i = 0; i < (adapter->login_buf_sz - 1) / 8 + 1; i++) {
-		netdev_dbg(adapter->netdev, "%016lx\n",
-			   ((unsigned long *)(adapter->login_buf))[i]);
-	}
+	ibmvnic_print_hex_dump(adapter->netdev, adapter->login_buf,
+			       adapter->login_buf_sz);
 
 	memset(&crq, 0, sizeof(crq));
 	crq.login.first = IBMVNIC_CRQ_CMD;
@@ -5319,15 +5329,13 @@ static void handle_query_ip_offload_rsp(struct ibmvnic_adapter *adapter)
 {
 	struct device *dev = &adapter->vdev->dev;
 	struct ibmvnic_query_ip_offload_buffer *buf = &adapter->ip_offload_buf;
-	int i;
 
 	dma_unmap_single(dev, adapter->ip_offload_tok,
 			 sizeof(adapter->ip_offload_buf), DMA_FROM_DEVICE);
 
 	netdev_dbg(adapter->netdev, "Query IP Offload Buffer:\n");
-	for (i = 0; i < (sizeof(adapter->ip_offload_buf) - 1) / 8 + 1; i++)
-		netdev_dbg(adapter->netdev, "%016lx\n",
-			   ((unsigned long *)(buf))[i]);
+	ibmvnic_print_hex_dump(adapter->netdev, buf,
+			       sizeof(adapter->ip_offload_buf));
 
 	netdev_dbg(adapter->netdev, "ipv4_chksum = %d\n", buf->ipv4_chksum);
 	netdev_dbg(adapter->netdev, "ipv6_chksum = %d\n", buf->ipv6_chksum);
@@ -5558,10 +5566,8 @@ static int handle_login_rsp(union ibmvnic_crq *login_rsp_crq,
 	netdev->mtu = adapter->req_mtu - ETH_HLEN;
 
 	netdev_dbg(adapter->netdev, "Login Response Buffer:\n");
-	for (i = 0; i < (adapter->login_rsp_buf_sz - 1) / 8 + 1; i++) {
-		netdev_dbg(adapter->netdev, "%016lx\n",
-			   ((unsigned long *)(adapter->login_rsp_buf))[i]);
-	}
+	ibmvnic_print_hex_dump(netdev, adapter->login_rsp_buf,
+			       adapter->login_rsp_buf_sz);
 
 	/* Sanity checks */
 	if (login->num_txcomp_subcrqs != login_rsp->num_txsubm_subcrqs ||
-- 
2.39.5




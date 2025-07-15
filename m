Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815C52E8E1A;
	Tue, 15 Jul 2025 13:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585992; cv=none; b=mGzc9JTJr/DkmtjaDdDJ6X4IZliFFmNQBhP2oBp/QJSdFSlYXlDLUHRfoMZzQKSZi5CGOgxblucmFHs8NmMDFCV5rMPXgVlvoed1SVtLDydiV/DDSXcyJCYPZCbn2C/aCiyQY8UwKNPLByFsgh9r3N75xhMuQySP+GfIHIv/BLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585992; c=relaxed/simple;
	bh=ErSy9AIZZVKGfmre+FX91KLGLCLLsdGEvZBs70MkRDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwlGkc5ZBlo8/piBl/0oExuct88G5B9ykWLX3U13hH71p7pgUNszNQNstDxPkxJlJfmw3XKNVtVVTGn31ZqSL9qHbkkdIF2IxRMee0DAScjnJgzcPDTlsLlCWHtR6u7K5odbp7niWsC3FGBBBF+gdejdZ+jV4S+XtcJeIsTwMm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3F2ISSh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3F2ISSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4348C4CEE3;
	Tue, 15 Jul 2025 13:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585991;
	bh=ErSy9AIZZVKGfmre+FX91KLGLCLLsdGEvZBs70MkRDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S3F2ISShseZiTAfEHWd4ZSq5+Nnx6LrubJe8vZkMtlDybXdKArnma7AZNQbkyRJvs
	 jWHWvLo3pIbC+/m/hNsM6vk0htd53Tk7Nr5JGsIgC6oyMhmwnBLLzDE0IWeSk3QNhe
	 Lkz4GSQTjIhcOPJfoyC/IdRFwyNJPU6bzJZLNeCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Dave Marquardt <davemarq@linux.ibm.com>,
	Haren Myneni <haren@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/109] ibmvnic: Fix hardcoded NUM_RX_STATS/NUM_TX_STATS with dynamic sizeof
Date: Tue, 15 Jul 2025 15:13:41 +0200
Message-ID: <20250715130802.283800695@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingming Cao <mmc@linux.ibm.com>

[ Upstream commit 01b8114b432d7baaa5e51ab229c12c4f36b8e2c6 ]

The previous hardcoded definitions of NUM_RX_STATS and
NUM_TX_STATS were not updated when new fields were added
to the ibmvnic_{rx,tx}_queue_stats structures. Specifically,
commit 2ee73c54a615 ("ibmvnic: Add stat for tx direct vs tx
batched") added a fourth TX stat, but NUM_TX_STATS remained 3,
leading to a mismatch.

This patch replaces the static defines with dynamic sizeof-based
calculations to ensure the stat arrays are correctly sized.
This fixes incorrect indexing and prevents incomplete stat
reporting in tools like ethtool.

Fixes: 2ee73c54a615 ("ibmvnic: Add stat for tx direct vs tx batched")
Signed-off-by: Mingming Cao <mmc@linux.ibm.com>
Reviewed-by: Dave Marquardt <davemarq@linux.ibm.com>
Reviewed-by: Haren Myneni <haren@linux.ibm.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250709153332.73892-1-mmc@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index b3fc18db4f4c3..dfbda2e5ec88a 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -211,7 +211,6 @@ struct ibmvnic_statistics {
 	u8 reserved[72];
 } __packed __aligned(8);
 
-#define NUM_TX_STATS 3
 struct ibmvnic_tx_queue_stats {
 	u64 batched_packets;
 	u64 direct_packets;
@@ -219,13 +218,18 @@ struct ibmvnic_tx_queue_stats {
 	u64 dropped_packets;
 };
 
-#define NUM_RX_STATS 3
+#define NUM_TX_STATS \
+	(sizeof(struct ibmvnic_tx_queue_stats) / sizeof(u64))
+
 struct ibmvnic_rx_queue_stats {
 	u64 packets;
 	u64 bytes;
 	u64 interrupts;
 };
 
+#define NUM_RX_STATS \
+	(sizeof(struct ibmvnic_rx_queue_stats) / sizeof(u64))
+
 struct ibmvnic_acl_buffer {
 	__be32 len;
 	__be32 version;
-- 
2.39.5




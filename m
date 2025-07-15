Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BF22E62B4;
	Tue, 15 Jul 2025 13:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587068; cv=none; b=bxVWLEIv7jXi9Fv+e3M/vr8L8UmR+OTgEvoQWohEitmQIEpEpI+upmR0SQn9G02h8MUH5ROKzUTNkc5gtfqerGvXyWM41Dl9M166moAHlj9g+WqOXKQIrUrxfG/3aTMvz6aP9dR7gFgh3PFXgdRFAEXKm29UxtVs5Plr7UJ7NVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587068; c=relaxed/simple;
	bh=dqfV6IXA3S5uY53MhP6gjTl87RffaBdrryIwgViZ++c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RvM8VnMPWF8Pq8h/cDiymUNkA2PDfSd6SryIIuocEUZUJxnNJpAdfkyXs05xdL0pAg1NJWrMRjTlGHhPORmCPB2tsjo2hpVF9cJzFBRoGyPJtVvDnZmnXIgizRET4SmcTgBKvAX0/C4ZQ9i2joypnt0dI2yF25joIKy3dZmnZ5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SqUvU7/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SqUvU7/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E8DC4CEE3;
	Tue, 15 Jul 2025 13:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587068;
	bh=dqfV6IXA3S5uY53MhP6gjTl87RffaBdrryIwgViZ++c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SqUvU7/spHvymzJvCbrxtFQU/ASIkEjWj3gD5f+/Gt0WmjeReXjSYIbIb2dsfudgy
	 iH1PacBiFhrdm0dIJLiEKbR4q+TnfytH/1C9ijLlYXgJfi3sZUiSzGQszSxjWEmQpZ
	 9uT552oDsDOh5Kx+qbv2jjwNrsMjPjrazmIloftQ=
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
Subject: [PATCH 6.15 153/192] ibmvnic: Fix hardcoded NUM_RX_STATS/NUM_TX_STATS with dynamic sizeof
Date: Tue, 15 Jul 2025 15:14:08 +0200
Message-ID: <20250715130821.053427303@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index a189038d88df0..246ddce753f92 100644
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




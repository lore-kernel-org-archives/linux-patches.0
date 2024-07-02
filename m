Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BE4178381;
	Tue,  2 Jul 2024 17:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940779; cv=none; b=TiJhGwhNd8gZ+0FUArS+KNXm0MwZM5vsRM8gPWV2Uvr9OarSxBsBZKMMx4s2O0AQZiVunCGw64ixl+ROCuD5I5ksde/tr+8MH47l7fTXthmhusNbX9OkvvyqnJCTjqiDt5J+klEl7SNGujq1ErVOIcSeLd1j1p9OrMF4HlWx4JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940779; c=relaxed/simple;
	bh=tC7kLki2FIaWftD2wK45N/ZhMJPZgaAe0IiCJhOaupI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXy/sgS3U09g7KmKAfTtLyUbgc+59zXOD4k+2vVGERqs/Z6P4dGwsP58VihvXxSZbqQNSSm0M0/UdUkLU89D3QZips6QyLyH47AJbE2OZghmttxLjAFF/zTSbFDgDBIzM88GZqmaEeuG1Wra35KQmKusrhahisOlQ4qyWGmXXCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0y3z3Ne; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0y3z3Ne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD460C4AF0A;
	Tue,  2 Jul 2024 17:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940779;
	bh=tC7kLki2FIaWftD2wK45N/ZhMJPZgaAe0IiCJhOaupI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0y3z3NegH/iLPYTSoTq0XID613xipNUUxNIwolLaNXfPnu6M2+Ey70RjNawanIx4
	 lmWNSbovXJbozWssz9nQXtSP3GmmVqGLADK3EOtBZt/Ci+/qcTwb1tl00aA77qu0j1
	 cr24AvVSNilvPAPONAkCHionYfSeaHqmSpC9YoYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Child <nnac123@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/163] ibmvnic: Free any outstanding tx skbs during scrq reset
Date: Tue,  2 Jul 2024 19:02:26 +0200
Message-ID: <20240702170234.274453933@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Child <nnac123@linux.ibm.com>

[ Upstream commit 49bbeb5719c2f56907d3a9623b47c6c15c2c431d ]

There are 2 types of outstanding tx skb's:
Type 1: Packets that are sitting in the drivers ind_buff that are
waiting to be batch sent to the NIC. During a device reset, these are
freed with a call to ibmvnic_tx_scrq_clean_buffer()
Type 2: Packets that have been sent to the NIC and are awaiting a TX
completion IRQ. These are free'd during a reset with a call to
clean_tx_pools()

During any reset which requires us to free the tx irq, ensure that the
Type 2 skb references are freed. Since the irq is released, it is
impossible for the NIC to inform of any completions.

Furthermore, later in the reset process is a call to init_tx_pools()
which marks every entry in the tx pool as free (ie not outstanding).
So if the driver is to make a call to init_tx_pools(), it must first
be sure that the tx pool is empty of skb references.

This issue was discovered by observing the following in the logs during
EEH testing:
	TX free map points to untracked skb (tso_pool 0 idx=4)
	TX free map points to untracked skb (tso_pool 0 idx=5)
	TX free map points to untracked skb (tso_pool 1 idx=36)

Fixes: 65d6470d139a ("ibmvnic: clean pending indirect buffs during reset")
Signed-off-by: Nick Child <nnac123@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index cdf5251e56795..ca21e55335b23 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4057,6 +4057,12 @@ static void release_sub_crqs(struct ibmvnic_adapter *adapter, bool do_h_free)
 		adapter->num_active_tx_scrqs = 0;
 	}
 
+	/* Clean any remaining outstanding SKBs
+	 * we freed the irq so we won't be hearing
+	 * from them
+	 */
+	clean_tx_pools(adapter);
+
 	if (adapter->rx_scrq) {
 		for (i = 0; i < adapter->num_active_rx_scrqs; i++) {
 			if (!adapter->rx_scrq[i])
-- 
2.43.0




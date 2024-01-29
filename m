Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2182159576;
	Mon, 29 Jan 2024 17:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548187; cv=none; b=eWrc0ybMQnj4ympG/nEHe1d0PvmHL6nRIE57WS3Eb1Rll3tILIPxkFJmsxtjn1aKX0qELa2asD4TnvbNfP3qgBWRma9sHaN9eKabBIqhgEhsoVvGRaI9xMkIEnTwiXcl4RPMYN2Eb6f16jyhtu3Y1TGjoIYZM7qx9GAKjZISbHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548187; c=relaxed/simple;
	bh=40vGYWATS9hwY3XTQyCtCo3qf48s1epaELwQQF5PYBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IO6NexXllAv4p5Hfq4Yef8qmh+EudN4tKsSi5BzM55Bz3Da2aZUCBPE+1PNp7PI+8s5qz7hMyJeanQ36rRnEZfgfiOAQ2Q5k4aRBKygx4rLN3OAHwP+BrOVCaEJqKfyJTV4ohkCfgptRWSfPo9Y+R4e6ZWHKvuJoFAqMxSrd5QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=brRjG4vU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="brRjG4vU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997CAC433C7;
	Mon, 29 Jan 2024 17:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548187;
	bh=40vGYWATS9hwY3XTQyCtCo3qf48s1epaELwQQF5PYBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=brRjG4vULstlyigJrcqVtm/MZyaa6fVdtdMsJ4/3bZ0aMuqVjCXZDpQHI49Bxygy6
	 hmL4kGCVNXXO4So7TXV+DH7fCKntcu0zaFOM3/ErTvDe6zjge2lc/b09o/a8KEa3LI
	 awR1VkxPjqxh2C+G2aQPWdZJRJbR3bwxkFRsS3WQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jenishkumar Maheshbhai Patel <jpatel2@marvell.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 203/346] net: mvpp2: clear BM pool before initialization
Date: Mon, 29 Jan 2024 09:03:54 -0800
Message-ID: <20240129170022.365490321@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jenishkumar Maheshbhai Patel <jpatel2@marvell.com>

[ Upstream commit 9f538b415db862e74b8c5d3abbccfc1b2b6caa38 ]

Register value persist after booting the kernel using
kexec which results in kernel panic. Thus clear the
BM pool registers before initialisation to fix the issue.

Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
Signed-off-by: Jenishkumar Maheshbhai Patel <jpatel2@marvell.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://lore.kernel.org/r/20240119035914.2595665-1-jpatel2@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 27 ++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 93137606869e..065f07392c96 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -614,12 +614,38 @@ static void mvpp23_bm_set_8pool_mode(struct mvpp2 *priv)
 	mvpp2_write(priv, MVPP22_BM_POOL_BASE_ADDR_HIGH_REG, val);
 }
 
+/* Cleanup pool before actual initialization in the OS */
+static void mvpp2_bm_pool_cleanup(struct mvpp2 *priv, int pool_id)
+{
+	unsigned int thread = mvpp2_cpu_to_thread(priv, get_cpu());
+	u32 val;
+	int i;
+
+	/* Drain the BM from all possible residues left by firmware */
+	for (i = 0; i < MVPP2_BM_POOL_SIZE_MAX; i++)
+		mvpp2_thread_read(priv, thread, MVPP2_BM_PHY_ALLOC_REG(pool_id));
+
+	put_cpu();
+
+	/* Stop the BM pool */
+	val = mvpp2_read(priv, MVPP2_BM_POOL_CTRL_REG(pool_id));
+	val |= MVPP2_BM_STOP_MASK;
+	mvpp2_write(priv, MVPP2_BM_POOL_CTRL_REG(pool_id), val);
+}
+
 static int mvpp2_bm_init(struct device *dev, struct mvpp2 *priv)
 {
 	enum dma_data_direction dma_dir = DMA_FROM_DEVICE;
 	int i, err, poolnum = MVPP2_BM_POOLS_NUM;
 	struct mvpp2_port *port;
 
+	if (priv->percpu_pools)
+		poolnum = mvpp2_get_nrxqs(priv) * 2;
+
+	/* Clean up the pool state in case it contains stale state */
+	for (i = 0; i < poolnum; i++)
+		mvpp2_bm_pool_cleanup(priv, i);
+
 	if (priv->percpu_pools) {
 		for (i = 0; i < priv->port_count; i++) {
 			port = priv->port_list[i];
@@ -629,7 +655,6 @@ static int mvpp2_bm_init(struct device *dev, struct mvpp2 *priv)
 			}
 		}
 
-		poolnum = mvpp2_get_nrxqs(priv) * 2;
 		for (i = 0; i < poolnum; i++) {
 			/* the pool in use */
 			int pn = i / (poolnum / 2);
-- 
2.43.0




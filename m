Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514087B3F2;
	Wed, 21 Feb 2024 13:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523790; cv=none; b=cAFEObRbMVGFK9wdozQ7SkHGEUelswL7h6lDPU4kXTZDq26pZIOhIIwcE2vyZZ2ckVED70IcvH0Io7FXAcYdDzdmF1huNHEbvhGKW1LUYGJQNpxgQkn+Q9n9rZC3d79IgzFs6Oj3kZxQG0UUT1slA1Zdc8KltbdwopAuRZfw+js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523790; c=relaxed/simple;
	bh=m2BPwJptNQ88ibIhAZcQxLaAw7KA5Zl65gTLHOvF+O0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qsim7UWr6hZIvBL0opr5ZoArGGrpOAd1xxkp+SNm5/9RhZEidZO6yPIJC9K5yUilqpJ9fKUzD0tgc5SdW8aMuEwx5RlN0xw4DpZtUDerTpo1eiarQdUtJ6sC4R8C/3SDosNZMa/0VPqFPoF0LXfoS8fujcoU5EY3Xi5HfpuGYgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UV8Dm6Q8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UV8Dm6Q8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE536C43394;
	Wed, 21 Feb 2024 13:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523790;
	bh=m2BPwJptNQ88ibIhAZcQxLaAw7KA5Zl65gTLHOvF+O0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UV8Dm6Q87RaGDIviBK8VrWj2yXLjj7ksLKQogMie8WbXB++YBXRDBHeNDq1hwOWn7
	 J9dqr2OFJdOIsGDvKKxwgkPhMJwwykD6WP8p4RoP/AcOJoK9PIOlW3zRi7Vb+8M9ot
	 +Q/a9QmST4WjJ8iqFS0mTaEw7zcTQvpcK5G8Kxhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jenishkumar Maheshbhai Patel <jpatel2@marvell.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/379] net: mvpp2: clear BM pool before initialization
Date: Wed, 21 Feb 2024 14:03:57 +0100
Message-ID: <20240221125956.630346851@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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
index e0e6275b3e20..e4e80c2b1ce4 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -581,12 +581,38 @@ static int mvpp2_bm_pools_init(struct device *dev, struct mvpp2 *priv)
 	return err;
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
@@ -596,7 +622,6 @@ static int mvpp2_bm_init(struct device *dev, struct mvpp2 *priv)
 			}
 		}
 
-		poolnum = mvpp2_get_nrxqs(priv) * 2;
 		for (i = 0; i < poolnum; i++) {
 			/* the pool in use */
 			int pn = i / (poolnum / 2);
-- 
2.43.0




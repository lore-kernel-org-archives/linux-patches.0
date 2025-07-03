Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345342EF670;
	Thu,  3 Jul 2025 14:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554514; cv=none; b=H20NK5hsAgel4WGT2irObPlP7PivZMn7XrmSMNwreJVf86jK/dtThqfiREtvLEDjJ4IxzQB0H7fgG4xKhWryZJjl6mTvS/2e441vQ9ChT5JAedhisfdI1mmKuIAUDUecEhE0EYY38Cr07ZvzAZneNHum3dWit3+nCSG7dbQdv+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554514; c=relaxed/simple;
	bh=R1hW+Rm2hlIBJ2N4KJw9jshdWHwDuRIzTgKUXszAjes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7PTGDftLC31ART4jBucmoa1tjZPfsd/3L65wNpdYWAwn2s9nf7iXZCKpjEWmu+Z5sC3fH1mSghshWpQjeg0e9SvDBtVmRnXIja+RhWHYJm5jaTcaHPw3oTkg1v4WnHW5mQKVHcNX6qYJl32zdiHzZ7f6851/+Cl7urISXwnaEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OaMBE7yn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OaMBE7yn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567A5C4CEE3;
	Thu,  3 Jul 2025 14:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554513;
	bh=R1hW+Rm2hlIBJ2N4KJw9jshdWHwDuRIzTgKUXszAjes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OaMBE7ynX1b1GZEz2Y1FS2zBSdd2C5qhvBXzjqyZ8HR9ri508ntrSUPj+48GMYXc5
	 916IgR9HF9zsQ61CG4t0sNeb7iPGRVHMekwopo+9yieWJ1wY2LAbk27jGH7HEe2kfx
	 1Y5gxdb2JLes1DZF8E+VsQ+jQUmPtAsvkmYSjuVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <dqfext@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 211/218] net: stmmac: Fix accessing freed irq affinity_hint
Date: Thu,  3 Jul 2025 16:42:39 +0200
Message-ID: <20250703144004.653311063@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingfang Deng <dqfext@gmail.com>

[ Upstream commit c60d101a226f18e9a8f01bb4c6ca2b47dfcb15ef ]

The cpumask should not be a local variable, since its pointer is saved
to irq_desc and may be accessed from procfs.
To fix it, use the persistent mask cpumask_of(cpu#).

Cc: stable@vger.kernel.org
Fixes: 8deec94c6040 ("net: stmmac: set IRQ affinity hint for multi MSI vectors")
Signed-off-by: Qingfang Deng <dqfext@gmail.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250318032424.112067-1-dqfext@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 0250c5cb28ff2..36328298dc9b8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3603,7 +3603,6 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	enum request_irq_err irq_err;
-	cpumask_t cpu_mask;
 	int irq_idx = 0;
 	char *int_name;
 	int ret;
@@ -3732,9 +3731,8 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
 			irq_idx = i;
 			goto irq_error;
 		}
-		cpumask_clear(&cpu_mask);
-		cpumask_set_cpu(i % num_online_cpus(), &cpu_mask);
-		irq_set_affinity_hint(priv->rx_irq[i], &cpu_mask);
+		irq_set_affinity_hint(priv->rx_irq[i],
+				      cpumask_of(i % num_online_cpus()));
 	}
 
 	/* Request Tx MSI irq */
@@ -3757,9 +3755,8 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
 			irq_idx = i;
 			goto irq_error;
 		}
-		cpumask_clear(&cpu_mask);
-		cpumask_set_cpu(i % num_online_cpus(), &cpu_mask);
-		irq_set_affinity_hint(priv->tx_irq[i], &cpu_mask);
+		irq_set_affinity_hint(priv->tx_irq[i],
+				      cpumask_of(i % num_online_cpus()));
 	}
 
 	return 0;
-- 
2.39.5




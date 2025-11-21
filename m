Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209DE3F9D2;
	Fri, 21 Nov 2025 13:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733535; cv=none; b=cUQCwD35j+ZPsOYUXGQSNGRqIO5PAduo6FmEpNBS/jJndZ7LRw/9cUEmERCUWqD0Vo9PzDJ2r5qrAViYgmGC0NofvRrAlGaLNAWnjv4DF/HJjEvV268BYBQvpofQQzeZHyAqp/rEI4nKLuffwgNOx4gcTHhpeW69Ngo9oEcpjf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733535; c=relaxed/simple;
	bh=dgkvbYU5EHaD2RYk9b9vxkniTpsskDVpI6+ZLsnGNuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z16hxVR9zRHlFFmBOttq8iA3PMsZYDg5XUyIacQIZC1caWwHC8H2Zq3FQIuZq1wDO5pp6NI99fT0/9VbuIj4Mns0HXbvhMRdwSi1Q3ewjUTK3618ZFGlPBO28fx7gO5S8BGpYc5mf0tBPK/8a2IRoEV9LB0HzeFVdQATrEHHMZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oppp0mia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oppp0mia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99107C4CEF1;
	Fri, 21 Nov 2025 13:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733535;
	bh=dgkvbYU5EHaD2RYk9b9vxkniTpsskDVpI6+ZLsnGNuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oppp0mia85nEZaI14fxdhSyE9wiytx+m3gxbmClHsO4EPmkwjmUSVMnZZym0aNWbA
	 GD9/Atz1eBYrcfX7egBGlwWJoMiZorrWx1Wpi+tkoUh5oAXHkHiDWljQ9fFgS0KBly
	 5Fg8sa7QQbnlSFV+YfJCeeHzCY23jxO4p2O9GGYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <dqfext@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Rajani Kantha <681739313@139.com>
Subject: [PATCH 6.6 502/529] net: stmmac: Fix accessing freed irq affinity_hint
Date: Fri, 21 Nov 2025 14:13:21 +0100
Message-ID: <20251121130248.878141531@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
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
Signed-off-by: Rajani Kantha <681739313@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3516,7 +3516,6 @@ static int stmmac_request_irq_multi_msi(
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	enum request_irq_err irq_err;
-	cpumask_t cpu_mask;
 	int irq_idx = 0;
 	char *int_name;
 	int ret;
@@ -3628,9 +3627,8 @@ static int stmmac_request_irq_multi_msi(
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
@@ -3653,9 +3651,8 @@ static int stmmac_request_irq_multi_msi(
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



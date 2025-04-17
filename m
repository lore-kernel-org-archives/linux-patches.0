Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E285A1EB1BF;
	Thu, 17 Apr 2025 18:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913289; cv=none; b=m+ObDNoZHUGSMH2Rf/W1dGi8BRpFvmcPWwjUSZZuo+oV7SEIMb2c0ax0QaxbmBifyYtlIyoag+bwMQA4VXR0o3Osnc1nFwOV35fFLyLE2d5dIc7jMqqArOcGX+rxF98Ay8xMMu6OL2fmG8z5KZWoALzw24AxbWR11NH/gVqXWhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913289; c=relaxed/simple;
	bh=oDe70kJuNOtQymgUC7ztH1LhtjeYXtT7rO7Vqxz1/GY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IUpXneb3C4WYF2kaV9a1hnYpFn8nqRsfZiDLhP2nqf5dVS5rvbt654QMIvCwecbgrWlxM/G04X4dBYWy0KdmKUXzdrumoR0KEf+icn3GGbEnJAubANONVFqgmjqkEVKc01g6dxcC/ZlaZkf8aqkYGQSTGpEFMcMC5eEwp5gVdH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PfSOsK4E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PfSOsK4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB07C4CEE4;
	Thu, 17 Apr 2025 18:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913288;
	bh=oDe70kJuNOtQymgUC7ztH1LhtjeYXtT7rO7Vqxz1/GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PfSOsK4ERleyPpotua3vivDO7PPGmL5Dqe4tW3r9kNHZxBP+icueBV1UqjMpaiHIt
	 +AhHgkkkbqKuxK+oMXapBBi4J1clw1R8zbpgqxBieWg4FfNYlEvDXwcFQC5fUFnG6f
	 kzLzWAky7LNr4Nh2xcQSDSSMqGgoHRMv9oLaZuqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <dqfext@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.14 289/449] net: stmmac: Fix accessing freed irq affinity_hint
Date: Thu, 17 Apr 2025 19:49:37 +0200
Message-ID: <20250417175129.713165055@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

From: Qingfang Deng <dqfext@gmail.com>

commit c60d101a226f18e9a8f01bb4c6ca2b47dfcb15ef upstream.

The cpumask should not be a local variable, since its pointer is saved
to irq_desc and may be accessed from procfs.
To fix it, use the persistent mask cpumask_of(cpu#).

Cc: stable@vger.kernel.org
Fixes: 8deec94c6040 ("net: stmmac: set IRQ affinity hint for multi MSI vectors")
Signed-off-by: Qingfang Deng <dqfext@gmail.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250318032424.112067-1-dqfext@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3640,7 +3640,6 @@ static int stmmac_request_irq_multi_msi(
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	enum request_irq_err irq_err;
-	cpumask_t cpu_mask;
 	int irq_idx = 0;
 	char *int_name;
 	int ret;
@@ -3769,9 +3768,8 @@ static int stmmac_request_irq_multi_msi(
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
@@ -3794,9 +3792,8 @@ static int stmmac_request_irq_multi_msi(
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



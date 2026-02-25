Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E0221D596;
	Wed, 25 Feb 2026 01:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982967; cv=none; b=M3aodCHcJhAIbNettPOma0rCg1Q4xxpHOVOjsPtWXWqU4XVQsF+zPIWVQIijQq5CBASrD4dUcQFXRQ2iVDhjDMmdy50g0wzmwwhbEZ4iHlpM2+8+bV9eJxIt+VaqOGDoEAG8HX38icJqgXCApOHjRdgmFI6ZNoPpuW6h9s86v3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982967; c=relaxed/simple;
	bh=F4wibqX3GDgFQbEdlc5XSIzJ4G8ef8eYAl0S2hIQIW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpJ1Wo2PMKRUbCALfci5Nu8yzdOXQNtvgMHxn3xQIWd4zzfFmGA92mf5aN9tcKA/8dH54J89JuTCPxKcgksTrCqxpkdG9jbPCWqSnXN/CCbg6BJfQEfUGbdh6xoEwD7oUy12kBy5219UHCt3FVXwimST0c71GGQGOWyT147ez3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2p4Yk0Wi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2p4Yk0Wi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693F0C116D0;
	Wed, 25 Feb 2026 01:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982966;
	bh=F4wibqX3GDgFQbEdlc5XSIzJ4G8ef8eYAl0S2hIQIW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2p4Yk0WiukR6FxrZbSjQ0vUhc6sJ9iWsZ8rVTG2JngmCorgwjuQ6/fH9TJN+e2qVB
	 c2mfZH1SBoLvcr/SOhklzbr7YacD0AEzGGLoTEDsGTSCHew+YOavquYTu+U6Qo9pFs
	 j8C3YeV8+ZckU1GkFnb7+PxQTGnwxYtDzT+KkK+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianpeng Chang <jianpeng.chang.cn@windriver.com>,
	Breno Leitao <leitao@debian.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 115/781] crypto: caam - fix netdev memory leak in dpaa2_caam_probe
Date: Tue, 24 Feb 2026 17:13:44 -0800
Message-ID: <20260225012402.496498521@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianpeng Chang <jianpeng.chang.cn@windriver.com>

[ Upstream commit 7d43252b3060b0ba4a192dce5dba85a3f39ffe39 ]

When commit 0e1a4d427f58 ("crypto: caam: Unembed net_dev structure in
dpaa2") converted embedded net_device to dynamically allocated pointers,
it added cleanup in dpaa2_dpseci_disable() but missed adding cleanup in
dpaa2_dpseci_free() for error paths.

This causes memory leaks when dpaa2_dpseci_dpio_setup() fails during probe
due to DPIO devices not being ready yet. The kernel's deferred probe
mechanism handles the retry successfully, but the netdevs allocated during
the failed probe attempt are never freed, resulting in kmemleak reports
showing multiple leaked netdev-related allocations all traced back to
dpaa2_caam_probe().

Fix this by preserving the CPU mask of allocated netdevs during setup and
using it for cleanup in dpaa2_dpseci_free(). This approach ensures that
only the CPUs that actually had netdevs allocated will be cleaned up,
avoiding potential issues with CPU hotplug scenarios.

Fixes: 0e1a4d427f58 ("crypto: caam: Unembed net_dev structure in dpaa2")
Signed-off-by: Jianpeng Chang <jianpeng.chang.cn@windriver.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/caamalg_qi2.c | 27 +++++++++++++++------------
 drivers/crypto/caam/caamalg_qi2.h |  2 ++
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 107ccb2ade420..c6117c23eb25b 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -4814,7 +4814,8 @@ static void dpaa2_dpseci_free(struct dpaa2_caam_priv *priv)
 {
 	struct device *dev = priv->dev;
 	struct fsl_mc_device *ls_dev = to_fsl_mc_device(dev);
-	int err;
+	struct dpaa2_caam_priv_per_cpu *ppriv;
+	int i, err;
 
 	if (DPSECI_VER(priv->major_ver, priv->minor_ver) > DPSECI_VER(5, 3)) {
 		err = dpseci_reset(priv->mc_io, 0, ls_dev->mc_handle);
@@ -4822,6 +4823,12 @@ static void dpaa2_dpseci_free(struct dpaa2_caam_priv *priv)
 			dev_err(dev, "dpseci_reset() failed\n");
 	}
 
+	for_each_cpu(i, priv->clean_mask) {
+		ppriv = per_cpu_ptr(priv->ppriv, i);
+		free_netdev(ppriv->net_dev);
+	}
+	free_cpumask_var(priv->clean_mask);
+
 	dpaa2_dpseci_congestion_free(priv);
 	dpseci_close(priv->mc_io, 0, ls_dev->mc_handle);
 }
@@ -5007,16 +5014,15 @@ static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
 	struct device *dev = &ls_dev->dev;
 	struct dpaa2_caam_priv *priv;
 	struct dpaa2_caam_priv_per_cpu *ppriv;
-	cpumask_var_t clean_mask;
 	int err, cpu;
 	u8 i;
 
 	err = -ENOMEM;
-	if (!zalloc_cpumask_var(&clean_mask, GFP_KERNEL))
-		goto err_cpumask;
-
 	priv = dev_get_drvdata(dev);
 
+	if (!zalloc_cpumask_var(&priv->clean_mask, GFP_KERNEL))
+		goto err_cpumask;
+
 	priv->dev = dev;
 	priv->dpsec_id = ls_dev->obj_desc.id;
 
@@ -5118,7 +5124,7 @@ static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
 			err = -ENOMEM;
 			goto err_alloc_netdev;
 		}
-		cpumask_set_cpu(cpu, clean_mask);
+		cpumask_set_cpu(cpu, priv->clean_mask);
 		ppriv->net_dev->dev = *dev;
 
 		netif_napi_add_tx_weight(ppriv->net_dev, &ppriv->napi,
@@ -5126,18 +5132,16 @@ static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
 					 DPAA2_CAAM_NAPI_WEIGHT);
 	}
 
-	err = 0;
-	goto free_cpumask;
+	return 0;
 
 err_alloc_netdev:
-	free_dpaa2_pcpu_netdev(priv, clean_mask);
+	free_dpaa2_pcpu_netdev(priv, priv->clean_mask);
 err_get_rx_queue:
 	dpaa2_dpseci_congestion_free(priv);
 err_get_vers:
 	dpseci_close(priv->mc_io, 0, ls_dev->mc_handle);
 err_open:
-free_cpumask:
-	free_cpumask_var(clean_mask);
+	free_cpumask_var(priv->clean_mask);
 err_cpumask:
 	return err;
 }
@@ -5182,7 +5186,6 @@ static int __cold dpaa2_dpseci_disable(struct dpaa2_caam_priv *priv)
 		ppriv = per_cpu_ptr(priv->ppriv, i);
 		napi_disable(&ppriv->napi);
 		netif_napi_del(&ppriv->napi);
-		free_netdev(ppriv->net_dev);
 	}
 
 	return 0;
diff --git a/drivers/crypto/caam/caamalg_qi2.h b/drivers/crypto/caam/caamalg_qi2.h
index 61d1219a202fc..8e65b4b28c7ba 100644
--- a/drivers/crypto/caam/caamalg_qi2.h
+++ b/drivers/crypto/caam/caamalg_qi2.h
@@ -42,6 +42,7 @@
  * @mc_io: pointer to MC portal's I/O object
  * @domain: IOMMU domain
  * @ppriv: per CPU pointers to privata data
+ * @clean_mask: CPU mask of CPUs that have allocated netdevs
  */
 struct dpaa2_caam_priv {
 	int dpsec_id;
@@ -65,6 +66,7 @@ struct dpaa2_caam_priv {
 
 	struct dpaa2_caam_priv_per_cpu __percpu *ppriv;
 	struct dentry *dfs_root;
+	cpumask_var_t clean_mask;
 };
 
 /**
-- 
2.51.0




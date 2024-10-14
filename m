Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557631AB6C1;
	Mon, 14 Oct 2024 14:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917000; cv=none; b=Xi7r7uj7g+0eY09acsn8tWO/C+dDzEUtCf575slTz1UxczYrc+hhgMqu2bv/waBkNkcx3EIKuNndDWEUx4ZNLhtUjnaUyFeQnrfwgzdJELoZmpcqojMfliyX2NQ6Z24jFQSobb0VjMs+ZhzPGriZTW6w4c9Lc0/6JKUSqY0jLAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917000; c=relaxed/simple;
	bh=O5oGpRzabzeqX37hsifSO8BttgEqXt2+CVwyWOtndHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L12paS+w3bGj7RBIYWRtZdlSHtM1qruJkU9O1QHfDEIzAjxHV2amfo+I5I6p9QqDbk3UHGyVU0b4zOifDBZWBa1EinWXkj9ZvdDJxPp3+BYvAPyHlFXspltLfD3ymb2j4I389ES2iQUVVp/qfS6HmzBJh2J+0cYHS+uR11mow2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Abhsdf+3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Abhsdf+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0CA5C4CEC7;
	Mon, 14 Oct 2024 14:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917000;
	bh=O5oGpRzabzeqX37hsifSO8BttgEqXt2+CVwyWOtndHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Abhsdf+3rkg1zUN/CELGDG9FUchWA4S1RLrEK7HrhBR9ZCojSkYYkV5XXgw/dkrUw
	 nX95rRqmd/TZZKBy+p4Eet2xt/X5k11/Eb68f78baJjrQOkhqfNr4ec9lN7q6/1HIa
	 8fuddLQ3Wfbgl3t5HWljbeh67dmaXCelGkY0+6lI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/213] thermal: int340x: processor_thermal: Set feature mask before proc_thermal_add
Date: Mon, 14 Oct 2024 16:20:30 +0200
Message-ID: <20241014141047.812429843@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 6ebc25d8b053a208786295bab58abbb66b39c318 ]

The function proc_thermal_add() adds sysfs entries for power limits.

The feature mask of available features is not present at that time, so
it cannot be used by proc_thermal_add() to selectively create sysfs
attributes.

The feature mask is set by proc_thermal_mmio_add(), so modify the code
to call it before proc_thermal_add() so as to allow the latter to use
the feature mask.

There is no functional impact with this change.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 99ca0b57e49f ("thermal: intel: int340x: processor: Fix warning during module unload")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../processor_thermal_device_pci.c            | 21 +++++++++----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
index 0d1e980072704..e7a0f17cdbe4b 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
@@ -223,19 +223,19 @@ static int proc_thermal_pci_probe(struct pci_dev *pdev, const struct pci_device_
 
 	INIT_DELAYED_WORK(&pci_info->work, proc_thermal_threshold_work_fn);
 
-	ret = proc_thermal_add(&pdev->dev, proc_priv);
-	if (ret) {
-		dev_err(&pdev->dev, "error: proc_thermal_add, will continue\n");
-		pci_info->no_legacy = 1;
-	}
-
 	proc_priv->priv_data = pci_info;
 	pci_info->proc_priv = proc_priv;
 	pci_set_drvdata(pdev, proc_priv);
 
 	ret = proc_thermal_mmio_add(pdev, proc_priv, id->driver_data);
 	if (ret)
-		goto err_ret_thermal;
+		return ret;
+
+	ret = proc_thermal_add(&pdev->dev, proc_priv);
+	if (ret) {
+		dev_err(&pdev->dev, "error: proc_thermal_add, will continue\n");
+		pci_info->no_legacy = 1;
+	}
 
 	psv_trip.temperature = get_trip_temp(pci_info);
 
@@ -245,7 +245,7 @@ static int proc_thermal_pci_probe(struct pci_dev *pdev, const struct pci_device_
 							&tzone_params, 0, 0);
 	if (IS_ERR(pci_info->tzone)) {
 		ret = PTR_ERR(pci_info->tzone);
-		goto err_ret_mmio;
+		goto err_del_legacy;
 	}
 
 	/* request and enable interrupt */
@@ -276,11 +276,10 @@ static int proc_thermal_pci_probe(struct pci_dev *pdev, const struct pci_device_
 	pci_free_irq_vectors(pdev);
 err_ret_tzone:
 	thermal_zone_device_unregister(pci_info->tzone);
-err_ret_mmio:
-	proc_thermal_mmio_remove(pdev, proc_priv);
-err_ret_thermal:
+err_del_legacy:
 	if (!pci_info->no_legacy)
 		proc_thermal_remove(proc_priv);
+	proc_thermal_mmio_remove(pdev, proc_priv);
 	pci_disable_device(pdev);
 
 	return ret;
-- 
2.43.0




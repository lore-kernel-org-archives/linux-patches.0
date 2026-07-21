Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2613EBF02;
	Tue, 21 Jul 2026 17:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655328; cv=none; b=WImb+Xwo1Ei12Mui7c+h8D48yQ9cFcgHYyko5c5GhCQmLVEOefltyrslCd4fU/yKvv63jFrWD/qF8mbN7ZwC5ke/fTJbKGIlwhFctcEqwqvA3H4UMu+mltCNilTNPXW4qshBCjuQPN2MC+dpYzyql+mdr7jwh1ogy0KBL9SJFCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655328; c=relaxed/simple;
	bh=cO6ElW2VHjdqON5JHJbep+g21b920BmAt1F+2kOYAI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrWb1hdqky3O6wmztvEWHBiZjcLU11fdMBoQ8HrzSKNBXZ7XZsoGqhlMpT+i6f18gO2t2fEeD39QbsegsGrGfTnc9vIXoQIiYyR1MSPc7Fze2pZmHId6yvd7BFeCXSYaOJhIvOREbIL62+ZRE1VZSgYcH21F1yTI7lVMKSivsQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0o8Cu5LS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0o8Cu5LS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBF51F000E9;
	Tue, 21 Jul 2026 17:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655327;
	bh=7qoFpTdsqVM46sX9BoBXxt4ekqGoilTm3nt12qqCQJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0o8Cu5LSsw6/daLJdt+Rh6PR3gE11g6Bm9bb5qWVLE2xPwjLbJ0oxcuI7kCY6X9JL
	 IMrcyIXJ2y/u5d3al5qnAXncJJDGbjUqxYTODsZuuDjn5Ec7I8u2lSX3dI82AUkXwn
	 T4QH/2MOTKiqFWnZTApvuYfoSj+S5Iad7TVQDAZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Luke Wang <ziniu.wang_1@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.1 2043/2077] mmc: sdhci-esdhc-imx: fix resume error handling
Date: Tue, 21 Jul 2026 17:28:36 +0200
Message-ID: <20260721152640.883956500@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luke Wang <ziniu.wang_1@nxp.com>

commit e27c946b589c53520409a0956b33d52ef7a0898f upstream.

Check pm_runtime_force_resume() return value in resume. If it fails
(clock enable failure), return immediately since accessing hardware
registers on an unclocked device would cause a kernel panic.

The early return intentionally skips enable_irq() and
sdhci_disable_irq_wakeups() because the IRQ handler reads
SDHCI_INT_STATUS, which would also fault without clocks. The PM runtime
usage counter leak only affects this already-broken device instance and
is an acceptable tradeoff to preserve system stability.

Remove the return value check for mmc_gpio_set_cd_wake(host->mmc, false)
since disable_irq_wake() called internally always returns 0.

Also return 0 explicitly on the success path instead of propagating
stale return values.

Fixes: 676a83855614 ("mmc: host: sdhci-esdhc-imx: refactor the system PM logic")
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Luke Wang <ziniu.wang_1@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -2123,12 +2123,12 @@ static int sdhci_esdhc_resume(struct dev
 			dev_warn(dev, "Failed to restore pinctrl state\n");
 	}
 
-	pm_runtime_force_resume(dev);
-
-	ret = mmc_gpio_set_cd_wake(host->mmc, false);
+	ret = pm_runtime_force_resume(dev);
 	if (ret)
 		return ret;
 
+	mmc_gpio_set_cd_wake(host->mmc, false);
+
 	/* re-initialize hw state in case it's lost in low power mode */
 	sdhci_esdhc_imx_hwinit(host);
 
@@ -2155,7 +2155,7 @@ static int sdhci_esdhc_resume(struct dev
 
 	pm_runtime_put_autosuspend(dev);
 
-	return ret;
+	return 0;
 }
 
 static int sdhci_esdhc_runtime_suspend(struct device *dev)



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398A42E1C7C;
	Tue, 31 Mar 2026 17:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976784; cv=none; b=dfVknqZPR/Cjki+Tx7Oa5t5PPN4249OP5JKfN7et2/wDjn+XQOhg/0L0qHu3uRMppAK52A6oIxRkq7sclR4f2f6aAwNzN/lLuYqXpz+nYOtBIlZq5PTQoxEGcwk6qEnm5MAFA+vuKjbuzBpgH52nSD/dCr1x5D0q5n15S4qK6iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976784; c=relaxed/simple;
	bh=Ux/GIHzvFMYNG/brA++zdcGhq7OhXd5uQ37bIBOdu44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmB64lA6wJficu//tKyiiVj1YaMYFzC879VDvr3vOP7K16H1KPgO/CZcuS9bwcHtcyzq6Ohjzhms2I/HC2aVNFxeraKOllm3FvfsrCb0zVmb0c7EnyvfRR0jlO3CJ1DQh3X4SJGzAoZSB3DHro7JnWgmv52K99+9/lp884HdJMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QbZUswe4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QbZUswe4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2723C19423;
	Tue, 31 Mar 2026 17:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976784;
	bh=Ux/GIHzvFMYNG/brA++zdcGhq7OhXd5uQ37bIBOdu44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbZUswe4PXxx1zLcIX36KGbGBFsV6KSHQNP+FhR2UYGLrJciaVepQB+UTAG91Xk6f
	 Srh+DDtyEt0fPMZSJqMWFmWvatYG6Yf/jMz7YSLlNdGz8/N4RRGdiG7rS9hjqOM38V
	 Ilw+FGmTNcKMYW1YcJmCBYvZEMjVZZ3/vjXd+OVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Du <bin.du@amd.com>,
	Pratap Nirujogi <pratap.nirujogi@amd.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 226/309] i2c: designware: amdisp: Fix resume-probe race condition issue
Date: Tue, 31 Mar 2026 18:22:09 +0200
Message-ID: <20260331161801.765485957@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pratap Nirujogi <pratap.nirujogi@amd.com>

commit e2f1ada8e089dd5a331bcd8b88125ae2af8d188f upstream.

Identified resume-probe race condition in kernel v7.0 with the commit
38fa29b01a6a ("i2c: designware: Combine the init functions"),but this
issue existed from the beginning though not detected.

The amdisp i2c device requires ISP to be in power-on state for probe
to succeed. To meet this requirement, this device is added to genpd
to control ISP power using runtime PM. The pm_runtime_get_sync() called
before i2c_dw_probe() triggers PM resume, which powers on ISP and also
invokes the amdisp i2c runtime resume before the probe completes resulting
in this race condition and a NULL dereferencing issue in v7.0

Fix this race condition by using the genpd APIs directly during probe:
  - Call dev_pm_genpd_resume() to Power ON ISP before probe
  - Call dev_pm_genpd_suspend() to Power OFF ISP after probe
  - Set the device to suspended state with pm_runtime_set_suspended()
  - Enable runtime PM only after the device is fully initialized

Fixes: d6263c468a761 ("i2c: amd-isp: Add ISP i2c-designware driver")
Co-developed-by: Bin Du <bin.du@amd.com>
Signed-off-by: Bin Du <bin.du@amd.com>
Signed-off-by: Pratap Nirujogi <pratap.nirujogi@amd.com>
Cc: <stable@vger.kernel.org> # v6.16+
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260320201302.3490570-1-pratap.nirujogi@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-designware-amdisp.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/i2c/busses/i2c-designware-amdisp.c
+++ b/drivers/i2c/busses/i2c-designware-amdisp.c
@@ -7,6 +7,7 @@
 
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/pm_domain.h>
 #include <linux/pm_runtime.h>
 #include <linux/soc/amd/isp4_misc.h>
 
@@ -82,22 +83,20 @@ static int amd_isp_dw_i2c_plat_probe(str
 	if (isp_i2c_dev->shared_with_punit)
 		pm_runtime_get_noresume(&pdev->dev);
 
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_get_sync(&pdev->dev);
-
+	dev_pm_genpd_resume(&pdev->dev);
 	ret = i2c_dw_probe(isp_i2c_dev);
 	if (ret) {
 		dev_err_probe(&pdev->dev, ret, "i2c_dw_probe failed\n");
 		goto error_release_rpm;
 	}
-
-	pm_runtime_put_sync(&pdev->dev);
+	dev_pm_genpd_suspend(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
 
 	return 0;
 
 error_release_rpm:
 	amd_isp_dw_i2c_plat_pm_cleanup(isp_i2c_dev);
-	pm_runtime_put_sync(&pdev->dev);
 	return ret;
 }
 



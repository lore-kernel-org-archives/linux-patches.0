Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716A078B61;
	Tue, 27 Feb 2024 14:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043132; cv=none; b=Re+Njk4NqOBpaWwYAEn9fcsTU8Hp+KGgz1Xb698PR0NpuSaJvVyTtnMmI1e2Yf0NGnoM35m7DKZyYjNz98iPu2C3B5umEMGDMVwQIwma1wMp5c21smoEYey93i9AfPuDHxs3cqkDZOpE+7e7Yzcwr9SWTk3bMPYMQ3N5taxfXlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043132; c=relaxed/simple;
	bh=B6bpFGLrnswU5s/AgxEOq3MrG81x7H+eRft5l8kzN+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SrGa0ErEw3UoSiyf9FRTVsF2/XDboxqYhA2c3Bq7kBIuzHomYDhWP106sCtvRTruNvQCztNT1wR1wuKJ0NJZPI6PLUDGSzfwDNydGpbQNHvXQV2CyraZ6c9hxbr2z5Ekfs2b9Wnzrp5h1NICsCtZhOcNiQeTxFygdidlEkob19c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aj8OYsYp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aj8OYsYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CE0C433F1;
	Tue, 27 Feb 2024 14:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043132;
	bh=B6bpFGLrnswU5s/AgxEOq3MrG81x7H+eRft5l8kzN+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aj8OYsYpZQS0oduxEaG6wyKn/Rz3jUqNk2hWx6TuqdLd5aIEaKPPpE7UhXGhICHcZ
	 T1GyqiBaDrYKO5G1Gm647H+lzfR6dai69hLn+wrsuXN/dWAkbj66WMX4lt2okW6UdI
	 WNf6y+cLqAHV3N+r1goaeDio76MihbfkTph36d4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <Sergey.Semin@baikalelectronics.ru>,
	Hannes Reinecke <hare@suse.de>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 218/245] ata: libahci_platform: Introduce reset assertion/deassertion methods
Date: Tue, 27 Feb 2024 14:26:46 +0100
Message-ID: <20240227131622.286788468@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit f67f12ff57bcfcd7d64280f748787793217faeaf ]

Currently the ACHI-platform library supports only the assert and deassert
reset signals and ignores the platforms with self-deasserting reset lines.
That prone to having the platforms with self-deasserting reset method
misbehaviour when it comes to resuming from sleep state after the clocks
have been fully disabled. For such cases the controller needs to be fully
reset all over after the reference clocks are enabled and stable,
otherwise the controller state machine might be in an undetermined state.

The best solution would be to auto-detect which reset method is supported
by the particular platform and use it implicitly in the framework of the
ahci_platform_enable_resources()/ahci_platform_disable_resources()
methods. Alas it can't be implemented due to the AHCI-platform library
already supporting the shared reset control lines. As [1] says in such
case we have to use only one of the next methods:
+ reset_control_assert()/reset_control_deassert();
+ reset_control_reset()/reset_control_rearm().
If the driver had an exclusive control over the reset lines we could have
been able to manipulate the lines with no much limitation and just used
the combination of the methods above to cover all the possible
reset-control cases. Since the shared reset control has already been
advertised and couldn't be changed with no risk to breaking the platforms
relying on it, we have no choice but to make the platform drivers to
determine which reset methods the platform reset system supports.

In order to implement both types of reset control support we suggest to
introduce the new AHCI-platform flag: AHCI_PLATFORM_RST_TRIGGER, which
when passed to the ahci_platform_get_resources() method together with the
AHCI_PLATFORM_GET_RESETS flag will indicate that the reset lines are
self-deasserting thus the reset_control_reset()/reset_control_rearm() will
be used to control the reset state. Otherwise the
reset_control_deassert()/reset_control_assert() methods will be utilized.

[1] Documentation/driver-api/reset.rst

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Stable-dep-of: 26c8404e162b ("ata: ahci_ceva: fix error handling for Xilinx GT PHY support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci.h             |  1 +
 drivers/ata/libahci_platform.c | 50 ++++++++++++++++++++++++++++++----
 include/linux/ahci_platform.h  |  5 +++-
 3 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 54e79f966444c..b4c59fe2db60a 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -344,6 +344,7 @@ struct ahci_host_priv {
 	bool			got_runtime_pm; /* Did we do pm_runtime_get? */
 	unsigned int		n_clks;
 	struct clk_bulk_data	*clks;		/* Optional */
+	unsigned int		f_rsts;
 	struct reset_control	*rsts;		/* Optional */
 	struct regulator	**target_pwrs;	/* Optional */
 	struct regulator	*ahci_regulator;/* Optional */
diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
index 6ae1d8b870a2d..43380d1a410e2 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -122,6 +122,44 @@ void ahci_platform_disable_clks(struct ahci_host_priv *hpriv)
 }
 EXPORT_SYMBOL_GPL(ahci_platform_disable_clks);
 
+/**
+ * ahci_platform_deassert_rsts - Deassert/trigger platform resets
+ * @hpriv: host private area to store config values
+ *
+ * This function deasserts or triggers all the reset lines found for
+ * the AHCI device.
+ *
+ * RETURNS:
+ * 0 on success otherwise a negative error code
+ */
+int ahci_platform_deassert_rsts(struct ahci_host_priv *hpriv)
+{
+	if (hpriv->f_rsts & AHCI_PLATFORM_RST_TRIGGER)
+		return reset_control_reset(hpriv->rsts);
+
+	return reset_control_deassert(hpriv->rsts);
+}
+EXPORT_SYMBOL_GPL(ahci_platform_deassert_rsts);
+
+/**
+ * ahci_platform_assert_rsts - Assert/rearm platform resets
+ * @hpriv: host private area to store config values
+ *
+ * This function asserts or rearms (for self-deasserting resets) all
+ * the reset controls found for the AHCI device.
+ *
+ * RETURNS:
+ * 0 on success otherwise a negative error code
+ */
+int ahci_platform_assert_rsts(struct ahci_host_priv *hpriv)
+{
+	if (hpriv->f_rsts & AHCI_PLATFORM_RST_TRIGGER)
+		return reset_control_rearm(hpriv->rsts);
+
+	return reset_control_assert(hpriv->rsts);
+}
+EXPORT_SYMBOL_GPL(ahci_platform_assert_rsts);
+
 /**
  * ahci_platform_enable_regulators - Enable regulators
  * @hpriv: host private area to store config values
@@ -219,18 +257,18 @@ int ahci_platform_enable_resources(struct ahci_host_priv *hpriv)
 	if (rc)
 		goto disable_regulator;
 
-	rc = reset_control_deassert(hpriv->rsts);
+	rc = ahci_platform_deassert_rsts(hpriv);
 	if (rc)
 		goto disable_clks;
 
 	rc = ahci_platform_enable_phys(hpriv);
 	if (rc)
-		goto disable_resets;
+		goto disable_rsts;
 
 	return 0;
 
-disable_resets:
-	reset_control_assert(hpriv->rsts);
+disable_rsts:
+	ahci_platform_assert_rsts(hpriv);
 
 disable_clks:
 	ahci_platform_disable_clks(hpriv);
@@ -257,7 +295,7 @@ void ahci_platform_disable_resources(struct ahci_host_priv *hpriv)
 {
 	ahci_platform_disable_phys(hpriv);
 
-	reset_control_assert(hpriv->rsts);
+	ahci_platform_assert_rsts(hpriv);
 
 	ahci_platform_disable_clks(hpriv);
 
@@ -442,6 +480,8 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev,
 			rc = PTR_ERR(hpriv->rsts);
 			goto err_out;
 		}
+
+		hpriv->f_rsts = flags & AHCI_PLATFORM_RST_TRIGGER;
 	}
 
 	/*
diff --git a/include/linux/ahci_platform.h b/include/linux/ahci_platform.h
index 49e5383d42222..6d7dd472d3703 100644
--- a/include/linux/ahci_platform.h
+++ b/include/linux/ahci_platform.h
@@ -23,6 +23,8 @@ int ahci_platform_enable_phys(struct ahci_host_priv *hpriv);
 void ahci_platform_disable_phys(struct ahci_host_priv *hpriv);
 int ahci_platform_enable_clks(struct ahci_host_priv *hpriv);
 void ahci_platform_disable_clks(struct ahci_host_priv *hpriv);
+int ahci_platform_deassert_rsts(struct ahci_host_priv *hpriv);
+int ahci_platform_assert_rsts(struct ahci_host_priv *hpriv);
 int ahci_platform_enable_regulators(struct ahci_host_priv *hpriv);
 void ahci_platform_disable_regulators(struct ahci_host_priv *hpriv);
 int ahci_platform_enable_resources(struct ahci_host_priv *hpriv);
@@ -41,6 +43,7 @@ int ahci_platform_resume_host(struct device *dev);
 int ahci_platform_suspend(struct device *dev);
 int ahci_platform_resume(struct device *dev);
 
-#define AHCI_PLATFORM_GET_RESETS	0x01
+#define AHCI_PLATFORM_GET_RESETS	BIT(0)
+#define AHCI_PLATFORM_RST_TRIGGER	BIT(1)
 
 #endif /* _AHCI_PLATFORM_H */
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F411EB5FD;
	Sat, 12 Sep 2026 07:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197620; cv=none; b=Lh7YB32z9ZubCJg5n0XXzDWAUaP2qtalcHR+X5Y/9iXUcjICV4fWiP5VJu3K+Onc7LRoiCJcNx7DEOHAqNT2BFbfWdcL70cUPdfs3A1/5FueNTxsNAuFnt2KbhzvZquKiEMxfEQrL9CndAywJ+mR/isd0zwl4fMXp8A45wkyBsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197620; c=relaxed/simple;
	bh=hK8HTzz6ySuA9twcCz5ZbV0gBAm6q423Y8MoVpJd2/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IJ/9nR3FWSAKjFjsGUIlSOwJMEPzzxqrRla0jeTc+coDtlQgMJhkDTXkpju8v1OhtF2W0T1w+Xs/rwklDgrx8/tQd9E6PvBwXBK6b1AGR3JeFavRfQYxXaRwYD39APZhQevGuvSS6iOoZCuc5BI6QyF/fHy+q+zSlxOk5mc5AdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=krNrAZ8b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="krNrAZ8b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A7B1F000FF;
	Sat, 12 Sep 2026 07:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197618;
	bh=O4YN2XCJWskf3458FSEc6027slwVXwpAV+pKH+ODzZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=krNrAZ8bmLlmtAMrKXTIIzLacQw9C0+dzD3RVdg0nO/Ff6UNEtgsnEmzEx4AMPzy0
	 afRogv5vDGXWSg1lPoD9/cmCZjdu23reJn48SYRHeEXHLkYR07Q/+PcMmhdw9YQjxI
	 JMemwxqZSXAkbZ1SOAnwhxJ4fvg6incKP7MjYZaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0211/1815] clk: qcom: gdsc: Add custom disable callback for GX GDSC
Date: Sat, 12 Sep 2026 08:32:41 +0200
Message-ID: <20260912065653.948935662@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>

[ Upstream commit 0661ee1d650facefdf61401c7d00eb96fad40b10 ]

The GX GDSC is a special power domain that should only be disabled
by OS during GMU recovery. In all other scenarios, the GMU firmware
is responsible for handling its disable sequence, and OS must not
interfere.

During the resume_noirq() phase of system resume, the GenPD framework
enables all power domains and later disables them in the complete()
phase if there are no active votes from OS. This behavior can
incorrectly disable the GX GDSC while the GMU firmware is still using
it.

To prevent this, implement a custom disable callback for GX GDSC that
relies on GenPD’s synced_poweroff flag. The GMU driver sets this flag
only during recovery, allowing OS to explicitly disable GX GDSC in
hardware in that case. In all other situations, the disable callback
will avoid touching GX GDSC hardware.

Signed-off-by: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
Signed-off-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260427-gfx-clk-fixes-v2-1-797e54b3d464@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: badf361c00c8 ("clk: qcom: gxclkctl: Use custom disable callback for gx_gdsc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gdsc.c | 22 ++++++++++++++++++++++
 drivers/clk/qcom/gdsc.h |  1 +
 2 files changed, 23 insertions(+)

diff --git a/drivers/clk/qcom/gdsc.c b/drivers/clk/qcom/gdsc.c
index ee5f86ca50cb7..f419a28f616b6 100644
--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -708,3 +708,25 @@ int gdsc_gx_do_nothing_enable(struct generic_pm_domain *domain)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(gdsc_gx_do_nothing_enable);
+
+/*
+ * GX GDSC is a special power domain. Normally, its disable sequence
+ * is managed by the GMU firmware, and high level OS must not attempt
+ * to disable it. The only exception is during GMU recovery, where the
+ * GMU driver can set GenPD’s synced_poweroff flag to allow explicitly
+ * disable GX GDSC in hardware.
+ */
+int gdsc_gx_disable(struct generic_pm_domain *domain)
+{
+	struct gdsc *sc = domain_to_gdsc(domain);
+
+	if (domain->synced_poweroff)
+		return gdsc_disable(domain);
+
+	/* Remove parent-supply placed in enable */
+	if (sc->rsupply)
+		return regulator_disable(sc->rsupply);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(gdsc_gx_disable);
diff --git a/drivers/clk/qcom/gdsc.h b/drivers/clk/qcom/gdsc.h
index 92ff6bcce7b1c..2f9665b664e60 100644
--- a/drivers/clk/qcom/gdsc.h
+++ b/drivers/clk/qcom/gdsc.h
@@ -93,6 +93,7 @@ int gdsc_register(struct gdsc_desc *desc, struct reset_controller_dev *,
 		  struct regmap *);
 void gdsc_unregister(struct gdsc_desc *desc);
 int gdsc_gx_do_nothing_enable(struct generic_pm_domain *domain);
+int gdsc_gx_disable(struct generic_pm_domain *domain);
 #else
 static inline int gdsc_register(struct gdsc_desc *desc,
 				struct reset_controller_dev *rcdev,
-- 
2.53.0




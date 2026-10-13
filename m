Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5714E7816;
	Tue, 13 Oct 2026 11:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892474; cv=none; b=l+yNj6UTOy+KHv+P45YOdfOITc3EOvyQaacFyq3JjjRJ+mPY0TdhZAinhtxamZtRiVT4F8oCj4A5RqNT9BYwNX+fGcOVqiiZW239eLcsBZqIM/SnKq8d4AYdDLEuQgWNxsazArZn56o570qxUaO4XgDCVVWVEqwB5UyW+11f0zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892474; c=relaxed/simple;
	bh=r4dJCHdjNlxkqSRZk31tabf5d5TuqNfrPv+85ZasakY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRhcE4qT+dNjw4wiYNnnm0+njKVljtoAkqChllBZPo/f6IlRdzk7cMOaAGDubewUtPLE3H62Hm/slBPou48t4KB2lco0meOz5mdHdMMIiHXuSqHo+20njk9IzFId06/RfrBzlpkFnFbyKPRvxLgVf72QdRM9UiJxv1mKJFAva1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QgtpU9xH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QgtpU9xH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8091F000FF;
	Tue, 13 Oct 2026 11:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892473;
	bh=Ldxy5qR5Bab5fEBMhPO+dXG+PF3UU8wJnonCZcsf8+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QgtpU9xHtgKHTOVnHcULX3jGH1NywIZpWjGDH3FFcMRf8+kFhBNfiMLLmTF6EOjP9
	 51dpUgyJKP1jus81cPQm2x6100Yae3Ygwj3YvMA3rB/qs2mcndNvTSaLznL58X8jPh
	 aLbSrogcMtcdECkskEh/LAdEhKQ/DLU3jyka2DPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naomi Chu <naomi.chu@mediatek.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 186/281] scsi: ufs: core: Hold a clock reference across the probe
Date: Tue, 13 Oct 2026 13:38:22 +0200
Message-ID: <20261013112859.679448262@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naomi Chu <naomi.chu@mediatek.com>

[ Upstream commit 02a3178319639f650428164d4d003de4dc03e326 ]

Clock gating becomes possible as soon as ufshcd_init_clk_gating() has run,
and from that point on the probe keeps accessing host registers without
ever taking a clock reference. This has been safe only because of the state
check in __ufshcd_release(): gate_work is not queued unless
hba->ufshcd_state is UFSHCD_STATE_OPERATIONAL, and the promotion to that
state used to happen after the last register access of the probe, at the
end of ufshcd_probe_hba().

That is fragile: it only works while the promotion happens after the
register accesses. Commit a390e6677f41 ("scsi: ufs: core: Expand the
ufshcd_device_init(hba, true) call") changed that ordering by moving the
promotion into ufshcd_init(), which schedules ufshcd_async_scan()
afterwards. ufshcd_probe_hba() therefore now runs with the state already
promoted, and it accesses host registers without holding a clock reference:

 - On hosts with UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH it calls
   ufshcd_hba_stop() and ufshcd_hba_enable() before ufshcd_device_init()
   sets the state back to UFSHCD_STATE_RESET, and both read
   REG_CONTROLLER_ENABLE, so gated clocks stall there instead of just
   losing a write.

 - It ends with an ufshcd_configure_auto_hibern8() write, which its other
   callers do take a clock reference for.

Take a clock reference as soon as clock gating has been initialised and
keep it until the probe is over. It then does not matter who drops a clock
reference while the probe is running, and the register accesses of the
probe no longer depend on hba->ufshcd_state. The reference is dropped by
ufshcd_async_scan() once the scan has finished, or by the new out_release
label if the probe fails after it was taken.

Fixes: a390e6677f41 ("scsi: ufs: core: Expand the ufshcd_device_init(hba, true) call")
Signed-off-by: Naomi Chu <naomi.chu@mediatek.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Link: https://patch.msgid.link/20260909091045.1134956-1-naomi.chu@mediatek.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index fb5f119b19772..0a9366f21483f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9484,6 +9484,7 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 	ret = ufshcd_add_lus(hba);
 
 out:
+	ufshcd_release(hba);
 	pm_runtime_put_sync(hba->dev);
 
 	if (ret)
@@ -11206,6 +11207,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	ufshcd_init_clk_gating(hba);
 
+	/* Released by ufshcd_async_scan(), or by out_release on failure. */
+	ufshcd_hold(hba);
+
 	ufshcd_init_clk_scaling(hba);
 
 	/*
@@ -11226,7 +11230,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	err = devm_request_irq(dev, irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
 	if (err) {
 		dev_err(hba->dev, "request irq failed\n");
-		goto out_disable;
+		goto out_release;
 	} else {
 		hba->is_irq_enabled = true;
 	}
@@ -11242,7 +11246,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		dev_err(hba->dev, "Host controller enable failed\n");
 		ufshcd_print_evt_hist(hba);
 		ufshcd_print_host_state(hba);
-		goto out_disable;
+		goto out_release;
 	}
 
 	INIT_DELAYED_WORK(&hba->rpm_dev_flush_recheck_work, ufshcd_rpm_dev_flush_recheck_work);
@@ -11256,7 +11260,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	err = ufshcd_add_scsi_host(hba);
 	if (err)
-		goto out_disable;
+		goto out_release;
 
 	/* Hold auto suspend until async scan completes */
 	pm_runtime_get_sync(dev);
@@ -11276,7 +11280,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	err = ufshcd_link_startup(hba);
 	if (err)
-		goto out_disable;
+		goto out_release;
 
 	if (hba->mcq_enabled)
 		ufshcd_config_mcq(hba);
@@ -11293,23 +11297,23 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	/* Verify device initialization by sending NOP OUT UPIU */
 	err = ufshcd_verify_dev_init(hba);
 	if (err)
-		goto out_disable;
+		goto out_release;
 
 	/* Initiate UFS initialization, and waiting until completion */
 	err = ufshcd_complete_dev_init(hba);
 	if (err)
-		goto out_disable;
+		goto out_release;
 
 	err = ufshcd_device_params_init(hba);
 	if (err)
-		goto out_disable;
+		goto out_release;
 
 	err = ufshcd_post_device_init(hba);
 
 initialized:
 	ufshcd_process_probe_result(hba, probe_start, err);
 	if (err)
-		goto out_disable;
+		goto out_release;
 
 	ufs_sysfs_add_nodes(hba->dev);
 	hba->dme_qos_sysfs_handle = sysfs_get_dirent(hba->dev->kobj.sd,
@@ -11320,6 +11324,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	ufshcd_pm_qos_init(hba);
 	return 0;
 
+out_release:
+	ufshcd_release(hba);
 out_disable:
 	hba->is_irq_enabled = false;
 	ufshcd_hba_exit(hba);
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A141A4DA9A5;
	Tue, 13 Oct 2026 12:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893975; cv=none; b=MnlA/OvJB0KkU9fHUpC4OXh+Nb2a24GiDok0CsDMEkdzT4d4FWMOkqkXjd6h72Llo4yztRm+Kcs5/TN8IZZ3YKybqux+2G9J3W+z9qmkuMI9p2dknTV2+QIQOqC5tyjgPEiZcCT+KAwhosQKq6eM+tc5BmVVVlPXJjA3QjhOA6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893975; c=relaxed/simple;
	bh=f555QEvWFSKi/bCB/c6V/ofeTHBtM+5ooQuCXL4qNPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0cTbNHxSiaBWMdLlRG1ZnUhqjbSc3a1X5X33MMKHpp8wXYciqXGj7gcYo1OERYel+oNZ/3S9sL6EHhYf6xoi0HwA7jO1fDUU+w+fLqhqqDd+5M1USCSlqEMVOHZlPzYEdUzskDIy+IVufLoF5vRaDI/qlRbxDcT/IPjZI1rLeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ybGPO8yf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ybGPO8yf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E781F000FF;
	Tue, 13 Oct 2026 12:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893974;
	bh=YW1krxYtbd55kyoc7qofTBODjCPkq7nNBJEXqPM/4xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ybGPO8yfxqW/s62MkTnHRfc6Os5p3EjPiD60BwCAm9fX9fTCBqYvpKPnoGCVdXYwN
	 YheY3Sgri1mAgXPVyzpYbcGzVGDBYIiq8eCYB9hFlaoQC7e2KjfxmXgjB/MHd2Su4u
	 ofDSlaXFJ4c6qufiK0qQyyWjJs0l8HU2wBttr3NM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 406/621] irqchip/gic-v5: Clear per-CPU IRS data on teardown
Date: Tue, 13 Oct 2026 13:36:41 +0200
Message-ID: <20261013112930.474478479@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Sascha Bischoff <Sascha.Bischoff@arm.com>

[ Upstream commit 3dfc0ab5fefd052c6028c4632b1fad8bdaf7967e ]

IRS affinity setup publishes an IRS pointer and IAFFID state in the
per-CPU data before the remaining IRS initialization can fail. The
error path then frees the IRS data without clearing that published
state, leaving CPUs associated with freed memory.

On initialization failure and normal IRS teardown, clear the per-CPU
IRS association by removing the stale pointer to irs_data. Also
invalidate the per-CPU IAFFID state for any CPUs that were tied to the
IRS before it was freed.

Fixes: 5cb1b6dab2de ("irqchip/gic-v5: Add GICv5 IRS/SPI support")
Fixes: 35866efa52fe ("irqchip/gic-v5: Add ACPI IRS probing")
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Link: https://sashiko.dev/#/patchset/20260724104819.1296803-1-sascha.bischoff@arm.com?part=2
Link: https://patch.msgid.link/20260811152630.942023-2-sascha.bischoff@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v5-irs.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v5-irs.c
index a650eccdb37a8..cf951d4071cbb 100644
--- a/drivers/irqchip/irq-gic-v5-irs.c
+++ b/drivers/irqchip/irq-gic-v5-irs.c
@@ -652,6 +652,18 @@ static int __init gicv5_irs_of_init_affinity(struct device_node *node,
 	return ret;
 }
 
+static void __init gicv5_irs_clear_affinity(struct gicv5_irs_chip_data *irs_data)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		if (per_cpu(per_cpu_irs_data, cpu) == irs_data) {
+			per_cpu(cpu_iaffid, cpu).valid = false;
+			per_cpu(per_cpu_irs_data, cpu) = NULL;
+		}
+	}
+}
+
 static void irs_setup_pri_bits(u32 idr1)
 {
 	switch (FIELD_GET(GICV5_IRS_IDR1_PRIORITY_BITS, idr1)) {
@@ -762,6 +774,7 @@ static int __init gicv5_irs_init(struct device_node *node)
 	return 0;
 
 out_iomem:
+	gicv5_irs_clear_affinity(irs_data);
 	iounmap(irs_base);
 out_err:
 	kfree(irs_data);
@@ -776,6 +789,7 @@ void __init gicv5_irs_remove(void)
 	gicv5_deinit_lpis();
 
 	list_for_each_entry_safe(irs_data, tmp_data, &irs_nodes, entry) {
+		gicv5_irs_clear_affinity(irs_data);
 		iounmap(irs_data->irs_base);
 		list_del(&irs_data->entry);
 		kfree(irs_data);
-- 
2.53.0




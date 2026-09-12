Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17AC2E2286;
	Sat, 12 Sep 2026 09:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204742; cv=none; b=G8eXh19EqVzF4wxNXjr0QW+3uMngMlgrZHA9L/C5EXAklEd1fyjCfUSonc3z11sNp1H7bCAi0qOJyFhHHLwxAyt8oT00d1LPQUi8XX2gqWiUTlJB7NLHywPyJ9QMlxWby8YCUxKiV71x5aalSFri6/NJIrstjluMh8tAYSdPWXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204742; c=relaxed/simple;
	bh=fgNnuyzPQ+WJB733UuADleIvQ7ec7NQMhYay2uA8sOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bp1K4ocRZZWUK3oXtbcjhK1N+t2A8JMCSuW1fGSoe84McJQ1kxE5fLi/xRmYStWZemGJGsk6d6DQb1xOhCVsrfu0x1mTytZNutjsEcqjtXTzGbLbc1DEOE+2mmoRc/91HUBa+WyNUGyGyHjuzQxLU62CPuZuAmgwuuMHC41maAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=unaWVOvI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="unaWVOvI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB9C1F000FF;
	Sat, 12 Sep 2026 09:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204740;
	bh=XhLxAW8jsWH6lNdRrhQAd39Mh1f3J2ycUUPe7gCAD5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=unaWVOvIKdDyekR/tEYnNn6hZ7dp4GRZg264OU2uvJENxZZuKPGXGtDZHrvfNTFsa
	 bRBf1fVokQIGrc9uti4y+mQZARj9xfBmJPpa1LFE2B8u4q1RgGQA/C0M3fQyxejQy0
	 4JvT4kLvt06BXTvNWRUBXVOFS3x8cDX1m/gm+O3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1648/1815] irqchip/gic-v5: Disable IRSes on probe failures
Date: Sat, 12 Sep 2026 08:56:38 +0200
Message-ID: <20260912065727.682183267@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Pieralisi <lpieralisi@kernel.org>

[ Upstream commit 79b115c2a29204cb7e836b0df0b8c466be4b2250 ]

GICv5 driver probe failures cause IRSes initialized by the kernel to be
unmapped and their data structures to be destroyed but the current driver
leaves the probed IRSes enabled, whereas they should be disabled.

Disable IRSes on driver probe failures so that the IRSes are brought back
to their quiescent HW state.

Fixes: 5cb1b6dab2de ("irqchip/gic-v5: Add GICv5 IRS/SPI support")
Fixes: 35866efa52fe ("irqchip/gic-v5: Add ACPI IRS probing")
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://sashiko.dev/#/message/20260810104747.E5CE71F000E9%40smtp.kernel.org
Link: https://patch.msgid.link/20260812-gicv5-7-2-fixes-v1-3-3743e82c69a4@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v5-irs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v5-irs.c
index 0bd9ae9ae12ef..9d25ce8bfd8c9 100644
--- a/drivers/irqchip/irq-gic-v5-irs.c
+++ b/drivers/irqchip/irq-gic-v5-irs.c
@@ -488,6 +488,12 @@ static int gicv5_irs_wait_for_idle(struct gicv5_irs_chip_data *irs_data)
 					GICV5_IRS_CR0_IDLE, NULL);
 }
 
+static void __init gicv5_irs_disable(struct gicv5_irs_chip_data *irs_data)
+{
+	irs_writel_relaxed(irs_data, 0, GICV5_IRS_CR0);
+	gicv5_irs_wait_for_idle(irs_data);
+}
+
 void gicv5_irs_syncr(void)
 {
 	struct gicv5_irs_chip_data *irs_data;
@@ -786,6 +792,7 @@ static int __init gicv5_irs_of_init(struct device_node *node)
 
 out_iomem:
 	gicv5_irs_clear_affinity(irs_data);
+	gicv5_irs_disable(irs_data);
 	iounmap(irs_base);
 out_err:
 	kfree(irs_data);
@@ -801,6 +808,7 @@ void __init gicv5_irs_remove(void)
 
 	list_for_each_entry_safe(irs_data, tmp_data, &irs_nodes, entry) {
 		gicv5_irs_clear_affinity(irs_data);
+		gicv5_irs_disable(irs_data);
 		iounmap(irs_data->irs_base);
 		list_del(&irs_data->entry);
 		kfree(irs_data);
@@ -968,6 +976,7 @@ static int __init gic_acpi_parse_madt_irs(union acpi_subtable_headers *header,
 
 out_map:
 	gicv5_irs_clear_affinity(irs_data);
+	gicv5_irs_disable(irs_data);
 	iounmap(irs_base);
 out_release:
 	release_mem_region(r->start, resource_size(r));
-- 
2.53.0




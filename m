Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977E9361DDC;
	Sat, 12 Sep 2026 09:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204600; cv=none; b=iWWmEoOHO/j/lm0UCC9j66FS7Tc3kZQ4TN9YtN9fNh1TqiAXunLXx7RVMmvB/TUZ/KDjwFl5+03YML2QcYq1tuU4nUUXXkjFrBkZoNXZyaH16ZkkYW0edtqVVaHJw5a91pgARmmmkMq/FAekviqvhgoxVzZWdtVxCW625ONAamk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204600; c=relaxed/simple;
	bh=vq4UpF4rRFf9unWQSofyDMW2DaTrnP3gyg1d96gwAXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3fAGW/9Ge/siuMxCGtkO+qhHLEi4pKABXMor0HHXxuHVLMU+0+5cUbGeblwlmUb06lQrzzOrecY5I5F6vckBhs1Y9L7L9Ju6tyQqc6iQbcdmoj9sQL4nyrzIxRrCvBy2a/9Od9JCOsN0DeWMcNzImcKIqal7G1RWjf1k7klOQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fvJu84Ju; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fvJu84Ju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7391F000FF;
	Sat, 12 Sep 2026 09:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204599;
	bh=aLrk13Ew+6OS6PU6WspBkPFz3qGrwCLs2FaqZWyuCzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fvJu84JuHWpt3w08M5eOzI9hCER87x6Fa9AHUDfwvqYtcTsMpZijIHLb3ePvApArv
	 XddEUHdx1pXUv+f51mE61mDPJymMXbc3N19Q0ZAEVsAKpLJ47b+1uEHW+wFHH2cILr
	 6a7RXYqD/yIBe5y3MziPbxG/++4oztaxiGb3phpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1644/1815] irqchip/gic-v5: Clear per-CPU IRS data on teardown
Date: Sat, 12 Sep 2026 08:56:34 +0200
Message-ID: <20260912065727.587110325@linuxfoundation.org>
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
 drivers/irqchip/irq-gic-v5-irs.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v5-irs.c
index f3fce0b1e25d9..3028a8bbbf68b 100644
--- a/drivers/irqchip/irq-gic-v5-irs.c
+++ b/drivers/irqchip/irq-gic-v5-irs.c
@@ -651,6 +651,18 @@ static int __init gicv5_irs_of_init_affinity(struct device_node *node,
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
@@ -773,6 +785,7 @@ static int __init gicv5_irs_of_init(struct device_node *node)
 	return ret;
 
 out_iomem:
+	gicv5_irs_clear_affinity(irs_data);
 	iounmap(irs_base);
 out_err:
 	kfree(irs_data);
@@ -787,6 +800,7 @@ void __init gicv5_irs_remove(void)
 	gicv5_deinit_lpis();
 
 	list_for_each_entry_safe(irs_data, tmp_data, &irs_nodes, entry) {
+		gicv5_irs_clear_affinity(irs_data);
 		iounmap(irs_data->irs_base);
 		list_del(&irs_data->entry);
 		kfree(irs_data);
@@ -951,6 +965,7 @@ static int __init gic_acpi_parse_madt_irs(union acpi_subtable_headers *header,
 	return 0;
 
 out_map:
+	gicv5_irs_clear_affinity(irs_data);
 	iounmap(irs_base);
 out_release:
 	release_mem_region(r->start, resource_size(r));
-- 
2.53.0




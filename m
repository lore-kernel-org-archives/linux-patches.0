Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2AF42586B;
	Sat, 12 Sep 2026 12:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216259; cv=none; b=AyPe8mCP/FjGMBe2HE56Pc+UJobP9xM2kFFktDkwluYWYQQNxtEeHhkF9xPyoT5IEo1sIn1sBWe4vJQkq1p19fjC/h9jxnKYzzge8pJ+5zAMMBRDEKcGpe/FosQmydDYjSgDNhD7eEqZPfck1pJC7efXd2SSmx7zynRz1IQ45Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216259; c=relaxed/simple;
	bh=mYBJGYsUQEqXhyjwmmJOMelVgZHC+kdxDcbMKSL5Asg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNubpfZSPzB0u1Zvv0dnaGMf+tfj99zSLi5vhkCL+Zlh8ip42+JJASbzftXNn4din8NE8cYAAy2CW/Jv9YsEQdLFU+Ob/DChwIlOoItzabMO+hKdL7+3M6PMtdVYbx9Yjc+O73cqUXArhEv17Lb3DSfC/NXdxfLgfZP7zxeQKk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrEFN380; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrEFN380"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81AA1F000FF;
	Sat, 12 Sep 2026 12:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216257;
	bh=Gggxtnm34DhW03XaBXAVUnEI9jItZdn37yDHlzMT9m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nrEFN380g5ib1mNt0CML7jqbJcChEWAsuFiMBGjvWNnZfBPQhkzBFE0QdGBH4l3x3
	 vaQea+W17BAq/2Vqpq8J9iNljS2jNoN3U4O6d44X3lQuIIxzUEKrWg2cORp/adzbzJ
	 hvlkqfOw99FTRGGOehDNNPX92cwaiqTziOnfBJWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Gondois <pierre.gondois@arm.com>,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0658/1376] ACPI: CPPC: Refactor register value get and set ABIs
Date: Sat, 12 Sep 2026 08:51:24 +0200
Message-ID: <20260912065622.205715132@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lifeng Zheng <zhenglifeng1@huawei.com>

[ Upstream commit ab482f1bac6b128b8fe910b6663a4f74a3a9796c ]

Refactor register value get and set ABIs by using cppc_get_reg_val(),
cppc_set_reg_val() and CPPC_REG_VAL_READ().

Reviewed-by: Pierre Gondois <pierre.gondois@arm.com>
Signed-off-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20250411093855.982491-7-zhenglifeng1@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 9dfd13f80c85 ("cpufreq/amd-pstate: Toggle auto_sel in active mode on shared memory systems")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c | 111 +++------------------------------------
 1 file changed, 7 insertions(+), 104 deletions(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 52306eec1cca8..e33ad70827429 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1616,44 +1616,14 @@ EXPORT_SYMBOL_GPL(cppc_set_epp_perf);
  */
 int cppc_get_auto_sel_caps(int cpunum, struct cppc_perf_caps *perf_caps)
 {
-	struct cpc_desc *cpc_desc = per_cpu(cpc_desc_ptr, cpunum);
-	struct cpc_register_resource *auto_sel_reg;
-	u64  auto_sel;
-
-	if (!cpc_desc) {
-		pr_debug("No CPC descriptor for CPU:%d\n", cpunum);
-		return -ENODEV;
-	}
-
-	auto_sel_reg = &cpc_desc->cpc_regs[AUTO_SEL_ENABLE];
-
-	if (!CPC_SUPPORTED(auto_sel_reg))
-		pr_warn_once("Autonomous mode is not unsupported!\n");
-
-	if (CPC_IN_PCC(auto_sel_reg)) {
-		int pcc_ss_id = per_cpu(cpu_pcc_subspace_idx, cpunum);
-		struct cppc_pcc_data *pcc_ss_data = NULL;
-		int ret = 0;
-
-		if (pcc_ss_id < 0)
-			return -ENODEV;
-
-		pcc_ss_data = pcc_data[pcc_ss_id];
-
-		down_write(&pcc_ss_data->pcc_lock);
-
-		if (send_pcc_cmd(pcc_ss_id, CMD_READ) >= 0) {
-			cpc_read(cpunum, auto_sel_reg, &auto_sel);
-			perf_caps->auto_sel = (bool)auto_sel;
-		} else {
-			ret = -EIO;
-		}
-
-		up_write(&pcc_ss_data->pcc_lock);
+	u64 auto_sel;
+	int ret;
 
+	ret = cppc_get_reg_val(cpunum, AUTO_SEL_ENABLE, &auto_sel);
+	if (ret)
 		return ret;
-	}
 
+	perf_caps->auto_sel = (bool)auto_sel;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(cppc_get_auto_sel_caps);
@@ -1665,43 +1635,7 @@ EXPORT_SYMBOL_GPL(cppc_get_auto_sel_caps);
  */
 int cppc_set_auto_sel(int cpu, bool enable)
 {
-	int pcc_ss_id = per_cpu(cpu_pcc_subspace_idx, cpu);
-	struct cpc_register_resource *auto_sel_reg;
-	struct cpc_desc *cpc_desc = per_cpu(cpc_desc_ptr, cpu);
-	struct cppc_pcc_data *pcc_ss_data = NULL;
-	int ret = -EINVAL;
-
-	if (!cpc_desc) {
-		pr_debug("No CPC descriptor for CPU:%d\n", cpu);
-		return -ENODEV;
-	}
-
-	auto_sel_reg = &cpc_desc->cpc_regs[AUTO_SEL_ENABLE];
-
-	if (CPC_IN_PCC(auto_sel_reg)) {
-		if (pcc_ss_id < 0) {
-			pr_debug("Invalid pcc_ss_id\n");
-			return -ENODEV;
-		}
-
-		if (CPC_SUPPORTED(auto_sel_reg)) {
-			ret = cpc_write(cpu, auto_sel_reg, enable);
-			if (ret)
-				return ret;
-		}
-
-		pcc_ss_data = pcc_data[pcc_ss_id];
-
-		down_write(&pcc_ss_data->pcc_lock);
-		/* after writing CPC, transfer the ownership of PCC to platform */
-		ret = send_pcc_cmd(pcc_ss_id, CMD_WRITE);
-		up_write(&pcc_ss_data->pcc_lock);
-	} else {
-		ret = -ENOTSUPP;
-		pr_debug("_CPC in PCC is not supported\n");
-	}
-
-	return ret;
+	return cppc_set_reg_val(cpu, AUTO_SEL_ENABLE, enable);
 }
 EXPORT_SYMBOL_GPL(cppc_set_auto_sel);
 
@@ -1715,38 +1649,7 @@ EXPORT_SYMBOL_GPL(cppc_set_auto_sel);
  */
 int cppc_set_enable(int cpu, bool enable)
 {
-	int pcc_ss_id = per_cpu(cpu_pcc_subspace_idx, cpu);
-	struct cpc_register_resource *enable_reg;
-	struct cpc_desc *cpc_desc = per_cpu(cpc_desc_ptr, cpu);
-	struct cppc_pcc_data *pcc_ss_data = NULL;
-	int ret = -EINVAL;
-
-	if (!cpc_desc) {
-		pr_debug("No CPC descriptor for CPU:%d\n", cpu);
-		return -EINVAL;
-	}
-
-	enable_reg = &cpc_desc->cpc_regs[ENABLE];
-
-	if (CPC_IN_PCC(enable_reg)) {
-
-		if (pcc_ss_id < 0)
-			return -EIO;
-
-		ret = cpc_write(cpu, enable_reg, enable);
-		if (ret)
-			return ret;
-
-		pcc_ss_data = pcc_data[pcc_ss_id];
-
-		down_write(&pcc_ss_data->pcc_lock);
-		/* after writing CPC, transfer the ownership of PCC to platfrom */
-		ret = send_pcc_cmd(pcc_ss_id, CMD_WRITE);
-		up_write(&pcc_ss_data->pcc_lock);
-		return ret;
-	}
-
-	return cpc_write(cpu, enable_reg, enable);
+	return cppc_set_reg_val(cpu, ENABLE, enable);
 }
 EXPORT_SYMBOL_GPL(cppc_set_enable);
 
-- 
2.53.0




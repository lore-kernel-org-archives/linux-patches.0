Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C78114D439;
	Mon, 16 Sep 2024 12:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488370; cv=none; b=BgIeklpceov/wrT72qrg3bQNDHxkLjPcCANzrND3D/lZmgZFi/yFeRTUzSdBmZ9tc6d/TajwoJgR6sdiI+50am6domKm55chTtvpLJtL/c5lPHhk1QH+BWULIunLeB+HvYawC/0jTU+/3GWPhkrXQ0+O/X71DjUAge0ON9iquHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488370; c=relaxed/simple;
	bh=HVLKDCHvscOm1sKOa5Mz6gTewVKnO2kbkYfjm2fU2YI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIIwB5bwyT6e12yd9BubgF3qvfGbbvMs0lVXXFd1TeBHQr4jmmRS2n3Fi4x0Shx7lSapY/oBkoEfZcUJT25m8+AYlfTjthd0q3YbPFkQ2A8s6G4Q93lKL4ZoTTm9wcQcqR8D4b4EdXjpQl+oR9/Ab1XtbGj7u6d46GaXRXD/g88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ukNd8r7d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ukNd8r7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9F6C4CEC4;
	Mon, 16 Sep 2024 12:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488370;
	bh=HVLKDCHvscOm1sKOa5Mz6gTewVKnO2kbkYfjm2fU2YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukNd8r7dtJSaTl1oVXwzdufsuUt5fjXx4dT+m4sNbrzuBGFcubWeFijEKrEDMY9jS
	 RgpiH44Rnm4fCwVqYsVa/Hddg7BAPyHsgdOJiYq6aG1u9gnlGKnX8r6I1qr2K2QfmX
	 6i6a3pmMpdSENJZ3xL0jz8EAlOKfhdgYRarlsv8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Anup Patel <anup@brainfault.org>,
	Andrea Parri <parri.andrea@gmail.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 089/121] drivers: perf: Fix smp_processor_id() use in preemptible code
Date: Mon, 16 Sep 2024 13:44:23 +0200
Message-ID: <20240916114232.093364599@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Ghiti <alexghiti@rivosinc.com>

[ Upstream commit 2840dadf0dde92638d13b97998026c5fcddbdceb ]

As reported in [1], the use of smp_processor_id() in
pmu_sbi_device_probe() must be protected by disabling the preemption, so
simple use get_cpu()/put_cpu() instead.

Reported-by: Nam Cao <namcao@linutronix.de>
Closes: https://lore.kernel.org/linux-riscv/20240820074925.ReMKUPP3@linutronix.de/ [1]
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Tested-by: Nam Cao <namcao@linutronix.de>
Fixes: a8625217a054 ("drivers/perf: riscv: Implement SBI PMU snapshot function")
Reported-by: Andrea Parri <parri.andrea@gmail.com>
Tested-by: Andrea Parri <parri.andrea@gmail.com>
Link: https://lore.kernel.org/r/20240826165210.124696-1-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/riscv_pmu_sbi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 11c7c85047ed..765bda7924f7 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -1368,11 +1368,15 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
 
 	/* SBI PMU Snapsphot is only available in SBI v2.0 */
 	if (sbi_v2_available) {
+		int cpu;
+
 		ret = pmu_sbi_snapshot_alloc(pmu);
 		if (ret)
 			goto out_unregister;
 
-		ret = pmu_sbi_snapshot_setup(pmu, smp_processor_id());
+		cpu = get_cpu();
+
+		ret = pmu_sbi_snapshot_setup(pmu, cpu);
 		if (ret) {
 			/* Snapshot is an optional feature. Continue if not available */
 			pmu_sbi_snapshot_free(pmu);
@@ -1386,6 +1390,7 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
 			 */
 			static_branch_enable(&sbi_pmu_snapshot_available);
 		}
+		put_cpu();
 	}
 
 	register_sysctl("kernel", sbi_pmu_sysctl_table);
-- 
2.43.0




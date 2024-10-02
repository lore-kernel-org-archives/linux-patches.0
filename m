Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7251D0E1B;
	Wed,  2 Oct 2024 14:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880495; cv=none; b=AKJoR4Kq0Kyqn9SiZiaI48mfg0aGHcjkA/fTRgGDuRzfDTAfe1DWJbcbp70MGf6j8JCf8pudwFwTpxNtLhTEvw2MNxDvmXs/tnea8nTIf4GcfvdXsLu/5vRz+gsGhXhC1elv6R6eIJJm3vbQF1ISJH3zXu9Y7ES3R9Q2seqTjqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880495; c=relaxed/simple;
	bh=s37hLnuDMMTc178L14jcfwJ6+06pnY8Uw2+6R8QREOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1nWz4jsB4v1F41WNCIFzW2usIfrXX1e67wO4najEzcEDK/F70Ty8bsTdp8BP1vDaduELQ0Iem4+7p1UQBCxU2Rry23qQVqTGQEj25P4aeHdNdWD5DLTp/1G9+1VgGw+ijWNrzIWe+EqO0aOV2qOUxKctUOxu2huL9zX69ugmhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j/LJCx5O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j/LJCx5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C556DC4CEC2;
	Wed,  2 Oct 2024 14:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880495;
	bh=s37hLnuDMMTc178L14jcfwJ6+06pnY8Uw2+6R8QREOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j/LJCx5O6IwKdpKdlJmtYG0fExF/QaEWqr7eCyiG/1iitkUL3JtoN8Pje1o554/Ws
	 puFRb+iC69rWIe8Qse1xiP+amRlfT5a9N7ZPAUypALWRSoIcZJAG6o5O3KWwqArfOA
	 aYow5b0chDgUUa9KUCsVgwuBWYWPda8cCbdiDMZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Anup Patel <anup@brainfault.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 479/538] cpuidle: riscv-sbi: Use scoped device node handling to fix missing of_node_put
Date: Wed,  2 Oct 2024 15:01:58 +0200
Message-ID: <20241002125811.351984598@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit a309320ddbac6b1583224fcb6bacd424bcf8637f upstream.

Two return statements in sbi_cpuidle_dt_init_states() did not drop the
OF node reference count.  Solve the issue and simplify entire error
handling with scoped/cleanup.h.

Fixes: 6abf32f1d9c5 ("cpuidle: Add RISC-V SBI CPU idle driver")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://patch.msgid.link/20240820094023.61155-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpuidle/cpuidle-riscv-sbi.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- a/drivers/cpuidle/cpuidle-riscv-sbi.c
+++ b/drivers/cpuidle/cpuidle-riscv-sbi.c
@@ -8,6 +8,7 @@
 
 #define pr_fmt(fmt) "cpuidle-riscv-sbi: " fmt
 
+#include <linux/cleanup.h>
 #include <linux/cpuhotplug.h>
 #include <linux/cpuidle.h>
 #include <linux/cpumask.h>
@@ -267,19 +268,16 @@ static int sbi_cpuidle_dt_init_states(st
 {
 	struct sbi_cpuidle_data *data = per_cpu_ptr(&sbi_cpuidle_data, cpu);
 	struct device_node *state_node;
-	struct device_node *cpu_node;
 	u32 *states;
 	int i, ret;
 
-	cpu_node = of_cpu_device_node_get(cpu);
+	struct device_node *cpu_node __free(device_node) = of_cpu_device_node_get(cpu);
 	if (!cpu_node)
 		return -ENODEV;
 
 	states = devm_kcalloc(dev, state_count, sizeof(*states), GFP_KERNEL);
-	if (!states) {
-		ret = -ENOMEM;
-		goto fail;
-	}
+	if (!states)
+		return -ENOMEM;
 
 	/* Parse SBI specific details from state DT nodes */
 	for (i = 1; i < state_count; i++) {
@@ -295,10 +293,8 @@ static int sbi_cpuidle_dt_init_states(st
 
 		pr_debug("sbi-state %#x index %d\n", states[i], i);
 	}
-	if (i != state_count) {
-		ret = -ENODEV;
-		goto fail;
-	}
+	if (i != state_count)
+		return -ENODEV;
 
 	/* Initialize optional data, used for the hierarchical topology. */
 	ret = sbi_dt_cpu_init_topology(drv, data, state_count, cpu);
@@ -308,10 +304,7 @@ static int sbi_cpuidle_dt_init_states(st
 	/* Store states in the per-cpu struct. */
 	data->states = states;
 
-fail:
-	of_node_put(cpu_node);
-
-	return ret;
+	return 0;
 }
 
 static void sbi_cpuidle_deinit_cpu(int cpu)



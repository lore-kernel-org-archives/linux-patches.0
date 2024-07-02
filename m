Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5E915B0FE;
	Tue,  2 Jul 2024 17:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940488; cv=none; b=hko6mB0RDQhu3zfxh+h0yygZx3jg5yZx9iM0kD1GDF7P7FLNFuTVNkBKtFRry/I3dRhn9Tb4P7Vb/hQ6+W1HeNsJ+Nl6X1fDhxgZDMDVRCVxnQ8Cm3AuYhg8qAJNmDNvEgHjpWvmZTbhjfMoEsXTe1ipNI62DVjZXQ9v8eqAqo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940488; c=relaxed/simple;
	bh=3AestHnHKfDKcXFfh/fr9KZIM1V5xpwalSj87YbV8ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvhqAxzuU6c67JjjVkJzEYlVjVXeGZIbmzcRdFDIHR4FLdAlUx5f2tfvl4OB5Qj8CAVz66mFLqEMtG1FbB28cGfAvuky669kACav3zJ86nOnosdUXWQCK5wZLz9ElqpdC96S9kIhFowtFs5jnUoaned3oqXlwiCtdt12t7+epac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vatJKjCR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vatJKjCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DA3C116B1;
	Tue,  2 Jul 2024 17:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940488;
	bh=3AestHnHKfDKcXFfh/fr9KZIM1V5xpwalSj87YbV8ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vatJKjCRe17R6GHUMDHhAuxOVpvkZ4bR4XMdGfCO13ISXVhWdp6MulpU7eIVkHqhu
	 bEUWMXv8yeC8qyATm/I6140lGC7/SKSSIymJfgzpZ1SooFh+MQwTRXMdDu6uWMwh+Q
	 pvOcALQyHkORIJUyt/OuQxRGHYTodbJ29t4wviLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Rainbolt <arainbolt@kfocus.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.9 169/222] cpufreq: intel_pstate: Use HWP to initialize ITMT if CPPC is missing
Date: Tue,  2 Jul 2024 19:03:27 +0200
Message-ID: <20240702170250.435704317@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit a1ff59784b277795a613beaa5d3dd9c5595c69a7 upstream.

It is reported that single-thread performance on some hybrid systems
dropped significantly after commit 7feec7430edd ("ACPI: CPPC: Only probe
for _CPC if CPPC v2 is acked") which prevented _CPC from being used if
the support for it had not been confirmed by the platform firmware.

The problem is that if the platform firmware does not confirm CPPC v2
support, cppc_get_perf_caps() returns an error which prevents the
intel_pstate driver from enabling ITMT.  Consequently, the scheduler
does not get any hints on CPU performance differences, so in a hybrid
system some tasks may run on CPUs with lower capacity even though they
should be running on high-capacity CPUs.

To address this, modify intel_pstate to use the information from
MSR_HWP_CAPABILITIES to enable ITMT if CPPC is not available (which is
done already if the highest performance number coming from CPPC is not
realistic).

Fixes: 7feec7430edd ("ACPI: CPPC: Only probe for _CPC if CPPC v2 is acked")
Closes: https://lore.kernel.org/linux-acpi/d01b0a1f-bd33-47fe-ab41-43843d8a374f@kfocus.org
Link: https://lore.kernel.org/linux-acpi/ZnD22b3Br1ng7alf@kf-XE
Reported-by: Aaron Rainbolt <arainbolt@kfocus.org>
Tested-by: Aaron Rainbolt <arainbolt@kfocus.org>
Cc: 5.19+ <stable@vger.kernel.org> # 5.19+
Link: https://patch.msgid.link/12460110.O9o76ZdvQC@rjwysocki.net
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/intel_pstate.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -357,15 +357,14 @@ static void intel_pstate_set_itmt_prio(i
 	int ret;
 
 	ret = cppc_get_perf_caps(cpu, &cppc_perf);
-	if (ret)
-		return;
-
 	/*
-	 * On some systems with overclocking enabled, CPPC.highest_perf is hardcoded to 0xff.
-	 * In this case we can't use CPPC.highest_perf to enable ITMT.
-	 * In this case we can look at MSR_HWP_CAPABILITIES bits [8:0] to decide.
+	 * If CPPC is not available, fall back to MSR_HWP_CAPABILITIES bits [8:0].
+	 *
+	 * Also, on some systems with overclocking enabled, CPPC.highest_perf is
+	 * hardcoded to 0xff, so CPPC.highest_perf cannot be used to enable ITMT.
+	 * Fall back to MSR_HWP_CAPABILITIES then too.
 	 */
-	if (cppc_perf.highest_perf == CPPC_MAX_PERF)
+	if (ret || cppc_perf.highest_perf == CPPC_MAX_PERF)
 		cppc_perf.highest_perf = HWP_HIGHEST_PERF(READ_ONCE(all_cpu_data[cpu]->hwp_cap_cached));
 
 	/*



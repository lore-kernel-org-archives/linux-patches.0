Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790161B583A;
	Tue,  2 Jul 2024 17:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941096; cv=none; b=GSTABs2ghLikz6O3ELJ1DtrvFCUUvSHfgQaPdFD+Ztp7gphAi/dMGExCMc8TOWkijysNuysbCgF2MDu+9V9zMfCyJkVKrCCGQpqrYf9UnKoPUaDP6SyCeB4ALPcQPdC+a4V5aF8rPYFxkNn+m9OvjmV6eBqCFBICbbYLWV2Vwf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941096; c=relaxed/simple;
	bh=PxKa4aJMl8COiaJeQ8f5vdPniAYgEzuNgUsUrT7UdJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWAHbF1EFMl2ULiZ670Dq1jCjX8kl4gYGS2sm9Cw6gLoCYb2yxNi7I32/3iVaUZ+d5Q4+tfYfuGkRPcJPGMTghNSx0YfBE9iiJSB3sJblSCS12Aerv6+ekVhHo3S4OQBRrgLbIGJYT+//SPO3GhOu8EmmgaeuOSGKSU5P4jbEPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iz1Q/TIi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iz1Q/TIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A2BC116B1;
	Tue,  2 Jul 2024 17:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941096;
	bh=PxKa4aJMl8COiaJeQ8f5vdPniAYgEzuNgUsUrT7UdJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iz1Q/TIippcyuq2SRhn3n29LIx69A88YKtRuV+SZpm359sM8FCxk1LEkJpg6wHxiU
	 KtizexlinOXW/fHKeYBoU6BKIdJqAS/UEydQI0T5+pKTnyO/wxunvVUG9GcHqInn17
	 pv/lxHrCDz+iLDp/GJPNOOZ9dNvl+Soel2s1RtQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Rainbolt <arainbolt@kfocus.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.6 126/163] cpufreq: intel_pstate: Use HWP to initialize ITMT if CPPC is missing
Date: Tue,  2 Jul 2024 19:04:00 +0200
Message-ID: <20240702170237.820808280@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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
@@ -356,15 +356,14 @@ static void intel_pstate_set_itmt_prio(i
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E77323F417;
	Sun,  7 Jun 2026 11:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830022; cv=none; b=cEy6ytY0v2rYQ7At/9jyCGCeYf6W/cRa6VmldIOlH8tPD1P2FQYt+pbR5MgAeUthTFDS6EBZgz7N0l9vNjU/U4TptIbzUuXGBpEsIQR3hsRFDaVEPCegye1MEGq4RCkkTdrAqwabpuax/WVDSgaYQH7tyQO1DqS7mFEB2OzxBjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830022; c=relaxed/simple;
	bh=VTpYzzHPQUPyp256AN63kOWsN7JHdh2qvT0UkqBkC6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THBONJxU+aUWuJEEzAn8R0ui+qPYpSXeC5JykID5qY/LDBf6Jjl8RWjvOzGsKbSpdTdN0VOAhh7CvqQ8TnZOTvIlymcnKdnPJbkuQDJbDCLmnJWRnIgI1wDzeTZcwlxu/u7Bp7rR/TX7yjOIJyog20s1SPpmQeJRmvwbeaek/2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPypxlbD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPypxlbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29DC01F0089A;
	Sun,  7 Jun 2026 11:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830020;
	bh=8uhBay7PAoZidtlTLS62bFjDb8dshxUP6JVB9J1zeC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iPypxlbDpOADAWZxOpem2jREVZ5MVkO8oHgUdLoKArnayoMI7es0crOvP6U0zSVeN
	 9kOe4khxt0L/rUJCL4PLLMSV43iX6+5fcuio3FuTu6vFHN1VTwOF1HdjYOEDEegjYL
	 dU4HMDohpa4yOVywWORt0hv5g16CzT5PEP0sgW+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 300/315] cpufreq: intel_pstate: Add and use hybrid_get_cpu_type()
Date: Sun,  7 Jun 2026 12:01:27 +0200
Message-ID: <20260607095738.617623996@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 528dde6619677ac6dc26d9dda1e3c9014b4a08c8 ]

Introduce a function for identifying the type of a given CPU in a
hybrid system, called hybrid_get_cpu_type(), and use if for hybrid
scaling factor determination in hwp_get_cpu_scaling().

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/1954386.tdWV9SEqCh@rafael.j.wysocki
Stable-dep-of: 0e7c710478b3 ("cpufreq: intel_pstate: Use correct scaling factor on Raptor Lake-E")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/intel_pstate.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -909,6 +909,11 @@ static struct freq_attr *hwp_cpufreq_att
 	[HWP_CPUFREQ_ATTR_COUNT] = NULL,
 };
 
+static u8 hybrid_get_cpu_type(unsigned int cpu)
+{
+	return cpu_data(cpu).topo.intel_type;
+}
+
 static bool no_cas __ro_after_init;
 
 static struct cpudata *hybrid_max_perf_cpu __read_mostly;
@@ -2299,18 +2304,14 @@ static int knl_get_turbo_pstate(int cpu)
 static int hwp_get_cpu_scaling(int cpu)
 {
 	if (hybrid_scaling_factor) {
-		struct cpuinfo_x86 *c = &cpu_data(cpu);
-		u8 cpu_type = c->topo.intel_type;
-
 		/*
 		 * Return the hybrid scaling factor for P-cores and use the
 		 * default core scaling for E-cores.
 		 */
-		if (cpu_type == INTEL_CPU_TYPE_CORE)
+		if (hybrid_get_cpu_type(cpu) == INTEL_CPU_TYPE_CORE)
 			return hybrid_scaling_factor;
 
-		if (cpu_type == INTEL_CPU_TYPE_ATOM)
-			return core_get_scaling();
+		return core_get_scaling();
 	}
 
 	/* Use core scaling on non-hybrid systems. */



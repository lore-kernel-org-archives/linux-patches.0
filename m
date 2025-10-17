Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2A732C93B;
	Fri, 17 Oct 2025 15:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714707; cv=none; b=XDbJdo4xca18CWXW6QkAXXkz/aE3jtAxS5ABCyuFRlRgRY6MqlBXxNdQPr9jKgymBznXXKX/h2V9OmvPVg4a9dd140vAyh3HQ08geovmir6WDpkejoISKrrlLT3prDNtLuMO5BpAf62AAZFpTuBrYyAZSZbN3zDIjyLn/EOrlgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714707; c=relaxed/simple;
	bh=BLo3klvGw/RyW3fP1dsC4zzjFsPD9+ewzfwfVmNTJRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGqHDODmj+aVl7SjSacyDTQRlxAWxGmJtxTNEatJAhp6HveRKUKxcMe+4+3e9Y2c5mZlJipYjX1EdrUfIDcJFuTR+P7XbEO1DC+5hsL6Q7XV8vR029rs1sFM0/+EwG5cB/kq9lA8qTtpAQmKkso9h6+HoCuo+hU/ncox6uZBEkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WTcwgptb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WTcwgptb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262E7C4CEE7;
	Fri, 17 Oct 2025 15:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714707;
	bh=BLo3klvGw/RyW3fP1dsC4zzjFsPD9+ewzfwfVmNTJRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WTcwgptbJJiLDtwzW3Kad7no35XMKrMx9BrnquTk39jwyX4cQUF/bhH3lzJKmYpDJ
	 tU2sOhPZyv3BKPtfBcAl8ZqZHXE/rdBT/GzMCYiyjZ4IYy61k6C38vj+Sb1s9kKtjv
	 wqBPg+lFTXpIdTn6nRRqiU8raIFiue87dT2j/MdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shawnguo@kernel.org>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Jie Zhan <zhanjie9@hisilicon.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Qais Yousef <qyousef@layalina.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 237/277] cpufreq: Make drivers using CPUFREQ_ETERNAL specify transition latency
Date: Fri, 17 Oct 2025 16:54:04 +0200
Message-ID: <20251017145155.792023259@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit f97aef092e199c10a3da96ae79b571edd5362faa ]

Commit a755d0e2d41b ("cpufreq: Honour transition_latency over
transition_delay_us") caused platforms where cpuinfo.transition_latency
is CPUFREQ_ETERNAL to get a very large transition latency whereas
previously it had been capped at 10 ms (and later at 2 ms).

This led to a user-observable regression between 6.6 and 6.12 as
described by Shawn:

"The dbs sampling_rate was 10000 us on 6.6 and suddently becomes
 6442450 us (4294967295 / 1000 * 1.5) on 6.12 for these platforms
 because the default transition delay was dropped [...].

 It slows down dbs governor's reacting to CPU loading change
 dramatically.  Also, as transition_delay_us is used by schedutil
 governor as rate_limit_us, it shows a negative impact on device
 idle power consumption, because the device gets slightly less time
 in the lowest OPP."

Evidently, the expectation of the drivers using CPUFREQ_ETERNAL as
cpuinfo.transition_latency was that it would be capped by the core,
but they may as well return a default transition latency value instead
of CPUFREQ_ETERNAL and the core need not do anything with it.

Accordingly, introduce CPUFREQ_DEFAULT_TRANSITION_LATENCY_NS and make
all of the drivers in question use it instead of CPUFREQ_ETERNAL.  Also
update the related Rust binding.

Fixes: a755d0e2d41b ("cpufreq: Honour transition_latency over transition_delay_us")
Closes: https://lore.kernel.org/linux-pm/20250922125929.453444-1-shawnguo2@yeah.net/
Reported-by: Shawn Guo <shawnguo@kernel.org>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Jie Zhan <zhanjie9@hisilicon.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: 6.6+ <stable@vger.kernel.org> # 6.6+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/2264949.irdbgypaU6@rafael.j.wysocki
[ rjw: Fix typo in new symbol name, drop redundant type cast from Rust binding ]
Tested-by: Shawn Guo <shawnguo@kernel.org> # with cpufreq-dt driver
Reviewed-by: Qais Yousef <qyousef@layalina.io>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ omitted Rust changes ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/cpufreq-dt.c          |    2 +-
 drivers/cpufreq/imx6q-cpufreq.c       |    2 +-
 drivers/cpufreq/mediatek-cpufreq-hw.c |    2 +-
 drivers/cpufreq/scmi-cpufreq.c        |    2 +-
 drivers/cpufreq/scpi-cpufreq.c        |    2 +-
 drivers/cpufreq/spear-cpufreq.c       |    2 +-
 include/linux/cpufreq.h               |    3 +++
 7 files changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/cpufreq/cpufreq-dt.c
+++ b/drivers/cpufreq/cpufreq-dt.c
@@ -110,7 +110,7 @@ static int cpufreq_init(struct cpufreq_p
 
 	transition_latency = dev_pm_opp_get_max_transition_latency(cpu_dev);
 	if (!transition_latency)
-		transition_latency = CPUFREQ_ETERNAL;
+		transition_latency = CPUFREQ_DEFAULT_TRANSITION_LATENCY_NS;
 
 	cpumask_copy(policy->cpus, priv->cpus);
 	policy->driver_data = priv;
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -443,7 +443,7 @@ soc_opp_out:
 	}
 
 	if (of_property_read_u32(np, "clock-latency", &transition_latency))
-		transition_latency = CPUFREQ_ETERNAL;
+		transition_latency = CPUFREQ_DEFAULT_TRANSITION_LATENCY_NS;
 
 	/*
 	 * Calculate the ramp time for max voltage change in the
--- a/drivers/cpufreq/mediatek-cpufreq-hw.c
+++ b/drivers/cpufreq/mediatek-cpufreq-hw.c
@@ -238,7 +238,7 @@ static int mtk_cpufreq_hw_cpu_init(struc
 
 	latency = readl_relaxed(data->reg_bases[REG_FREQ_LATENCY]) * 1000;
 	if (!latency)
-		latency = CPUFREQ_ETERNAL;
+		latency = CPUFREQ_DEFAULT_TRANSITION_LATENCY_NS;
 
 	policy->cpuinfo.transition_latency = latency;
 	policy->fast_switch_possible = true;
--- a/drivers/cpufreq/scmi-cpufreq.c
+++ b/drivers/cpufreq/scmi-cpufreq.c
@@ -280,7 +280,7 @@ static int scmi_cpufreq_init(struct cpuf
 
 	latency = perf_ops->transition_latency_get(ph, domain);
 	if (!latency)
-		latency = CPUFREQ_ETERNAL;
+		latency = CPUFREQ_DEFAULT_TRANSITION_LATENCY_NS;
 
 	policy->cpuinfo.transition_latency = latency;
 
--- a/drivers/cpufreq/scpi-cpufreq.c
+++ b/drivers/cpufreq/scpi-cpufreq.c
@@ -157,7 +157,7 @@ static int scpi_cpufreq_init(struct cpuf
 
 	latency = scpi_ops->get_transition_latency(cpu_dev);
 	if (!latency)
-		latency = CPUFREQ_ETERNAL;
+		latency = CPUFREQ_DEFAULT_TRANSITION_LATENCY_NS;
 
 	policy->cpuinfo.transition_latency = latency;
 
--- a/drivers/cpufreq/spear-cpufreq.c
+++ b/drivers/cpufreq/spear-cpufreq.c
@@ -183,7 +183,7 @@ static int spear_cpufreq_probe(struct pl
 
 	if (of_property_read_u32(np, "clock-latency",
 				&spear_cpufreq.transition_latency))
-		spear_cpufreq.transition_latency = CPUFREQ_ETERNAL;
+		spear_cpufreq.transition_latency = CPUFREQ_DEFAULT_TRANSITION_LATENCY_NS;
 
 	cnt = of_property_count_u32_elems(np, "cpufreq_tbl");
 	if (cnt <= 0) {
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -32,6 +32,9 @@
  */
 
 #define CPUFREQ_ETERNAL			(-1)
+
+#define CPUFREQ_DEFAULT_TRANSITION_LATENCY_NS	NSEC_PER_MSEC
+
 #define CPUFREQ_NAME_LEN		16
 /* Print length for names. Extra 1 space for accommodating '\n' in prints */
 #define CPUFREQ_NAME_PLEN		(CPUFREQ_NAME_LEN + 1)



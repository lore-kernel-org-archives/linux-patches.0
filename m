Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA82277035;
	Tue, 21 Oct 2025 20:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076805; cv=none; b=N/ze8BH4M/o0lOBQiKRTUAEo0oZ+1vWGbUS5aCkWKxwEdXGZG3UmSrtjzExpVRX2M62isrW9pPZGUBGVMuyOajqXtiMKIuMyJBYPR6/BFwQEzZJnN9f15V78f2dADr7Url86XIxys4j3qoXj2/9nEWkxAMPM5529/ghpXz4ZsPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076805; c=relaxed/simple;
	bh=cOH8q8wvTchTWVA21vLSSciHPLkhE7YSrZCJvSTknck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1FUrY8fNsWxSbTTvRiW9VF266IDf2+Gcdn/+9+v4tD4UmTDcwyqPMt2roHu0VMc82Vvvtv51aDONDQx6fo9mMRr0sg7HlMZFTKtuXLVdfEZuWQ7OQ+5OKAE8PGGF9G9fG/FT6ViB3KQrQ4HXjvY+lQBYwrLRzcX3xmjLnY8YZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JVmcz6+k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JVmcz6+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68DAEC4CEF1;
	Tue, 21 Oct 2025 20:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076804;
	bh=cOH8q8wvTchTWVA21vLSSciHPLkhE7YSrZCJvSTknck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JVmcz6+k1XCPHLejr6SItyRQjtODQYWCoR5l09xtEB9eDkNZPbcoOrcmrq5EAR7HB
	 SngLV7Z0BxUTG8GRuO++E1kVz4lULrxILI98i8X/alL6LAk6mjkmMs762rZWeq9KCf
	 l0r92FNKS9ghyU6bbGb3UWSbGPdLuizz9CQF6Xgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Jie Zhan <zhanjie9@hisilicon.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Qais Yousef <qyousef@layalina.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/136] cpufreq: CPPC: Avoid using CPUFREQ_ETERNAL as transition delay
Date: Tue, 21 Oct 2025 21:50:29 +0200
Message-ID: <20251021195036.968440290@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

[ Upstream commit f965d111e68f4a993cc44d487d416e3d954eea11 ]

If cppc_get_transition_latency() returns CPUFREQ_ETERNAL to indicate a
failure to retrieve the transition latency value from the platform
firmware, the CPPC cpufreq driver will use that value (converted to
microseconds) as the policy transition delay, but it is way too large
for any practical use.

Address this by making the driver use the cpufreq's default
transition latency value (in microseconds) as the transition delay
if CPUFREQ_ETERNAL is returned by cppc_get_transition_latency().

Fixes: d4f3388afd48 ("cpufreq / CPPC: Set platform specific transition_delay_us")
Cc: 5.19+ <stable@vger.kernel.org> # 5.19
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Jie Zhan <zhanjie9@hisilicon.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Qais Yousef <qyousef@layalina.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/cppc_cpufreq.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -339,6 +339,16 @@ static int cppc_verify_policy(struct cpu
 	return 0;
 }
 
+static unsigned int __cppc_cpufreq_get_transition_delay_us(unsigned int cpu)
+{
+	unsigned int transition_latency_ns = cppc_get_transition_latency(cpu);
+
+	if (transition_latency_ns == CPUFREQ_ETERNAL)
+		return CPUFREQ_DEFAULT_TRANSITION_LATENCY_NS / NSEC_PER_USEC;
+
+	return transition_latency_ns / NSEC_PER_USEC;
+}
+
 /*
  * The PCC subspace describes the rate at which platform can accept commands
  * on the shared PCC channel (including READs which do not count towards freq
@@ -361,12 +371,12 @@ static unsigned int cppc_cpufreq_get_tra
 			return 10000;
 		}
 	}
-	return cppc_get_transition_latency(cpu) / NSEC_PER_USEC;
+	return __cppc_cpufreq_get_transition_delay_us(cpu);
 }
 #else
 static unsigned int cppc_cpufreq_get_transition_delay_us(unsigned int cpu)
 {
-	return cppc_get_transition_latency(cpu) / NSEC_PER_USEC;
+	return __cppc_cpufreq_get_transition_delay_us(cpu);
 }
 #endif
 



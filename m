Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9F22737F6;
	Tue, 21 Oct 2025 19:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076379; cv=none; b=cVGeF84/CLHm6Ojpb1rULkSEHTL4Lcc/TtRnKBVzh4crgcZTnxB2Q0nxmq+chcfL1PW1ti7rOIvpwLVFj6OIYt5ssZT45X6DQOByPQc17Sh/UIjcWrtOiePax4BoqhEjjdp23oHUM/GHd5PTwxYQkPBR7ZMxMv13T76JY9q1kk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076379; c=relaxed/simple;
	bh=ED7UoZ00ULBkA476RJnsQNQE1QMgmXwkNkB1JBntgGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=feUr4rulFkkY3h0ZO+S49u5bRoxJCDu1cseT+Yqp9/w8fAir4z1Z1XN5qXy4FraY0//ntXdkaBVGdJ91NJhJFOZyXFiMhSQ35YQwJ1ZykS/yp3fhiL6pb4AMxsQMsiIdoTWWSau82wzccPVSPoXIJ4KX/ceUH75YlVsKIUFzAGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zQvLlD06; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zQvLlD06"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B670C4CEF1;
	Tue, 21 Oct 2025 19:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076379;
	bh=ED7UoZ00ULBkA476RJnsQNQE1QMgmXwkNkB1JBntgGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zQvLlD065MVEvNV8sIzfLnOT6UZOEz4Uq9nmL/wwY+6YFByUEUkoExnGjnQzOq58m
	 1MGjwXQZKtb6+R0acuyywWk3gP7H2fG633EcUGKljOS6fW0I4d46xMWzF/VO3EcxXJ
	 F5ZMnzVYJYg2zkCo3JaDgDcqMOk8rcztC9YVp1T4=
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
Subject: [PATCH 6.6 017/105] cpufreq: CPPC: Avoid using CPUFREQ_ETERNAL as transition delay
Date: Tue, 21 Oct 2025 21:50:26 +0200
Message-ID: <20251021195021.901746052@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ added CPUFREQ_DEFAULT_TRANSITION_LATENCY_NS definition to include/linux/cpufreq.h ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/cppc_cpufreq.c |   14 ++++++++++++--
 include/linux/cpufreq.h        |    3 +++
 2 files changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -344,6 +344,16 @@ static int cppc_verify_policy(struct cpu
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
@@ -366,12 +376,12 @@ static unsigned int cppc_cpufreq_get_tra
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



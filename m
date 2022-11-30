Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103DD79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874BEC433C1;
	Wed, 30 Nov 2022 18:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834231;
	bh=G5BNTwF674l+IZbN/9mH7YmgwJu3d8ZWMmuVd7Cd+aU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GRpy7SOoG88yy1tzgjL3RMWFNoru83eBXECKpCj2kJvvexmdFw1tXfbm1pdS/jRdq
	 3oj0hABZ5jJ8lxYnaySceaPSY1q/ximIs19y8eiEP8BFACZfBwUprH9YKGkgpNyz05
	 qr0vvPShR0NlRNFSqTpVbwnEow3BDVPSXhVOfvVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huang Rui <ray.huang@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Wyes Karny <wyes.karny@amd.com>,
	Perry Yuan <Perry.Yuan@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.0 178/289] cpufreq: amd-pstate: cpufreq: amd-pstate: reset MSR_AMD_PERF_CTL register at init
Date: Wed, 30 Nov 2022 19:22:43 +0100
Message-Id: <20221130180548.164273836@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wyes Karny <wyes.karny@amd.com>

commit 919f4557696939625085435ebde09a539de2349c upstream.

MSR_AMD_PERF_CTL is guaranteed to be 0 on a cold boot. However, on a
kexec boot, for instance, it may have a non-zero value (if the cpu was
in a non-P0 Pstate).  In such cases, the cores with non-P0 Pstates at
boot will never be pushed to P0, let alone boost frequencies.

Kexec is a common workflow for reboot on Linux and this creates a
regression in performance. Fix it by explicitly setting the
MSR_AMD_PERF_CTL to 0 during amd_pstate driver init.

Cc: All applicable <stable@vger.kernel.org>
Acked-by: Huang Rui <ray.huang@amd.com>
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Tested-by: Wyes Karny <wyes.karny@amd.com>
Signed-off-by: Wyes Karny <wyes.karny@amd.com>
Signed-off-by: Perry Yuan <Perry.Yuan@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/amd-pstate.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -483,12 +483,22 @@ static void amd_pstate_boost_init(struct
 	amd_pstate_driver.boost_enabled = true;
 }
 
+static void amd_perf_ctl_reset(unsigned int cpu)
+{
+	wrmsrl_on_cpu(cpu, MSR_AMD_PERF_CTL, 0);
+}
+
 static int amd_pstate_cpu_init(struct cpufreq_policy *policy)
 {
 	int min_freq, max_freq, nominal_freq, lowest_nonlinear_freq, ret;
 	struct device *dev;
 	struct amd_cpudata *cpudata;
 
+	/*
+	 * Resetting PERF_CTL_MSR will put the CPU in P0 frequency,
+	 * which is ideal for initialization process.
+	 */
+	amd_perf_ctl_reset(policy->cpu);
 	dev = get_cpu_device(policy->cpu);
 	if (!dev)
 		return -ENODEV;



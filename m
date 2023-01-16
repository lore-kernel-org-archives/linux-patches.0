Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865D633EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E133DC433EF;
	Mon, 16 Jan 2023 15:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884482;
	bh=60p8QE83Ztk/TuSwLNwYkgzqK+iuZ9nzVr4FnkjINuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bVrc3V/4Prh2YiYZvSW6JHlq7/ck29jRMEVlVVe5dBvCUPX3+/h7kE44Ibpkv417V
	 YKTABscBYsqh+CLJ5sihOOg0bkg7Qz1fcslgB0MI+LecmODumKwdGqG4uJTKwegYw4
	 z9/3CBYy9M5Xqc/2eYg79GO5Ls0L7RuF2QBUTbRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huang Rui <ray.huang@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Wyes Karny <wyes.karny@amd.com>,
	Perry Yuan <perry.yuan@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 023/183] cpufreq: amd-pstate: fix kernel hang issue while amd-pstate unregistering
Date: Mon, 16 Jan 2023 16:49:06 +0100
Message-Id: <20230116154804.368439704@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Perry Yuan <perry.yuan@amd.com>

commit 4f3085f87b51a551a0647f218d4f324796ecb703 upstream.

In the amd_pstate_adjust_perf(), there is one cpufreq_cpu_get() call to
increase increments the kobject reference count of policy and make it as
busy. Therefore, a corresponding call to cpufreq_cpu_put() is needed to
decrement the kobject reference count back, it will resolve the kernel
hang issue when unregistering the amd-pstate driver and register the
`amd_pstate_epp` driver instance.

Fixes: 1d215f0319 ("cpufreq: amd-pstate: Add fast switch function for AMD P-State")
Acked-by: Huang Rui <ray.huang@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Tested-by: Wyes Karny <wyes.karny@amd.com>
Signed-off-by: Perry Yuan <perry.yuan@amd.com>
Cc: 5.17+ <stable@vger.kernel.org> # 5.17+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/amd-pstate.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -307,6 +307,7 @@ static void amd_pstate_adjust_perf(unsig
 		max_perf = min_perf;
 
 	amd_pstate_update(cpudata, min_perf, des_perf, max_perf, true);
+	cpufreq_cpu_put(policy);
 }
 
 static int amd_get_min_freq(struct amd_cpudata *cpudata)



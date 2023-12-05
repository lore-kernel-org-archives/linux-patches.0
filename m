Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43746FAF;
	Tue,  5 Dec 2023 03:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ErIDDgVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0ECC433C7;
	Tue,  5 Dec 2023 03:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746701;
	bh=+m3T8h7cGCUevYURK73UrdYHDGfnR+L/qIkYe2x8fb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ErIDDgVDrk/3SV8p3MJ4uWK8Y9Ieg1FJ5g9adhBT0llbQw/k68ZYKvekXbBz3r7ou
	 zcoEf+/l8iWHWtDWqN11LpnOvujC/jjXSPzN+Q9d4IeBpcOGiJ42eE7yoQISnwFaC0
	 WYxLV2IMJzfEufWaooHvdCJjIRjgaxEz0xoTVa7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wyes Karny <wyes.karny@amd.com>,
	Ayush Jain <ayush.jain3@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/134] cpufreq/amd-pstate: Only print supported EPP values for performance governor
Date: Tue,  5 Dec 2023 12:16:36 +0900
Message-ID: <20231205031543.307235753@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

From: Ayush Jain <ayush.jain3@amd.com>

[ Upstream commit 142c169b31beb364ef39385b4e88735bd51d37fe ]

show_energy_performance_available_preferences() to show only supported
values which is performance in performance governor policy.

-------Before--------
$ cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_driver
amd-pstate-epp
$ cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
performance
$ cat /sys/devices/system/cpu/cpu1/cpufreq/energy_performance_preference
performance
$ cat /sys/devices/system/cpu/cpu1/cpufreq/energy_performance_available_preferences
default performance balance_performance balance_power power

-------After--------
$ cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_driver
amd-pstate-epp
$ cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
performance
$ cat /sys/devices/system/cpu/cpu1/cpufreq/energy_performance_preference
performance
$ cat /sys/devices/system/cpu/cpu1/cpufreq/energy_performance_available_preferences
performance

Fixes: ffa5096a7c33 ("cpufreq: amd-pstate: implement Pstate EPP support for the AMD processors")
Suggested-by: Wyes Karny <wyes.karny@amd.com>
Signed-off-by: Ayush Jain <ayush.jain3@amd.com>
Reviewed-by: Wyes Karny <wyes.karny@amd.com>
Acked-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 3313d1d2c6ddf..1f6186475715e 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -882,11 +882,16 @@ static ssize_t show_energy_performance_available_preferences(
 {
 	int i = 0;
 	int offset = 0;
+	struct amd_cpudata *cpudata = policy->driver_data;
+
+	if (cpudata->policy == CPUFREQ_POLICY_PERFORMANCE)
+		return sysfs_emit_at(buf, offset, "%s\n",
+				energy_perf_strings[EPP_INDEX_PERFORMANCE]);
 
 	while (energy_perf_strings[i] != NULL)
 		offset += sysfs_emit_at(buf, offset, "%s ", energy_perf_strings[i++]);
 
-	sysfs_emit_at(buf, offset, "\n");
+	offset += sysfs_emit_at(buf, offset, "\n");
 
 	return offset;
 }
-- 
2.42.0




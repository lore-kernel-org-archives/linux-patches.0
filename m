Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEB7145FE3;
	Thu, 13 Jun 2024 11:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279534; cv=none; b=TsVtanlownSlGtqU8+ow7wiWPtADfrUqAb6UpztXYeeAheOGzu4doYwjU+NJlVmSVrYJ6R7WihPufoREIJ7bLywSOA/ss4XW6CORuHAA3V39IrHFDTqmPox5RVRKSnZm1KEro0PP/0aKuvzLL3YIxr4cl5kosU26nL3+wvFOXNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279534; c=relaxed/simple;
	bh=X8Ftv2j1sP0BjHuRj1gLAYQe8PzhdNC6s7b1Fz8VNqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jbl50QSIwJ+++qt2pTntR9seCKV2xYQme8L0OWbSYuyezEl9xsOBx6CnmzRCOgHoNhewL9pJgb8oqvSlJ2i+ROjzvcvcQAzgR2MEPSaQZuJyI0NfgnzcNIFMY2xjRioatYkLxVwPYQAWH28ad38uh3OSMR99faQr9VYD9PMBPbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xG2ir5DE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xG2ir5DE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E535BC2BBFC;
	Thu, 13 Jun 2024 11:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279534;
	bh=X8Ftv2j1sP0BjHuRj1gLAYQe8PzhdNC6s7b1Fz8VNqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xG2ir5DEGxyaEe5tsvk1LVvzc7o0InnZOSDvXuHDSnYU2QwhovBVm1NdSw6iuw8LV
	 evNRRzEwsxFmbZ68OOosZudbTyu6xH2SAzmWE9JA37wJaN+QCYsj8EqJ7c6H8NcUYz
	 X1Ia7qKyFzBiRvRfRZ5rKcEgQDmKsqDb4mB4mMug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Peter Jung <ptr1337@cachyos.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.9 091/157] cpufreq: amd-pstate: Fix the inconsistency in max frequency units
Date: Thu, 13 Jun 2024 13:33:36 +0200
Message-ID: <20240613113230.946701747@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

From: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>

commit e4731baaf29438508197d3a8a6d4f5a8c51663f8 upstream.

The nominal frequency in cpudata is maintained in MHz whereas all other
frequencies are in KHz. This means we have to convert nominal frequency
value to KHz before we do any interaction with other frequency values.

In amd_pstate_set_boost(), this conversion from MHz to KHz is missed,
fix that.

Tested on a AMD Zen4 EPYC server

Before:
$ cat /sys/devices/system/cpu/cpufreq/policy*/scaling_max_freq | uniq
2151
$ cat /sys/devices/system/cpu/cpufreq/policy*/cpuinfo_min_freq | uniq
400000
$ cat /sys/devices/system/cpu/cpufreq/policy*/scaling_cur_freq | uniq
2151
409422

After:
$ cat /sys/devices/system/cpu/cpufreq/policy*/scaling_max_freq | uniq
2151000
$ cat /sys/devices/system/cpu/cpufreq/policy*/cpuinfo_min_freq | uniq
400000
$ cat /sys/devices/system/cpu/cpufreq/policy*/scaling_cur_freq | uniq
2151000
1799527

Fixes: ec437d71db77 ("cpufreq: amd-pstate: Introduce a new AMD P-State driver to support future processors")
Signed-off-by: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
Acked-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Tested-by: Peter Jung <ptr1337@cachyos.org>
Cc: 5.17+ <stable@vger.kernel.org> # 5.17+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/amd-pstate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -705,7 +705,7 @@ static int amd_pstate_set_boost(struct c
 	if (state)
 		policy->cpuinfo.max_freq = cpudata->max_freq;
 	else
-		policy->cpuinfo.max_freq = cpudata->nominal_freq;
+		policy->cpuinfo.max_freq = cpudata->nominal_freq * 1000;
 
 	policy->max = policy->cpuinfo.max_freq;
 



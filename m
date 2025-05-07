Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B921FF5EC;
	Wed,  7 May 2025 18:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643998; cv=none; b=HlgWxZ5wKSxck8cFq9WdX1BDEJvzWoza1Lt4NPnQQk+zt4cCwsaYji4G2mpG61xv0qdcJXNC4I/lSwLIbr/PdfhfmYCPsV6/L3wQgMlVYKDa1Rx91ExWL6EB++6M57ot1NSuIdhE+jiruzblvNYr20LTZYNX4LnKQLF1DCKEmmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643998; c=relaxed/simple;
	bh=XglTjcs9X5Oj8WmqBVP7ZkgX/xMKCbi10nhDWAld9lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DJMTm4mzqtNn8hKULOPM/qTPPa3+QMlgMyLS4OK4vH60YNhuG7lH4wnTVcNzb5XGL+y8TGNxrusAPsw0kX2UTMgyh1uhhyUFHWypIV32HcF7vDC36GBFA8wh+BRtHTXNzT/uyzwbo5xGTArct5Z78sOW0UTne8b0OXO/Vu0XDkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jjdHcLh2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jjdHcLh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E03C4CEE2;
	Wed,  7 May 2025 18:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643998;
	bh=XglTjcs9X5Oj8WmqBVP7ZkgX/xMKCbi10nhDWAld9lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jjdHcLh2Rp4dQBa8PD72hh5Vdc0Ky5kc8NmZhv7XMptEbuO9wBIJhK+Zqnr+yTFMs
	 OTOPUJARC+mjATeUCUHn30XPjFIu7CqxNX35N779UPPFaglJQViOVJYCJQjnJ6odLe
	 1vAs8z3RlKuvI+32PTfdQKiPhJkpPHaNTHnzZM6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Chin <nic.c3.14@gmail.com>,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 079/183] cpufreq: ACPI: Re-sync CPU boost state on system resume
Date: Wed,  7 May 2025 20:38:44 +0200
Message-ID: <20250507183827.886394332@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 3d59224947b024c9b2aa6e149a1537d449adb828 ]

During CPU hotunplug events (such as those occurring during
suspend/resume cycles), platform firmware may modify the CPU boost
state.

If boost was disabled prior to CPU removal, it correctly remains
disabled upon re-plug. However, if firmware re-enables boost while the
CPU is offline, the CPU may return with boost enabled—even if it was
originally disabled—once it is hotplugged back in. This leads to
inconsistent behavior and violates user or kernel policy expectations.

To maintain consistency, ensure the boost state is re-synchronized with
the kernel policy when a CPU is hotplugged back in.

Note: This re-synchronization is not necessary during the initial call
to ->init() for a CPU, as the cpufreq core handles it via
cpufreq_online(). At that point, acpi_cpufreq_driver.boost_enabled is
initialized to the value returned by boost_state(0).

Fixes: 2b16c631832d ("cpufreq: ACPI: Remove set_boost in acpi_cpufreq_cpu_init()")
Reported-by: Nicholas Chin <nic.c3.14@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220013
Tested-by: Nicholas Chin <nic.c3.14@gmail.com>
Reviewed-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://patch.msgid.link/9c7de55fb06015c1b77e7dafd564b659838864e0.1745511526.git.viresh.kumar@linaro.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/acpi-cpufreq.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index ae0766b5a076b..453b629d3de65 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -909,8 +909,19 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	if (perf->states[0].core_frequency * 1000 != freq_table[0].frequency)
 		pr_warn(FW_WARN "P-state 0 is not max freq\n");
 
-	if (acpi_cpufreq_driver.set_boost)
-		policy->boost_supported = true;
+	if (acpi_cpufreq_driver.set_boost) {
+		if (policy->boost_supported) {
+			/*
+			 * The firmware may have altered boost state while the
+			 * CPU was offline (for example during a suspend-resume
+			 * cycle).
+			 */
+			if (policy->boost_enabled != boost_state(cpu))
+				set_boost(policy, policy->boost_enabled);
+		} else {
+			policy->boost_supported = true;
+		}
+	}
 
 	return result;
 
-- 
2.39.5




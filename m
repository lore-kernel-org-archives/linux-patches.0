Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6E4DDCB;
	Mon,  4 Mar 2024 21:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588193; cv=none; b=eGy5GYF+gh+5ESrqfDE778IQQgh1tTdAFUzgvqdHCOC+ZFhHuvkC14sWJkpTAvf5PgjM1U24pjLceuH9Xtvxb0Vl4KcjsAcI43kNkitV99FAQl1D+8mnmpszoRjvgKovfO+8CEGhyXs9arfhV363VAaFxDDjli7SifokB3wbNP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588193; c=relaxed/simple;
	bh=kVT99ARBmnUCOc8b2Nt6iYJDhtL2nNdK4LBIpsXOZI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+aqh7hqzz5E54eU6yTeOq6T5kaPxKz8qCwdb8dEZxvOO8gg++Poz/RTZUPNswChl+TSxaeDN8kDLCR/cud4Osqz5H0miOYH8KdsqJCWcAx0AQLOeo/HXwQE+hNYsbUb3U6j1xLgz6g77SMBTaVJ765XqMygkgLuaIjwV7Kxv4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOimRgAX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOimRgAX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E467CC433F1;
	Mon,  4 Mar 2024 21:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588193;
	bh=kVT99ARBmnUCOc8b2Nt6iYJDhtL2nNdK4LBIpsXOZI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOimRgAXP7/mtAiQuj7iBEJeG9+rR2Mvzo5+9e66B0mdGqP6oQzMaCis6/sAN7wdW
	 bGusrObJjp8+4cMvD8+LoTG/PPOarLUIBvs9eD2gbkOVns7V9wS9gaUmbEfCt58O1M
	 rl1xpwCI87z8aTHjpaFRQSIuDyJEBDB/vje+CxV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Smythies <dsmythies@telus.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/143] cpufreq: intel_pstate: fix pstate limits enforcement for adjust_perf call back
Date: Mon,  4 Mar 2024 21:22:14 +0000
Message-ID: <20240304211550.390123048@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

From: Doug Smythies <dsmythies@telus.net>

[ Upstream commit f0a0fc10abb062d122db5ac4ed42f6d1ca342649 ]

There is a loophole in pstate limit clamping for the intel_cpufreq CPU
frequency scaling driver (intel_pstate in passive mode), schedutil CPU
frequency scaling governor, HWP (HardWare Pstate) control enabled, when
the adjust_perf call back path is used.

Fix it.

Fixes: a365ab6b9dfb cpufreq: intel_pstate: Implement the ->adjust_perf() callback
Signed-off-by: Doug Smythies <dsmythies@telus.net>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index c352a593e5d86..586a58d761bb6 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2987,6 +2987,9 @@ static void intel_cpufreq_adjust_perf(unsigned int cpunum,
 	if (min_pstate < cpu->min_perf_ratio)
 		min_pstate = cpu->min_perf_ratio;
 
+	if (min_pstate > cpu->max_perf_ratio)
+		min_pstate = cpu->max_perf_ratio;
+
 	max_pstate = min(cap_pstate, cpu->max_perf_ratio);
 	if (max_pstate < min_pstate)
 		max_pstate = min_pstate;
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD1C8F58;
	Mon,  4 Mar 2024 21:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588622; cv=none; b=LqV+2SbkrLN2fCXifaslPV+EnopVol87xHCvCGLi7XFUXwMUPTh53NqQf/cxwlKsQCabHIty7t+gm6W6/hw0thCB4pJzgmd2Uas5Ax1MWuPKxkWybnMF4Ds1GlXsWIfSRgngR7rh7jpCAuaCiPpBkibUnWUw2MhN30f5Xbo9o/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588622; c=relaxed/simple;
	bh=4BvG2zYmOtRa+gXtSCx4lG1Gj3vEFHh4GxRSj5TI3Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QA/P+eWnf6cG5XoHrqXtWtMUtg6Tkgc2KviqANQHIM+ZM1C3lNyYZasw2BhTf7wc4hWktbppUvaSShFsDmuQF0cW58tTDbmhAV262k/Ba20AostHJK8yMoWInFwlYQURksegfCyPqHYF5b+CYG3bvb1WBArK11DqZw/5T86D7pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZnBacUla; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZnBacUla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB23AC433C7;
	Mon,  4 Mar 2024 21:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588622;
	bh=4BvG2zYmOtRa+gXtSCx4lG1Gj3vEFHh4GxRSj5TI3Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZnBacUla85wA1K1zZHvoc8MKoeNgSmx6rZjZc/23fhfsjCsmAsvhmLg1+plVSm0Aj
	 Iwy4kRJNTunMB/ilGM9BxlZXfs8UM7FHezOlhdbq+1XsVzdI3xHOrzrt4C82gPqT+E
	 CSJSdL3iHn7rE2dgNpskq2ofnZJiowJI+qGn5QnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Smythies <dsmythies@telus.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/215] cpufreq: intel_pstate: fix pstate limits enforcement for adjust_perf call back
Date: Mon,  4 Mar 2024 21:21:36 +0000
Message-ID: <20240304211558.037001955@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index abdd26f7d04c9..5771f3fc6115d 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2952,6 +2952,9 @@ static void intel_cpufreq_adjust_perf(unsigned int cpunum,
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




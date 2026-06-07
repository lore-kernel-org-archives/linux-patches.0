Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAFF352006;
	Sun,  7 Jun 2026 11:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830029; cv=none; b=tR2cFv6OM6MZsjFFw3PtGrDe9wiga32wg+Iw2AnfSyseVElPqwVcfofrctva3/SwdpyBshtefNdFpXRfSVd4q+u/Ql3zgHXrrcxnplCIDKe3LlllzvPBCQSqqmj23Dfv4+hF+8rf4JtXDutLH12LzgL7KY440IUHhg/ToOy9rWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830029; c=relaxed/simple;
	bh=lAEiFHNcrwkhyy9od+kvUpAO0IVknjQLGf4bEjhhAmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgStiATgjwFTdJiE/LKsE3HzGktcMGharNe/fEfK3K+kqQp4Rn2jGj02bsV+d03plyhamj7aesIbTSNLc2r56ELn/HCRrd5wEBbppA2apux1RaTw305skZsWFZnJXIq5rXIgTFLM44rOiKV/zFQutVKKZmxJjsPt8OVJHbdspaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+oi6x8B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+oi6x8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60CD1F00893;
	Sun,  7 Jun 2026 11:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830028;
	bh=YyBnrCnVy44jDWTXEIlT8CQ1mJOtmdqhW5WaEPPmlgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A+oi6x8B0RUH4Fh+7QrMAGEsd0Ej4nhlx56kl/yh3bGN3Pv/YYyp8d56DdnjOtxCx
	 W57JevCTat5vD1EASLJ1Luk24j9UjEmAZ5objY+uhvRqXzZEIIKQEaGp+GJIaihHSX
	 AJ/VDrSRQf1gAKZ+mbt6yqJeJzOVT7VbHR7RSQhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Tseng <henrytseng@qnap.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 301/315] cpufreq: intel_pstate: Use correct scaling factor on Raptor Lake-E
Date: Sun,  7 Jun 2026 12:01:28 +0200
Message-ID: <20260607095738.655874108@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 0e7c710478b3089cdfe8669347f77b163e836c4f ]

Raptor Lake-E has the same processor ID as Raptor Lake-S, so there is
an entry in intel_hybrid_scaling_factor[] for it.  It does not contain
E-cores though and hybrid_get_cpu_type() returns 0 for its P-cores, so
they get the default "core" scaling factor.  However, the original
Raptor Lake scaling factor for P-cores still needs to be used for
mapping the HWP performance levels of the P-cores in Raptor Lake-E to
frequency, as though they were part of a real hybrid system.

To address this, update hwp_get_cpu_scaling() to return
hybrid_scaling_factor, which is the P-core scaling factor
retrieved from intel_hybrid_scaling_factor[], for all CPUs
that are not enumerated as E-cores.

Fixes: 9b18d536b124 ("cpufreq: intel_pstate: Use CPPC to get scaling factors")
Link: https://lore.kernel.org/all/20260511235328.2018458-1-srinivas.pandruvada@linux.intel.com/
Reported-by: Henry Tseng <henrytseng@qnap.com>
Closes: https://lore.kernel.org/linux-pm/20260508063032.3248602-1-henrytseng@qnap.com/
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: All applicable <stable@vger.kernel.org>
Link: https://patch.msgid.link/4523296.ejJDZkT8p0@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/intel_pstate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2308,7 +2308,7 @@ static int hwp_get_cpu_scaling(int cpu)
 		 * Return the hybrid scaling factor for P-cores and use the
 		 * default core scaling for E-cores.
 		 */
-		if (hybrid_get_cpu_type(cpu) == INTEL_CPU_TYPE_CORE)
+		if (hybrid_get_cpu_type(cpu) != INTEL_CPU_TYPE_ATOM)
 			return hybrid_scaling_factor;
 
 		return core_get_scaling();



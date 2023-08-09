Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FBB17AAD
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:38:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A512C433C7;
	Wed,  9 Aug 2023 11:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581111;
	bh=OZPqh6DPtVNj/6F3HCkbpXeXCAEQ902CoFTvPplyJig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6RlPG+I6nhxAAgpd8WO91599HH2oheWKCZCHz5UmiopOVtDbIN3O/wtEcOBMBOen
	 AHOoHzOEjY/pnAKQmTzykoShUM2tFcwY81cDn4O+GzpB3KdIKIHvUzjdRx3xwVKteA
	 Kegh1j+ptE4/7T/NmSxD4U0mI7Jnju/5iwyOCPtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Hagar Hemdan <hagarhem@amazon.de>
Subject: [PATCH 5.10 109/201] cpufreq: intel_pstate: Drop ACPI _PSS states table patching
Date: Wed,  9 Aug 2023 12:41:51 +0200
Message-ID: <20230809103647.449848820@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit e8a0e30b742f76ebd0f3b196973df4bf65d8fbbb upstream.

After making acpi_processor_get_platform_limit() use the "no limit"
value for its frequency QoS request when _PPC returns 0, it is not
necessary to replace the frequency corresponding to the first _PSS
return package entry with the maximum turbo frequency of the given
CPU in intel_pstate_init_acpi_perf_limits() any more, so drop the
code doing that along with the comment explaining it.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Hagar Hemdan <hagarhem@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/intel_pstate.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -443,20 +443,6 @@ static void intel_pstate_init_acpi_perf_
 			 (u32) cpu->acpi_perf_data.states[i].control);
 	}
 
-	/*
-	 * The _PSS table doesn't contain whole turbo frequency range.
-	 * This just contains +1 MHZ above the max non turbo frequency,
-	 * with control value corresponding to max turbo ratio. But
-	 * when cpufreq set policy is called, it will call with this
-	 * max frequency, which will cause a reduced performance as
-	 * this driver uses real max turbo frequency as the max
-	 * frequency. So correct this frequency in _PSS table to
-	 * correct max turbo frequency based on the turbo state.
-	 * Also need to convert to MHz as _PSS freq is in MHz.
-	 */
-	if (!global.turbo_disabled)
-		cpu->acpi_perf_data.states[0].core_frequency =
-					policy->cpuinfo.max_freq / 1000;
 	cpu->valid_pss_table = true;
 	pr_debug("_PPC limits will be enforced\n");
 



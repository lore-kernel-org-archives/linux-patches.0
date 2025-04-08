Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00D9225412;
	Tue,  8 Apr 2025 12:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114416; cv=none; b=RcJ1dQY2kJDvQufpD72QBZkEmijBYzR1KExIqBSSQTceBvuXDIPyQbLonU1DMl6Pqg2Kv9oSljrkI+/PEAgOn6FF7DIuMKt50MKFfwQ0q6sFDbLwmKAWGGV+wp1PFx2aPCZxC89ch3QD8mjDmt6MgcrdLR4/LdnjuTpYkaGG8EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114416; c=relaxed/simple;
	bh=NybpiI5PPIc/LaglhznPwgEB313t9DyKfuPfOrjmMv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SuixaeVkfOXui3Yloo93HY1YAkY2RWiGFCzofETHMz5fQc8yoO4uKmFAJsukPYjKkheEED9sa2cenYyCuakwkt2mDcJ6Yy0v0TU5QaVcn+5eABC0uoPaQo6O2WId0S+qc3IAtcVS4GCOz0fAdwoS67rTH34KDuzxRIjOSg5EyZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GmyIvIlC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GmyIvIlC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E836C4CEE5;
	Tue,  8 Apr 2025 12:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114415;
	bh=NybpiI5PPIc/LaglhznPwgEB313t9DyKfuPfOrjmMv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GmyIvIlC1rO9CRRnwLTNvOatyvcWHSyghZ7BNITgg6endzXe0HNAkkOwFOPc+aWjn
	 CI0zIpqmzdneZNixUJa0Lx3SRnvgOUPKm+zAje4TVFu3hn1fiPeiVmRSHpgwxZP8fC
	 jj2UlGUtELy5qOJaQRXmxxW/IwjNO2u3TA0sv5qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vaibhav Jain <vaibhav@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 099/499] powerpc/perf: Fix ref-counting on the PMU vpa_pmu
Date: Tue,  8 Apr 2025 12:45:11 +0200
Message-ID: <20250408104853.684486400@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vaibhav Jain <vaibhav@linux.ibm.com>

[ Upstream commit ff99d5b6a246715f2257123cdf6c4a29cb33aa78 ]

Commit 176cda0619b6 ("powerpc/perf: Add perf interface to expose vpa
counters") introduced 'vpa_pmu' to expose Book3s-HV nested APIv2 provided
L1<->L2 context switch latency counters to L1 user-space via
perf-events. However the newly introduced PMU named 'vpa_pmu' doesn't
assign ownership of the PMU to the module 'vpa_pmu'. Consequently the
module 'vpa_pmu' can be unloaded while one of the perf-events are still
active, which can lead to kernel oops and panic of the form below on a
Pseries-LPAR:

BUG: Kernel NULL pointer dereference on read at 0x00000058
<snip>
 NIP [c000000000506cb8] event_sched_out+0x40/0x258
 LR [c00000000050e8a4] __perf_remove_from_context+0x7c/0x2b0
 Call Trace:
 [c00000025fc3fc30] [c00000025f8457a8] 0xc00000025f8457a8 (unreliable)
 [c00000025fc3fc80] [fffffffffffffee0] 0xfffffffffffffee0
 [c00000025fc3fcd0] [c000000000501e70] event_function+0xa8/0x120
<snip>
 Kernel panic - not syncing: Aiee, killing interrupt handler!

Fix this by adding the module ownership to 'vpa_pmu' so that the module
'vpa_pmu' is ref-counted and prevented from being unloaded when perf-events
are initialized.

Fixes: 176cda0619b6 ("powerpc/perf: Add perf interface to expose vpa counters")
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250204153527.125491-1-vaibhav@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/vpa-pmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/perf/vpa-pmu.c b/arch/powerpc/perf/vpa-pmu.c
index 6a5bfd2a13b5a..8407334689596 100644
--- a/arch/powerpc/perf/vpa-pmu.c
+++ b/arch/powerpc/perf/vpa-pmu.c
@@ -156,6 +156,7 @@ static void vpa_pmu_del(struct perf_event *event, int flags)
 }
 
 static struct pmu vpa_pmu = {
+	.module		= THIS_MODULE,
 	.task_ctx_nr	= perf_sw_context,
 	.name		= "vpa_pmu",
 	.event_init	= vpa_pmu_event_init,
-- 
2.39.5




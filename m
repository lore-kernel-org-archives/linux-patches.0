Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F846224F6;
	Tue,  8 Apr 2025 11:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111146; cv=none; b=FSqELoVkAVJRsQuZR1ope15kJoh2ZbvQ5wWeEFyLFFI1BOSOwjXDB9gbW6vqDddJNfQDHcVPbFcjzqgmByTECOXQ7sUQrodOJh9jgVrC9sXKG3ebsrhzbq3JXUAIPZGuoyFTuj72SWafKaXI60b1zsClMxGwnZiIY5tENjjGDyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111146; c=relaxed/simple;
	bh=aMd9tdc/bNmIlUxhozcnXmYT9AaOkwGA21ghczQjht8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSrmhmznQDB+qfOO0q9+ZHKUcXmXsxabgqxzgSWjpPQpkhCco+bJQr2/zzBamReHaSsCNuyQt1p5JAOIs/OoYW1hH+VMWKljmOOMFPJiPeXT3tYNLj6JN7qxWPpXyt/0Qyd6gsUFi5N7cQcCE9NjaYTMspYr88PUiFqT0beGsKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M8z3nEMv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M8z3nEMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D1BC4CEE5;
	Tue,  8 Apr 2025 11:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111146;
	bh=aMd9tdc/bNmIlUxhozcnXmYT9AaOkwGA21ghczQjht8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M8z3nEMvDU5TzKkXT5XEIicv3amj6Vs+Qb4sv/kB3KKdA6OsVk7njxxlYihTtR8oL
	 bYoc2MX/N/MK1CCHT3nTCqe8GixeN2KXemyiCCsPkRw4CBwqaYGP7nMwpNQMY8DGUl
	 5m4eyRXYlQsizBhCDEsKK+W8nxnNAI3X3n5HOrVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vaibhav Jain <vaibhav@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 324/731] powerpc/perf: Fix ref-counting on the PMU vpa_pmu
Date: Tue,  8 Apr 2025 12:43:41 +0200
Message-ID: <20250408104921.812123882@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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




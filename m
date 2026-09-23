Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FDD3ADBB4;
	Wed, 23 Sep 2026 14:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173480; cv=none; b=IIbgO6CCIQ4G6ki3y67QweUuIDDBKhZlTz7QCnhKnaX+rQpmSUO68TxQ33rMSR5VEetDcujQjWtbmJQNezsLQ0umnfXK57ni6CUAm6b2SLXAAyMn16PYMPX/bPL8ZY5rxh4V2HiFfVEop2baR+hxhXvD72b42AjHZTK2m7o/HMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173480; c=relaxed/simple;
	bh=im1zmo64ZPUkoW8tTUN0Tluu6vBuij4BUmU5K3obb/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnwgthqatYjROjWhqcEMQPzrPjnWuzCgXI6c/4Rpp6K/lCL4/zzvoq3ZYmyQZMavTrhiOKmKA2elz2rXSz98XoqMCLHJpKncdYekgHwOmddguU3GgpZsF2iEqBZM0jXQjSVn/vIi+zvAmGfVjrLsuvnJUSuIMPRxc4fEh8kkx/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FpccDsuj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FpccDsuj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F63E1F00893;
	Wed, 23 Sep 2026 14:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173479;
	bh=9QNE4bNr62FH2r/G0nr2SjyyFQtahh+xixW8Nh8LZE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FpccDsujjcx7AVdLX+rk87CpKP23Qe64yRIo3FERNu7ugXmGSliwgwcrrn3GWyiMf
	 9Gg404D4SXPfP90dllSVI/ewNXNmLXgnzmzcMBEX0LuL/U+iiEyCQRJX8N+cfaFFO2
	 9YffaBb+S2VSNLzaejET1LCAkFW8cSCYan6SijIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 226/438] perf: Fix null pointer access in is_include_guest_event()
Date: Wed, 23 Sep 2026 16:04:07 +0200
Message-ID: <20260923140650.624951298@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinay Belgaumkar <vinay.belgaumkar@intel.com>

[ Upstream commit 88aed0422f39b22406f35f1e758cea25e7bbcfb5 ]

A typical module unload occurring event when there is an active perf
connection leads to freeing of the pmu pointer. The call log is something
like:
 ..
 __pmu_detach_event
 pmu_detach_event
 pmu_detach_events
 perf_pmu_unregister
 ..

__pmu_detach_event() sets event->pmu to null. When the perf connection
finally is closed, the following stack trace is observed:

 Oops: general protection fault, kernel NULL pointer dereference
 ...
 RIP: 0010:_free_event+0x3e/0x370
 ...
 Call Trace:
 ...
 perf_event_release_kernel+0x260/0x2d0
 perf_release+0x12/0x20

A call to mediated_pmu_unaccount_event() inside _free_event() is the root
cause of this crash. Adding a check inside is_include_guest_event() ensures
we don't accidentally access a null pmu ptr. In addition to this, we will
now call mediated_pmu_unaccount_event() before clearing the pmu ptr so that
nr_include_guest_events counts are maintained correctly.

Fixes: eff95e170275 ("perf: Add APIs to create/release mediated guest vPMUs")
Assisted-by: Claude:Claude-Sonnet-5
Signed-off-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://patch.msgid.link/20260904181625.1394082-1-vinay.belgaumkar@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index bd8c1acf59e2e..60e60809bedc7 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6350,6 +6350,9 @@ static DEFINE_MUTEX(perf_mediated_pmu_mutex);
 /* !exclude_guest event of PMU with PERF_PMU_CAP_MEDIATED_VPMU */
 static inline bool is_include_guest_event(struct perf_event *event)
 {
+	if (!event->pmu)
+		return false;
+
 	if ((event->pmu->capabilities & PERF_PMU_CAP_MEDIATED_VPMU) &&
 	    !event->attr.exclude_guest)
 		return true;
@@ -12977,6 +12980,7 @@ static void __pmu_detach_event(struct pmu *pmu, struct perf_event *event,
 	exclusive_event_destroy(event);
 	module_put(pmu->module);
 
+	mediated_pmu_unaccount_event(event);
 	event->pmu = NULL; /* force fault instead of UAF */
 }
 
-- 
2.53.0




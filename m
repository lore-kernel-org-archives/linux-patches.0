Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77CC537FD;
	Mon,  8 Jan 2024 15:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jMsrLN2X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E135C433C9;
	Mon,  8 Jan 2024 15:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728563;
	bh=H/R/nhiya/oFUBkyRvt/rXR8LicDkrGN0ai8oDSTnE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jMsrLN2X0CTGev0CpXebBcmEWYB+g9AW216/0Q++s7zIvng/98cHtbt0BMvYKvF0V
	 khz9k/XCrO8pQL89g6tnUz9fHeV+zusy6hoFFl2lSRcOs/l84jhvEIVkLc7oB4R7Ua
	 LkOngYlGlDtAnw95Mt55lcqpTiniW1RE3bmnaFYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/150] s390/cpumf: support user space events for counting
Date: Mon,  8 Jan 2024 16:35:40 +0100
Message-ID: <20240108153515.337386634@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 91d5364dc673fa9cf3a5b7b30cf33c70803eb3a4 ]

CPU Measurement counting facility events PROBLEM_STATE_CPU_CYCLES(32)
and PROBLEM_STATE_INSTRUCTIONS(33) are valid events. However the device
driver returns error -EOPNOTSUPP when these event are to be installed.

Fix this and allow installation of events PROBLEM_STATE_CPU_CYCLES,
PROBLEM_STATE_CPU_CYCLES:u, PROBLEM_STATE_INSTRUCTIONS and
PROBLEM_STATE_INSTRUCTIONS:u.
Kernel space counting only is still not supported by s390.

Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Acked-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 09cda0a40051 ("s390/mm: add missing arch_set_page_dat() call to vmem_crst_alloc()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_cpum_cf.c | 35 ++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/arch/s390/kernel/perf_cpum_cf.c b/arch/s390/kernel/perf_cpum_cf.c
index f043a7ff220b7..28fa80fd69fa0 100644
--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -2,7 +2,7 @@
 /*
  * Performance event support for s390x - CPU-measurement Counter Facility
  *
- *  Copyright IBM Corp. 2012, 2021
+ *  Copyright IBM Corp. 2012, 2022
  *  Author(s): Hendrik Brueckner <brueckner@linux.ibm.com>
  *	       Thomas Richter <tmricht@linux.ibm.com>
  */
@@ -434,6 +434,12 @@ static void cpumf_hw_inuse(void)
 	mutex_unlock(&pmc_reserve_mutex);
 }
 
+static int is_userspace_event(u64 ev)
+{
+	return cpumf_generic_events_user[PERF_COUNT_HW_CPU_CYCLES] == ev ||
+	       cpumf_generic_events_user[PERF_COUNT_HW_INSTRUCTIONS] == ev;
+}
+
 static int __hw_perf_event_init(struct perf_event *event, unsigned int type)
 {
 	struct perf_event_attr *attr = &event->attr;
@@ -456,19 +462,26 @@ static int __hw_perf_event_init(struct perf_event *event, unsigned int type)
 		if (is_sampling_event(event))	/* No sampling support */
 			return -ENOENT;
 		ev = attr->config;
-		/* Count user space (problem-state) only */
 		if (!attr->exclude_user && attr->exclude_kernel) {
-			if (ev >= ARRAY_SIZE(cpumf_generic_events_user))
-				return -EOPNOTSUPP;
-			ev = cpumf_generic_events_user[ev];
-
-		/* No support for kernel space counters only */
+			/*
+			 * Count user space (problem-state) only
+			 * Handle events 32 and 33 as 0:u and 1:u
+			 */
+			if (!is_userspace_event(ev)) {
+				if (ev >= ARRAY_SIZE(cpumf_generic_events_user))
+					return -EOPNOTSUPP;
+				ev = cpumf_generic_events_user[ev];
+			}
 		} else if (!attr->exclude_kernel && attr->exclude_user) {
+			/* No support for kernel space counters only */
 			return -EOPNOTSUPP;
-		} else {	/* Count user and kernel space */
-			if (ev >= ARRAY_SIZE(cpumf_generic_events_basic))
-				return -EOPNOTSUPP;
-			ev = cpumf_generic_events_basic[ev];
+		} else {
+			/* Count user and kernel space, incl. events 32 + 33 */
+			if (!is_userspace_event(ev)) {
+				if (ev >= ARRAY_SIZE(cpumf_generic_events_basic))
+					return -EOPNOTSUPP;
+				ev = cpumf_generic_events_basic[ev];
+			}
 		}
 		break;
 
-- 
2.43.0




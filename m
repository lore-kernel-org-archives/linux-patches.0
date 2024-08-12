Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F721183CA6;
	Mon, 12 Aug 2024 16:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479814; cv=none; b=UX86hHm6wzMUbsa4iTana381+vHZBjLrnSUWuNrq+TXFIsz8C/Zoh59vzWnDqTaEDZ0LSaMdtGMeO6R+SSp7Ouc+NGySUpDIWMfGxaGea/8rYjMs4khc7/r4g8005tdf6SO1u7ECYBlif696lYKoFhzMb18alXpEuao7GGv3PDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479814; c=relaxed/simple;
	bh=+07iESalb7ST/nyektPEBcCOqDFBGcpxqVFro1kauNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=COUITqnstF+nEV6Uiv+4T8Eg5aQMyuiKlzx1WNHYSeb/0dvt9K7B3jLhmlZnh1LWfsjY1afbyjcpU39hrLmH9AdaS16UwLX4MA/nONh1ssXWiDPCQQJIq11Z/w+CCS8Rdzp27/HBrGRXQPjepT4n4X/gDz5wWDz5iN2LAzENWpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qF7767j3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qF7767j3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AF8C32782;
	Mon, 12 Aug 2024 16:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479814;
	bh=+07iESalb7ST/nyektPEBcCOqDFBGcpxqVFro1kauNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qF7767j3ZtVSxvF82sqMlL/LkFki/6zgQeBp17EUo/erglf16aKFwNIbeIOa7VDcp
	 CtM3/V5JUekZEhgZrIEAjOt2OryNKg+7dSuN1yNA2QDOiC0KLYcQ1eHNDcOTO15BOs
	 7E7hDtWp40E+cksCg/eKH2ioWOIPBGFoL9ZPRUdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 010/263] perf/x86/amd: Use try_cmpxchg() in events/amd/{un,}core.c
Date: Mon, 12 Aug 2024 18:00:11 +0200
Message-ID: <20240812160146.922614486@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uros Bizjak <ubizjak@gmail.com>

[ Upstream commit cd84351c8c1baec86342d784feb884ace007d51c ]

Replace this pattern in events/amd/{un,}core.c:

    cmpxchg(*ptr, old, new) == old

... with the simpler and faster:

    try_cmpxchg(*ptr, &old, new)

The x86 CMPXCHG instruction returns success in the ZF flag, so this change
saves a compare after the CMPXCHG.

No functional change intended.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20240425101708.5025-1-ubizjak@gmail.com
Stable-dep-of: f73cefa3b72e ("perf/x86: Fix smp_processor_id()-in-preemptible warnings")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/core.c   | 4 +++-
 arch/x86/events/amd/uncore.c | 8 ++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index 1fc4ce44e743c..18bfe3451f3aa 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -433,7 +433,9 @@ static void __amd_put_nb_event_constraints(struct cpu_hw_events *cpuc,
 	 * when we come here
 	 */
 	for (i = 0; i < x86_pmu.num_counters; i++) {
-		if (cmpxchg(nb->owners + i, event, NULL) == event)
+		struct perf_event *tmp = event;
+
+		if (try_cmpxchg(nb->owners + i, &tmp, NULL))
 			break;
 	}
 }
diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index 5a4bfe9aea237..0bfde2ea5cb8c 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -162,7 +162,9 @@ static int amd_uncore_add(struct perf_event *event, int flags)
 	/* if not, take the first available counter */
 	hwc->idx = -1;
 	for (i = 0; i < pmu->num_counters; i++) {
-		if (cmpxchg(&ctx->events[i], NULL, event) == NULL) {
+		struct perf_event *tmp = NULL;
+
+		if (try_cmpxchg(&ctx->events[i], &tmp, event)) {
 			hwc->idx = i;
 			break;
 		}
@@ -196,7 +198,9 @@ static void amd_uncore_del(struct perf_event *event, int flags)
 	event->pmu->stop(event, PERF_EF_UPDATE);
 
 	for (i = 0; i < pmu->num_counters; i++) {
-		if (cmpxchg(&ctx->events[i], event, NULL) == event)
+		struct perf_event *tmp = event;
+
+		if (try_cmpxchg(&ctx->events[i], &tmp, NULL))
 			break;
 	}
 
-- 
2.43.0




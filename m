Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E75768EA;
	Mon,  8 Apr 2024 13:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583384; cv=none; b=a5fwhE8dvUwmnNo9etcg1PSkopOHVph7VWtiKJ3c+3IYf69WeU2uKiDF7WzK/oLNhevJT++u+yroBQi8QpC+7T94nQ581R9zjIsgV6e5BElo/to251gc2n8b2qqwKp7Qs3qZzOmbm2Zsap/RAqK2TEpT/JzX67WgOt+88YbY4AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583384; c=relaxed/simple;
	bh=wRtUrOFBDDKViwfFonpCvvj5kNjqk0rv+Vcu9fLfi6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eR4MfXulF9cDMBMOj6WZ5E/WKJsyLOtW66GO3DVBmoxXh8q8fyDA8O5HfxkJqPfILs1ZzjWZtcj2JiAMfaBYccyIa2XykscufOBiQU+3MuiFR6mabfHNadlCOPLnTZFrThHL5K+CqGL4H1EW89bqjKcDHifPB9FnH+6TI+QBRX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z0z4/xRX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z0z4/xRX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35E7C433F1;
	Mon,  8 Apr 2024 13:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583384;
	bh=wRtUrOFBDDKViwfFonpCvvj5kNjqk0rv+Vcu9fLfi6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z0z4/xRXm1ey3U9PIJYWu812FW3rN0vJCg505m7xzCDUPk2ORmguRaRU67oAj6U9E
	 5fMeg+sA3ftnJ4K2L9tdM/fOcRGVAh7jREKXgOJeoEZlN8FjzXaYTgjA53YAn5cdwK
	 vLBJY3NQa/vsxP0Ti6CrTQoFILP9qCBtvUJ6r7Cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 190/252] s390/pai: initialize event count once at initialization
Date: Mon,  8 Apr 2024 14:58:09 +0200
Message-ID: <20240408125312.556571613@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit b286997e83dcf7b498329a66a8a22fc8a5bf50f0 ]

Event count value is initialized and set to zero in function
paicrypt_start().  This function is called once per CPU when an
event is started on that CPU. This leads to event count value
being set to zero as many times as there are online CPUs.
This is not necessary. The event count value is bound to the event
and it is sufficient to initialize the event counter once at
event creation time. This is done when the event structure
is dynamicly allocated with __GFP_ZERO flag. This sets
member count to zero.

Acked-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Stable-dep-of: e9f3af02f639 ("s390/pai: fix sampling event removal for PMU device driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_pai_crypto.c | 1 -
 arch/s390/kernel/perf_pai_ext.c    | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/s390/kernel/perf_pai_crypto.c b/arch/s390/kernel/perf_pai_crypto.c
index 4a4e914c283c8..0921cea849125 100644
--- a/arch/s390/kernel/perf_pai_crypto.c
+++ b/arch/s390/kernel/perf_pai_crypto.c
@@ -253,7 +253,6 @@ static void paicrypt_start(struct perf_event *event, int flags)
 	if (!event->hw.last_tag) {
 		event->hw.last_tag = 1;
 		sum = paicrypt_getall(event);		/* Get current value */
-		local64_set(&event->count, 0);
 		local64_set(&event->hw.prev_count, sum);
 	}
 }
diff --git a/arch/s390/kernel/perf_pai_ext.c b/arch/s390/kernel/perf_pai_ext.c
index b5febe22d0546..ac32107167eac 100644
--- a/arch/s390/kernel/perf_pai_ext.c
+++ b/arch/s390/kernel/perf_pai_ext.c
@@ -327,7 +327,6 @@ static void paiext_start(struct perf_event *event, int flags)
 	event->hw.last_tag = 1;
 	sum = paiext_getall(event);		/* Get current value */
 	local64_set(&event->hw.prev_count, sum);
-	local64_set(&event->count, 0);
 }
 
 static int paiext_add(struct perf_event *event, int flags)
-- 
2.43.0




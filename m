Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BC86FC5;
	Tue, 12 May 2026 18:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609522; cv=none; b=P9HL79PSPYxe9fmtoBZ/1HEn7CrZm+asDIAcy3aqc0v/+sse11gApu3vsV6SIZaIe5aC/Nwwk/C4Ivqsc55ScRribsCWXyqEeQ7HDGofpTQhZvE/CqiBx28cc41YKyAP8uKnU8uzv0gciacuVJbWT6sB3Ekro3MVT0s/W7PHkrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609522; c=relaxed/simple;
	bh=nPQRQrNq7itYRi5+1WzGoDrAbTYWHvDhTd31FYYJ1Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbHD2xa7Jg2NOeIV/+aidjlZt5ejdR2WTjpLGPTiAP7jkycKxhe1UE0igcACN7FO/SNdjKCaQ/dvm5OiLh93udOJEAqmgGlaeN/bJ0XUcYcOm4rT4Khy9D+vJmz5oTxLB2W2YHjOO2M4HHZcVNxGw2SR7uCPysxhka2yZr6q8gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yetDqgUX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yetDqgUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF3BC2BCC7;
	Tue, 12 May 2026 18:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609522;
	bh=nPQRQrNq7itYRi5+1WzGoDrAbTYWHvDhTd31FYYJ1Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yetDqgUXhtW9lTwF5kmh0+N2K7QJYK9dy5LzH2WqR9VYG10w/YL451XPWjP87CPy1
	 t+JFbW4MGU0iTk0ej/P7EGB/iv5Wj426tzb/jaPEAJYbrw451/d8WRC8Bk0PPpWrKe
	 6FcTZK1LsWrbJLkmmryiq0W8ACARZqX/25uiwS6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 7.0 228/307] perf/x86/intel: Always reprogram ACR events to prevent stale masks
Date: Tue, 12 May 2026 19:40:23 +0200
Message-ID: <20260512173944.930704019@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

commit 8ba0b706a485b1e607594cf4210786d517ad1611 upstream.

Members of an ACR group are logically linked via a bitmask of their
hardware counter indices. If some members of the group are assigned new
hardware counters during rescheduling, even events that keep their
original counter index must be updated with a new mask.

Without this, an event will continue to use a stale acr_mask that
references the old indices of its group peers. Ensure all ACR events are
reprogrammed during the scheduling path to maintain consistency across
the group.

Fixes: ec980e4facef ("perf/x86/intel: Support auto counter reload")
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260430002558.712334-3-dapeng1.mi@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/core.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -1294,13 +1294,16 @@ int x86_perf_rdpmc_index(struct perf_eve
 	return event->hw.event_base_rdpmc;
 }
 
-static inline int match_prev_assignment(struct hw_perf_event *hwc,
+static inline int match_prev_assignment(struct perf_event *event,
 					struct cpu_hw_events *cpuc,
 					int i)
 {
+	struct hw_perf_event *hwc = &event->hw;
+
 	return hwc->idx == cpuc->assign[i] &&
-		hwc->last_cpu == smp_processor_id() &&
-		hwc->last_tag == cpuc->tags[i];
+	       hwc->last_cpu == smp_processor_id() &&
+	       hwc->last_tag == cpuc->tags[i] &&
+	       !is_acr_event_group(event);
 }
 
 static void x86_pmu_start(struct perf_event *event, int flags);
@@ -1346,7 +1349,7 @@ static void x86_pmu_enable(struct pmu *p
 			 * - no other event has used the counter since
 			 */
 			if (hwc->idx == -1 ||
-			    match_prev_assignment(hwc, cpuc, i))
+			    match_prev_assignment(event, cpuc, i))
 				continue;
 
 			/*
@@ -1367,7 +1370,7 @@ static void x86_pmu_enable(struct pmu *p
 			event = cpuc->event_list[i];
 			hwc = &event->hw;
 
-			if (!match_prev_assignment(hwc, cpuc, i))
+			if (!match_prev_assignment(event, cpuc, i))
 				x86_assign_hw_event(event, cpuc, i);
 			else if (i < n_running)
 				continue;



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC289470E84;
	Sat, 12 Sep 2026 10:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210210; cv=none; b=c6CMfDZSSn3mWilnZiQ5xlEtF8ZlaSvUm24bUYoASP5igJs/ucLjllhA1l7tr5IdyHZnOyKrWLqOCN966cmKy7KJ6zN/PQ3PyZ5U/Zsiz9gUAPf6OB0W7J5FrEUCTMzS8510JeefUDzOiOI85iSTuoq/ScWzIhIY632brJWggQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210210; c=relaxed/simple;
	bh=6VWbarVBt0bb8cMWeNcIU5MyUoLLC9qVy9LUE6O7MQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDcyXXWz7egZB6nUDEQL6wi5bFaMzApUc0rCn2YzNxRo5nZgzkc05rD8W1B15OaaN/l7WYKKTaH0OHjK5/ID7XY/mplENYVxjwDhEC1iXhE8/SgQoge0o8zYqbVUIweI6ogA6CfWef+fcR+iWXAHzbdMeFaD8dN6Ze5jYUj0ALM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=waurcUzc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="waurcUzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FCE1F000FF;
	Sat, 12 Sep 2026 10:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210207;
	bh=AnY/8BssCRlecqulIANlIjjgEnLlh+1b/axDJyEW4YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=waurcUzcysoD72ffZZOmPNe4IXHO5UVLU+gCNVio7kBOdqTFGe66iUMhbEz0mB8oZ
	 EX99SfRegxIjihaGL6/qGtfuebLhQBFK4po4694CbOX94PxV0iM2wK/QHAVKmteblr
	 Aj3TmdRBoa/7fbDCnDdHGCvpI4jtmeQ0dkdiIEn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Yi Lai <yi1.lai@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0980/1518] perf/x86/intel/pt: Factor out pt_config_enable()
Date: Sat, 12 Sep 2026 08:52:29 +0200
Message-ID: <20260912065645.628246774@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit c6df517796189723ffbdd7679206c97d3642c2ef ]

pt_config() enables tracing by allowing NMIs and pause/resume, issuing
the necessary barriers, and calling pt_config_start().  A later change
needs to re-enable tracing on a (re-)start path without repeating the
full pt_config() setup (filters, RTIT_CTL, buffer configuration).

Factor that enabling sequence out into a new helper, pt_config_enable(),
so it can be called on its own.

No functional change intended.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Yi Lai <yi1.lai@intel.com>
Link: https://patch.msgid.link/20260721070254.13557-2-adrian.hunter@intel.com
Stable-dep-of: 2e17bf3a469a ("perf/x86/intel/pt: Fix stop/start with no update")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/pt.c | 41 ++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index e8cf29d2b10c9..82725b11007a6 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -501,6 +501,29 @@ static u64 pt_config_filters(struct perf_event *event)
 	return rtit_ctl;
 }
 
+static void pt_config_enable(struct perf_event *event)
+{
+	struct pt *pt = this_cpu_ptr(&pt_ctx);
+
+	/*
+	 * Allow resume before starting so as not to overwrite a value set by a
+	 * PMI.
+	 */
+	barrier();
+	WRITE_ONCE(pt->resume_allowed, 1);
+	/* Configuration is complete, it is now OK to handle an NMI */
+	barrier();
+	WRITE_ONCE(pt->handle_nmi, 1);
+	barrier();
+	pt_config_start(event);
+	barrier();
+	/*
+	 * Allow pause after starting so its pt_config_stop() doesn't race with
+	 * pt_config_start().
+	 */
+	WRITE_ONCE(pt->pause_allowed, 1);
+}
+
 static void pt_config(struct perf_event *event)
 {
 	struct pt *pt = this_cpu_ptr(&pt_ctx);
@@ -540,23 +563,7 @@ static void pt_config(struct perf_event *event)
 
 	event->hw.aux_config = reg;
 
-	/*
-	 * Allow resume before starting so as not to overwrite a value set by a
-	 * PMI.
-	 */
-	barrier();
-	WRITE_ONCE(pt->resume_allowed, 1);
-	/* Configuration is complete, it is now OK to handle an NMI */
-	barrier();
-	WRITE_ONCE(pt->handle_nmi, 1);
-	barrier();
-	pt_config_start(event);
-	barrier();
-	/*
-	 * Allow pause after starting so its pt_config_stop() doesn't race with
-	 * pt_config_start().
-	 */
-	WRITE_ONCE(pt->pause_allowed, 1);
+	pt_config_enable(event);
 }
 
 static void pt_config_stop(struct perf_event *event)
-- 
2.53.0




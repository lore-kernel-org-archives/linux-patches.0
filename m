Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B39E41A503;
	Sat, 12 Sep 2026 08:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202473; cv=none; b=Pe0aoucV49Bpw535lBDy4NmxEG8ViB2SPculSs6F8BJyrVWZdOL/B+1kwcAcW2mZdfpNX/yjEg0EVnNu5KTyTEDML1RuCb77/+YDmsFeGqJO97QjYiYNeu5OOXHNCbOMQOByGZ4anPtotkClwHJ0x1rEDTvThcoVw8kIDW8OgxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202473; c=relaxed/simple;
	bh=BCKUDHNPZixZUGn60pSh0Baz/6fjpKm0A1ykGANY7N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nT2QE5+5cVetfAxgbpwZ8QpmeAZdqarHTwE7KmRuuu9KNEuWkQJIMN7MikzklN7LaAXbRImhFfaI5WSFQd5gjGC3XnyLE2FZIIhSKBLL6Mnrgx2ebLOi8j/qLV/0ejEmVxM9IrWxijl4bA1C/Q00fwDwhyzBgZuwG43gJj3v1sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0TYozvwL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0TYozvwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EFD1F000FF;
	Sat, 12 Sep 2026 08:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202471;
	bh=keUPxjKIQc2htOMtrtueVdd5ZCDA7hfoGJfyxCmkfzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0TYozvwLSLDDTp/5JMqPxaHCrxN+N6RJ0JXBAapvh3WgsOUEhIdO76yLc0cya9qVv
	 Ds7HJTNMxJsvezQ7UDUi5waSTs5ugv6ofrTc5C5O/KHrIzATun9syC4GMyxlr72EZP
	 NIonmqpchqoaDxElItNgcmRdEobwCKh+D/4SS224=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Yi Lai <yi1.lai@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1210/1815] perf/x86/intel/pt: Factor out pt_config_enable()
Date: Sat, 12 Sep 2026 08:49:20 +0200
Message-ID: <20260912065717.411364491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index b5726b50e77db..dc1be7f6e04b1 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -502,6 +502,29 @@ static u64 pt_config_filters(struct perf_event *event)
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
@@ -541,23 +564,7 @@ static void pt_config(struct perf_event *event)
 
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




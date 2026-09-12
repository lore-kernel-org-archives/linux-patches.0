Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEB5315D49;
	Sat, 12 Sep 2026 12:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217606; cv=none; b=YdH39vEd156NoAkpOomIJF0BYKE6WMR7adKi2dcC57TISz9qa2NQdUX5P12prOthXqJjoJPc2vcpvzNhlaLe+w9b/efiBwcLmJLCKXKUx54+l8+fdSTyaNsV9mTQD8yaCKSXEwu8BhX/WgOvPBFzfz3dLzq0nlkoBpY6LlmCdUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217606; c=relaxed/simple;
	bh=JmyxEzW8MwR/y6qkexuXkH5C90Ye0dQI3FHoLdkg8Fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ph578baeDbGUrysTOmzKEINJkoV1JitwPM6KuWECM/rOjZAy424+ySFmH6nh4mcyFbxlBLQfEItdfSD93JqiTyBkgNarSiwQZV/N4CB5+QsELMAzxsozY0MkBOpCa31c0Re8kIrvWvRU/HeQfcxzM4/ib45xb1wN5wfH4NRorJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkCPYZ7l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkCPYZ7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203161F000FF;
	Sat, 12 Sep 2026 12:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217603;
	bh=BoypZLCsOOMsdmvp8RChdHnYmU3unZe6aZzkzz9qFKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dkCPYZ7ltq/tiE/t2uHVBYagDcerKuX3YDctHgfM/jLTkw2Swgiw1lwgcQuyQdFZU
	 E7QkFa3XCjBUgidnGYLuYUyqs+XM/rxA/7BuO8apnonL0VMlyq1pe5CvAK0ByU/XsU
	 TPt1C94eKXAoK5dRfqVAO63CKD+oKza1H+pHC/sU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Yi Lai <yi1.lai@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0965/1376] perf/x86/intel/pt: Factor out pt_config_enable()
Date: Sat, 12 Sep 2026 08:56:31 +0200
Message-ID: <20260912065629.068053830@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4b0373bc8ab44..94714c20cefbe 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -499,6 +499,29 @@ static u64 pt_config_filters(struct perf_event *event)
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
@@ -538,23 +561,7 @@ static void pt_config(struct perf_event *event)
 
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




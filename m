Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C442C37AA65;
	Sat, 12 Sep 2026 08:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202478; cv=none; b=dq9mAYKnbiVcJlfLwuGci2Uv2u4YM19Nq6S9wv3TFcVCGG7xGCD+dxiiJ3Kvt92pMu9cyusJbOqGOUzIvM0Nb8ws/NvccqtA2CVHivFeyePqRkd7P8SV61P7OGc/m1nkGb4ltB+2utlCVF4PiCm2sIj/u5Yzz8eUqD61WlKE7ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202478; c=relaxed/simple;
	bh=4qB9Q4sFPcu9iOiOiX8eGWKCs+DqNTYudHTSIGcgAS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sG9/miVhzXzqrw9GDEQTsG6ZSBSHs12eIUGhjZElyDjqcm2vYBLQqqcaRNENbG7R7esIb772j62NV4rMIVibejP6hgr3hpJSq8ysShF9aKlYX68+HkTnroppTaWFR1HU4h8BT8j693r3XMPqp7X4YOC2/+2MWc1+TSZk+MuTLk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=udOLEjGC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="udOLEjGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D7D1F00893;
	Sat, 12 Sep 2026 08:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202476;
	bh=3UxQUitifHJRxOMkNZJqBLr40dLoA8gxJA9+4maI6Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=udOLEjGC9P5nRPEGtdfATN8QnQ4ejaTiLVAjl+5oCJFxdVgLIC6h8BKUggv1XWekK
	 CegelHaq4eM3HgkN6VlveorE9FMRxAvhKGI0yJ5WaiRu2N9VxN4pqSqo3ByiGjthXg
	 qDBoVMt56ZSr9jkb8Sg+JaBeLo7XjsfsAE63OgcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Yi Lai <yi1.lai@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1211/1815] perf/x86/intel/pt: Use bitwise access for PERF_HES_STOPPED
Date: Sat, 12 Sep 2026 08:49:21 +0200
Message-ID: <20260912065717.434647609@linuxfoundation.org>
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

[ Upstream commit 265bb4ef75fa657f4957d72087a6a246b89d5f0d ]

The Intel PT driver reads and writes event->hw.state as a whole value,
assuming it is either 0 or PERF_HES_STOPPED.  That is true today, but a
subsequent fix needs to also track an open AUX output buffer using the
PERF_HES_UPTODATE bit of the same field.

When more than one bit can be set, whole-value assignments would
overwrite the other bits and whole-value comparisons would fail to match.

Convert all accesses to set, clear and test the PERF_HES_STOPPED bit
individually, in preparation for that change.

No functional change intended: event->hw.state currently only ever
holds 0 or PERF_HES_STOPPED, so the bitwise forms are equivalent.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Yi Lai <yi1.lai@intel.com>
Link: https://patch.msgid.link/20260721070254.13557-3-adrian.hunter@intel.com
Stable-dep-of: 2e17bf3a469a ("perf/x86/intel/pt: Fix stop/start with no update")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/pt.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index dc1be7f6e04b1..2163e5ccdc043 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -1540,12 +1540,12 @@ void intel_pt_interrupt(void)
 
 	perf_aux_output_end(&pt->handle, local_xchg(&buf->data_size, 0));
 
-	if (!event->hw.state) {
+	if (!(event->hw.state & PERF_HES_STOPPED)) {
 		int ret;
 
 		buf = perf_aux_output_begin(&pt->handle, event);
 		if (!buf) {
-			event->hw.state = PERF_HES_STOPPED;
+			event->hw.state |= PERF_HES_STOPPED;
 			WRITE_ONCE(pt->resume_allowed, 0);
 			return;
 		}
@@ -1639,7 +1639,7 @@ static void pt_event_start(struct perf_event *event, int mode)
 			goto fail_end_stop;
 	}
 
-	hwc->state = 0;
+	hwc->state &= ~PERF_HES_STOPPED;
 
 	pt_config_buffer(buf);
 	pt_config(event);
@@ -1649,7 +1649,7 @@ static void pt_event_start(struct perf_event *event, int mode)
 fail_end_stop:
 	perf_aux_output_end(&pt->handle, 0);
 fail_stop:
-	hwc->state = PERF_HES_STOPPED;
+	hwc->state |= PERF_HES_STOPPED;
 }
 
 static void pt_event_stop(struct perf_event *event, int mode)
@@ -1680,10 +1680,10 @@ static void pt_event_stop(struct perf_event *event, int mode)
 
 	pt_config_stop(event);
 
-	if (event->hw.state == PERF_HES_STOPPED)
+	if (event->hw.state & PERF_HES_STOPPED)
 		return;
 
-	event->hw.state = PERF_HES_STOPPED;
+	event->hw.state |= PERF_HES_STOPPED;
 
 	if (mode & PERF_EF_UPDATE) {
 		struct pt_buffer *buf = perf_get_aux(&pt->handle);
@@ -1778,10 +1778,10 @@ static int pt_event_add(struct perf_event *event, int mode)
 	if (mode & PERF_EF_START) {
 		pt_event_start(event, 0);
 		ret = -EINVAL;
-		if (hwc->state == PERF_HES_STOPPED)
+		if (hwc->state & PERF_HES_STOPPED)
 			goto fail;
 	} else {
-		hwc->state = PERF_HES_STOPPED;
+		hwc->state |= PERF_HES_STOPPED;
 	}
 
 	ret = 0;
-- 
2.53.0




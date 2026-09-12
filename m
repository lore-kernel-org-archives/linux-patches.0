Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC4629B78F;
	Sat, 12 Sep 2026 12:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217609; cv=none; b=CEwedzeJ4Nylin/ZJPLflBvPW03z2tAgTGYP7FGy2Xb3cqqaolTgcCLX9PGAYgEDZcfsDvXzQo3jufUeJONPTLPqRm+54akgqklvTSJL78ZbuscpNw1tpxyrrF3gt7yyzjs2tF9rd9c0qiB7FNFFr5ZminR4R6hVRbtgrpwzUBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217609; c=relaxed/simple;
	bh=cBWmgkNVdaCwyM4b0FgyndtHxPnjc7Qk3wYKdgOZ4U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VrMdCTzL3Q+jn8IAc4OORkfpMaOTdq9ubLpbMQ6WByAqW6FHaIBK1f+Vc35VVPHPHZIEJ++6NyDFggQssDYSUQH8OiUob/OobQe4gTVW+LTihn6Q2a7UHTa0A2aV6ZXLqEuMAav9HFKkuRHLTIEDrc3xa9QV/yJIGpt61QRDb0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8vQ1VEh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8vQ1VEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250B11F000FF;
	Sat, 12 Sep 2026 12:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217608;
	bh=FoIn9egQ62Y6ijL/99wyUCpb5/3IzuNdOrIWn3ODzY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d8vQ1VEhpEPAWUbmGvauO0dhYlIHvhXoLMKIOBda3KmiE2osW73IP24GDJlq7GTtU
	 97VagULIiA85n+C7gx7h4PseC2k/+8ioW1kLGyBua4D6LniJxyNUjBgDkn+I1jIRnJ
	 gn6GrzXMNRb2FZnJDg9zfsR0IwpaOrPrw4HtHPts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Yi Lai <yi1.lai@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0966/1376] perf/x86/intel/pt: Use bitwise access for PERF_HES_STOPPED
Date: Sat, 12 Sep 2026 08:56:32 +0200
Message-ID: <20260912065629.091473362@linuxfoundation.org>
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
index 94714c20cefbe..d060a705ea30f 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -1537,12 +1537,12 @@ void intel_pt_interrupt(void)
 
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
@@ -1637,7 +1637,7 @@ static void pt_event_start(struct perf_event *event, int mode)
 			goto fail_end_stop;
 	}
 
-	hwc->state = 0;
+	hwc->state &= ~PERF_HES_STOPPED;
 
 	pt_config_buffer(buf);
 	pt_config(event);
@@ -1647,7 +1647,7 @@ static void pt_event_start(struct perf_event *event, int mode)
 fail_end_stop:
 	perf_aux_output_end(&pt->handle, 0);
 fail_stop:
-	hwc->state = PERF_HES_STOPPED;
+	hwc->state |= PERF_HES_STOPPED;
 }
 
 static void pt_event_stop(struct perf_event *event, int mode)
@@ -1678,10 +1678,10 @@ static void pt_event_stop(struct perf_event *event, int mode)
 
 	pt_config_stop(event);
 
-	if (event->hw.state == PERF_HES_STOPPED)
+	if (event->hw.state & PERF_HES_STOPPED)
 		return;
 
-	event->hw.state = PERF_HES_STOPPED;
+	event->hw.state |= PERF_HES_STOPPED;
 
 	if (mode & PERF_EF_UPDATE) {
 		struct pt_buffer *buf = perf_get_aux(&pt->handle);
@@ -1776,10 +1776,10 @@ static int pt_event_add(struct perf_event *event, int mode)
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB76C46E002;
	Sat, 12 Sep 2026 10:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210214; cv=none; b=cY7NvaGQzDsXJnQpdwGVi6sMhV8JpFcMCHnt1uwo3ACelDiO5xdf1b7fUDrak3M2hoObNbMEu1/WmqvBbZQQHKt44jGQmx4CLUiTLgzmPEE8iaM4gZxL0w5qH3plEaIRMSBvD7M5EjT53aNkH9CgdHGFWLydGtWRxVuoebEyn4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210214; c=relaxed/simple;
	bh=6xRhXDPBC1xiECt+mR3zA8QpN1rDmf4B3SoGlf94nZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WYDzrHstmx7unl7QHzLD/o4mIXrOvAzioehTtsFDmGk+lGeCjjiQtUK0T63UR1295zcAYS8lUfRbc5a3Jjgel+H37dhO3a+cxnPrywJGZvHJ3+JqehgpSHHQanH80w6Nv3GmG1oZiTQoYGHL5sOVeALobZUuk8ly8rHZR810kZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ba2np/Nu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ba2np/Nu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282EC1F000FF;
	Sat, 12 Sep 2026 10:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210212;
	bh=V6i8/iCmIM7AxvH45eaksOpFBZ13XXlP+yKRyHdiPaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ba2np/NufpQFPUy0Lxj+BZrODyf5JrMZhs0G5L0x+rWFr7OP+ViSgDB7Cewp+BqUC
	 KVksxaNRTtgMVEWpwySItU/2OsaXAW+lhnrOWDLbczuliTQXwEu78U+TTwocVZHB2X
	 wqUZbS1xR4VQtmr4rhTtargbXKslWLbG9Be1hA/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Yi Lai <yi1.lai@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0981/1518] perf/x86/intel/pt: Use bitwise access for PERF_HES_STOPPED
Date: Sat, 12 Sep 2026 08:52:30 +0200
Message-ID: <20260912065645.650739064@linuxfoundation.org>
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
index 82725b11007a6..70bee69c598bc 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -1539,12 +1539,12 @@ void intel_pt_interrupt(void)
 
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




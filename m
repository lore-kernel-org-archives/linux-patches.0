Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35154281357;
	Mon, 13 Apr 2026 16:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096300; cv=none; b=YRZ6ckKJRNkA2C6gwEtGo+FKXawUkJ/0GMTF6UreJqJIjVP9KA8PxtDAEFuZmg9pgB8CB6MN77QTjUiHVLVAB4QwyQBH9LAcoRzSFIomvy5PtSykwMb850m1xgAVNUpKw4m1J/DPL3WTsOgpTG0Af39+7Bxzfw6WoNtHsKkMBEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096300; c=relaxed/simple;
	bh=1wKOuSgGRbA2xZ4fs9t/W8B2E+EbO/tc1qlmEYBKaFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WlAiUMq6YZlWLYhCeMRMMn4cTBJATot2PzUduW6UsJLBwbJgiYODmXqlb6JQ6IVsDR1tChqUn96clyCpCP6Xzy4P6KkmQdlSaq0eq8ylmg1kj7ub7KgSBXVOkxTxf5R1CZLhaetspD+yBUVAkOy1RgjFDJQvTJDYr/yy3kG370k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dIr3i4w3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dIr3i4w3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD603C2BCB0;
	Mon, 13 Apr 2026 16:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096300;
	bh=1wKOuSgGRbA2xZ4fs9t/W8B2E+EbO/tc1qlmEYBKaFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dIr3i4w3jzeoUA24DINerYKYCSHqBXOrjZgCK87tdJPgnt/punyFdy1aBWn7NT5Ne
	 yS/docBlTCXg9lXKZ4uEWM58cvNB6Viug4Mcv2peStz0dMSMXPMgd/apLKXBdrXqk8
	 2OvUf8rV3a/HnOt7nFu1TruoI6Sh0tJiXeJTGKvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Brzezinka <sebastian.brzezinka@intel.com>,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.19 45/86] drm/i915/gt: fix refcount underflow in intel_engine_park_heartbeat
Date: Mon, 13 Apr 2026 17:59:52 +0200
Message-ID: <20260413155733.249357626@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Brzezinka <sebastian.brzezinka@intel.com>

commit 4c71fd099513bfa8acab529b626e1f0097b76061 upstream.

A use-after-free / refcount underflow is possible when the heartbeat
worker and intel_engine_park_heartbeat() race to release the same
engine->heartbeat.systole request.

The heartbeat worker reads engine->heartbeat.systole and calls
i915_request_put() on it when the request is complete, but clears
the pointer in a separate, non-atomic step. Concurrently, a request
retirement on another CPU can drop the engine wakeref to zero, triggering
__engine_park() -> intel_engine_park_heartbeat(). If the heartbeat
timer is pending at that point, cancel_delayed_work() returns true and
intel_engine_park_heartbeat() reads the stale non-NULL systole pointer
and calls i915_request_put() on it again, causing a refcount underflow:

```
<4> [487.221889] Workqueue: i915-unordered engine_retire [i915]
<4> [487.222640] RIP: 0010:refcount_warn_saturate+0x68/0xb0
...
<4> [487.222707] Call Trace:
<4> [487.222711]  <TASK>
<4> [487.222716]  intel_engine_park_heartbeat.part.0+0x6f/0x80 [i915]
<4> [487.223115]  intel_engine_park_heartbeat+0x25/0x40 [i915]
<4> [487.223566]  __engine_park+0xb9/0x650 [i915]
<4> [487.223973]  ____intel_wakeref_put_last+0x2e/0xb0 [i915]
<4> [487.224408]  __intel_wakeref_put_last+0x72/0x90 [i915]
<4> [487.224797]  intel_context_exit_engine+0x7c/0x80 [i915]
<4> [487.225238]  intel_context_exit+0xf1/0x1b0 [i915]
<4> [487.225695]  i915_request_retire.part.0+0x1b9/0x530 [i915]
<4> [487.226178]  i915_request_retire+0x1c/0x40 [i915]
<4> [487.226625]  engine_retire+0x122/0x180 [i915]
<4> [487.227037]  process_one_work+0x239/0x760
<4> [487.227060]  worker_thread+0x200/0x3f0
<4> [487.227068]  ? __pfx_worker_thread+0x10/0x10
<4> [487.227075]  kthread+0x10d/0x150
<4> [487.227083]  ? __pfx_kthread+0x10/0x10
<4> [487.227092]  ret_from_fork+0x3d4/0x480
<4> [487.227099]  ? __pfx_kthread+0x10/0x10
<4> [487.227107]  ret_from_fork_asm+0x1a/0x30
<4> [487.227141]  </TASK>
```

Fix this by replacing the non-atomic pointer read + separate clear with
xchg() in both racing paths. xchg() is a single indivisible hardware
instruction that atomically reads the old pointer and writes NULL. This
guarantees only one of the two concurrent callers obtains the non-NULL
pointer and performs the put, the other gets NULL and skips it.

Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/work_items/15880
Fixes: 058179e72e09 ("drm/i915/gt: Replace hangcheck by heartbeats")
Cc: <stable@vger.kernel.org> # v5.5+
Signed-off-by: Sebastian Brzezinka <sebastian.brzezinka@intel.com>
Reviewed-by: Krzysztof Karas <krzysztof.karas@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://lore.kernel.org/r/d4c1c14255688dd07cc8044973c4f032a8d1559e.1775038106.git.sebastian.brzezinka@intel.com
(cherry picked from commit 13238dc0ee4f9ab8dafa2cca7295736191ae2f42)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_engine_heartbeat.c |   26 +++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_engine_heartbeat.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_heartbeat.c
@@ -148,10 +148,12 @@ static void heartbeat(struct work_struct
 	/* Just in case everything has gone horribly wrong, give it a kick */
 	intel_engine_flush_submission(engine);
 
-	rq = engine->heartbeat.systole;
-	if (rq && i915_request_completed(rq)) {
-		i915_request_put(rq);
-		engine->heartbeat.systole = NULL;
+	rq = xchg(&engine->heartbeat.systole, NULL);
+	if (rq) {
+		if (i915_request_completed(rq))
+			i915_request_put(rq);
+		else
+			engine->heartbeat.systole = rq;
 	}
 
 	if (!intel_engine_pm_get_if_awake(engine))
@@ -232,8 +234,11 @@ static void heartbeat(struct work_struct
 unlock:
 	mutex_unlock(&ce->timeline->mutex);
 out:
-	if (!engine->i915->params.enable_hangcheck || !next_heartbeat(engine))
-		i915_request_put(fetch_and_zero(&engine->heartbeat.systole));
+	if (!engine->i915->params.enable_hangcheck || !next_heartbeat(engine)) {
+		rq = xchg(&engine->heartbeat.systole, NULL);
+		if (rq)
+			i915_request_put(rq);
+	}
 	intel_engine_pm_put(engine);
 }
 
@@ -247,8 +252,13 @@ void intel_engine_unpark_heartbeat(struc
 
 void intel_engine_park_heartbeat(struct intel_engine_cs *engine)
 {
-	if (cancel_delayed_work(&engine->heartbeat.work))
-		i915_request_put(fetch_and_zero(&engine->heartbeat.systole));
+	if (cancel_delayed_work(&engine->heartbeat.work)) {
+		struct i915_request *rq;
+
+		rq = xchg(&engine->heartbeat.systole, NULL);
+		if (rq)
+			i915_request_put(rq);
+	}
 }
 
 void intel_gt_unpark_heartbeats(struct intel_gt *gt)



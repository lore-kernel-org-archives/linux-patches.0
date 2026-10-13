Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DD323643F;
	Tue, 13 Oct 2026 12:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894631; cv=none; b=Hiz81uF/Tw294nUChWCB2vMEWDYGw/b8r3m3Ca1FBAi3sOvxGlXN0nDfgWVRrVk6G25P1vKHC/pLajgvOsc64Lr/qLAs+9Rpur1oJ8NNZoElU7lWdcMEjClxq8KRjokD+PXF+yez+Xbf5Si8B6obfntLjlx3r6mmuPjsjSUigBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894631; c=relaxed/simple;
	bh=sN8ILVqE5+/wk2q8gd9QxhHjxpiHI/foQswAEst3hgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TyKpL/x87ZXzeMYDlIvYVMht9/U2eSGfxW5b2xpuYRobBWNvqiBs0qu/CoNon7QHbc4u4/oXTBFyhH7t1Lms5KBvVe1twhd0UlZBbWCf5qJEhdOOGksRc9izkqc/oI177cXAnn8o+8FOI2K4yl9qZ9Y1BuSwuZpx/GC4RNDUq6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OfMxmcmR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OfMxmcmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2A11F000FF;
	Tue, 13 Oct 2026 12:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894630;
	bh=yxVx6+WW5mjS4QQNvqsK7RjzcCEvS7y4wtikAAihSCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OfMxmcmRPFGUMUnuojjRL7abZt28v8cWZkfI1CySWCo0EfQsvCyZMZx/TGeEtVgSU
	 Xyhd7nDfIl781PbUlvlc6L56uLvr5B410jcJrmTQO9cXL7Z8EwO2dt+dPEej8d2vyk
	 ULREcmkqSn/It8YDSU42zp/SG8uQgURMm1p7p+VY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haishuang Yan <yanhaishuang@cmss.chinamobile.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 582/621] devlink: fix devlink_rel reference leak when notify work is pending
Date: Tue, 13 Oct 2026 13:39:37 +0200
Message-ID: <20261013112934.616259760@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

[ Upstream commit c5381ae1cd1481cc431c2bd79460472c6f1d3ce3 ]

devlink_rel_nested_in_notify_work_schedule() takes a reference on the
devlink_rel for the notify work and then queues the work, ignoring the
return value of schedule_delayed_work(). If the work is already pending,
nothing new is queued, the work runs only once and drops only one
reference, so the extra one is leaked together with the devlink_rel and
its index in devlink_rels.

This is easy to hit. devl_register() of a nested instance queues the
work, and if the instance is unregistered before the work has run,
devlink_rel_put() queues it again while it is still pending. The work
also keeps rescheduling itself for as long as the parent devlink lock
cannot be taken, which widens the window. Registering and unregistering
a nested devlink instance 100 times while holding the parent lock leaks
all 100 devlink_rel objects.

The reschedule path in devlink_rel_nested_in_notify_work() has the same
problem: if the work was queued again while it was running, the
reference it holds is never dropped.

Drop the reference in both places when the work was already pending.
The pending work holds its own reference, so this can not be the last
one.

Fixes: c137743bce02 ("devlink: introduce object and nested devlink relationship infra")
Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261001042232.222987-1-yanhaishuang@cmss.chinamobile.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/devlink/core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/devlink/core.c b/net/devlink/core.c
index d8f875b229897..0a31f28c8128c 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -96,13 +96,19 @@ static void devlink_rel_nested_in_notify_work(struct work_struct *work)
 	return;
 
 reschedule_work:
-	schedule_delayed_work(&rel->nested_in.notify_work, 1);
+	/* The work may have been queued again meanwhile, which took its own
+	 * reference. Drop ours in that case.
+	 */
+	if (!schedule_delayed_work(&rel->nested_in.notify_work, 1))
+		__devlink_rel_put(rel);
 }
 
 static void devlink_rel_nested_in_notify_work_schedule(struct devlink_rel *rel)
 {
 	__devlink_rel_get(rel);
-	schedule_delayed_work(&rel->nested_in.notify_work, 0);
+	/* The pending work holds a reference already, drop the new one. */
+	if (!schedule_delayed_work(&rel->nested_in.notify_work, 0))
+		__devlink_rel_put(rel);
 }
 
 static struct devlink_rel *devlink_rel_alloc(void)
-- 
2.53.0




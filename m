Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC333815F8;
	Sat, 12 Sep 2026 19:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242892; cv=none; b=rMAtqi5lPdagyWycwuTiZc7S8X6akkwIXkKwkBpLs5RK8CO2gI/GeU3yD9y2MXBRkqYJMp+NZukhIN+gQblnLPKlI5C+oG/sz//jh8e2ujv5X8K+NbFhHXlmON61BmE3pQ/ncRTcNcR3KGCt2/Bw91oGSiDmI7DVlzJ1CKXwPRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242892; c=relaxed/simple;
	bh=KYSYwva2uMfez8T4gv/tMJ/13vEW16oitUbDyHGPqb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J1jYlI71GS0iqy5i1pC1Bj2JM0lK+HX3YeMQa+yEEeJXBp9sVfTyvdnm0vxN/4KzsNJavlpoSF2TyRWdZY7hcrDZISrNcDY6xGRrnbvLH9r/gdRqgABhfXyO0YJyqkhPv901gejyQgWHeqrtACQO3CtiKlUcEa/uAyOeKc16a5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uCHxzmeD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uCHxzmeD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9FB1F000FF;
	Sat, 12 Sep 2026 19:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242890;
	bh=okH5DIPPBUZrF1vlJcoJLNJDIVyefIF6olmIgGt3iPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uCHxzmeDx4VNeQt7ubTDi7ukJElHfzritKc0WmelRR+zHsLWyIvVqjhS9Iw1z1ebJ
	 sQNGoV/ontnajW1OmJCdAwKf+svwsgiqz1FSI/F0i6cexrqGGmK70+SU5FUVGuN5i1
	 cqNByvSL25RlhQgR0LHCPYijq4G0BZK2qICrJhDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Gupta <sidgup@codeaurora.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Alex Elder <elder@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 522/798] remoteproc: use freezable workqueue for crash notifications
Date: Sat, 12 Sep 2026 09:02:30 +0200
Message-ID: <20260912065529.097937954@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@linaro.org>

[ Upstream commit 3ad51c1743ebd23ec3b5ebc6195dafe867eaebb1 ]

When a remoteproc has crashed, rproc_report_crash() is called to
handle whatever recovery is desired.  This can happen at almost any
time, often triggered by an interrupt, though it can also be
initiated by a write to debugfs file remoteproc/remoteproc*/crash.

When a crash is reported, the crash handler worker is scheduled to
run (rproc_crash_handler_work()).  One thing that worker does is
call rproc_trigger_recovery(), which calls rproc_stop().  That calls
the ->stop method for any remoteproc subdevices before making the
remote processor go offline.

The Q6V5 modem remoteproc driver implements an SSR subdevice that
notifies registered drivers when the modem changes operational state
(prepare, started, stop/crash, unprepared).  The IPA driver
registers to receive these notifications.

With that as context, I'll now describe the problem.

There was a situation in which buggy modem firmware led to a modem
crash very soon after system (AP) resume had begun.  The crash caused
a remoteproc SSR crash notification to be sent to the IPA driver.
The problem was that, although system resume had begun, it had not
yet completed, and the IPA driver was still in a suspended state.

This scenario could happen to any driver that registers for these
SSR notifications, because they are delivered without knowledge of
the (suspend) state of registered recipient drivers.

This patch offers a simple fix for this, by having the crash
handling worker function run on the system freezable workqueue.
This workqueue does not operate if user space is frozen (for
suspend).  As a result, the SSR subdevice only delivers its
crash notification when the system is fully operational (i.e.,
neither suspended nor in suspend/resume transition).

Tested-by: Siddharth Gupta <sidgup@codeaurora.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro>
Signed-off-by: Alex Elder <elder@linaro.org>
Link: https://lore.kernel.org/r/20210519234418.1196387-2-elder@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Stable-dep-of: 74ee3b2f5767 ("remoteproc: Prevent crash handling to race with rproc_del()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 144f0405b4c93..e416908745d17 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -2450,8 +2450,8 @@ void rproc_report_crash(struct rproc *rproc, enum rproc_crash_type type)
 	dev_err(&rproc->dev, "crash detected in %s: type %s\n",
 		rproc->name, rproc_crash_to_string(type));
 
-	/* create a new task to handle the error */
-	schedule_work(&rproc->crash_handler);
+	/* Have a worker handle the error; ensure system is not suspended */
+	queue_work(system_freezable_wq, &rproc->crash_handler);
 }
 EXPORT_SYMBOL(rproc_report_crash);
 
-- 
2.53.0




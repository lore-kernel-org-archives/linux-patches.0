Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041BB404BDA;
	Tue, 21 Jul 2026 18:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658123; cv=none; b=LRTqSS5QcpSd8EacGNcWFBKVDbuw/Gxwv8RS2SV1uypvzfdU+Lsj4cOz7DBQF1shcr0nYDjIG0HfhMDROIkTsJa6Rp4aTewX+8iC3+hMinutpaCjzV/Uwbl4lufq2HpHrBV7ZWKGd+2lHgI+RVwuHSA4l+Xk6bI+EW3WRfK3BM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658123; c=relaxed/simple;
	bh=u9I59wA7WqVo2Rqttp+p7sXoN8Yy1jnyHUm0oZTvFnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKHUkN9OCB7OqGDZ/t8WSY+Q5lGU2aSue3JmmAWZgE7prtbU1yslgnvQz9PLmOCPFXfLSx/cOtYAXKSpQGIBaFSw+LcGmsYsHTC69HWw/LzXHTlv/dzLdpLncUCgrflj0lf49nOZXGVROzV/QLlSmWac0ZNSQshjZuEs5eqyjuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y6SN7ML6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y6SN7ML6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652811F00A3A;
	Tue, 21 Jul 2026 18:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658121;
	bh=5XQMFVok1rDjeugov4zTu2lnRDzBTOb/tKIqwQwPkdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y6SN7ML6f5vDrf/INPVeImqeyE39ZsnWuWo+3oQIdf84pNrE/twVSREGHNbk5hIXQ
	 fIDjM7qm2pUsPVwXgo2mWQBDCXiu/xA7WR7zngTGwE0RgLptAOI3gUUREtokRfnEcS
	 DwihdePMePVrw622aYJiyV+G/onr8sC5Re55wP1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0981/1611] tracing/events: Fix to check the simple_tsk_fn creation
Date: Tue, 21 Jul 2026 17:18:17 +0200
Message-ID: <20260721152537.456000494@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit cda1fbfc5313bb90daa271d45eea4a8d317a8544 ]

Sashiko pointed that this sample code does not correctly handle the
failure of thread creation because kthread_run() can return -errno.

Check the simple_tsk_fn is correctly initialized (created) or not.

Link: https://lore.kernel.org/all/178165817322.269421.3992299509400184196.stgit@devnote2/

Link: https://sashiko.dev/#/patchset/178092865666.163648.10457567771536160909.stgit%40devnote2

Fixes: 9cfe06f8cd5c ("tracing/events: add trace-events-sample")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/trace_events/trace-events-sample.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/samples/trace_events/trace-events-sample.c b/samples/trace_events/trace-events-sample.c
index ecc7db237f2eff..0b7a6efdb247a8 100644
--- a/samples/trace_events/trace-events-sample.c
+++ b/samples/trace_events/trace-events-sample.c
@@ -107,6 +107,10 @@ int foo_bar_reg(void)
 	 * for consistency sake, we still take the thread_mutex.
 	 */
 	simple_tsk_fn = kthread_run(simple_thread_fn, NULL, "event-sample-fn");
+	if (IS_ERR_OR_NULL(simple_tsk_fn)) {
+		pr_err("Failed to create simple_thread_fn\n");
+		simple_tsk_fn = NULL;
+	}
  out:
 	mutex_unlock(&thread_mutex);
 	return 0;
-- 
2.53.0




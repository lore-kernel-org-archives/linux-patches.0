Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D4E43B48C;
	Tue, 21 Jul 2026 22:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674010; cv=none; b=tXe26L9U0oS8+evaUJvxwr6vuA78vuhuSa20m6ZCJAKp8e4wrS6uxNOz7qt5EIRYl2X3Wwt/HNhmYVNNWw5BKQ1DpgVKLwnhlJSIYi9kPvS2Wgmst4CGeFNhfGuur7b6F8yV8OLrgYYNjWkkbA8j5jmJNEhyroW3gSidRoxlCok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674010; c=relaxed/simple;
	bh=0q7qPVa2krYlxb70CkohHtyB9uLdRw8xkO9J77BFAu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=huIvoARqzkdZ1mkZWzaEoBqtgLhrIAtUEGvoWfqnPtxGN7MHKvHPwo/S6EWUV9zSRyKrahD7EzFg2WbKI6RMNKL7DulrVxwadcd1qkcYMeLamZbTFipGxYF73WP4WGV64VdwdJjfbY0271IY0wpr+Fp95w6KC2xAoqK3r4AK0Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dV4hGugy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dV4hGugy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC46B1F000E9;
	Tue, 21 Jul 2026 22:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674009;
	bh=aFpkPU/s9awKRitwQMLTgmi6jBlthVGCMLeY4TJRrD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dV4hGugyQTLazMuFknuJB9NbRVFLSDgMjeO7L3ezCyQ1dH9GdaQfPPIwgHVEbFCKx
	 uUQ4B4NqAQfNjiZWnES5nmbDmhVe0fC+QFnDTzRVMLlXrMJqhIaN8YGivVSz+easjq
	 M0S3YpMP9dnL2SDE1fSl7Ahks7h3r/LvPG/ogmkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 379/699] tracing/events: Fix to check the simple_tsk_fn creation
Date: Tue, 21 Jul 2026 17:22:18 +0200
Message-ID: <20260721152404.241100323@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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
index 1a72b7d95cdc74..2bcae90d85e51f 100644
--- a/samples/trace_events/trace-events-sample.c
+++ b/samples/trace_events/trace-events-sample.c
@@ -94,6 +94,10 @@ int foo_bar_reg(void)
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




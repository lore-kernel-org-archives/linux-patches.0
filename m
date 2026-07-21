Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D930C39B97E;
	Tue, 21 Jul 2026 21:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669831; cv=none; b=XFofSCSdbjLKhyZayh8KjlpGROhsXOMtu7FHx3eNLjTzJ+EVWXWNN6Pu1QaIoRRdX7w54xRtCJw880JPoGkWGzrFHmcTWeIUgTZw/jr7WLaaHZQPqu5dx6enaKwN+gOAA1VCeaT4ipx2HdiPlOxq2PVLzn8HllmVp8eCzdKib4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669831; c=relaxed/simple;
	bh=sS1sjq27j6F1niAr596xzoYJ72htQ1DdChZbqIPPYv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UvR7nLG+PCsM7jp/6ps3joUVIgAsLfvGwIYNJHlPNCvo+qDJYewbyesz/ANpqRPdsbGiQZF7d0YIZKhc61YerabcBq9aA6SL3/B+ZQrYzncByGIMitujwf46zUbGrgBsvklmeBhwcfykEKJMt6YzDQp8i98z3ft5/pXXg+FDzMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NYfg4OsJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NYfg4OsJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8941F000E9;
	Tue, 21 Jul 2026 21:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669830;
	bh=gpGdZ2AcAjqq1oMGu9v3pX6p2EDYsmb4B1Nr3A2PhHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NYfg4OsJ2WD3yIlVj6rzI9aLnGbeqfvPqUzEVzWyDu/DCADyAtIf1QhwL9mIeLIUn
	 hfvlJv0WY5BcKTvpS3V1fAheDHNy01Af1bL1qDAPAeLbogbPro53ACXnjpIjgCnipr
	 iWY5Rlr/fG7zlEMDt9WoFCUkDu9rFZTpObI/iyy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0660/1067] tracing/events: Fix to check the simple_tsk_fn creation
Date: Tue, 21 Jul 2026 17:21:01 +0200
Message-ID: <20260721152439.360268058@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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




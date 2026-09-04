Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EB83815E1;
	Fri,  4 Sep 2026 06:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501949; cv=none; b=Cr1+cTcHzl/2yWrQKkyBasoePlwLxRIFV0pCWSJuo2AU4+WrBgitO0m0bwm1keQ3EwN7fsRgfOSfgshECZLRE1f9lKVvahvyoXL2P26AtGUNPbB7alkVSrRm9MvtPu7hdvlKejjAnNZnbTAWLheZjl42m5mx0P9QAmp67rdxTAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501949; c=relaxed/simple;
	bh=KMTX8874ZLDw3BcS0OFsJVN3y0WriyYoi08beLl2qn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1ZVgJGuvLa6GS85L5acKlWnFFtIjsyqkZiWp4adqCwpiMfq2zaJgMyRUx9Z/m6ldqDkyh7H71MtulAqua6TuFI4UWS3HKpy0nq582ommAAqrgMSZ2uXpArUdWzFNSpIWJj+J+IPENcPyFVCCDadX4ooH7T02ALEUleIsB/8P8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JSgk3PtR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JSgk3PtR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFC91F00A3D;
	Fri,  4 Sep 2026 06:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501947;
	bh=fV4QfdurxPEdYMkqomILfVPca4412YN79T48IgIO7kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JSgk3PtRE7WbPUiWaZCsEojBK3ozifiFddYyUWwxEPiYiMtY66LA245ReMxIs/xRE
	 +3tUXgSYJQ/wxnzCDgppyOtSf4J24K9C3l9wGSyaSM1e9M2zzOmhwKWwxBbrZM2cEX
	 PlNXnmctF9eq1PXcnJU8RUZMSSDW8nUEKGRaOXVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 035/403] tracing: Fix crash passing ERR_PTR to kthread_stop()
Date: Fri,  4 Sep 2026 06:57:18 +0200
Message-ID: <20260904045735.612116696@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Hui Su <sh_def@163.com>

commit 649bc7df3e5d7be6f7996a95084037dbf3cad1e5 upstream.

event_test_stuff() calls kthread_run() and unconditionally passes the
returned task_struct pointer to kthread_stop(). kthread_run() returns an
error pointer such as ERR_PTR(-ENOMEM) when kthread creation fails, for
example under memory pressure during the boot-time event self-test.
kthread_stop() then dereferences the invalid pointer, crashing the kernel.

Check the result of kthread_run() before passing it to kthread_stop(). Use
WARN_ON() so that a failure to create the self-test thread does not go
unnoticed, matching the ring-buffer self-test fix in commit
91542863abad ("ring-buffer: Fix crash passing ERR_PTR to kthread_stop()").

Cc: stable@vger.kernel.org
Fixes: e6187007d6c3 ("tracing/events: add startup tests for events")
Link: https://patch.msgid.link/20260817120642.668375-3-sh_def@163.com
Signed-off-by: Hui Su <sh_def@163.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -4385,6 +4385,8 @@ static __init void event_test_stuff(void
 	struct task_struct *test_thread;
 
 	test_thread = kthread_run(event_test_thread, NULL, "test-events");
+	if (WARN_ON(IS_ERR(test_thread)))
+		return;
 	msleep(1);
 	kthread_stop(test_thread);
 }



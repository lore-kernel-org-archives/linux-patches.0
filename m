Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFF0423A7C;
	Tue, 31 Mar 2026 16:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976240; cv=none; b=Nsalf2hCzRr28vJ02HxY/LG/o0mY8hia49B/VGEJ9vo2dZHvMhgES3BIIvyMkgH27hSHt5zDu67BXff/x12uERnDcOyU4ctCY0Gfqh0HWBF+QeXee87CYvSR5YIhVr0rkPEHIyrolfTqkgO+myP3WGTQrYYcgjglTDlPdP3RncM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976240; c=relaxed/simple;
	bh=wP3ZqOTkiL3/e4DnA2hXmt3OHob4wnMs0hjqvxvPkKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8/vzbAm+TQxDNRhVM8HddKyFXL3+JSDxdjCuMIfDX01/Cms8oSdDu0YQq9rJp1tt3Rs/3D/iz0fItrBt9Lf1D7KPy3fTIsBqMTV/WuqNDPM2F2YvHL2uOCih5HoU/bXpFLtehEKvzsxufUyErhdJTqsZoKXBJlU9BDqT3iORBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dbIJ/2uT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dbIJ/2uT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D34C19423;
	Tue, 31 Mar 2026 16:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976240;
	bh=wP3ZqOTkiL3/e4DnA2hXmt3OHob4wnMs0hjqvxvPkKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dbIJ/2uTauGEPt5hhskNxQ5I5Tr0ojRiXMQI+6oQLbHS2dmk9DzyUtBHvEBfIORJt
	 OB58inds8Lvcvlv25HYuRixPpOGvmZOiM5lAgw8wptGuhkOZrm5pulVMHvCqvsXCNu
	 cUtRc6NP6l1K0qqBJbPggHWbeQRFIZ+m+aKxXlVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	elver@google.com,
	kees@kernel.org,
	Guohua Yan <guohua.yan@unisoc.com>,
	Xuewen Yan <xuewen.yan@unisoc.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 017/309] tracing: Revert "tracing: Remove pid in task_rename tracing output"
Date: Tue, 31 Mar 2026 18:18:40 +0200
Message-ID: <20260331161754.112336559@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Xuewen Yan <xuewen.yan@unisoc.com>

[ Upstream commit a6f22e50c7d51aa225c392c62c33f0fae11f734d ]

This reverts commit e3f6a42272e028c46695acc83fc7d7c42f2750ad.

The commit says that the tracepoint only deals with the current task,
however the following case is not current task:

comm_write() {
    p = get_proc_task(inode);
    if (!p)
        return -ESRCH;

    if (same_thread_group(current, p))
        set_task_comm(p, buffer);
}
where set_task_comm() calls __set_task_comm() which records
the update of p and not current.

So revert the patch to show pid.

Cc: <mhiramat@kernel.org>
Cc: <mathieu.desnoyers@efficios.com>
Cc: <elver@google.com>
Cc: <kees@kernel.org>
Link: https://patch.msgid.link/20260306075954.4533-1-xuewen.yan@unisoc.com
Fixes: e3f6a42272e0 ("tracing: Remove pid in task_rename tracing output")
Reported-by: Guohua Yan <guohua.yan@unisoc.com>
Signed-off-by: Xuewen Yan <xuewen.yan@unisoc.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/task.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/task.h b/include/trace/events/task.h
index 4f0759634306c..b9a129eb54d9e 100644
--- a/include/trace/events/task.h
+++ b/include/trace/events/task.h
@@ -38,19 +38,22 @@ TRACE_EVENT(task_rename,
 	TP_ARGS(task, comm),
 
 	TP_STRUCT__entry(
+		__field(	pid_t,	pid)
 		__array(	char, oldcomm,  TASK_COMM_LEN)
 		__array(	char, newcomm,  TASK_COMM_LEN)
 		__field(	short,	oom_score_adj)
 	),
 
 	TP_fast_assign(
+		__entry->pid = task->pid;
 		memcpy(entry->oldcomm, task->comm, TASK_COMM_LEN);
 		strscpy(entry->newcomm, comm, TASK_COMM_LEN);
 		__entry->oom_score_adj = task->signal->oom_score_adj;
 	),
 
-	TP_printk("oldcomm=%s newcomm=%s oom_score_adj=%hd",
-		  __entry->oldcomm, __entry->newcomm, __entry->oom_score_adj)
+	TP_printk("pid=%d oldcomm=%s newcomm=%s oom_score_adj=%hd",
+		__entry->pid, __entry->oldcomm,
+		__entry->newcomm, __entry->oom_score_adj)
 );
 
 /**
-- 
2.51.0




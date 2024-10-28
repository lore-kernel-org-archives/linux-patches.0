Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6E719067C;
	Mon, 28 Oct 2024 06:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097270; cv=none; b=ZOysfQ7DS7NGMWsh1eHdZE3Wf9+6HDD9tHOFm1kUZQRF18Y5ZwKYtV76KaYT0ZvnfSa/321E9pW99rBsCZczUKiqL/j3usLKOwyYdMPmKT2CfpLIMiilY8jwfjMCza1RNm051Adw/FhclE0F5oyTQJcBbN1AyXI4Y2Sj9nBSRQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097270; c=relaxed/simple;
	bh=ozdYqmXY66xrJraDMKX7wvPGhCCk5OxJkLHsLnpZ51s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kd11NKHBwVmPbNEA4UhGXW76SvY2AlJFy3LVIPkxYJxA9+hal9Y/wC1JqzeeSIX+BYRvo25btr5+sHmyOTNCuP+dewhyRr1Y4DhN/o4lsq7Z/q46kDwTEDxJELFUjpSLeuAzs9XeNeFlkJCWMRs+FAO3A30CDqgjkL+Wxj6y7FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SUT5pU0d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SUT5pU0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E28DC4CEED;
	Mon, 28 Oct 2024 06:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097270;
	bh=ozdYqmXY66xrJraDMKX7wvPGhCCk5OxJkLHsLnpZ51s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SUT5pU0dVy25XHG+9mtoLl0zN+d4SOcV5kZuGijt+jROMCft5QgCgLTplcWhF9PZ4
	 H+WXoW1f7Yf+cn2lAt9BRsSGbAMu/zedJxVKDRfdt82mfbN50dYoyytLUJ1yWTR0gN
	 hGV7EnqcV6B/2/ZEiZz0hog4RoJGxFvHJSEa6TuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Rome <linux@jordanrome.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/137] bpf: Fix iter/task tid filtering
Date: Mon, 28 Oct 2024 07:24:53 +0100
Message-ID: <20241028062300.294485465@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jordan Rome <linux@jordanrome.com>

[ Upstream commit 9495a5b731fcaf580448a3438d63601c88367661 ]

In userspace, you can add a tid filter by setting
the "task.tid" field for "bpf_iter_link_info".
However, `get_pid_task` when called for the
`BPF_TASK_ITER_TID` type should have been using
`PIDTYPE_PID` (tid) instead of `PIDTYPE_TGID` (pid).

Fixes: f0d74c4da1f0 ("bpf: Parameterize task iterators.")
Signed-off-by: Jordan Rome <linux@jordanrome.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20241016210048.1213935-1-linux@jordanrome.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/task_iter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index c4ab9d6cdbe9c..f7ef58090c7d0 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -119,7 +119,7 @@ static struct task_struct *task_seq_get_next(struct bpf_iter_seq_task_common *co
 		rcu_read_lock();
 		pid = find_pid_ns(common->pid, common->ns);
 		if (pid) {
-			task = get_pid_task(pid, PIDTYPE_TGID);
+			task = get_pid_task(pid, PIDTYPE_PID);
 			*tid = common->pid;
 		}
 		rcu_read_unlock();
-- 
2.43.0




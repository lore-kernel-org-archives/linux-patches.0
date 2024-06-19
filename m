Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D5A145FEF;
	Wed, 19 Jun 2024 13:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802081; cv=none; b=JW9D1mNNb4mwi3Fn1WIP5IH6x2HEThjhQS7UUfE3b2mWN6Zy/RBR+P3L12NfrKFKu8BGZxRJHloP3kMddTYtyz3lJuDWLL9gxcLWMm9JpO1Fy56fsYFZwDuC+odebgh8kJz6ATIEThEZwmbZe+1NnwtQlnKQqyTv1RtA15+R9vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802081; c=relaxed/simple;
	bh=+mm+su0uX/U5asRcsOrEmT3/4oNMk0Wz6ntPedczTaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKrpGJmmpdbMTZNgLNuzuq+hX+CfSbK2JoL0Kt4huCXl81Z10JlHzUJObqGAeyfjV1nPUeAQ74X1HAPcKky6fbwglllwo9DZOYWZDQRoFQ2zw0l5FEoAA9rtwoinkPnSNIwguRoL0XtHgTLK1My9stqQRQXhREwsyfr3rNH+ILE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IhVKX7Ml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IhVKX7Ml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEE8C2BBFC;
	Wed, 19 Jun 2024 13:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802080;
	bh=+mm+su0uX/U5asRcsOrEmT3/4oNMk0Wz6ntPedczTaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IhVKX7MlgAKytk9WXQmsFiQA1tDnqpr9tPZHAKlCZMqbopkW0mBZZm79/LT9juN+0
	 01DkVaK6j0b6DmVoCcot9jZKDkiFYM04QZF14nF46PO8MgmwErfpOX0uXDmU/ZNWB9
	 4DHPim32qpRPD7YpiKajHkW+NK+eoP4wF4UuydmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/267] bpf: fix multi-uprobe PID filtering logic
Date: Wed, 19 Jun 2024 14:53:46 +0200
Message-ID: <20240619125609.233910558@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 46ba0e49b64232adac35a2bc892f1710c5b0fb7f ]

Current implementation of PID filtering logic for multi-uprobes in
uprobe_prog_run() is filtering down to exact *thread*, while the intent
for PID filtering it to filter by *process* instead. The check in
uprobe_prog_run() also differs from the analogous one in
uprobe_multi_link_filter() for some reason. The latter is correct,
checking task->mm, not the task itself.

Fix the check in uprobe_prog_run() to perform the same task->mm check.

While doing this, we also update get_pid_task() use to use PIDTYPE_TGID
type of lookup, given the intent is to get a representative task of an
entire process. This doesn't change behavior, but seems more logical. It
would hold task group leader task now, not any random thread task.

Last but not least, given multi-uprobe support is half-broken due to
this PID filtering logic (depending on whether PID filtering is
important or not), we need to make it easy for user space consumers
(including libbpf) to easily detect whether PID filtering logic was
already fixed.

We do it here by adding an early check on passed pid parameter. If it's
negative (and so has no chance of being a valid PID), we return -EINVAL.
Previous behavior would eventually return -ESRCH ("No process found"),
given there can't be any process with negative PID. This subtle change
won't make any practical change in behavior, but will allow applications
to detect PID filtering fixes easily. Libbpf fixes take advantage of
this in the next patch.

Cc: stable@vger.kernel.org
Acked-by: Jiri Olsa <jolsa@kernel.org>
Fixes: b733eeade420 ("bpf: Add pid filter support for uprobe_multi link")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20240521163401.3005045-2-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 8edbafe0d4cdf..cc29bf49f7159 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -3099,7 +3099,7 @@ static int uprobe_prog_run(struct bpf_uprobe *uprobe,
 	struct bpf_run_ctx *old_run_ctx;
 	int err = 0;
 
-	if (link->task && current != link->task)
+	if (link->task && current->mm != link->task->mm)
 		return 0;
 
 	if (sleepable)
@@ -3200,8 +3200,9 @@ int bpf_uprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	upath = u64_to_user_ptr(attr->link_create.uprobe_multi.path);
 	uoffsets = u64_to_user_ptr(attr->link_create.uprobe_multi.offsets);
 	cnt = attr->link_create.uprobe_multi.cnt;
+	pid = attr->link_create.uprobe_multi.pid;
 
-	if (!upath || !uoffsets || !cnt)
+	if (!upath || !uoffsets || !cnt || pid < 0)
 		return -EINVAL;
 	if (cnt > MAX_UPROBE_MULTI_CNT)
 		return -E2BIG;
@@ -3225,10 +3226,9 @@ int bpf_uprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 		goto error_path_put;
 	}
 
-	pid = attr->link_create.uprobe_multi.pid;
 	if (pid) {
 		rcu_read_lock();
-		task = get_pid_task(find_vpid(pid), PIDTYPE_PID);
+		task = get_pid_task(find_vpid(pid), PIDTYPE_TGID);
 		rcu_read_unlock();
 		if (!task) {
 			err = -ESRCH;
-- 
2.43.0




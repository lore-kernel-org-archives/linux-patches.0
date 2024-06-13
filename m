Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30CB144D16;
	Thu, 13 Jun 2024 11:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279666; cv=none; b=JvpBnLzU0NKD4zllgW6An4r80+IAPG8JKX+LDJyRUJkh6Cb1lEl4EyWEuPe+0LMRy/IDuN2bDGnft+AIiXJDRdNtZ3bvsw+gG8h2XsEzW7Lzlv4hnQQ2Er8mG0YGz76C9Kg4C3vYpO9LdGWb2y/7KoOgflOtCsbN98nOJycub4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279666; c=relaxed/simple;
	bh=7Mt1b4m+v4+wm4YYRuLtJ7yMkRyDANHqcR+FFC6Ebsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPCs4E7u4Mwnvf5vp9ChSepDsOctEVCc0Q+aY/ljosvCOY+gL3mFIywtwWi3GihqaIKAC+1cEkky8iZVYzv9aA+rTdkBDIqdQPzqUD/OMbwL8j0BodEghlwb236ATV0f4NKMdFmIgCdqsIa+T2p+UYAxhQZWuBbQS0lk/KiluBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hSneWhqs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hSneWhqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B790C2BBFC;
	Thu, 13 Jun 2024 11:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279666;
	bh=7Mt1b4m+v4+wm4YYRuLtJ7yMkRyDANHqcR+FFC6Ebsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hSneWhqs7eviHQdPRWL5LyVc0S8sqSwueYycC21pt0Yd9PCTpVJTWa+T+39xo3P10
	 RRKV/BhlJSPF3mqtg2ksZ8dOmYbALYGE6po1jgs1h3ly8hp0RPLfxlus1vfXdm1H5k
	 smUB2FaM1kgdBd3fxtmXWR/YdT6FLq3DqbH0cu8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.9 152/157] bpf: fix multi-uprobe PID filtering logic
Date: Thu, 13 Jun 2024 13:34:37 +0200
Message-ID: <20240613113233.289155791@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

commit 46ba0e49b64232adac35a2bc892f1710c5b0fb7f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/bpf_trace.c                                   |    8 ++++----
 tools/testing/selftests/bpf/prog_tests/uprobe_multi_test.c |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -3260,7 +3260,7 @@ static int uprobe_prog_run(struct bpf_up
 	struct bpf_run_ctx *old_run_ctx;
 	int err = 0;
 
-	if (link->task && current != link->task)
+	if (link->task && current->mm != link->task->mm)
 		return 0;
 
 	if (sleepable)
@@ -3361,8 +3361,9 @@ int bpf_uprobe_multi_link_attach(const u
 	upath = u64_to_user_ptr(attr->link_create.uprobe_multi.path);
 	uoffsets = u64_to_user_ptr(attr->link_create.uprobe_multi.offsets);
 	cnt = attr->link_create.uprobe_multi.cnt;
+	pid = attr->link_create.uprobe_multi.pid;
 
-	if (!upath || !uoffsets || !cnt)
+	if (!upath || !uoffsets || !cnt || pid < 0)
 		return -EINVAL;
 	if (cnt > MAX_UPROBE_MULTI_CNT)
 		return -E2BIG;
@@ -3386,10 +3387,9 @@ int bpf_uprobe_multi_link_attach(const u
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
--- a/tools/testing/selftests/bpf/prog_tests/uprobe_multi_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/uprobe_multi_test.c
@@ -397,7 +397,7 @@ static void test_attach_api_fails(void)
 	link_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_UPROBE_MULTI, &opts);
 	if (!ASSERT_ERR(link_fd, "link_fd"))
 		goto cleanup;
-	ASSERT_EQ(link_fd, -ESRCH, "pid_is_wrong");
+	ASSERT_EQ(link_fd, -EINVAL, "pid_is_wrong");
 
 cleanup:
 	if (link_fd >= 0)



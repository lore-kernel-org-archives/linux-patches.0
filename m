Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DB018A922;
	Mon, 28 Oct 2024 06:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098169; cv=none; b=QXlo2DxRZjsGh2Z8Cnvrymo7W3o4Ty1bj5U6lcyvpZ37ojowcL6PRYgMFSCBvFfhXFbR36+1h6rKjYF858g4h+jyBoyZBjzr+DT5MjFTWwgJx2kvjlAjwZEt7QtWFZA6TwU+TFjVAbWFn9CZ1QwLho1YbafAS3hQFtqHoOR4lSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098169; c=relaxed/simple;
	bh=A4ssoDjBrLqBI53W/fpHZ//mFVqIFmn8R/GsU+LABz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VO8SeLKOaRBk8XdG7hTvwbaCi6/NYU7nbZwe5YhTbHuAa6Ek/l2A7DipXrikHh8gn5i0OTPRlwtZpC/CtmpRRiqnyAvDRCJnz7M8lPqDS1jPzc7jrUzRqg9dTcC7Yj8Uc2A/xZIE2qiwnr/Wvd8/MyGVz14895pcSxV6mvSaCbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QCpDYt+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QCpDYt+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62EDC4CEC3;
	Mon, 28 Oct 2024 06:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098169;
	bh=A4ssoDjBrLqBI53W/fpHZ//mFVqIFmn8R/GsU+LABz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QCpDYt+C3QVE09bq9I7CnOqK6BW5TYQj9Y0gKHP6B3I5/K5G//yfUJYZL+Pcakp5n
	 EcmjJ4DEM1jmQLOgxmMLhx9P3F2GwU3XvL9LfNIZuhnHztYwVN7nT3WJo1y+/qTIqS
	 y3cAvAVW6xnD75AagbQGuFL/HL756Un/Ww0UoKGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Rome <linux@jordanrome.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 108/261] bpf: Fix iter/task tid filtering
Date: Mon, 28 Oct 2024 07:24:10 +0100
Message-ID: <20241028062314.735433731@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 02aa9db8d7961..5af9e130e500f 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -99,7 +99,7 @@ static struct task_struct *task_seq_get_next(struct bpf_iter_seq_task_common *co
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




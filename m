Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279942F94A0;
	Tue, 17 Jun 2025 16:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177589; cv=none; b=O/1aigZ91rR1gWeLLmfK8QM92TSVqdHmDN8Syt1XMB3X4UDKXz4V1loJTU3xagd5BLxbhk3Ltn6vqumBqc7rWx1gLIwnlYXYttsWAilnt9E3yTWhsnMmbiRaQRbukWbbEF5PfNl+jiCGGOyGZKwxKV8Nr1GMyCgG7yA7fxufTZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177589; c=relaxed/simple;
	bh=PYcoGI43X8aI4yQF0Se/Fs5N03EjC73DRNsfcdrdOAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGxWeDjaMRQyBgagCxsajgfbA+jR3XiZkXNw4tMGBvc15MLvdeWzKmDk8p0ptFgYluQZDdIpy2rKX8fmi0ksGAHxW7PpAPLgVZSZxbKdWoIMlmqd54EIs6IJXzpfJaIUHPtU+EJESyyRhGCV6u81xBEPDgJRUe7wUI0GzWIPLbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NxYRQj7k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NxYRQj7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487E0C4CEE3;
	Tue, 17 Jun 2025 16:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177588;
	bh=PYcoGI43X8aI4yQF0Se/Fs5N03EjC73DRNsfcdrdOAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NxYRQj7kJ0xEfji8xDHFaJxHjqmxvzOQBygTssyYfn6tDKkVTqiCV/fp/LxuYeMIv
	 Z5zknP4EnqAoL1iam5RyH887zHvGYCmAISxZ4+1hQ2VEoT/b8ud4jJQW67u1QxxUfJ
	 Xw31s2x05FAPZNh/dip0K0KXoinamAroJNRODAi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuewen Yan <xuewen.yan@unisoc.com>,
	Di Shen <di.shen@unisoc.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 306/780] bpf: Revert "bpf: remove unnecessary rcu_read_{lock,unlock}() in multi-uprobe attach logic"
Date: Tue, 17 Jun 2025 17:20:14 +0200
Message-ID: <20250617152503.921960825@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Di Shen <di.shen@unisoc.com>

[ Upstream commit 4e2e6841ff761cc15a54e8bebcf35d7325ec78a2 ]

This reverts commit 4a8f635a6054.

Althought get_pid_task() internally already calls rcu_read_lock() and
rcu_read_unlock(), the find_vpid() was not.

The documentation for find_vpid() clearly states:
"Must be called with the tasklist_lock or rcu_read_lock() held."

Add proper rcu_read_lock/unlock() to protect the find_vpid().

Fixes: 4a8f635a6054 ("bpf: remove unnecessary rcu_read_{lock,unlock}() in multi-uprobe attach logic")
Reported-by: Xuewen Yan <xuewen.yan@unisoc.com>
Signed-off-by: Di Shen <di.shen@unisoc.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20250520054943.5002-1-xuewen.yan@unisoc.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index e1bf9c06007fb..090cdab38f0cc 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -3423,7 +3423,9 @@ int bpf_uprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	}
 
 	if (pid) {
+		rcu_read_lock();
 		task = get_pid_task(find_vpid(pid), PIDTYPE_TGID);
+		rcu_read_unlock();
 		if (!task) {
 			err = -ESRCH;
 			goto error_path_put;
-- 
2.39.5




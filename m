Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352481F429B;
	Tue, 17 Dec 2024 17:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456292; cv=none; b=aWZIAAKnr9eDw7Z6Cdi8t+DMPR4RNX7NQ3rSLOME+l/nJOU2UgM+anBfuDslScyVZwsmzyugExmsGfhKgbwXNl2ElrEFXeyWDF9tHtWi1tt5qb1lQcJv8kk95n/SlCH6upHN0IpF7QQsm9HfOcPvJQeCeV+J1rZfUC1yqMGtKTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456292; c=relaxed/simple;
	bh=NVBFJm6BdlpBOpJdU6yRsjG7SOX3+FmzNmgxaRhU7Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dX+sbeeS072hH6tQ1PidBuk0XFOzNidLEyizcyVjK9hEU6/XTye5zp1B5tn3gAsU+wwrswLEbipcuqrqp4IK7PT5Df5ygKwiSbfZdCl32LHDFiigFbptV9KNvua3JVsjZLD0U6AojW7dQNwzoVW6jM4X4+jYBVbgEaw02X3DICU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2A1kF7E9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2A1kF7E9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B075EC4CED3;
	Tue, 17 Dec 2024 17:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456292;
	bh=NVBFJm6BdlpBOpJdU6yRsjG7SOX3+FmzNmgxaRhU7Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2A1kF7E9cPngLnCMPT6kbW8MV/FKzl/Ei9+knPgPqcu3htAmh1X/JxPzt7mTsuNYm
	 4citzlf+5Oj1Sph6/5JY72fuBXivw6HJzREwA3gQGJiA9Pnl3QmRY8rlu00o9P6Szu
	 hS2QpC3Z7e/+zYrX/FNQDXZ/eslBMk6JEP/eiIrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 6.12 003/172] bpf: Fix UAF via mismatching bpf_prog/attachment RCU flavors
Date: Tue, 17 Dec 2024 18:05:59 +0100
Message-ID: <20241217170546.368891741@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit ef1b808e3b7c98612feceedf985c2fbbeb28f956 upstream.

Uprobes always use bpf_prog_run_array_uprobe() under tasks-trace-RCU
protection. But it is possible to attach a non-sleepable BPF program to a
uprobe, and non-sleepable BPF programs are freed via normal RCU (see
__bpf_prog_put_noref()). This leads to UAF of the bpf_prog because a normal
RCU grace period does not imply a tasks-trace-RCU grace period.

Fix it by explicitly waiting for a tasks-trace-RCU grace period after
removing the attachment of a bpf_prog to a perf_event.

Fixes: 8c7dcb84e3b7 ("bpf: implement sleepable uprobes by chaining gps")
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/bpf/20241210-bpf-fix-actual-uprobe-uaf-v1-1-19439849dd44@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/bpf_trace.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2223,6 +2223,13 @@ void perf_event_detach_bpf_prog(struct p
 		bpf_prog_array_free_sleepable(old_array);
 	}
 
+	/*
+	 * It could be that the bpf_prog is not sleepable (and will be freed
+	 * via normal RCU), but is called from a point that supports sleepable
+	 * programs and uses tasks-trace-RCU.
+	 */
+	synchronize_rcu_tasks_trace();
+
 	bpf_prog_put(event->prog);
 	event->prog = NULL;
 



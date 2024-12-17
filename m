Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211061F7574;
	Tue, 17 Dec 2024 17:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456524; cv=none; b=SOihquZdKnCEi9tx1DgYY7j8tkwtAPyFnZfIKydmFG3lY43UwrYe/3Zpoya+VOryePZgEOBVpmDUPIPxj20oBHanFZ1vQ/TiN2DuY0Mhzm13RJRvByjH9oUAYwdPMzvGtDeqJ+LHDz8d9MTL7ujGoMCJKRT1vKwvLWOtDBPLBHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456524; c=relaxed/simple;
	bh=kpslnGk57HAh923wo0VZ7CoH0OAwGNpA3WVt3lM3hg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RpwDEmuvgzOftmjiNIazStoKSDRWrAAvB3DYp0y29yWtIXGNkDzR2xgWnjoUICa3iPrFey3yNttl7ffvKmBvfG0vk4BSZnkWu8Okrz9EMXiS215TV1KMUpZCSMdeyLNVPOh6WUYpjFmTQe9lWSORvGcOrhnBuO0/dSTQbl6/Hrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IKScSr58; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IKScSr58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F412C4CED3;
	Tue, 17 Dec 2024 17:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456523;
	bh=kpslnGk57HAh923wo0VZ7CoH0OAwGNpA3WVt3lM3hg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IKScSr58RkKXn8f2tvIjBW5TK8Kjq/pFhN9X6qkLjSpu+T/ZhmjrSsi9WFlRyBxwC
	 EAOASirYzDDbvg2liq9af57tB+kgoAh2NW9RPEW+ivmyoP/er8lDxOF9rDA0itQCkO
	 l1iW7vyKgIlLWrntacdPSwdWpe/Dw3h81OtEjr2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2e0d2840414ce817aaac@syzkaller.appspotmail.com,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 6.12 078/172] bpf,perf: Fix invalid prog_array access in perf_event_detach_bpf_prog
Date: Tue, 17 Dec 2024 18:07:14 +0100
Message-ID: <20241217170549.524270906@linuxfoundation.org>
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

From: Jiri Olsa <jolsa@kernel.org>

commit 978c4486cca5c7b9253d3ab98a88c8e769cb9bbd upstream.

Syzbot reported [1] crash that happens for following tracing scenario:

  - create tracepoint perf event with attr.inherit=1, attach it to the
    process and set bpf program to it
  - attached process forks -> chid creates inherited event

    the new child event shares the parent's bpf program and tp_event
    (hence prog_array) which is global for tracepoint

  - exit both process and its child -> release both events
  - first perf_event_detach_bpf_prog call will release tp_event->prog_array
    and second perf_event_detach_bpf_prog will crash, because
    tp_event->prog_array is NULL

The fix makes sure the perf_event_detach_bpf_prog checks prog_array
is valid before it tries to remove the bpf program from it.

[1] https://lore.kernel.org/bpf/Z1MR6dCIKajNS6nU@krava/T/#m91dbf0688221ec7a7fc95e896a7ef9ff93b0b8ad

Fixes: 0ee288e69d03 ("bpf,perf: Fix perf_event_detach_bpf_prog error handling")
Reported-by: syzbot+2e0d2840414ce817aaac@syzkaller.appspotmail.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20241208142507.1207698-1-jolsa@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/bpf_trace.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2215,6 +2215,9 @@ void perf_event_detach_bpf_prog(struct p
 		goto unlock;
 
 	old_array = bpf_event_rcu_dereference(event->tp_event->prog_array);
+	if (!old_array)
+		goto put;
+
 	ret = bpf_prog_array_copy(old_array, event->prog, NULL, 0, &new_array);
 	if (ret < 0) {
 		bpf_prog_array_delete_safe(old_array, event->prog);
@@ -2223,6 +2226,7 @@ void perf_event_detach_bpf_prog(struct p
 		bpf_prog_array_free_sleepable(old_array);
 	}
 
+put:
 	/*
 	 * It could be that the bpf_prog is not sleepable (and will be freed
 	 * via normal RCU), but is called from a point that supports sleepable



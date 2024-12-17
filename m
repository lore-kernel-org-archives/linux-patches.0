Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34581F7577;
	Tue, 17 Dec 2024 17:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455946; cv=none; b=F7/wplM18au8GfrJ+NW5Ene0676F2Vzftp0KnqLuCJIifYjdQwiO6gsUs8YbVkLfrFU4iVX8DDMU7C/oTOtREEl/+OliSij9UhpkHwcH01HLMdhwlU2A0l3YMYmKUyu31y6TMr3tUnGcyh3ZaC9CeohVjBzQuAPKP06CgwNlIek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455946; c=relaxed/simple;
	bh=OPoFM9v7srdb0U7u7f0oUpc45M293FkfL1Cg07iNx0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lk0TXJBQd3nT7rxNVfbAyCUHjeLivffotKoHTTwNQputzbmz51RftqEnAFz8+9ptn9BUry/1EUhnc7YSh4ZQx8GC85zLG/GQ7Xm6oUky9o4RkE4O00NzifGL3Xc2CqPLyuR29W0kLG1nrWgxyJN2njdlXhP64bNLpW5KvHH6EYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OMpafJeU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OMpafJeU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16083C4CED3;
	Tue, 17 Dec 2024 17:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455946;
	bh=OPoFM9v7srdb0U7u7f0oUpc45M293FkfL1Cg07iNx0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OMpafJeUWrVsUQnj/m1fQ3Nbuo60f0gluHJtwNfySPH4bU50ThJItr82lvxvUNL2K
	 pSQGf9EmZm2dbwj9rEawSF32MTZOLYKK71Ch815YMzeJCCbPFT76ySJxWxuhC5UefY
	 REyFeg7X0utbzfi2ICPBZ0Cjy1vl6ifqbLByAoaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 6.6 001/109] bpf: Fix UAF via mismatching bpf_prog/attachment RCU flavors
Date: Tue, 17 Dec 2024 18:06:45 +0100
Message-ID: <20241217170533.395054721@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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
@@ -2224,6 +2224,13 @@ void perf_event_detach_bpf_prog(struct p
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
 



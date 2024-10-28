Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECCD8837;
	Mon, 28 Oct 2024 06:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098334; cv=none; b=A05WunzzQpOEn8b/TGaXTzpAM3DJ7/QwkMUYiSuVS0B3ngY1zbvmj5IAG3AewGftB/PNY8yEKuWYWk3YjSZ9vAXGfVPeE78+IRQtA6PUsv4yzCFW7efsBPgJ/FM6WfSnoCZpOpG8YP9iGVRj+7Pcj9/H70uNcl9hw+zVSdJmbGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098334; c=relaxed/simple;
	bh=F3kOO/IZUoHlT8tNRsDYTXwc6EtE/JtqlG4ZTr30AGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKcCiwyXOmABptvN9J+M2PgJFmYJzq2hd3d791wDjYCdR+wf9Rkzg/EEKBUA0S9pGmkf+5xaExtjfQ+3zgqoiy5GuqGW/nbRp5bbeUoYmtPqBFleu6+o6o19EblmcxQIJBoZtCurvhiynnQCFCaGDNtCB2zmYjvMjzlmdehkCWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UR3ZdAjL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UR3ZdAjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F96CC4CEC3;
	Mon, 28 Oct 2024 06:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098334;
	bh=F3kOO/IZUoHlT8tNRsDYTXwc6EtE/JtqlG4ZTr30AGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UR3ZdAjLMJ175OSWnsXmQ3Hf+uaMrk+dgQQK+egiKdwWb1jRgMBOkn/j6Y0cxeafT
	 0rqQu2LY/+0CphqWnkWuRrksIntYMnnDwLgJ6KP/pXoSQ/3OhdXwpzoZPph4aJcNN8
	 u8pA++01N+LIbp+WCUsi/I/jkZh2/RmEv5GUrmWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 174/261] bpf,perf: Fix perf_event_detach_bpf_prog error handling
Date: Mon, 28 Oct 2024 07:25:16 +0100
Message-ID: <20241028062316.360189833@linuxfoundation.org>
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

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 0ee288e69d033850bc87abe0f9cc3ada24763d7f ]

Peter reported that perf_event_detach_bpf_prog might skip to release
the bpf program for -ENOENT error from bpf_prog_array_copy.

This can't happen because bpf program is stored in perf event and is
detached and released only when perf event is freed.

Let's drop the -ENOENT check and make sure the bpf program is released
in any case.

Fixes: 170a7e3ea070 ("bpf: bpf_prog_array_copy() should return -ENOENT if exclude_prog not found")
Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20241023200352.3488610-1-jolsa@kernel.org

Closes: https://lore.kernel.org/lkml/20241022111638.GC16066@noisy.programming.kicks-ass.net/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 50c0b1088a9eb..6dbbb3683ab2e 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2306,8 +2306,6 @@ void perf_event_detach_bpf_prog(struct perf_event *event)
 
 	old_array = bpf_event_rcu_dereference(event->tp_event->prog_array);
 	ret = bpf_prog_array_copy(old_array, event->prog, NULL, 0, &new_array);
-	if (ret == -ENOENT)
-		goto unlock;
 	if (ret < 0) {
 		bpf_prog_array_delete_safe(old_array, event->prog);
 	} else {
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8927415B10D;
	Mon, 28 Oct 2024 06:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097101; cv=none; b=Py48yWZUCeDP6VHDzFyMpw21giUNZ/UumKYDALVi7Q9WxmNgi274nkUcCB+gWCX5Q/+LX0UXjICc26j1pjx6bg4jMq4v5pkNy4dXndB5ulR86rlGUv9YsMjRBdW+gi2M6pECSK9hTlpgwqT/gwn35/YN8ciVn9iEzoi6Ahgs8kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097101; c=relaxed/simple;
	bh=hzrOELiL5gkm6O243wzvamsfqSWp2oldPSGt96TUbkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuU2QSLeTC88kYzEenknwvcXTcyRGbMU9DdO6LT3tDH/hI0g3NMWf6h3y8vkX3BsKDrnrCArnZ+PC3CWkkPLBJ+cGeQWSaeNMlwr6vbHTBn8kibFy6sTj0fSMU683GZq3sQLE7buxJVr+R0GEiFJzxETw3/DIPG6UhMo/grDILU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ty/Jw1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ty/Jw1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D03EC4CECD;
	Mon, 28 Oct 2024 06:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097101;
	bh=hzrOELiL5gkm6O243wzvamsfqSWp2oldPSGt96TUbkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ty/Jw1FvJasmAFC7566qvBGX3gd2fh79+pGlqZafE9Qj5QS/I2Se2fLAljuf+Hry
	 zeOx1rlz1KB6H8C+AAqwiGisxUL86GGYpZhIqE4pRCisxC9LPrfilXUZYfCz3cwIRy
	 Aib9Y83DzcY8xx77+olmG4AOXBa+a4LXKqJfmBIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 64/80] bpf,perf: Fix perf_event_detach_bpf_prog error handling
Date: Mon, 28 Oct 2024 07:25:44 +0100
Message-ID: <20241028062254.392692887@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a1dc0ff1962e6..126754b61edc0 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1790,8 +1790,6 @@ void perf_event_detach_bpf_prog(struct perf_event *event)
 
 	old_array = bpf_event_rcu_dereference(event->tp_event->prog_array);
 	ret = bpf_prog_array_copy(old_array, event->prog, NULL, 0, &new_array);
-	if (ret == -ENOENT)
-		goto unlock;
 	if (ret < 0) {
 		bpf_prog_array_delete_safe(old_array, event->prog);
 	} else {
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0293C12A14D;
	Tue, 23 Jan 2024 00:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968737; cv=none; b=NpGaFx+cGT8JkH1dIjSO7J0hL7ozIt3LoZpCm+woH3IsQw9fOWrAxtxcDfwJ03sgEF42Sep8CzpA7nrF/R7UTK8d4oZMY3I06fT4USb2g6vXEaI47nG4drYa8g4184rxXNBONL9ifJpJfpfwh143620L6FX4HtYy4kEibAZqa/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968737; c=relaxed/simple;
	bh=b/2Ycj//bWZk+XsmXV836jef0UT9YkbmpPdk0GSxmTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLhbzOdYqpvkTdYLQmJ/Ud/DCCPjqg/rpRT3BjyL5FmTeEqKOiD/75Ocjx0aB/lg6SP5qAbKpNbEOIrMxh+msCV1yFhInKZ53BY5tidyOne241zLGmGY5Zf7bdqEqJx5Q/zEA9czyZVMOdom989Uu02nAZYJE9NNo0/iKz6nuCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VAwxLeL7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VAwxLeL7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D68C43399;
	Tue, 23 Jan 2024 00:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968736;
	bh=b/2Ycj//bWZk+XsmXV836jef0UT9YkbmpPdk0GSxmTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VAwxLeL7td2g90+BWSeVKrOWL1Htp22+fBvUbhSht7PG42QIaiZuvy9Dp9zxxGZe5
	 jkyL/UCxQWMfQk8k9E8vh5b36xAswNVhBpXMjBQnTk7RSzp0blolgWfvyUPICtxp/M
	 ALZByHEFrLUN9jWb5d6cBJvjRRMKJ+J3TsnkOSnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 022/194] ring-buffer: Do not record in NMI if the arch does not support cmpxchg in NMI
Date: Mon, 22 Jan 2024 15:55:52 -0800
Message-ID: <20240122235720.178239115@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit 712292308af2265cd9b126aedfa987f10f452a33 ]

As the ring buffer recording requires cmpxchg() to work, if the
architecture does not support cmpxchg in NMI, then do not do any recording
within an NMI.

Link: https://lore.kernel.org/linux-trace-kernel/20231213175403.6fc18540@gandalf.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 4a03eac43aaf..0c0ca21d807d 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2976,6 +2976,12 @@ rb_reserve_next_event(struct ring_buffer *buffer,
 	int nr_loops = 0;
 	u64 diff;
 
+	/* ring buffer does cmpxchg, make sure it is safe in NMI context */
+	if (!IS_ENABLED(CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG) &&
+	    (unlikely(in_nmi()))) {
+		return NULL;
+	}
+
 	rb_start_commit(cpu_buffer);
 
 #ifdef CONFIG_RING_BUFFER_ALLOW_SWAP
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5EF2F3C19;
	Tue,  6 Jan 2026 17:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720876; cv=none; b=YGlWEfqUNkFKfP7Sf2u8sqiKeLoS/989rfp0d9IcI636EOTxeJV9bVWRex9qT9Re4p6NnwNm/imX3EJJmrC/WyMKcMNkGNjanPHM2QylqI2wKHoPtwh3LQazGg/HTsWCZM5bQKv6GE/OkDzFh2+1Xy/5B6RwersOTDHebLAo0lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720876; c=relaxed/simple;
	bh=13G6bRBOfYZh9lqXFcxrqiMo93MglwmpeunW1SntUx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4foZxZqxKOaojXnxJl5avgWVf+xrxdMoz94cBlnhzjclcG3H7c6H4XQIFtIMs8q5rVLajWo4LyC7Xi0PJKgST9yYfB26c1wM1j20yrLpg0iHNWDyPSaa9pMhJWRGP1r1FbZYDFalb30fUu6HElrq0ccAlUvmC5haIUdPdpxcEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cqxvKnhR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cqxvKnhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D731C19425;
	Tue,  6 Jan 2026 17:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720876;
	bh=13G6bRBOfYZh9lqXFcxrqiMo93MglwmpeunW1SntUx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cqxvKnhRPi8oQ31mCPno4FgVKcGY0cDu/uKSpJfxYIxY/KESA4HMSvDjPqqDWcAJH
	 Bv0KYdRe/c6CNkAkpg8onOsFk4K78YQ4dTXIG449k+KhqdVEbQ30eyDexez/5C7Rmy
	 DaVXmBgzzSPgiK62m2WbWxtStAig+GsNMCTRbADY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wang.yaxin@zte.com.cn,
	mhiramat@kernel.org,
	mark.rutland@arm.com,
	mathieu.desnoyers@efficios.com,
	zhang.run@zte.com.cn,
	yang.yang29@zte.com.cn,
	Shengming Hu <hu.shengming@zte.com.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 368/567] fgraph: Initialize ftrace_ops->private for function graph ops
Date: Tue,  6 Jan 2026 18:02:30 +0100
Message-ID: <20260106170504.954826214@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Shengming Hu <hu.shengming@zte.com.cn>

commit b5d6d3f73d0bac4a7e3a061372f6da166fc6ee5c upstream.

The ftrace_pids_enabled(op) check relies on op->private being properly
initialized, but fgraph_ops's underlying ftrace_ops->private was left
uninitialized. This caused ftrace_pids_enabled() to always return false,
effectively disabling PID filtering for function graph tracing.

Fix this by copying src_ops->private to dst_ops->private in
fgraph_init_ops(), ensuring PID filter state is correctly propagated.

Cc: stable@vger.kernel.org
Cc: <wang.yaxin@zte.com.cn>
Cc: <mhiramat@kernel.org>
Cc: <mark.rutland@arm.com>
Cc: <mathieu.desnoyers@efficios.com>
Cc: <zhang.run@zte.com.cn>
Cc: <yang.yang29@zte.com.cn>
Fixes: c132be2c4fcc1 ("function_graph: Have the instances use their own ftrace_ops for filtering")
Link: https://patch.msgid.link/20251126172926004y3hC8QyU4WFOjBkU_UxLC@zte.com.cn
Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/fgraph.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/trace/fgraph.c
+++ b/kernel/trace/fgraph.c
@@ -943,6 +943,7 @@ void fgraph_init_ops(struct ftrace_ops *
 		mutex_init(&dst_ops->local_hash.regex_lock);
 		INIT_LIST_HEAD(&dst_ops->subop_list);
 		dst_ops->flags |= FTRACE_OPS_FL_INITIALIZED;
+		dst_ops->private = src_ops->private;
 	}
 #endif
 }



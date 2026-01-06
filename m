Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE163644BE;
	Tue,  6 Jan 2026 17:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721988; cv=none; b=Go/NYFg47F2cZshUGet5aFStzNaKwhYDXdGXG+VXldhJ1xhiFiAhJorV0FrdGIzKGMm/DytXdhqbaHNxTi3Fddz6pESkjl121yYmSVGffjpdSY0ayQ3Fm/YQ/9gjaNvJ4b1274kR8himt3ntX5gZ1205pOPEr1ZCd9zHiuOyZlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721988; c=relaxed/simple;
	bh=DUAfrA4EVcG/fASPY7jqL0rYDaelLH2o+FYYwlRCxrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pfKaNkuL2+R4IMku6AAByhG0+cpGVsu2WmZFkg+OedlaM9rcC9z3AZzmQDp1btvqrqZMBIZNJ00XVoy9EmjYjoluM5bQ9bC/Vc6wqjccnIhAmd/HbN9+gJjWy67Q9V+w5dIgUweAKTmcce33WVnDUi8x1ZD6bdwkv8SGTD7JzWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ri2E7Dv5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ri2E7Dv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E8EC116C6;
	Tue,  6 Jan 2026 17:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721988;
	bh=DUAfrA4EVcG/fASPY7jqL0rYDaelLH2o+FYYwlRCxrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ri2E7Dv5LkcaVbMmkwnY/x6UOGLeZLa3VZAURCa5NHzWDVcomIy8nlMSUzEXJk/Gv
	 auvnshe9oLGQw6JZMqjvRputywdxs67XQNNbDfniJwsdVw6BkDfDq3UHdu/BkUSk0R
	 csim7XZ+63HZ2SlTYIAG7dqoIKHMZ509ymn0UBdU=
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
Subject: [PATCH 6.18 124/312] fgraph: Initialize ftrace_ops->private for function graph ops
Date: Tue,  6 Jan 2026 18:03:18 +0100
Message-ID: <20260106170552.330383637@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1019,6 +1019,7 @@ void fgraph_init_ops(struct ftrace_ops *
 		mutex_init(&dst_ops->local_hash.regex_lock);
 		INIT_LIST_HEAD(&dst_ops->subop_list);
 		dst_ops->flags |= FTRACE_OPS_FL_INITIALIZED;
+		dst_ops->private = src_ops->private;
 	}
 #endif
 }



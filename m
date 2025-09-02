Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435D4305076;
	Tue,  2 Sep 2025 13:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819890; cv=none; b=pPOd07aEORQ+h0kJXBQH+uQS8tLOTWFWdD+wLVbQnHLq8pqhnd/OurmBw694MTQJAscvgQoeczIh2XIKFBtrDoUNDQk6OTsuVHsBR39du4dacLkCBVBF0VPsSa2/CVOq2tNH+bznd/IWuU4Gu5NnWKSWlU1GNYhy8YVWp0gnoZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819890; c=relaxed/simple;
	bh=A/H7RSy1GPaI7c8IMD/jzCg+mM9b7PGRlFLH97bMrPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vB6Uj8S6lvnCh9V8sCzFDSmiZXMmRdr3DqfbemWXC/PGoFXN4UZEzxMEDZezBxfUaha63dkKhi3XB2FUr7IU4gaHCWlGFGCqqAeJ64BX5Z5GQFFWH9Ms/6c2be1JtuRuHzqPTGMNeS/Ofr6ohFJZbpBe0Wqe9h15xPLkSDt4j/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qm43NTLx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qm43NTLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94F5C4CEF4;
	Tue,  2 Sep 2025 13:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819890;
	bh=A/H7RSy1GPaI7c8IMD/jzCg+mM9b7PGRlFLH97bMrPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qm43NTLx1adr4Clwg+M/hXIS8ldS5LPWVsn/aRpJIKgEegCGfZdQTsEo1WEOHHPxW
	 an19GTshK+9FjSqMhJpoaVugDiywaFLGqEvKLMUYroLCU+VF19OL/a8S1VCj8bhJF7
	 D+4mVyXzLBVp4Q2g5X1kw7MoH3Hsm8r7G5bJbN0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Ye Weihua <yeweihua4@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 03/95] trace/fgraph: Fix the warning caused by missing unregister notifier
Date: Tue,  2 Sep 2025 15:19:39 +0200
Message-ID: <20250902131939.742134593@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Weihua <yeweihua4@huawei.com>

[ Upstream commit edede7a6dcd7435395cf757d053974aaab6ab1c2 ]

This warning was triggered during testing on v6.16:

notifier callback ftrace_suspend_notifier_call already registered
WARNING: CPU: 2 PID: 86 at kernel/notifier.c:23 notifier_chain_register+0x44/0xb0
...
Call Trace:
 <TASK>
 blocking_notifier_chain_register+0x34/0x60
 register_ftrace_graph+0x330/0x410
 ftrace_profile_write+0x1e9/0x340
 vfs_write+0xf8/0x420
 ? filp_flush+0x8a/0xa0
 ? filp_close+0x1f/0x30
 ? do_dup2+0xaf/0x160
 ksys_write+0x65/0xe0
 do_syscall_64+0xa4/0x260
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

When writing to the function_profile_enabled interface, the notifier was
not unregistered after start_graph_tracing failed, causing a warning the
next time function_profile_enabled was written.

Fixed by adding unregister_pm_notifier in the exception path.

Link: https://lore.kernel.org/20250818073332.3890629-1-yeweihua4@huawei.com
Fixes: 4a2b8dda3f870 ("tracing/function-graph-tracer: fix a regression while suspend to disk")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Ye Weihua <yeweihua4@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/fgraph.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/fgraph.c b/kernel/trace/fgraph.c
index c12335499ec91..2eed8bc672f91 100644
--- a/kernel/trace/fgraph.c
+++ b/kernel/trace/fgraph.c
@@ -1316,6 +1316,7 @@ int register_ftrace_graph(struct fgraph_ops *gops)
 		ftrace_graph_active--;
 		gops->saved_func = NULL;
 		fgraph_lru_release_index(i);
+		unregister_pm_notifier(&ftrace_suspend_notifier);
 	}
 	return ret;
 }
-- 
2.50.1




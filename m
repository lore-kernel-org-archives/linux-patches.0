Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072B53AFB07;
	Sat, 17 Oct 2026 17:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258132; cv=none; b=pnVCYTr7ee9dVsPKFf89pW4gOo3K6m0Hzf1aBIoGg9iCWL3gq8NOnAWihQHoMZxwgY4p7VrrfGhSvoO0cPBV3h94XB0ItOHP57pfgxPLjIQtcPx8HhSKHGbaoSzh/rsBGpe6bokuBs1npGOPQR7wtLxAM7CNkBiS9mkjC2Yn2ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258132; c=relaxed/simple;
	bh=on+Q9DLPHBDVlpO7alBBA/8lKIv/qTGqOsgmMsK/yzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FrcXlEt8wzoNAVuu5XOfGCQsWDPhMI8lBNc5zR44wCTnEPOSF5qgPZ/3mYLI4jnv7rtfld/iG48T15ugkMFuMRGQTkbLoW/z1oj3WuHp87dlBDnXZEta/qsAmmnrTJamUhBOwzx0dOs1RhcEeSc0nBIALg6zZiGKmuy0znL3SqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CJj0KMLd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CJj0KMLd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8EA1F000C4;
	Sat, 17 Oct 2026 17:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258129;
	bh=scgKCjjIQOgaKCNPak8wYWalRyQ6Ied1HNIJJyB1ZPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CJj0KMLdTFgcDuH+vgCfVUvL5d0X8m6RQR2wVozRsi3Ka/c758P1FdejVHZCJ3rdy
	 pRhDM8niz4mETPmI3qv02DEARhc1Q7bYXtq8LdNpvyANmVKSS1Rw3qaesk07AdetT4
	 iuWqZ+dqUJxcaWISg6Segx/QLHA7rSWvq43tnfZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Ye Weihua <yeweihua4@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0781/1674] trace/fgraph: Fix the warning caused by missing unregister notifier
Date: Sat, 17 Oct 2026 17:50:53 +0200
Message-ID: <20261017160451.152007171@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c83c005e654e3..f7e0ade90500c 100644
--- a/kernel/trace/fgraph.c
+++ b/kernel/trace/fgraph.c
@@ -648,6 +648,7 @@ int register_ftrace_graph(struct fgraph_ops *gops)
 	ret = start_graph_tracing();
 	if (ret) {
 		ftrace_graph_active--;
+		unregister_pm_notifier(&ftrace_suspend_notifier);
 		goto out;
 	}
 
-- 
2.53.0




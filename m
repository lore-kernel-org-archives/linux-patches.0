Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282D61C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3F9C433C1;
	Wed, 23 Nov 2022 09:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194979;
	bh=YAx0O8hu4W+XO3DC1SvBaGe0aeZ1TmlGsoJNDEZiJNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MwdG3pZnPNQNVBo1W+9tJxOM6xD+8aHNqcKqTwa7GsR2e9Z4k8nX9pzalb4kD239I
	 umI+lo1Xz8nvp3Dlq0UTm8sB6QdYffwvfZ4GzIbJWVuSup9UX9yWsCkqEvvvR17DWO
	 CpLrQ96oBQpchLEmfHPFcOcuwRS74N5qdfjz8/g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiu Jianfeng <xiujianfeng@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 113/156] ftrace: Fix null pointer dereference in ftrace_add_mod()
Date: Wed, 23 Nov 2022 09:51:10 +0100
Message-Id: <20221123084602.044152049@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiu Jianfeng <xiujianfeng@huawei.com>

commit 19ba6c8af9382c4c05dc6a0a79af3013b9a35cd0 upstream.

The @ftrace_mod is allocated by kzalloc(), so both the members {prev,next}
of @ftrace_mode->list are NULL, it's not a valid state to call list_del().
If kstrdup() for @ftrace_mod->{func|module} fails, it goes to @out_free
tag and calls free_ftrace_mod() to destroy @ftrace_mod, then list_del()
will write prev->next and next->prev, where null pointer dereference
happens.

BUG: kernel NULL pointer dereference, address: 0000000000000008
Oops: 0002 [#1] PREEMPT SMP NOPTI
Call Trace:
 <TASK>
 ftrace_mod_callback+0x20d/0x220
 ? do_filp_open+0xd9/0x140
 ftrace_process_regex.isra.51+0xbf/0x130
 ftrace_regex_write.isra.52.part.53+0x6e/0x90
 vfs_write+0xee/0x3a0
 ? __audit_filter_op+0xb1/0x100
 ? auditd_test_task+0x38/0x50
 ksys_write+0xa5/0xe0
 do_syscall_64+0x3a/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
Kernel panic - not syncing: Fatal exception

So call INIT_LIST_HEAD() to initialize the list member to fix this issue.

Link: https://lkml.kernel.org/r/20221116015207.30858-1-xiujianfeng@huawei.com

Cc: stable@vger.kernel.org
Fixes: 673feb9d76ab ("ftrace: Add :mod: caching infrastructure to trace_array")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1307,6 +1307,7 @@ static int ftrace_add_mod(struct trace_a
 	if (!ftrace_mod)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&ftrace_mod->list);
 	ftrace_mod->func = kstrdup(func, GFP_KERNEL);
 	ftrace_mod->module = kstrdup(module, GFP_KERNEL);
 	ftrace_mod->enable = enable;



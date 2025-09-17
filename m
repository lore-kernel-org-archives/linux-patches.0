Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B62436D;
	Wed, 17 Sep 2025 12:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112629; cv=none; b=DJgMdoX2iL362xuBLvuaZcAxk5qlHs7rYT/b9I3haesCrsAn1/d5sacehc3oyKxWv5+bzYNV1gcO+USUfFOmzpU1p0BvGc6+EV2sSvcUsuYEIS1RTf9yt/NStGIZp9C5glIlF3SMTk/g4w2uo4GLoftpRq21IrZ3drA7TLg1CII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112629; c=relaxed/simple;
	bh=ZrSsW45VwnRTugYZp/3wnPxgOObLG1qiH8OYzfXNsB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tz8B/OU9q57imXMKSjw6KmE17HpMdGRhbz8jsRrgJdq0fNJMfpDOOeMF+Yzj/sVwzuPgOwxPQlxZ1ibmUbF+ST1p3qnngdLPDDmuyeHaIKcG2VffChgvnoxedDqKY/gaakzBMl6jqCO0SyA4Wqgqf/zepHzNgFr0wFP86fKR8Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UfxpWEmH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UfxpWEmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB66C4CEF5;
	Wed, 17 Sep 2025 12:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112629;
	bh=ZrSsW45VwnRTugYZp/3wnPxgOObLG1qiH8OYzfXNsB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UfxpWEmH0Q6SBDElUS2N/xaobPZNr7zZSJcDjCKYWWFQYyj+PJfSSWGnebtAIb3bC
	 iz3I4J/53rXy7zBbI4LjnrPkVxC5GNqHHWO74ZrfV8/HSIjQ5g9norwyz4nljyHOdn
	 NqwAprMI71i6INSC840RVYsFJXxlq9XHvd9EGh94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	tglozar@redhat.com,
	Wang Liang <wangliang74@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 028/189] tracing/osnoise: Fix null-ptr-deref in bitmap_parselist()
Date: Wed, 17 Sep 2025 14:32:18 +0200
Message-ID: <20250917123352.541957142@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Liang <wangliang74@huawei.com>

[ Upstream commit c1628c00c4351dd0727ef7f670694f68d9e663d8 ]

A crash was observed with the following output:

BUG: kernel NULL pointer dereference, address: 0000000000000010
Oops: Oops: 0000 [#1] SMP NOPTI
CPU: 2 UID: 0 PID: 92 Comm: osnoise_cpus Not tainted 6.17.0-rc4-00201-gd69eb204c255 #138 PREEMPT(voluntary)
RIP: 0010:bitmap_parselist+0x53/0x3e0
Call Trace:
 <TASK>
 osnoise_cpus_write+0x7a/0x190
 vfs_write+0xf8/0x410
 ? do_sys_openat2+0x88/0xd0
 ksys_write+0x60/0xd0
 do_syscall_64+0xa4/0x260
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

This issue can be reproduced by below code:

fd=open("/sys/kernel/debug/tracing/osnoise/cpus", O_WRONLY);
write(fd, "0-2", 0);

When user pass 'count=0' to osnoise_cpus_write(), kmalloc() will return
ZERO_SIZE_PTR (16) and cpulist_parse() treat it as a normal value, which
trigger the null pointer dereference. Add check for the parameter 'count'.

Cc: <mhiramat@kernel.org>
Cc: <mathieu.desnoyers@efficios.com>
Cc: <tglozar@redhat.com>
Link: https://lore.kernel.org/20250906035610.3880282-1-wangliang74@huawei.com
Fixes: 17f89102fe23 ("tracing/osnoise: Allow arbitrarily long CPU string")
Signed-off-by: Wang Liang <wangliang74@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_osnoise.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index fd259da0aa645..337bc0eb5d71b 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -2322,6 +2322,9 @@ osnoise_cpus_write(struct file *filp, const char __user *ubuf, size_t count,
 	int running, err;
 	char *buf __free(kfree) = NULL;
 
+	if (count < 1)
+		return 0;
+
 	buf = kmalloc(count, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E5B2BEFE3;
	Tue, 26 Aug 2025 11:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207812; cv=none; b=e77CIUYtbITTz3GLX2wnWFRkUqEQ7JaCvHOWP7wa65oeIeLnaV2zEcw3kvmzPaAZih8jD+j/+dRUDGaBs6tXPGWZTuMOo2RMmyANO3AK/w+r6FXE+K9O5rTVG2UwiBFX6xgMDS/J7izGMXUVWLkH+1F9ZkC+il98mxnEUc+R+Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207812; c=relaxed/simple;
	bh=OTWKgj9hnP2mRnUON06KuAs849OTiJXBzh5dTLeRvwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+pcVOHHinvmDw92G2A+QiIgVJrVPvjsRbrxcS9gdazLN8Q+9lVMCa6n0+4q2lY4Z04thQfzp7rsYG48MUFv+RWTRNOsjMId70F3yXivuzcnrKZRMAJZiE1znRL5HdfsiTu+psV7g9C09ewMOdpPermsXBe8aQRR5Qx50PGT8QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dk+wosTA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dk+wosTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF27C4CEF1;
	Tue, 26 Aug 2025 11:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207812;
	bh=OTWKgj9hnP2mRnUON06KuAs849OTiJXBzh5dTLeRvwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dk+wosTAi58t4t46kVPRo4dvGvF05nvpoNsK0ZQjgsbyV61IWhP/NcTStaqjiuu0F
	 bi1jme0nLTZVqAlfm/uGS9eRaDOgyuO0xMNgDKmZTnVXm+dMODWGKv6Q7vbLjrLt0T
	 lLhaYlnQFRC24Cxly/zWZpeFIQEAkXq72NAmsIaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 327/457] tracing: Limit access to parser->buffer when trace_get_user failed
Date: Tue, 26 Aug 2025 13:10:11 +0200
Message-ID: <20250826110945.426909244@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 6a909ea83f226803ea0e718f6e88613df9234d58 ]

When the length of the string written to set_ftrace_filter exceeds
FTRACE_BUFF_MAX, the following KASAN alarm will be triggered:

BUG: KASAN: slab-out-of-bounds in strsep+0x18c/0x1b0
Read of size 1 at addr ffff0000d00bd5ba by task ash/165

CPU: 1 UID: 0 PID: 165 Comm: ash Not tainted 6.16.0-g6bcdbd62bd56-dirty
Hardware name: linux,dummy-virt (DT)
Call trace:
 show_stack+0x34/0x50 (C)
 dump_stack_lvl+0xa0/0x158
 print_address_description.constprop.0+0x88/0x398
 print_report+0xb0/0x280
 kasan_report+0xa4/0xf0
 __asan_report_load1_noabort+0x20/0x30
 strsep+0x18c/0x1b0
 ftrace_process_regex.isra.0+0x100/0x2d8
 ftrace_regex_release+0x484/0x618
 __fput+0x364/0xa58
 ____fput+0x28/0x40
 task_work_run+0x154/0x278
 do_notify_resume+0x1f0/0x220
 el0_svc+0xec/0xf0
 el0t_64_sync_handler+0xa0/0xe8
 el0t_64_sync+0x1ac/0x1b0

The reason is that trace_get_user will fail when processing a string
longer than FTRACE_BUFF_MAX, but not set the end of parser->buffer to 0.
Then an OOB access will be triggered in ftrace_regex_release->
ftrace_process_regex->strsep->strpbrk. We can solve this problem by
limiting access to parser->buffer when trace_get_user failed.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/20250813040232.1344527-1-pulehui@huaweicloud.com
Fixes: 8c9af478c06b ("ftrace: Handle commands when closing set_ftrace_filter file")
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |   18 ++++++++++++------
 kernel/trace/trace.h |    8 +++++++-
 2 files changed, 19 insertions(+), 7 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1846,7 +1846,7 @@ int trace_get_user(struct trace_parser *
 
 	ret = get_user(ch, ubuf++);
 	if (ret)
-		return ret;
+		goto fail;
 
 	read++;
 	cnt--;
@@ -1860,7 +1860,7 @@ int trace_get_user(struct trace_parser *
 		while (cnt && isspace(ch)) {
 			ret = get_user(ch, ubuf++);
 			if (ret)
-				return ret;
+				goto fail;
 			read++;
 			cnt--;
 		}
@@ -1878,12 +1878,14 @@ int trace_get_user(struct trace_parser *
 	while (cnt && !isspace(ch) && ch) {
 		if (parser->idx < parser->size - 1)
 			parser->buffer[parser->idx++] = ch;
-		else
-			return -EINVAL;
+		else {
+			ret = -EINVAL;
+			goto fail;
+		}
 
 		ret = get_user(ch, ubuf++);
 		if (ret)
-			return ret;
+			goto fail;
 		read++;
 		cnt--;
 	}
@@ -1898,11 +1900,15 @@ int trace_get_user(struct trace_parser *
 		/* Make sure the parsed string always terminates with '\0'. */
 		parser->buffer[parser->idx] = 0;
 	} else {
-		return -EINVAL;
+		ret = -EINVAL;
+		goto fail;
 	}
 
 	*ppos += read;
 	return read;
+fail:
+	trace_parser_fail(parser);
+	return ret;
 }
 
 /* TODO add a seq_buf_to_buffer() */
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1292,6 +1292,7 @@ bool ftrace_event_is_function(struct tra
  */
 struct trace_parser {
 	bool		cont;
+	bool		fail;
 	char		*buffer;
 	unsigned	idx;
 	unsigned	size;
@@ -1299,7 +1300,7 @@ struct trace_parser {
 
 static inline bool trace_parser_loaded(struct trace_parser *parser)
 {
-	return (parser->idx != 0);
+	return !parser->fail && parser->idx != 0;
 }
 
 static inline bool trace_parser_cont(struct trace_parser *parser)
@@ -1313,6 +1314,11 @@ static inline void trace_parser_clear(st
 	parser->idx = 0;
 }
 
+static inline void trace_parser_fail(struct trace_parser *parser)
+{
+	parser->fail = true;
+}
+
 extern int trace_parser_get_init(struct trace_parser *parser, int size);
 extern void trace_parser_put(struct trace_parser *parser);
 extern int trace_get_user(struct trace_parser *parser, const char __user *ubuf,



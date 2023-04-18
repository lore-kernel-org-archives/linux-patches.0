Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6313D2566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D268BC433D2;
	Tue, 18 Apr 2023 12:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821206;
	bh=hdBRzJ09ojHdhzBgNZGolVrkfb0OKPCv4xaYzsyE4LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VrKxv8G5vJMYPWJTT8QGADYTqkUO6NNwKxclOkMFag0Wx7HliY0q4GXqHZM1akGzW
	 SQiQGd7Xhj29id3ixdlLwJBz36NuQ6XbZ9Jhnon6hKSBrdTDg9qCVH8IJNQTLmqruR
	 ofTst69cQYBrN3qoM0nvrSuWneEyzgo1/oEIIw9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	mhiramat@kernel.org,
	mark.rutland@arm.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	Zheng Yejian <zhengyejian1@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 039/124] ftrace: Fix issue that direct->addr not restored in modify_ftrace_direct()
Date: Tue, 18 Apr 2023 14:20:58 +0200
Message-Id: <20230418120311.242391812@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zheng Yejian <zhengyejian1@huawei.com>

commit 2a2d8c51defb446e8d89a83f42f8e5cd529111e9 upstream.

Syzkaller report a WARNING: "WARN_ON(!direct)" in modify_ftrace_direct().

Root cause is 'direct->addr' was changed from 'old_addr' to 'new_addr' but
not restored if error happened on calling ftrace_modify_direct_caller().
Then it can no longer find 'direct' by that 'old_addr'.

To fix it, restore 'direct->addr' to 'old_addr' explicitly in error path.

Link: https://lore.kernel.org/linux-trace-kernel/20230330025223.1046087-1-zhengyejian1@huawei.com

Cc: stable@vger.kernel.org
Cc: <mhiramat@kernel.org>
Cc: <mark.rutland@arm.com>
Cc: <ast@kernel.org>
Cc: <daniel@iogearbox.net>
Fixes: 8a141dd7f706 ("ftrace: Fix modify_ftrace_direct.")
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5390,12 +5390,15 @@ int modify_ftrace_direct(unsigned long i
 		ret = 0;
 	}
 
-	if (unlikely(ret && new_direct)) {
-		direct->count++;
-		list_del_rcu(&new_direct->next);
-		synchronize_rcu_tasks();
-		kfree(new_direct);
-		ftrace_direct_func_count--;
+	if (ret) {
+		direct->addr = old_addr;
+		if (unlikely(new_direct)) {
+			direct->count++;
+			list_del_rcu(&new_direct->next);
+			synchronize_rcu_tasks();
+			kfree(new_direct);
+			ftrace_direct_func_count--;
+		}
 	}
 
  out_unlock:



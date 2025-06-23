Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3544136348;
	Mon, 23 Jun 2025 21:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715491; cv=none; b=gXHLs/azTeXYxcHyrelxBUiygtA3UQbwiHJH1oi5TdYbkk79RKqNccQQAeeZW35fbcXh+jksGW/lok5viQZuKyaK+l/pHzuhPutxqwHbUrOUWWN98CYcfJt11F9rk3uJ3bIsLhjfxcs5ayayapaK32W+9wfs1JGzkUqUQMfVBUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715491; c=relaxed/simple;
	bh=Cd1b5omrIMH+PNj5iozbZrJjk7vkQ0kBIlxxQ37gYRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ekr4BUXSWUsrjNnLF6Kklj/EEhMIS7/Bx3zHaIhiCaSmtZOBHNB9xOGZUsnJpIjO1oWl6hHnL2k22g6S08qbWyfnLg5/ak96drsuT2HI+USmLJc6zQ1kPAUFLuAcr2Y3ZnRrdPzZjeLCAcCO/1j1OGoCZ1U+Ogl9QFmkcK9APfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WxZFQZ0Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WxZFQZ0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A32AC4CEEA;
	Mon, 23 Jun 2025 21:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715491;
	bh=Cd1b5omrIMH+PNj5iozbZrJjk7vkQ0kBIlxxQ37gYRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WxZFQZ0ZKfLS2d0J8lmEufRW0fKPjGzBRfGaWlMeVqImdATD2XKkoMybRe2FZZqVq
	 zX/rl0QrtO0R9eIkeTNGfj2UK/xriqbJ10MulnCeHSj8Gb1bQVdhzQoY26yMZkLvlz
	 wtAA2MC5vysWWjvQmAWPqCWzUTGJJqdm4sfKhJJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 264/508] perf: Ensure bpf_perf_link path is properly serialized
Date: Mon, 23 Jun 2025 15:05:09 +0200
Message-ID: <20250623130651.742393239@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 7ed9138a72829d2035ecbd8dbd35b1bc3c137c40 ]

Ravi reported that the bpf_perf_link_attach() usage of
perf_event_set_bpf_prog() is not serialized by ctx->mutex, unlike the
PERF_EVENT_IOC_SET_BPF case.

Reported-by: Ravi Bangoria <ravi.bangoria@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Ravi Bangoria <ravi.bangoria@amd.com>
Link: https://lkml.kernel.org/r/20250307193305.486326750@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 3544f26b58060..25df8971a56ed 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5726,6 +5726,9 @@ static int perf_event_set_output(struct perf_event *event,
 static int perf_event_set_filter(struct perf_event *event, void __user *arg);
 static int perf_copy_attr(struct perf_event_attr __user *uattr,
 			  struct perf_event_attr *attr);
+static int __perf_event_set_bpf_prog(struct perf_event *event,
+				     struct bpf_prog *prog,
+				     u64 bpf_cookie);
 
 static long _perf_ioctl(struct perf_event *event, unsigned int cmd, unsigned long arg)
 {
@@ -5794,7 +5797,7 @@ static long _perf_ioctl(struct perf_event *event, unsigned int cmd, unsigned lon
 		if (IS_ERR(prog))
 			return PTR_ERR(prog);
 
-		err = perf_event_set_bpf_prog(event, prog, 0);
+		err = __perf_event_set_bpf_prog(event, prog, 0);
 		if (err) {
 			bpf_prog_put(prog);
 			return err;
@@ -10350,8 +10353,9 @@ static inline bool perf_event_is_tracing(struct perf_event *event)
 	return false;
 }
 
-int perf_event_set_bpf_prog(struct perf_event *event, struct bpf_prog *prog,
-			    u64 bpf_cookie)
+static int __perf_event_set_bpf_prog(struct perf_event *event,
+				     struct bpf_prog *prog,
+				     u64 bpf_cookie)
 {
 	bool is_kprobe, is_uprobe, is_tracepoint, is_syscall_tp;
 
@@ -10389,6 +10393,20 @@ int perf_event_set_bpf_prog(struct perf_event *event, struct bpf_prog *prog,
 	return perf_event_attach_bpf_prog(event, prog, bpf_cookie);
 }
 
+int perf_event_set_bpf_prog(struct perf_event *event,
+			    struct bpf_prog *prog,
+			    u64 bpf_cookie)
+{
+	struct perf_event_context *ctx;
+	int ret;
+
+	ctx = perf_event_ctx_lock(event);
+	ret = __perf_event_set_bpf_prog(event, prog, bpf_cookie);
+	perf_event_ctx_unlock(event, ctx);
+
+	return ret;
+}
+
 void perf_event_free_bpf_prog(struct perf_event *event)
 {
 	if (!perf_event_is_tracing(event)) {
@@ -10408,7 +10426,15 @@ static void perf_event_free_filter(struct perf_event *event)
 {
 }
 
-int perf_event_set_bpf_prog(struct perf_event *event, struct bpf_prog *prog,
+static int __perf_event_set_bpf_prog(struct perf_event *event,
+				     struct bpf_prog *prog,
+				     u64 bpf_cookie)
+{
+	return -ENOENT;
+}
+
+int perf_event_set_bpf_prog(struct perf_event *event,
+			    struct bpf_prog *prog,
 			    u64 bpf_cookie)
 {
 	return -ENOENT;
-- 
2.39.5




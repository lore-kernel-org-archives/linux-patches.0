Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227CE2ED868;
	Tue, 17 Jun 2025 16:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178295; cv=none; b=lFgogRb+CnNu5TdI9xdQtknO4M9hPLLaXMuL7EJRocm39IYz19pZ2dkCYS5ct2O3dLfgY4MOLeJcQNfl0k8NJNkbmA0n63Bt5JR9tCfHVRuATzERYE2GxSoYIbxmkxjhPwfLlrtiV4ImTMW4vaj14E4rgLjNhJINKi/HMgIPj64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178295; c=relaxed/simple;
	bh=Va3txz1AOXN9W30RUo/3BGv8jOQYP1iYCJfuf7f5GcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YhDF9cs7p1GhYtuO0JRz7Rv5rlt+2P3gYXk+8t/VGkdkxmAF8JOuBksov+R8837IA51JqNU8dAaB9VD3IvRSxQWdswn5za+iuwxxhWfd2kX2xNvJKlKeK5ArDgXyy1TLNr71nAZscC2b4QJsZ6UGLmV1witYzfTMTrP8yVnRuXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNTYp/E3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNTYp/E3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F76C4CEE3;
	Tue, 17 Jun 2025 16:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178295;
	bh=Va3txz1AOXN9W30RUo/3BGv8jOQYP1iYCJfuf7f5GcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNTYp/E3k7I5aYLDdkx3sp/Jj6N/4QAYqHsyzuZan2yuqS39+SE2Na+zZqO8WaNu/
	 wq2dlMjDyQYnPZKNckqWd6Whkbp4iL1zTib8L7OTD6c7x86nB8OwXzgiA1seG1ul50
	 JEO88Q+YTF3jpf9kaMnM8/BR6iA2pQ/gJ6aIXU9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 475/512] perf: Ensure bpf_perf_link path is properly serialized
Date: Tue, 17 Jun 2025 17:27:21 +0200
Message-ID: <20250617152438.821524734@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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
index 8352376d82154..9ce82904f761d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6031,6 +6031,9 @@ static int perf_event_set_output(struct perf_event *event,
 static int perf_event_set_filter(struct perf_event *event, void __user *arg);
 static int perf_copy_attr(struct perf_event_attr __user *uattr,
 			  struct perf_event_attr *attr);
+static int __perf_event_set_bpf_prog(struct perf_event *event,
+				     struct bpf_prog *prog,
+				     u64 bpf_cookie);
 
 static long _perf_ioctl(struct perf_event *event, unsigned int cmd, unsigned long arg)
 {
@@ -6099,7 +6102,7 @@ static long _perf_ioctl(struct perf_event *event, unsigned int cmd, unsigned lon
 		if (IS_ERR(prog))
 			return PTR_ERR(prog);
 
-		err = perf_event_set_bpf_prog(event, prog, 0);
+		err = __perf_event_set_bpf_prog(event, prog, 0);
 		if (err) {
 			bpf_prog_put(prog);
 			return err;
@@ -10756,8 +10759,9 @@ static inline bool perf_event_is_tracing(struct perf_event *event)
 	return false;
 }
 
-int perf_event_set_bpf_prog(struct perf_event *event, struct bpf_prog *prog,
-			    u64 bpf_cookie)
+static int __perf_event_set_bpf_prog(struct perf_event *event,
+				     struct bpf_prog *prog,
+				     u64 bpf_cookie)
 {
 	bool is_kprobe, is_uprobe, is_tracepoint, is_syscall_tp;
 
@@ -10795,6 +10799,20 @@ int perf_event_set_bpf_prog(struct perf_event *event, struct bpf_prog *prog,
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
@@ -10814,7 +10832,15 @@ static void perf_event_free_filter(struct perf_event *event)
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




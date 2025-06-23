Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A7B21B9C9;
	Mon, 23 Jun 2025 21:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714099; cv=none; b=PtYJPr72LRPwajBRiPeLzw33Q/JaajdowmOJs+XcTYKdcpXccKXPPD+uuGsvQOgqRcMT47vJmRlSXCk26ynViWqeuBX4Cv9Nqc3WbhT4KZnl63VzJbKTNQqGMFdW0/Wz0kt+U5KafLkVSeaXzsdCopbgPP5Th84arAWsvHKpbM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714099; c=relaxed/simple;
	bh=wZsh6mRgNuKCylTmWCM88R0rFuVCg75U+SUdmIzORVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4eqokSTiI0eINqXn6t+CPgZ0lRVN1I/CBrrR7/K/u+EXJjtpHwTxWKd4ls8Fwei8xGPamzjo7LenStJRlww6vscDGsb2Wa8zpKm7k5BTbQj1GMd6FVxEMsWnMtDLBi0TPJW8/EdHZpScWqIOYAtPB9Ux/qwXwqkdFdLvD6bC/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gWnznvZ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gWnznvZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2E0C4CEEA;
	Mon, 23 Jun 2025 21:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714098;
	bh=wZsh6mRgNuKCylTmWCM88R0rFuVCg75U+SUdmIzORVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gWnznvZ5gPfFHwUV1GG7cJ8e69p5M3uDYbeaNZQMWly7+cECs1D+b9ZPXL7lCbkTw
	 lo2JgjGz/zSxIZMx2PFE4hQlK8ZeaoY70NymFsKBvNBJBetiSUf23brJps/loDTxiI
	 BK4OcKtAkRLAfVt5VchB/sHsquOSvf/xOQHQXFUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 165/411] perf: Ensure bpf_perf_link path is properly serialized
Date: Mon, 23 Jun 2025 15:05:09 +0200
Message-ID: <20250623130637.844528070@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cb0c8aa71c98b..dd9ae1cae8e3c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5822,6 +5822,9 @@ static int perf_event_set_output(struct perf_event *event,
 static int perf_event_set_filter(struct perf_event *event, void __user *arg);
 static int perf_copy_attr(struct perf_event_attr __user *uattr,
 			  struct perf_event_attr *attr);
+static int __perf_event_set_bpf_prog(struct perf_event *event,
+				     struct bpf_prog *prog,
+				     u64 bpf_cookie);
 
 static long _perf_ioctl(struct perf_event *event, unsigned int cmd, unsigned long arg)
 {
@@ -5890,7 +5893,7 @@ static long _perf_ioctl(struct perf_event *event, unsigned int cmd, unsigned lon
 		if (IS_ERR(prog))
 			return PTR_ERR(prog);
 
-		err = perf_event_set_bpf_prog(event, prog, 0);
+		err = __perf_event_set_bpf_prog(event, prog, 0);
 		if (err) {
 			bpf_prog_put(prog);
 			return err;
@@ -10360,8 +10363,9 @@ static inline bool perf_event_is_tracing(struct perf_event *event)
 	return false;
 }
 
-int perf_event_set_bpf_prog(struct perf_event *event, struct bpf_prog *prog,
-			    u64 bpf_cookie)
+static int __perf_event_set_bpf_prog(struct perf_event *event,
+				     struct bpf_prog *prog,
+				     u64 bpf_cookie)
 {
 	bool is_kprobe, is_tracepoint, is_syscall_tp;
 
@@ -10395,6 +10399,20 @@ int perf_event_set_bpf_prog(struct perf_event *event, struct bpf_prog *prog,
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
@@ -10414,7 +10432,15 @@ static void perf_event_free_filter(struct perf_event *event)
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




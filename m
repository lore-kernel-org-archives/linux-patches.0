Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633A318EFD0;
	Mon, 28 Oct 2024 06:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098007; cv=none; b=i7hxES2HDdLaJoC2IeINm0F2Q4R1RVQAeAyuHRF7GdZlTqqJ151gxXF85TR6RpjEr01R5GPcLeqOKA9zwTtvaPB8MGtRThwY8MNzVDXJSf70Ng/BYJKRiulQEVfM2VxNtXOFXPLKmlI3g7kEQnptWz0/bkFZdWnY+/n5IvuycGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098007; c=relaxed/simple;
	bh=DIhGOEAsHXw2/9u1+Qch7GqHHfRCNJYxXY7vjke8MJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHn8xCgqwfS6ZYS+J+pjVJI9qdcE40axvWDxeWdzQsWl+d6qRLW/Zoeb78m1ZL1bnifE5kLWHGcFkWTISYj7edbpPzJu3nyr2xnfQ6xY8K2Ek6Pa+gau3NoPZS3aDEQBwCq3xT/tuD9gM0c5qUe7OoAxAF0rOL/0pZecVWpyLf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fEcYslaU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fEcYslaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05699C4CEC3;
	Mon, 28 Oct 2024 06:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098007;
	bh=DIhGOEAsHXw2/9u1+Qch7GqHHfRCNJYxXY7vjke8MJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fEcYslaUi4ABeSahUjmGLUU+b0u8d04Wb7AHCH21/LIx+G4bNvVk+U2/ls4iUtiQw
	 11HIpX7Jr0+QgYQ0N7WLvoGKWmQe9Af4ewNw7fAMtfDXAJasawgLS/olEUfZ/aersq
	 NaWIG/M1SECs/hYz5jxMEDtoTyMhl4o4IkbC3jBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyrone Wu <wudevelops@gmail.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 019/261] bpf: fix unpopulated name_len field in perf_event link info
Date: Mon, 28 Oct 2024 07:22:41 +0100
Message-ID: <20241028062312.493583426@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyrone Wu <wudevelops@gmail.com>

[ Upstream commit 4deecdd29cf29844c7bd164d72dc38d2e672f64e ]

Previously when retrieving `bpf_link_info.perf_event` for
kprobe/uprobe/tracepoint, the `name_len` field was not populated by the
kernel, leaving it to reflect the value initially set by the user. This
behavior was inconsistent with how other input/output string buffer
fields function (e.g. `raw_tracepoint.tp_name_len`).

This patch fills `name_len` with the actual size of the string name.

Fixes: 1b715e1b0ec5 ("bpf: Support ->fill_link_info for perf_event")
Signed-off-by: Tyrone Wu <wudevelops@gmail.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Yafang Shao <laoar.shao@gmail.com>
Link: https://lore.kernel.org/r/20241008164312.46269-1-wudevelops@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 21fb9c4d498fb..26e69d4fc3dad 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3636,15 +3636,16 @@ static void bpf_perf_link_dealloc(struct bpf_link *link)
 }
 
 static int bpf_perf_link_fill_common(const struct perf_event *event,
-				     char __user *uname, u32 ulen,
+				     char __user *uname, u32 *ulenp,
 				     u64 *probe_offset, u64 *probe_addr,
 				     u32 *fd_type, unsigned long *missed)
 {
 	const char *buf;
-	u32 prog_id;
+	u32 prog_id, ulen;
 	size_t len;
 	int err;
 
+	ulen = *ulenp;
 	if (!ulen ^ !uname)
 		return -EINVAL;
 
@@ -3652,10 +3653,17 @@ static int bpf_perf_link_fill_common(const struct perf_event *event,
 				      probe_offset, probe_addr, missed);
 	if (err)
 		return err;
+
+	if (buf) {
+		len = strlen(buf);
+		*ulenp = len + 1;
+	} else {
+		*ulenp = 1;
+	}
 	if (!uname)
 		return 0;
+
 	if (buf) {
-		len = strlen(buf);
 		err = bpf_copy_to_user(uname, buf, ulen, len);
 		if (err)
 			return err;
@@ -3680,7 +3688,7 @@ static int bpf_perf_link_fill_kprobe(const struct perf_event *event,
 
 	uname = u64_to_user_ptr(info->perf_event.kprobe.func_name);
 	ulen = info->perf_event.kprobe.name_len;
-	err = bpf_perf_link_fill_common(event, uname, ulen, &offset, &addr,
+	err = bpf_perf_link_fill_common(event, uname, &ulen, &offset, &addr,
 					&type, &missed);
 	if (err)
 		return err;
@@ -3688,7 +3696,7 @@ static int bpf_perf_link_fill_kprobe(const struct perf_event *event,
 		info->perf_event.type = BPF_PERF_EVENT_KRETPROBE;
 	else
 		info->perf_event.type = BPF_PERF_EVENT_KPROBE;
-
+	info->perf_event.kprobe.name_len = ulen;
 	info->perf_event.kprobe.offset = offset;
 	info->perf_event.kprobe.missed = missed;
 	if (!kallsyms_show_value(current_cred()))
@@ -3710,7 +3718,7 @@ static int bpf_perf_link_fill_uprobe(const struct perf_event *event,
 
 	uname = u64_to_user_ptr(info->perf_event.uprobe.file_name);
 	ulen = info->perf_event.uprobe.name_len;
-	err = bpf_perf_link_fill_common(event, uname, ulen, &offset, &addr,
+	err = bpf_perf_link_fill_common(event, uname, &ulen, &offset, &addr,
 					&type, NULL);
 	if (err)
 		return err;
@@ -3719,6 +3727,7 @@ static int bpf_perf_link_fill_uprobe(const struct perf_event *event,
 		info->perf_event.type = BPF_PERF_EVENT_URETPROBE;
 	else
 		info->perf_event.type = BPF_PERF_EVENT_UPROBE;
+	info->perf_event.uprobe.name_len = ulen;
 	info->perf_event.uprobe.offset = offset;
 	info->perf_event.uprobe.cookie = event->bpf_cookie;
 	return 0;
@@ -3744,12 +3753,18 @@ static int bpf_perf_link_fill_tracepoint(const struct perf_event *event,
 {
 	char __user *uname;
 	u32 ulen;
+	int err;
 
 	uname = u64_to_user_ptr(info->perf_event.tracepoint.tp_name);
 	ulen = info->perf_event.tracepoint.name_len;
+	err = bpf_perf_link_fill_common(event, uname, &ulen, NULL, NULL, NULL, NULL);
+	if (err)
+		return err;
+
 	info->perf_event.type = BPF_PERF_EVENT_TRACEPOINT;
+	info->perf_event.tracepoint.name_len = ulen;
 	info->perf_event.tracepoint.cookie = event->bpf_cookie;
-	return bpf_perf_link_fill_common(event, uname, ulen, NULL, NULL, NULL, NULL);
+	return 0;
 }
 
 static int bpf_perf_link_fill_perf_event(const struct perf_event *event,
-- 
2.43.0




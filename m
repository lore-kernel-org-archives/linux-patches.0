Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93258189BAF;
	Mon, 28 Oct 2024 06:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097485; cv=none; b=e65bhzru6N9K8BpALvwZ/r/ff7Q4weKQL4OPB0tqcfLanWb8QI+suf/T5+WCec7mkxqr2fhFmfPZgCl+TS1HVdg9yGCZyy9lRKKRqAZExsV3Xjymbp5QURARztGxYEk9gFRuuh8hNZDwnfT/QdW067p+9cMLR62KsH48i9cIjhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097485; c=relaxed/simple;
	bh=xnacDO6xtnHG3hmgAomWXy05mYqJePl0yNHvkhx+UMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mayTfb1Np7+SpynVNc0SRzfO80IAkO7K24B2nGsGhuPKgBtxEnkvJs+pQNpcofE17G8+xmdFquTKdpz9E7Hmn0qxFt+2EqoeqYfKEnvP/V5/wlh6sbb9E2jkZKfB4DYfa6XVuoGSpx8BKjRBoNZhl7SYdIes/09PAl+WnJfiqJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KQ9313HC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KQ9313HC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33113C4CEC3;
	Mon, 28 Oct 2024 06:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097485;
	bh=xnacDO6xtnHG3hmgAomWXy05mYqJePl0yNHvkhx+UMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KQ9313HC5vkEY5XVs8+5YJfx2p5YDeyr2W+arhpOLO/V0i2OYMyWsa8d6qT/q+Gw0
	 F7PdAdogIKf1VT84UK340pCEKS3cblk8vqWP4rr78p5Ukwf+JYT4svSxj68XTSgV2z
	 AOhGXtwCbAwo3VqKjmnbFu1AbAgGw0GJze7ng6Mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Song Liu <song@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/208] bpf: Add cookie to perf_event bpf_link_info records
Date: Mon, 28 Oct 2024 07:23:14 +0100
Message-ID: <20241028062307.009820836@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit d5c16492c66fbfca85f36e42363d32212df5927b ]

At the moment we don't store cookie for perf_event probes,
while we do that for the rest of the probes.

Adding cookie fields to struct bpf_link_info perf event
probe records:

  perf_event.uprobe
  perf_event.kprobe
  perf_event.tracepoint
  perf_event.perf_event

And the code to store that in bpf_link_info struct.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Song Liu <song@kernel.org>
Acked-by: Yafang Shao <laoar.shao@gmail.com>
Link: https://lore.kernel.org/r/20240119110505.400573-2-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 4deecdd29cf2 ("bpf: fix unpopulated name_len field in perf_event link info")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/bpf.h       | 6 ++++++
 kernel/bpf/syscall.c           | 4 ++++
 tools/include/uapi/linux/bpf.h | 6 ++++++
 3 files changed, 16 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 6ea588d1ae149..431bc700bcfb9 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -6556,6 +6556,7 @@ struct bpf_link_info {
 					__aligned_u64 file_name; /* in/out */
 					__u32 name_len;
 					__u32 offset; /* offset from file_name */
+					__u64 cookie;
 				} uprobe; /* BPF_PERF_EVENT_UPROBE, BPF_PERF_EVENT_URETPROBE */
 				struct {
 					__aligned_u64 func_name; /* in/out */
@@ -6563,14 +6564,19 @@ struct bpf_link_info {
 					__u32 offset; /* offset from func_name */
 					__u64 addr;
 					__u64 missed;
+					__u64 cookie;
 				} kprobe; /* BPF_PERF_EVENT_KPROBE, BPF_PERF_EVENT_KRETPROBE */
 				struct {
 					__aligned_u64 tp_name;   /* in/out */
 					__u32 name_len;
+					__u32 :32;
+					__u64 cookie;
 				} tracepoint; /* BPF_PERF_EVENT_TRACEPOINT */
 				struct {
 					__u64 config;
 					__u32 type;
+					__u32 :32;
+					__u64 cookie;
 				} event; /* BPF_PERF_EVENT_EVENT */
 			};
 		} perf_event;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 9c76f21f187f6..1d04d098f57db 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3500,6 +3500,7 @@ static int bpf_perf_link_fill_kprobe(const struct perf_event *event,
 	if (!kallsyms_show_value(current_cred()))
 		addr = 0;
 	info->perf_event.kprobe.addr = addr;
+	info->perf_event.kprobe.cookie = event->bpf_cookie;
 	return 0;
 }
 #endif
@@ -3525,6 +3526,7 @@ static int bpf_perf_link_fill_uprobe(const struct perf_event *event,
 	else
 		info->perf_event.type = BPF_PERF_EVENT_UPROBE;
 	info->perf_event.uprobe.offset = offset;
+	info->perf_event.uprobe.cookie = event->bpf_cookie;
 	return 0;
 }
 #endif
@@ -3552,6 +3554,7 @@ static int bpf_perf_link_fill_tracepoint(const struct perf_event *event,
 	uname = u64_to_user_ptr(info->perf_event.tracepoint.tp_name);
 	ulen = info->perf_event.tracepoint.name_len;
 	info->perf_event.type = BPF_PERF_EVENT_TRACEPOINT;
+	info->perf_event.tracepoint.cookie = event->bpf_cookie;
 	return bpf_perf_link_fill_common(event, uname, ulen, NULL, NULL, NULL, NULL);
 }
 
@@ -3560,6 +3563,7 @@ static int bpf_perf_link_fill_perf_event(const struct perf_event *event,
 {
 	info->perf_event.event.type = event->attr.type;
 	info->perf_event.event.config = event->attr.config;
+	info->perf_event.event.cookie = event->bpf_cookie;
 	info->perf_event.type = BPF_PERF_EVENT_EVENT;
 	return 0;
 }
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index acda713f8b4d1..977ec094bc2a6 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -6559,6 +6559,7 @@ struct bpf_link_info {
 					__aligned_u64 file_name; /* in/out */
 					__u32 name_len;
 					__u32 offset; /* offset from file_name */
+					__u64 cookie;
 				} uprobe; /* BPF_PERF_EVENT_UPROBE, BPF_PERF_EVENT_URETPROBE */
 				struct {
 					__aligned_u64 func_name; /* in/out */
@@ -6566,14 +6567,19 @@ struct bpf_link_info {
 					__u32 offset; /* offset from func_name */
 					__u64 addr;
 					__u64 missed;
+					__u64 cookie;
 				} kprobe; /* BPF_PERF_EVENT_KPROBE, BPF_PERF_EVENT_KRETPROBE */
 				struct {
 					__aligned_u64 tp_name;   /* in/out */
 					__u32 name_len;
+					__u32 :32;
+					__u64 cookie;
 				} tracepoint; /* BPF_PERF_EVENT_TRACEPOINT */
 				struct {
 					__u64 config;
 					__u32 type;
+					__u32 :32;
+					__u64 cookie;
 				} event; /* BPF_PERF_EVENT_EVENT */
 			};
 		} perf_event;
-- 
2.43.0




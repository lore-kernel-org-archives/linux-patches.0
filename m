Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3736FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:16:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF1DC433C8;
	Sun, 17 Sep 2023 20:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981814;
	bh=svO+GXBMomxTW8JIT8sk5mtDy8FhwsU87K2uRVP/DEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R68jzA+/ONxpUwid6lawwKijSXoQNoYzurUNti6fSlVLTKFUqb8w23VUfjb9cFvr7
	 7/ZdJWFnCDWUpQg65UW8Ydi2ZdnYdNuj3zHDJCQUrMm3lbTJObMygeZhQUuZ95drpl
	 bgAOM2lYwBTEvuvSHeWLg/tfp4bg6I4C5ezTfaQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Daniel T. Lee" <danieltimlee@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/511] samples/bpf: fix broken map lookup probe
Date: Sun, 17 Sep 2023 21:08:57 +0200
Message-ID: <20230917191116.515297475@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel T. Lee <danieltimlee@gmail.com>

[ Upstream commit d93a7cf6ca2cfcd7de5d06f753ce8d5e863316ac ]

In the commit 7c4cd051add3 ("bpf: Fix syscall's stackmap lookup
potential deadlock"), a potential deadlock issue was addressed, which
resulted in *_map_lookup_elem not triggering BPF programs.
(prior to lookup, bpf_disable_instrumentation() is used)

To resolve the broken map lookup probe using "htab_map_lookup_elem",
this commit introduces an alternative approach. Instead, it utilize
"bpf_map_copy_value" and apply a filter specifically for the hash table
with map_type.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
Fixes: 7c4cd051add3 ("bpf: Fix syscall's stackmap lookup potential deadlock")
Link: https://lore.kernel.org/r/20230818090119.477441-8-danieltimlee@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/tracex6_kern.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/tracex6_kern.c b/samples/bpf/tracex6_kern.c
index acad5712d8b4f..fd602c2774b8b 100644
--- a/samples/bpf/tracex6_kern.c
+++ b/samples/bpf/tracex6_kern.c
@@ -2,6 +2,8 @@
 #include <linux/version.h>
 #include <uapi/linux/bpf.h>
 #include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
 
 struct {
 	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
@@ -45,13 +47,24 @@ int bpf_prog1(struct pt_regs *ctx)
 	return 0;
 }
 
-SEC("kprobe/htab_map_lookup_elem")
-int bpf_prog2(struct pt_regs *ctx)
+/*
+ * Since *_map_lookup_elem can't be expected to trigger bpf programs
+ * due to potential deadlocks (bpf_disable_instrumentation), this bpf
+ * program will be attached to bpf_map_copy_value (which is called
+ * from map_lookup_elem) and will only filter the hashtable type.
+ */
+SEC("kprobe/bpf_map_copy_value")
+int BPF_KPROBE(bpf_prog2, struct bpf_map *map)
 {
 	u32 key = bpf_get_smp_processor_id();
 	struct bpf_perf_event_value *val, buf;
+	enum bpf_map_type type;
 	int error;
 
+	type = BPF_CORE_READ(map, map_type);
+	if (type != BPF_MAP_TYPE_HASH)
+		return 0;
+
 	error = bpf_perf_event_read_value(&counters, key, &buf, sizeof(buf));
 	if (error)
 		return 0;
-- 
2.40.1




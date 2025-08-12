Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88441474CC;
	Tue, 12 Aug 2025 18:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024668; cv=none; b=E0Jm8y91bMR+Ud1Dk2fHWPck9KaIoMFM6iMbkYWKjH26vk/q/cfJ+uRNldMW39UV618LIR6/LqT6Y5HVTCDCXZS1rALXOYvhiPHh3gzm7SXHsPCEoo5UfrOML9S7bb2PL6rK/Ds8vIzt9u5HyZmklWyeZKaXXH5xUDInLFGxeVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024668; c=relaxed/simple;
	bh=gGRJa40i/8C82ph3Auio5YU9mV1vkB43s+ieeXBOTlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFV+Jx41cE92AkfJnqRa9o+LQweiQFDrdQJymh5BcMQYwZWriqMbhIO1pNqKJ2TP3iC1RkJCWohCkMmex9pQNTXvOAsA/lxXg63fPiBGVdRSTrWnIJswFSp7OHkuVJjsIGmi2aT3lwSfLmTgMEG2oOlShi8r3Qpj5fuQBVwfky0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qtXYrDKZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qtXYrDKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1B2C4CEF0;
	Tue, 12 Aug 2025 18:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024668;
	bh=gGRJa40i/8C82ph3Auio5YU9mV1vkB43s+ieeXBOTlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qtXYrDKZpWhxIqz3LFPxQgLxrQL1lDCLzgvRS6omlxmKHdA/yEiT47Y6ue3ZC6IpW
	 TOCH4DrLsAODRdPzX3iE18Bhb0FD2e+14jE61qEf5FPxA/XYTp6IV2IlW3E2H4LKBL
	 7zbN3P6teck88OOtfVcuyDRa/YBDnnlbTbrkAYM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 441/627] bpf: Add cookie object to bpf maps
Date: Tue, 12 Aug 2025 19:32:16 +0200
Message-ID: <20250812173436.053359214@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 12df58ad294253ac1d8df0c9bb9cf726397a671d ]

Add a cookie to BPF maps to uniquely identify BPF maps for the timespan
when the node is up. This is different to comparing a pointer or BPF map
id which could get rolled over and reused.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20250730234733.530041-1-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: abad3d0bad72 ("bpf: Fix oob access in cgroup local storage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h  | 1 +
 kernel/bpf/syscall.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5b25d278409b..f9900a23ca16 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -310,6 +310,7 @@ struct bpf_map {
 	bool free_after_rcu_gp;
 	atomic64_t sleepable_refcnt;
 	s64 __percpu *elem_count;
+	u64 cookie; /* write-once */
 };
 
 static inline const char *btf_field_type_name(enum btf_field_type type)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index dd5304c6ac3c..82ae4fadecf0 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -37,6 +37,7 @@
 #include <linux/trace_events.h>
 #include <linux/tracepoint.h>
 #include <linux/overflow.h>
+#include <linux/cookie.h>
 
 #include <net/netfilter/nf_bpf_link.h>
 #include <net/netkit.h>
@@ -53,6 +54,7 @@
 #define BPF_OBJ_FLAG_MASK   (BPF_F_RDONLY | BPF_F_WRONLY)
 
 DEFINE_PER_CPU(int, bpf_prog_active);
+DEFINE_COOKIE(bpf_map_cookie);
 static DEFINE_IDR(prog_idr);
 static DEFINE_SPINLOCK(prog_idr_lock);
 static DEFINE_IDR(map_idr);
@@ -1487,6 +1489,10 @@ static int map_create(union bpf_attr *attr, bool kernel)
 	if (err < 0)
 		goto free_map;
 
+	preempt_disable();
+	map->cookie = gen_cookie_next(&bpf_map_cookie);
+	preempt_enable();
+
 	atomic64_set(&map->refcnt, 1);
 	atomic64_set(&map->usercnt, 1);
 	mutex_init(&map->freeze_mutex);
-- 
2.39.5




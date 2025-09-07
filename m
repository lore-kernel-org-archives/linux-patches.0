Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DE1189BB0;
	Sun,  7 Sep 2025 20:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276465; cv=none; b=KoFxiksA7fMm09M1KCTgjHlGazvVDEcrc7tieskg7UP65L1OrLMyL0vg8TbCllavmVKnnSA9cVPitNu9zo9HCWqcFqNMpVz84CVZAcIl/e2ZZe2lvuYYtj7dV68aLCSDsniY8QjRmGrsi+5tEfWgpdL0adjDJPwYr5/LVqnrw8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276465; c=relaxed/simple;
	bh=bS9+F5rFlCos7coG5DUQjO4wkX23MXPuJpH6pzvmkGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dD405m4ybyxP38EflLED2VbdN4f/xR2u7uZKEEdTa9ukXNXSeNj6teLgTDmWED2mB5IvhlVFt87ls7ktDA1Q8bCvJAWH7R3YKGFMrDY0O8cckFQLZBFWdYMYSpYFy8P/JbWameEhwYKuQNRHveAbYJ+lg8tfinsCCKxO5uYtcN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLva/HET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLva/HET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B7BC4CEF0;
	Sun,  7 Sep 2025 20:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276465;
	bh=bS9+F5rFlCos7coG5DUQjO4wkX23MXPuJpH6pzvmkGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xLva/HETn7EKfu1gN1jiOiLKk5AH/9rQsElB6L1uFJgXZRA7VHClAeuOJSEmkpWTn
	 6+OuQFRBzU7V1qr50jrGUHhCnNNopFuUtczbSg4yHkr4jpgba3MHuJSnYT+BAW8c/T
	 FRp0mlBR1xTDalWR8pmrRAbKQoNbjkKJ34dRapLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/121] bpf: Add cookie object to bpf maps
Date: Sun,  7 Sep 2025 21:57:17 +0200
Message-ID: <20250907195609.855500634@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 12df58ad294253ac1d8df0c9bb9cf726397a671d ]

Add a cookie to BPF maps to uniquely identify BPF maps for the timespan
when the node is up. This is different to comparing a pointer or BPF map
id which could get rolled over and reused.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20250730234733.530041-1-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h  | 1 +
 kernel/bpf/syscall.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 17de12a98f858..0a097087f0a7c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -300,6 +300,7 @@ struct bpf_map {
 	bool free_after_rcu_gp;
 	atomic64_t sleepable_refcnt;
 	s64 __percpu *elem_count;
+	u64 cookie; /* write-once */
 };
 
 static inline const char *btf_field_type_name(enum btf_field_type type)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index b66349f892f25..1d6bd012de9e6 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -35,6 +35,7 @@
 #include <linux/rcupdate_trace.h>
 #include <linux/memcontrol.h>
 #include <linux/trace_events.h>
+#include <linux/cookie.h>
 #include <net/netfilter/nf_bpf_link.h>
 
 #include <net/tcx.h>
@@ -50,6 +51,7 @@
 #define BPF_OBJ_FLAG_MASK   (BPF_F_RDONLY | BPF_F_WRONLY)
 
 DEFINE_PER_CPU(int, bpf_prog_active);
+DEFINE_COOKIE(bpf_map_cookie);
 static DEFINE_IDR(prog_idr);
 static DEFINE_SPINLOCK(prog_idr_lock);
 static DEFINE_IDR(map_idr);
@@ -1253,6 +1255,10 @@ static int map_create(union bpf_attr *attr)
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
2.50.1




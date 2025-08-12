Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F60726A0EB;
	Tue, 12 Aug 2025 18:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023656; cv=none; b=phfE15yfv7a6/yYIYkL/ctUKvvjW2RzzRHWi0hYVqeSWAGbAeox+nSQQq2P9J6XspQ5Jw37sn+SKYv5TZ1QbjT91Iqaw9vVnkl7LR9V63UUaGaKU1y3uPztPoT/QVxMH+K8crW+a3SItu8n5yuFpJK4r8S2Hzkekl7kG5wFQpD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023656; c=relaxed/simple;
	bh=BTKL2k8LiLYJvGfpulHE3UE0c2VgMaIFZhZiqBzce4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lM5A3Xv2glqgEkBPDbrX9On6Z6TXrKrNzv8o5njYz+wCI4oiMIwUNizo3KuUxis6OmSusfAvfk9OoXNj/F05K2Pz8smb9rhphXnhyxBSww+36DEPRwSGI2lq62qDv72ei4+lxLFYL5KIIYW/tHlpza1vIddQuvv9Mn14l2FevgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZmdMrpIA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZmdMrpIA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AE9C4CEF0;
	Tue, 12 Aug 2025 18:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023656;
	bh=BTKL2k8LiLYJvGfpulHE3UE0c2VgMaIFZhZiqBzce4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZmdMrpIAqPOCyxD6c+lRjRLQ4Weku5vsrO1Ucsk+V69wLgvkcbrf9rtQTJqCjJbHv
	 cPOxR3c2YI70Yv5XChsvJkA+vsIZ9giqRxw40PAIpNTCQ9goFU41sG/ZkB7o7aWLum
	 yPB3jrC4ptFhAuPOri1jznIEstQpw2eRSH1zYbIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b4169a1cfb945d2ed0ec@syzkaller.appspotmail.com,
	Charalampos Mitrodimas <charmitro@posteo.net>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 144/627] net, bpf: Fix RCU usage in task_cls_state() for BPF programs
Date: Tue, 12 Aug 2025 19:27:19 +0200
Message-ID: <20250812173424.772270467@linuxfoundation.org>
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

From: Charalampos Mitrodimas <charmitro@posteo.net>

[ Upstream commit 7f12c33850482521c961c5c15a50ebe9b9a88d1e ]

The commit ee971630f20f ("bpf: Allow some trace helpers for all prog
types") made bpf_get_cgroup_classid_curr helper available to all BPF
program types, not just networking programs.

This helper calls __task_get_classid() which internally calls
task_cls_state() requiring rcu_read_lock_bh_held(). This works
in networking/tc context where RCU BH is held, but triggers an RCU
warning when called from other contexts like BPF syscall programs
that run under rcu_read_lock_trace():

  WARNING: suspicious RCU usage
  6.15.0-rc4-syzkaller-g079e5c56a5c4 #0 Not tainted
  -----------------------------
  net/core/netclassid_cgroup.c:24 suspicious rcu_dereference_check() usage!

Fix this by also accepting rcu_read_lock_held() and
rcu_read_lock_trace_held() as valid RCU contexts in the
task_cls_state() function. This ensures the helper works correctly
in all needed RCU contexts where it might be called, regular RCU,
RCU BH (for networking), and RCU trace (for BPF syscall programs).

Fixes: ee971630f20f ("bpf: Allow some trace helpers for all prog types")
Reported-by: syzbot+b4169a1cfb945d2ed0ec@syzkaller.appspotmail.com
Signed-off-by: Charalampos Mitrodimas <charmitro@posteo.net>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20250611-rcu-fix-task_cls_state-v3-1-3d30e1de753f@posteo.net
Closes: https://syzkaller.appspot.com/bug?extid=b4169a1cfb945d2ed0ec
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netclassid_cgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/netclassid_cgroup.c b/net/core/netclassid_cgroup.c
index d22f0919821e..dff66d8fb325 100644
--- a/net/core/netclassid_cgroup.c
+++ b/net/core/netclassid_cgroup.c
@@ -21,7 +21,9 @@ static inline struct cgroup_cls_state *css_cls_state(struct cgroup_subsys_state
 struct cgroup_cls_state *task_cls_state(struct task_struct *p)
 {
 	return css_cls_state(task_css_check(p, net_cls_cgrp_id,
-					    rcu_read_lock_bh_held()));
+					    rcu_read_lock_held() ||
+					    rcu_read_lock_bh_held() ||
+					    rcu_read_lock_trace_held()));
 }
 EXPORT_SYMBOL_GPL(task_cls_state);
 
-- 
2.39.5




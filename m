Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9274E37146B;
	Sat, 28 Feb 2026 17:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301465; cv=none; b=UGefwqcDeVCDtpySKzTUYkapw0d8eGfWid3QThDVsQo/ePy5phMPhy3ETDJ1l9ourjVB2mbFYrpCzOkrm3tLHyhuLXW5ICsWIxj5moLEJpUT6FXDiI0KD6sHkUcmTekJmPPXccJG6pw4G398+iebZD4iqIl4cXn3wzNLqc7tYUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301465; c=relaxed/simple;
	bh=GmsVpxpNT/LPNenninbLyr63BYxl7iMmqbgXl29Fmfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HABIyWm+ev7d87yznT1p6k9sXTjEBB4UYm59ksZSLaOUqEQSha/XuZDOg8GGZ9q8Trp4ta/G0Ta6OYx1crTbTPBzdNbikPpcx6d4mofQk0nHFaZ4zubaTIuUDk/gMvEz1I5eTZznitvy2enZWGL3hm0B/+Fac5AWPJTOuOmxFwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U+RmjBO5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U+RmjBO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0924C19425;
	Sat, 28 Feb 2026 17:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301465;
	bh=GmsVpxpNT/LPNenninbLyr63BYxl7iMmqbgXl29Fmfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+RmjBO5fV8TXhYHNHsE/mY/twx9SuCmCw7yHCCARkfZE3XFiPWv4xBbCzDYjdWBJ
	 rCE0w3EWMBME82hTjctQqA9sWhO7aZsXIHJRkyG7PhaNb94MH81CyhLYkr7mzSJTBc
	 oZ1TBYj+HWTXwp/Iy6p8ewx+N91MgExo4fUJxZnFwFnzOSOr+WunBcVCYTnLIQEh8M
	 6sxYqi7Wzg+zGj7orUUgVsp/jMgAOcvDDIyJAZCS81+UrvS3WCsCGkIyfemgtB8Btz
	 uQt8kEtzzoSpWWaVy+4KJIlte5sFyoL4ABhtWWcCIj3Gg31kDwJcT/mWUX5+cYe//0
	 XmhnjvzRD/9/g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Breno Leitao <leitao@debian.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 650/752] uprobes: Fix incorrect lockdep condition in filter_chain()
Date: Sat, 28 Feb 2026 12:46:01 -0500
Message-ID: <20260228174750.1542406-650-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Breno Leitao <leitao@debian.org>

[ Upstream commit a56a38fd9196fc89401e498d70b7aa9c9679fa6e ]

The list_for_each_entry_rcu() in filter_chain() uses
rcu_read_lock_trace_held() as the lockdep condition, but the function
holds consumer_rwsem, not the RCU trace lock.

This gives me the following output when running with some locking debug
option enabled:

  kernel/events/uprobes.c:1141 RCU-list traversed in non-reader section!!
    filter_chain
    register_for_each_vma
    uprobe_unregister_nosync
    __probe_event_disable

Remove the incorrect lockdep condition since the rwsem provides
sufficient protection for the list traversal.

Fixes: cc01bd044e6a ("uprobes: travers uprobe's consumer list locklessly under SRCU protection")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260128-uprobe_rcu-v2-1-994ea6d32730@debian.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/uprobes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index f11ceb8be8c41..4f42e7af575f5 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1138,7 +1138,7 @@ static bool filter_chain(struct uprobe *uprobe, struct mm_struct *mm)
 	bool ret = false;
 
 	down_read(&uprobe->consumer_rwsem);
-	list_for_each_entry_rcu(uc, &uprobe->consumers, cons_node, rcu_read_lock_trace_held()) {
+	list_for_each_entry(uc, &uprobe->consumers, cons_node) {
 		ret = consumer_filter(uc, mm);
 		if (ret)
 			break;
-- 
2.51.0


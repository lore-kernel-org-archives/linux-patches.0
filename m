Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B7F2BCF7F;
	Thu, 12 Mar 2026 20:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346683; cv=none; b=okeIykKddSwglTJjtCy75io8Uwu3KUpFA8tEZsvrf8WNGLcoi0OuvnhTTiTqL6qb03Fxl9GbCBxVO4O9L6Wa6UGCRGWy+oUeueS+aREcopMW2Nu/nIAZFrtve/8e+BkeGbeDoRRkniY7UcwfJNoL6za/yPwvC3AWdekDr52oC8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346683; c=relaxed/simple;
	bh=sm9uR1mFDZZM3zzm6TFJXzIKpi5XXwvjqsSBYwWdJxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmEMLJFRGg0cv/P3/72FCOlPUToeG11PJMVZhJ9Z5iSJmoTujkojwiwEOyfUYz3uSFp7FyBFF24eMrrd0hnKpvrYmC4zaXkpXFV72kJZ1AxhyxhFHybfnTFYSmPrdllaFkQQLKoSaCBedg4gRLOlg9L9PEkpcUZg8qQvxWD4pcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WtyFrDXx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WtyFrDXx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CBEC2BC86;
	Thu, 12 Mar 2026 20:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346682;
	bh=sm9uR1mFDZZM3zzm6TFJXzIKpi5XXwvjqsSBYwWdJxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WtyFrDXxKSCNZnW2O1NrEV78qV/niGNWqfzuOI9/ZSMJrhYs7aWJUhVTv2aM0N6k9
	 JXoT5VE/iP5ePfXRvraKv26FbDynJocIvfSpzXJCysIbv+2nU/zWkOu9BvhAtk+rhn
	 +LF9FeradYhi7HsmoI7fUmVTA1d2h9mqLW+e6OUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 099/265] uprobes: Fix incorrect lockdep condition in filter_chain()
Date: Thu, 12 Mar 2026 21:08:06 +0100
Message-ID: <20260312201021.806462935@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
User-Agent: quilt/0.69
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
index 0eb9befe49a3c..e3c8d9900ca7f 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -949,7 +949,7 @@ static bool filter_chain(struct uprobe *uprobe, struct mm_struct *mm)
 	bool ret = false;
 
 	down_read(&uprobe->consumer_rwsem);
-	list_for_each_entry_rcu(uc, &uprobe->consumers, cons_node, rcu_read_lock_trace_held()) {
+	list_for_each_entry(uc, &uprobe->consumers, cons_node) {
 		ret = consumer_filter(uc, mm);
 		if (ret)
 			break;
-- 
2.51.0




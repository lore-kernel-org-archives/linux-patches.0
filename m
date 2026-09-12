Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EA1343893;
	Sat, 12 Sep 2026 09:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206437; cv=none; b=rgunIz0LdHhuDur8wo4IHhXL1x4bOJQJ19HsKHX2bCfa9yltY3/m2Ra9H0GDmEoA1EwGMyp7YqjhHQKk4uM1UmowaUSaEdu4DZYLv5uZZDHWj2igPHQEdIbGo2Wjxe0Q9dcvTEmal5FWg9HtkkzbRW0FVM0KQvAlGKAq0+4J3cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206437; c=relaxed/simple;
	bh=d1/UpNhYmm0r5esZJTtAxlgkQOrbTqW5YCxPKrlXdfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWDYzfLvljFIokwyLteRagPTTwRrgoeARigaA3lmqziQ/qKStu0g10Eq9KCC09iezHidGSrYXfaBr7r4vmYsgtkjIi8ZztLnFLTxlxfl/1gwYm2tYgtRqgZvEsyi0nf/em8OOK15Poktn3toq5bhJzyyUyyBdBo3weM6uBte+JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KslV7+Bd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KslV7+Bd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F421F000FF;
	Sat, 12 Sep 2026 09:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206436;
	bh=sSEZ4zanb4Br59LaFqedxxERWUH69OFZ8srLwh8+C+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KslV7+BdxJUSGxI13/OBbQTj0cr2WXAviKxrtF+Oc3wJdvqO/yodXh+MLH6E64r+E
	 iSpLmu5wKHnpN3hEJ3wqkzdR1Brb8yRHZESw9vAsMN5lCXeIMO2NY/1ER0LjgLLOE3
	 sftHt3pODQHWgJmV9IGW9oLw/OjSALUPwS0uP3t8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0207/1518] RDMA/irdma: Deduplicate the irdma_del_memlist logic
Date: Sat, 12 Sep 2026 08:39:36 +0200
Message-ID: <20260912065628.171124827@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 097f50384e1877b7cf3ace12ff0d1beed19f2088 ]

Simplify/dedup the irdma_del_memlist logic in preparation for
the QP/CQ/SRQ ring MR refcounting change that will follow in
a subsequent commit.

Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20260618201458.875740-2-jmoroni@google.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: f67d8a08f60c ("RDMA/irdma: Add refcounting to user ring MRs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 31 +++++++++++------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 4084168d0194f..9f3884f31555c 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -3868,35 +3868,28 @@ static void irdma_del_memlist(struct irdma_mr *iwmr,
 {
 	struct irdma_pbl *iwpbl = &iwmr->iwpbl;
 	unsigned long flags;
+	spinlock_t *lock;
 
 	switch (iwmr->type) {
 	case IRDMA_MEMREG_TYPE_CQ:
-		spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
-		if (iwpbl->on_list) {
-			iwpbl->on_list = false;
-			list_del(&iwpbl->list);
-		}
-		spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
+		lock = &ucontext->cq_reg_mem_list_lock;
 		break;
 	case IRDMA_MEMREG_TYPE_QP:
-		spin_lock_irqsave(&ucontext->qp_reg_mem_list_lock, flags);
-		if (iwpbl->on_list) {
-			iwpbl->on_list = false;
-			list_del(&iwpbl->list);
-		}
-		spin_unlock_irqrestore(&ucontext->qp_reg_mem_list_lock, flags);
+		lock = &ucontext->qp_reg_mem_list_lock;
 		break;
 	case IRDMA_MEMREG_TYPE_SRQ:
-		spin_lock_irqsave(&ucontext->srq_reg_mem_list_lock, flags);
-		if (iwpbl->on_list) {
-			iwpbl->on_list = false;
-			list_del(&iwpbl->list);
-		}
-		spin_unlock_irqrestore(&ucontext->srq_reg_mem_list_lock, flags);
+		lock = &ucontext->srq_reg_mem_list_lock;
 		break;
 	default:
-		break;
+		return;
+	}
+
+	spin_lock_irqsave(lock, flags);
+	if (iwpbl->on_list) {
+		iwpbl->on_list = false;
+		list_del(&iwpbl->list);
 	}
+	spin_unlock_irqrestore(lock, flags);
 }
 
 /**
-- 
2.53.0




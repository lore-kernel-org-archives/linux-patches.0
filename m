Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46D435AACE;
	Tue, 26 Aug 2025 14:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218423; cv=none; b=ht4tJySyjad6xLBtBM7YPw1jGZElBAepaEhydu7aW64cRfj5TS0XXZ12E/hbdrBzCSMFCuzPWPxfrhNCXdgtXWdHC/0fItpwip/9ZGuKwvn+ZgpbKh1CMOkogBalelHM380RUpxY0LbqQWe5IKUk4QUB9IOVZvOQbEIyETPUc1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218423; c=relaxed/simple;
	bh=FJiZea/ybZUSRrUE59aCZjM0XQvjlu2t06aRolvi21c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDnF4ZH/E6dvClFqj9NkfWqJpbSAEX3b4TwPjBHDNkkdX+zZkWjclj568R99KC6ZXHCnfqILCXwAkfNqLbgrNXBev60YckM0GvtqnVmRIveSezDye1ZTQ4i4c671L7wzFNAUJLdMLgBwILXyGAijMoKLsn6t2VWcOPwCR4V8T1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E3zCFO+t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E3zCFO+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653FBC4CEF1;
	Tue, 26 Aug 2025 14:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218423;
	bh=FJiZea/ybZUSRrUE59aCZjM0XQvjlu2t06aRolvi21c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E3zCFO+t5stlNXwSxeVrTMDPgcyiadwfEbTXpQPWNnB5/Fn89sCcLHnYyjRZGjyLM
	 j6epKBkhdDOta1l4FkFUu1jQqDRO2NGFAGDu/BpkvaH+bI+gyzSA0cCR9uvjXWefDf
	 YT7wEGp8DpBWZAkbNhwLKvER5yHJgbKiYescTAow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Liu <will@willsroot.io>,
	Savino Dicanosa <savy@syst3mfailure.io>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 517/523] net/sched: Remove unnecessary WARNING condition for empty child qdisc in htb_activate
Date: Tue, 26 Aug 2025 13:12:07 +0200
Message-ID: <20250826110937.191475243@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Liu <will@willsroot.io>

[ Upstream commit 2c2192e5f9c7c2892fe2363244d1387f62710d83 ]

The WARN_ON trigger based on !cl->leaf.q->q.qlen is unnecessary in
htb_activate. htb_dequeue_tree already accounts for that scenario.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: William Liu <will@willsroot.io>
Reviewed-by: Savino Dicanosa <savy@syst3mfailure.io>
Link: https://patch.msgid.link/20250819033632.579854-1-will@willsroot.io
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_htb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 94e0a8c68d59..b301efa41c1c 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -558,7 +558,7 @@ htb_change_class_mode(struct htb_sched *q, struct htb_class *cl, s64 *diff)
  */
 static inline void htb_activate(struct htb_sched *q, struct htb_class *cl)
 {
-	WARN_ON(cl->level || !cl->leaf.q || !cl->leaf.q->q.qlen);
+	WARN_ON(cl->level || !cl->leaf.q);
 
 	if (!cl->prio_activity) {
 		cl->prio_activity = 1 << cl->prio;
-- 
2.50.1




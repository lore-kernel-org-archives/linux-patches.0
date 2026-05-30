Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2710034389F;
	Sat, 30 May 2026 17:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162685; cv=none; b=Z9vZkwAK0AhjwGg1d0Qgky43n99abZNWRVlXFa5KTb4r/RkAGhtdLJM5Qw+BNntGdAIpRHgTNjdwdqekC0s/aYKP16KDTnPLMf6TsB8o8cwU54DZGtUYz1y7vdjbF4JljRjmIqvQ4i0PNhYf3X4/wnflO+lpJrGiXbHcO7PHHFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162685; c=relaxed/simple;
	bh=ZUBBkY29XwviwNr3ARfhvuODP1aMcYyi6zSr4TXhsDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=trwEs+EM0rL2ZCMX0iyBg2fOkHlUHHdvkvo7mZkJ9esdEQ6JYKl98UhNADUihQqpq7tDHiknTmEbuulYWC6YULGrjEXSa0frRAj4HFbQqa/Scqe9TCYUEtYPwl43DxlAUpMSgsH/rrZbrSD9IhMZHX15R7kQUWf89AMB33CMIwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sAttm5mD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sAttm5mD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C321F00893;
	Sat, 30 May 2026 17:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162684;
	bh=Eb4dQoj7aRwo1cHDRK262i/VolhU+w54OEN7tSwwErc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sAttm5mDyLQUWJhtqzSq5foLHlCjDZrwUTdOPhcJpzzOQ9C9TY8czkBJYy5pooALW
	 AaHP2JeMn9ERr+b3ztC1aROXVTAZzXh9VvTnMZ60iRWDIzrO70Ko4SkX4gVqSD9wm1
	 6WzcOhJOOkjUexfkc5gbeXkY/kPSu17A1x6kYpH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 032/776] xfrm: Wait for RCU readers during policy netns exit
Date: Sat, 30 May 2026 17:55:46 +0200
Message-ID: <20260530160241.107157604@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 069daad4f2ae9c5c108131995529d5f02392c446 ]

xfrm_policy_fini() frees the policy_bydst hash tables after flushing the
policy work items and deleting all policies, but it does not wait for
concurrent RCU readers to leave their read-side critical sections first.

The policy_bydst tables are published via rcu_assign_pointer() and are
looked up through rcu_dereference_check(), so netns teardown must also
wait for an RCU grace period before freeing the table memory.

Fix this by adding synchronize_rcu() before freeing the policy hash tables.

Fixes: e1e551bc5630 ("xfrm: policy: prepare policy_bydst hash for rcu lookups")
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 851029a5383a2..29b3db09e19cf 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -4125,6 +4125,8 @@ static void xfrm_policy_fini(struct net *net)
 #endif
 	xfrm_policy_flush(net, XFRM_POLICY_TYPE_MAIN, false);
 
+	synchronize_rcu();
+
 	WARN_ON(!list_empty(&net->xfrm.policy_all));
 
 	for (dir = 0; dir < XFRM_POLICY_MAX; dir++) {
-- 
2.53.0




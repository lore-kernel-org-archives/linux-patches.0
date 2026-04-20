Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6B52D77E5;
	Mon, 20 Apr 2026 15:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700340; cv=none; b=b0pAHyeS+Zf8tfoAk2SGBl0SAp0u62bdgs1wsDCHlygLynWWUVilUR+vIORN09xlMLwpH1fq4niNYcf9XjEeQz2Xvrx307YFn+nMvIacS2VJPMILi5WYM3xB1VeS0C/r+y9HvhPpHhGe0i4nYAnrhZkudPFdDZuJsk2ABiz3ctQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700340; c=relaxed/simple;
	bh=pRRh4qGQ84BfPvd4XeikiQVBiOko1b4tCEBwcFqDgqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RsvY7HnkOx4fS+P6zieKN0apQ0xz0HMlAG2R9TSoL5qpe8Kvts6xFCizbT6GSaWlBxKsrpWhf+reHwvOvUqcO8uL4hbSbyeyaU0gA3gu1swZ2eeWZFLQawFXhF0B4gg386LRYxwVWdOiBz4qImZb7qAeQOyOfPkNHUZI9j0P+As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xu2oLT6m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xu2oLT6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EE7C2BCB4;
	Mon, 20 Apr 2026 15:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700340;
	bh=pRRh4qGQ84BfPvd4XeikiQVBiOko1b4tCEBwcFqDgqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xu2oLT6mwlrIFHq/6G+lqaGaE8erERp05qNAhCNP3/YiOgyporweZmjYt6p5VuXjO
	 fFARMH7Eh1VGply2UwQkOs+P19L/dPsW5iMbmb70rhVyYgGBC11ITld4Cw0VtPzcBD
	 7gcDL6KAuj5RrOZBhvBf8IQBDmEpFUNUxA3kQp3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 107/220] xfrm: Wait for RCU readers during policy netns exit
Date: Mon, 20 Apr 2026 17:40:48 +0200
Message-ID: <20260420153937.887311223@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index c32d34c441ee0..4526c9078b136 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -4290,6 +4290,8 @@ static void xfrm_policy_fini(struct net *net)
 #endif
 	xfrm_policy_flush(net, XFRM_POLICY_TYPE_MAIN, false);
 
+	synchronize_rcu();
+
 	WARN_ON(!list_empty(&net->xfrm.policy_all));
 
 	for (dir = 0; dir < XFRM_POLICY_MAX; dir++) {
-- 
2.53.0




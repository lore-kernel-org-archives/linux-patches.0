Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084463BD634;
	Mon, 20 Apr 2026 13:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691530; cv=none; b=G+1fr3eZrIHmgsg/VUa3v6fZjoT+MWkjGQIryrGQ8V6GA6G8tCKgsdFd47JfQGarpPPkvirBz3qgtscTRGVS8FOngXn2HlJbamTLnkyLjAMQ/Cs2j4A59tp2QVlllDsgyNkv+62S8ZiNsKtqFeTPv8laEVy6PRxukdhDDoP5XqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691530; c=relaxed/simple;
	bh=lxLSueBLttRkcbbmKvm5YA5aOprqDc7YxCet6gcJ4Yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ku06StSHNPqok7BoXh49CvqzVFXYaXSODNo9BSQANFQlaV98GikmCz5bBF8Fhhf5OgmmeaI0Q7o0zcwREdR5OgBcChNcFSyt/HyJZfPmxCmSmlqbRu0spoMUicXCZ1aRElaaJvmAl8DZZCCHH+7oCkEEoXaJNy/xOJBegeuROJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AxvaBZzg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AxvaBZzg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A933BC2BCB4;
	Mon, 20 Apr 2026 13:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691529;
	bh=lxLSueBLttRkcbbmKvm5YA5aOprqDc7YxCet6gcJ4Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AxvaBZzgfFYhxOXXhK0it/6d45H1dOUynd2m8GG1ygCFDrQ26vO6DAiCgzMRkQa6t
	 UlvsNDULnycazmhmnctAPhwQ1lLyhnWgwBiVdQGIuVIfdmI6Cu8MEJ/Ni0gtU0dMhT
	 bHpS6zecXpsfMK4LZKS+BufLliagDt6ozZDd4RoI/59UQG0xtOxExMTYiOknvkjVrg
	 QxqDQLTGqHEFZX3TXi25UEG97KoS1UNNpgxZ6NjBj56IBmMHMmU2GLXzozwgwbd/mB
	 66V163Ha6Vhy7wIOWAf6aHIRuwOaFKtnlT1xacGSP4LOVNkXmC+EveUoBL32SvSoUx
	 ccqikb3qst1NA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] xfrm: Wait for RCU readers during policy netns exit
Date: Mon, 20 Apr 2026 09:17:57 -0400
Message-ID: <20260420132314.1023554-83-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6747402454;
	Mon, 20 Apr 2026 13:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691618; cv=none; b=Tax8yOeUXTgiSjz708JEjfmAiDB8+rVI2gNvE1TSOlGgtLFFLutuEf0ceD7zC/NN+fUpfPTG4W5syGe7cdQ7W6y4gB9vVyezlrXWhmp4eSeSzNFI/udtvrP+lgdDpSbsux7AKeCWbLn9fPwBSKMHblBjFUX8ij0pNNlk1fANNcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691618; c=relaxed/simple;
	bh=PfINNR3aHiNxGQtu6IFd7pGGh8hTgwFWzdqY76JFzAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjJGg/WHb7OpCWn5IE/ftKg3FLiUS/7AtmkQepss7wF5piAY2f6fXXGROYy2FisHlWLEHPWBmpsM0lzKIOl14Dkfm/jrSXuvJKfsj36OHw/i/K6vX89Mw4dTJSODQjsG5oG+6bXAXtiALqKnugcWswJdarvqkQZzSKQyvqZbezc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qV+V6Icz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qV+V6Icz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BE0C2BCB8;
	Mon, 20 Apr 2026 13:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691618;
	bh=PfINNR3aHiNxGQtu6IFd7pGGh8hTgwFWzdqY76JFzAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qV+V6IczhDl95f/NDGrp18tZiZwuXrQKPwugUQChPSpA5cdZPhFRZdMvikcLe2Ugy
	 4m0b1+J9OYK6Z0Bo8EtMvXLpOWOkhpdD8/LKTZU9GI5s5GGI8ktpNPWiyRH3VwlPnt
	 M9NO0eFFhww0Y5MwxdGNlc1wfbCGS+FGDBN1RJ7NWbEIfRB0DbzqhAcX1v7MU3bsSg
	 AYSmJ3te8pDiR+HWPBh41TXfUaZE+IoUYwFJ3MLNtdLllWldl2ZzEvSGksOeu9iq+f
	 OTB+o/pmQIn3mWYSyZEJdZXupDQdWEXT9zIz3MWdm5/jSQkIetoouSs8jpG0SHOlWV
	 teG3yaMt3JlQQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kotlyarov Mihail <mihailkotlyarow@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] xfrm: fix refcount leak in xfrm_migrate_policy_find
Date: Mon, 20 Apr 2026 09:18:49 -0400
Message-ID: <20260420132314.1023554-135-sashal@kernel.org>
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

From: Kotlyarov Mihail <mihailkotlyarow@gmail.com>

[ Upstream commit 83317cce60a032c49480dcdabe146435bd689d03 ]

syzkaller reported a memory leak in xfrm_policy_alloc:

  BUG: memory leak
  unreferenced object 0xffff888114d79000 (size 1024):
    comm "syz.1.17", pid 931
    ...
    xfrm_policy_alloc+0xb3/0x4b0 net/xfrm/xfrm_policy.c:432

The root cause is a double call to xfrm_pol_hold_rcu() in
xfrm_migrate_policy_find(). The lookup function already returns
a policy with held reference, making the second call redundant.

Remove the redundant xfrm_pol_hold_rcu() call to fix the refcount
imbalance and prevent the memory leak.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 563d5ca93e88 ("xfrm: switch migrate to xfrm_policy_lookup_bytype")
Signed-off-by: Kotlyarov Mihail <mihailkotlyarow@gmail.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 net/xfrm/xfrm_policy.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 4526c9078b136..29c94ee0ceb25 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -4528,9 +4528,6 @@ static struct xfrm_policy *xfrm_migrate_policy_find(const struct xfrm_selector *
 	pol = xfrm_policy_lookup_bytype(net, type, &fl, sel->family, dir, if_id);
 	if (IS_ERR_OR_NULL(pol))
 		goto out_unlock;
-
-	if (!xfrm_pol_hold_rcu(pol))
-		pol = NULL;
 out_unlock:
 	rcu_read_unlock();
 	return pol;
-- 
2.53.0


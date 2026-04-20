Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FBB2E093A;
	Mon, 20 Apr 2026 15:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700358; cv=none; b=qcFM14ZSZFDxiURoU9v2Zga+NeWeWITQ8lg3gYpNBeUOZQd13a4yOXi9FysY0/nDNrc6wj1/Xy10T+p+U13Rkmup/slCPgmgtldm/ruyMY+B3C5B+mDcd0d0NN4Nj4lEKpTlvjDWYOWoQbD9LybvbNJckoTGNlR4GZCYD4/brDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700358; c=relaxed/simple;
	bh=WnEOZxxahRZbEQjabfreuum/G/OTbylgATb8Dakwa7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KRQ/J1Io1q7m5K23fiT46CIOlhmh+DpBtDIp39UkmHNJys9JYpTQXGj2JF/HurLNcBead/7IR/Ydfby2a/1usjatIxK92yFGrKIHmE1zT/0g7nWdw6B5ExzBySRHtPExf4zhV5kHfF7hBg537/FDDPmYLlGHSf8oDUishn3UryM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hGyyzDjQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hGyyzDjQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59951C19425;
	Mon, 20 Apr 2026 15:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700358;
	bh=WnEOZxxahRZbEQjabfreuum/G/OTbylgATb8Dakwa7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hGyyzDjQZ4CXC1MEZVn2L3spfRjxANB0LPlfV87CXuDF4bbl1rOWUAkPRDoWkprzx
	 hsO3ZliyakVHSOAYIfdYsGqwm6F9BJ4JNjwka4901z517PHO0aM7tzsDkZrVjW2ibp
	 29S7KbhJNPjd6Cab8Mr90O9IQenl3Yf6iCQLUKa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kotlyarov Mihail <mihailkotlyarow@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 108/220] xfrm: fix refcount leak in xfrm_migrate_policy_find
Date: Mon, 20 Apr 2026 17:40:49 +0200
Message-ID: <20260420153937.922776962@linuxfoundation.org>
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




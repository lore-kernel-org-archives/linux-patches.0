Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CB0423A9D;
	Tue, 31 Mar 2026 16:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976393; cv=none; b=FwXV5gC7PHtIMMDgdhia7N7Wd5gSe4DAZkAUxNIH5APk33IT1Bm7H8NhjHDSkefY89tNo7AHRYVYsaNSBwHYdHG+fDEanIbhSQegww9THTqc3qp/xlryT3NzkHDb5iN5H0aoGCkQ2KwiIi7/P+BNTxLadHF5pn6iG7RYgvEHymw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976393; c=relaxed/simple;
	bh=PCCKheaP7hwnUd2jKfWVHZlvhaOKp8KYqwgkd/NtYbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRGWXJhTYluBtoXSdJQu6hLAXA+Zna9+z0mtJ8h/f2wEXsTu8AwKs3KLEiGqrt9kRETuC7cLeKSduUNUBf8nDgDShoLh+GU2U4VPqHMnRsSP1By3u/hD/j/Uvo/+fud0zqMpL/UR8lLUgqD+a+2QDm3h6Y44Tsn2IdzRUMx/dO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tB849qh1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tB849qh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1347C19423;
	Tue, 31 Mar 2026 16:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976393;
	bh=PCCKheaP7hwnUd2jKfWVHZlvhaOKp8KYqwgkd/NtYbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tB849qh1P9KZtWCBx9GRuRmXavMtSMiDtPI6V8R6upnXcU4am8Bvyuc0xUDNZ1bqJ
	 vCpl9qjuGFcYJA2Km4X6JyKce8aSl2VMp/ETIMWxZU9cMpbWIYXQHa9qyAivf9vzZm
	 HbaC4ghk5eUA8ezRc4+hG0UsMa3HN/f9ieBOQ5l4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minwoo Ra <raminwo0202@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 076/309] xfrm: prevent policy_hthresh.work from racing with netns teardown
Date: Tue, 31 Mar 2026 18:19:39 +0200
Message-ID: <20260331161756.285520747@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Minwoo Ra <raminwo0202@gmail.com>

[ Upstream commit 29fe3a61bcdce398ee3955101c39f89c01a8a77e ]

A XFRM_MSG_NEWSPDINFO request can queue the per-net work item
policy_hthresh.work onto the system workqueue.

The queued callback, xfrm_hash_rebuild(), retrieves the enclosing
struct net via container_of(). If the net namespace is torn down
before that work runs, the associated struct net may already have
been freed, and xfrm_hash_rebuild() may then dereference stale memory.

xfrm_policy_fini() already flushes policy_hash_work during teardown,
but it does not synchronize policy_hthresh.work.

Synchronize policy_hthresh.work in xfrm_policy_fini() as well, so the
queued work cannot outlive the net namespace teardown and access a
freed struct net.

Fixes: 880a6fab8f6b ("xfrm: configure policy hash table thresholds by netlink")
Signed-off-by: Minwoo Ra <raminwo0202@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 5428185196a1f..c32d34c441ee0 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -4282,6 +4282,8 @@ static void xfrm_policy_fini(struct net *net)
 	unsigned int sz;
 	int dir;
 
+	disable_work_sync(&net->xfrm.policy_hthresh.work);
+
 	flush_work(&net->xfrm.policy_hash_work);
 #ifdef CONFIG_XFRM_SUB_POLICY
 	xfrm_policy_flush(net, XFRM_POLICY_TYPE_SUB, false);
-- 
2.51.0




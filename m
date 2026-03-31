Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080BA413225;
	Tue, 31 Mar 2026 16:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975702; cv=none; b=bLBd0kc4GqBkX0AMBxiv6eoRFJiClEi0ot5aQ+HH+E5Jfn0E/ebS4PPeVk3+UcTnCxHcL/pWgfDAAwQlDFUdUkSgcsHHsWJasvCBwEUf09dA0CoKsXNVrG0Z6GDo9lmkKkzdg52Z1WkT4Gi39v7n+SuxXrwtvobYZanhRi561Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975702; c=relaxed/simple;
	bh=u8B5+8sMDWriSmI7WECcgkCisyLqmu9UMTQ63C2cU1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tzlv1Udtf/JokMX5u5UtS9t26WAqgSOLq3umCh4ws0Z+/Vt1DuEadklNOVVw+ZxNQTdl7KeyRXSUC9RWSzn1788gEu1rzmyAY6Kna4LIJTarPFG0hXPxJ/NwS1L2Z/ufUWvyxEOVw2V50PF/mvelE6OBEz8NKErqR7KmjUc3z14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FcnJkaon; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcnJkaon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938B4C19423;
	Tue, 31 Mar 2026 16:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975701;
	bh=u8B5+8sMDWriSmI7WECcgkCisyLqmu9UMTQ63C2cU1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FcnJkaon49c5Fn99s0o39WJXiVn+QdlOLw6AOQfQBy/a04ZXPczgGZ1GcNG6HtEwC
	 AOrxx0J+6JZk/zgO6y+uILRjNvIXK3VnYgtbeinQ0jFjVayj5HNx5YXqbDGzDW4Twe
	 5fc06KFVD7cpnU1VZs12jvUswywlAbIkOMtLiPWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minwoo Ra <raminwo0202@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/244] xfrm: prevent policy_hthresh.work from racing with netns teardown
Date: Tue, 31 Mar 2026 18:20:03 +0200
Message-ID: <20260331161743.651416992@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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
index e1ce873b83234..f4713ab7996f2 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -4270,6 +4270,8 @@ static void xfrm_policy_fini(struct net *net)
 	unsigned int sz;
 	int dir;
 
+	disable_work_sync(&net->xfrm.policy_hthresh.work);
+
 	flush_work(&net->xfrm.policy_hash_work);
 #ifdef CONFIG_XFRM_SUB_POLICY
 	xfrm_policy_flush(net, XFRM_POLICY_TYPE_SUB, false);
-- 
2.51.0




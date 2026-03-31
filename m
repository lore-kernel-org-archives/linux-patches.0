Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832243DFC7D;
	Tue, 31 Mar 2026 16:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974902; cv=none; b=IVUQDl0CJ5vJStzCVM/r2z0ns08QgE0Of+d2eAKnLi1zjpBzA+jddvQZaLOdp29V7P1BSM3lRs4nOaRXk0r9I6TgV+R9D3au3ko1fOsAgMaB2oCkTzgdKVuS1xF4v2i9+8MltLBZigRZ7E5de1CJ26d/4JOiQOIXEmqnSoHPz4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974902; c=relaxed/simple;
	bh=c8aemaO17YGoNx/4U/xG+627YZny1hfsDMlD/JTX3kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giU9YxEuodXJ7aCsLQKGh5/9OlANSG/X18cqpBtTrPdvfUkNzAQPvsNw0WjgwhdoG5HjZEUsprc1XKLepYb/BEJ/WPhC8c98tKjRzPDx2V5KyV78XO/rGOunvB3AuF9IftGxUGwLfpYBC1V6/cxxCpsGfRFBB73XMMth9Q/05YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDxxUGBz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDxxUGBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14393C19424;
	Tue, 31 Mar 2026 16:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974902;
	bh=c8aemaO17YGoNx/4U/xG+627YZny1hfsDMlD/JTX3kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vDxxUGBzcB10U/KuPQpu3Q5FLT01L8NLa7JQcaOvp68QlpKIH3qyK2syi9eRVL3Lx
	 YbjKUWaqdLtoggjsejrYK6NP1DDZRH//qvLATiE9XzefRwgCZSShTNBBmbTJD/knCD
	 lp+oT8oNvm0sBGw2A7PDrDDToI4H5tkISMv6ta9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minwoo Ra <raminwo0202@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 087/342] xfrm: prevent policy_hthresh.work from racing with netns teardown
Date: Tue, 31 Mar 2026 18:18:40 +0200
Message-ID: <20260331161802.222414684@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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




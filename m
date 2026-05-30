Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520452F25E4;
	Sat, 30 May 2026 16:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158316; cv=none; b=Q/u4RRmLmGe7382pzSHiMqcycw2ox7PHGc/XDMY7QmSrnqAK0Md1C4ryzTZ9rekCd3H03pcA0quuaDIN2MYr8Xmid3EaVxAcFMAGejYvi0G1EUeePfVrF9O7+2odAOkOarWbQx0otiNUgCUeFbp2lxyOgsxatSQS1wQsCj9v3gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158316; c=relaxed/simple;
	bh=w+CBrRGobN1qrj5QUzUsU15jW2bJPUn+8rEVy162Yjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFrSNdQtIjQzh8lJpFHhRCR/34hAVusw13Wg9IdCuEwLNoHwEi/zI9cC7TkGh8C/oupqeFUqkQ0KKKup6i703I65lKWOM0rLYRf1Z5ZqU8T3a+GxrFL2cWu+gjyXP4o/xzWnMRqo5Ea3tpvlhlu6qwhuuY+e+ooZ8+Z78VQgD6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y4N76Ga6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4N76Ga6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83C11F00893;
	Sat, 30 May 2026 16:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158315;
	bh=nrFQlPHMw2vtZUw6wpnATPgXay1fTtn4aYr+Bh3aq2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y4N76Ga6NcDCE9XC+qkw2BCuAQLLi/TWhzt+41XHmDmX58o8rlya050/fU0bsVWzR
	 eMyRkC0WvCiCWnh/wV/I4HdwQMwY/OwETr6/4VvtW7PFmkjznLTnwK27iTFtbMPGoq
	 Ya/181M52HFzZ18S4Qr7eo4iw90bSgplSMtdi0Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <nicholas@carlini.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/969] eventpoll: defer struct eventpoll free to RCU grace period
Date: Sat, 30 May 2026 17:52:36 +0200
Message-ID: <20260530160301.321008520@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Carlini <nicholas@carlini.com>

[ Upstream commit 07712db80857d5d09ae08f3df85a708ecfc3b61f ]

In certain situations, ep_free() in eventpoll.c will kfree the epi->ep
eventpoll struct while it still being used by another concurrent thread.
Defer the kfree() to an RCU callback to prevent UAF.

Fixes: f2e467a48287 ("eventpoll: Fix semi-unbounded recursion")
Signed-off-by: Nicholas Carlini <nicholas@carlini.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index f20a35775cf66..f6038819fe79f 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -225,6 +225,9 @@ struct eventpoll {
 	 */
 	refcount_t refcount;
 
+	/* used to defer freeing past ep_get_upwards_depth_proc() RCU walk */
+	struct rcu_head rcu;
+
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	/* used to track busy poll napi_id */
 	unsigned int napi_id;
@@ -708,7 +711,8 @@ static void ep_free(struct eventpoll *ep)
 	mutex_destroy(&ep->mtx);
 	free_uid(ep->user);
 	wakeup_source_unregister(ep->ws);
-	kfree(ep);
+	/* ep_get_upwards_depth_proc() may still hold epi->ep under RCU */
+	kfree_rcu(ep, rcu);
 }
 
 /*
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64F034389F;
	Sat, 30 May 2026 17:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162650; cv=none; b=uhwWydek+vdjvJVQKe959Vp2A5v1PWT8hrdxJHOH0jNoquOEm/WqIIvH2P9h1Lspf6t4JTvh+8PVM6pseMmH2/ZLzRKxqpaQPoRbeFWyWV7Dr+UXYULCvgUIHYNkbDyZAJ0Or9ZhiLBtX/UhjvfHcwAHtC13iElMf9IPskO9IOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162650; c=relaxed/simple;
	bh=Dv37+RFd8A0E39QzlxC42bARNziag1za54HS+PXpJu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOCPguVtNsSbC964x7fb3+h3bscMY5jbZ6nVtrrhSd6NdFTzkIhMj1ASxWpaC0DTb+AAfXChteq6pePWbgw11ws+dcbQbigHfvpP2ZdhQJvaN0LN1fVqkaIXGA55vfvoTXItIP2/S3I1A/mLWphm6WPdkDW0oQbbNwCd2yjB4uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YO3Yx/Ms; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YO3Yx/Ms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2701F00893;
	Sat, 30 May 2026 17:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162649;
	bh=UheCtBMBtd2/7bTvOC5nJzuPoTsQOT1jeZ/wBm2SjJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YO3Yx/Msy/5Yr5rpM3HDcZ5xWm432wxPO3urFgbdsNVS5C4rVlr4/fKTlh86qxCjI
	 TkL788w6gkcwkq+dBG898zrGF/eExNF9LkDEEyqXTi51oKYDXYCWyNwZhPLVzLPW28
	 lDeOG6r6UqUG3BkIVwKLUyOWGRfa8qhyxJHGzJP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <nicholas@carlini.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/776] eventpoll: defer struct eventpoll free to RCU grace period
Date: Sat, 30 May 2026 17:55:38 +0200
Message-ID: <20260530160240.887988805@linuxfoundation.org>
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
index 217b8016a6b50..8762d09086376 100644
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
@@ -701,7 +704,8 @@ static void ep_free(struct eventpoll *ep)
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




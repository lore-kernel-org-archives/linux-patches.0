Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413C428D85E;
	Wed, 23 Apr 2025 15:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420767; cv=none; b=mjxvoZBxMtWcBRc7/5nqNAbIZjnCVLywcXoYbcX6gzSmb6THuflY0GMsshxUcFsbd3nWf2SWJw1jV3f4b44bIOVtvAU96PM8k/tk8yRCnSrMi4Q2YLQXxosgC3f7hJI3LzUsu5wGq7x2kiFal+fkxnHJzw44/bZlJRWmxd/KEV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420767; c=relaxed/simple;
	bh=1p0uizIPmo7jQ/YZwoSu2oKbHFFiRYc2tvbdwvQ37vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCORZKfxQFmspEuMj/IKeQegoAQ3zQ2gIIf0afELv7mIvzvjfJBiD3qad8t7OCk449SVMxKwBUUeb2KhGmD+yiQ/gRaFl+fsV5V+qO87wFLIA16h4nkKtYp6YW6tUIsOyvFq/7MAJZPJc8l+fG8K+6tFEFkDWdV0LAbLbzPNoiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k76kjkiw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k76kjkiw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4197C4CEE2;
	Wed, 23 Apr 2025 15:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420767;
	bh=1p0uizIPmo7jQ/YZwoSu2oKbHFFiRYc2tvbdwvQ37vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k76kjkiwtuC/Jvx4Vo4ZuGf4z9/fbqGAISJSIcVD2jiY92A1yAquqDjpOwJ3JiTVe
	 p6aWCZ2TqELR6K8TkTYdBudrT2kM3W/vKOPIzTL4lmw2APFo+9QZfj3RwuNU0MxpFk
	 tMGERYCm43/6ez+nx1NSoOEG56KhEb10ZwVjK2Sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 120/241] eventpoll: abstract out ep_try_send_events() helper
Date: Wed, 23 Apr 2025 16:43:04 +0200
Message-ID: <20250423142625.486032193@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 38d203560118a673018df5892a6555bb0aba7762 ]

In preparation for reusing this helper in another epoll setup helper,
abstract it out.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Link: https://lore.kernel.org/r/20250219172552.1565603-3-axboe@kernel.dk
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 0a65bc27bd64 ("eventpoll: Set epoll timeout if it's in the future")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 7c0980db77b31..67d1808fda0e5 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1980,6 +1980,22 @@ static int ep_autoremove_wake_function(struct wait_queue_entry *wq_entry,
 	return ret;
 }
 
+static int ep_try_send_events(struct eventpoll *ep,
+			      struct epoll_event __user *events, int maxevents)
+{
+	int res;
+
+	/*
+	 * Try to transfer events to user space. In case we get 0 events and
+	 * there's still timeout left over, we go trying again in search of
+	 * more luck.
+	 */
+	res = ep_send_events(ep, events, maxevents);
+	if (res > 0)
+		ep_suspend_napi_irqs(ep);
+	return res;
+}
+
 /**
  * ep_poll - Retrieves ready events, and delivers them to the caller-supplied
  *           event buffer.
@@ -2031,17 +2047,9 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 
 	while (1) {
 		if (eavail) {
-			/*
-			 * Try to transfer events to user space. In case we get
-			 * 0 events and there's still timeout left over, we go
-			 * trying again in search of more luck.
-			 */
-			res = ep_send_events(ep, events, maxevents);
-			if (res) {
-				if (res > 0)
-					ep_suspend_napi_irqs(ep);
+			res = ep_try_send_events(ep, events, maxevents);
+			if (res)
 				return res;
-			}
 		}
 
 		if (timed_out)
-- 
2.39.5




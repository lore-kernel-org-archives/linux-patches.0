Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9930C3382DE;
	Mon, 20 Apr 2026 15:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700274; cv=none; b=teXaAJZ0pHb0rs848NmZ6izYkgvBY+KXHPY0j2+MmwCWvi+m+A7WVw6ZyG4NWn7Ai3RYS8H6L5KGPMfz3Bi5G/kdBAunuGqtyofvTUb7XVQypbfgyBafSBOK0zPnVyVcwlWG5/Sbipf+kib8HLGnv+e+8w401WLER/i0T2TBJFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700274; c=relaxed/simple;
	bh=Z1oHvWK4r+zzSfkprcw8wVE7P7ge9UFx82SYRTKj4UU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKty604MYE3yE79UiIP0VI7X6hiWAhWqy/ASv+vs+SFT5KFeLXELZxZLZ8zELKGCZmKqtH8hFU719ocfK8VBAJkULOk6+biFOY8vLXTBB+PGZd5zkkldbSfB93NYqAK2QfpStxZoPmMZpVn91J8Qz0dXR48Jpdl4voMJk9wlAgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fhexiCQ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fhexiCQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE67C19425;
	Mon, 20 Apr 2026 15:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700274;
	bh=Z1oHvWK4r+zzSfkprcw8wVE7P7ge9UFx82SYRTKj4UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fhexiCQ8EmtpjOIHoklc2KkNZAltqTV9rvd7EzxW+XZLJ8JZkbfLnGMEfsKbpBm7Q
	 Kdq/buuzBDUL2+q/rkUum2XaX9Ndwclx0LbzC8964nyukKMivQwWXxDn9cHcC0PWem
	 QtGS2o0ihkctc3JtGuOWa9YJiOf94b3ANYLvRY1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <nicholas@carlini.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 076/220] eventpoll: defer struct eventpoll free to RCU grace period
Date: Mon, 20 Apr 2026 17:40:17 +0200
Message-ID: <20260420153936.774715282@linuxfoundation.org>
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
index d20917b03161b..3bdbaf202d4db 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -226,6 +226,9 @@ struct eventpoll {
 	 */
 	refcount_t refcount;
 
+	/* used to defer freeing past ep_get_upwards_depth_proc() RCU walk */
+	struct rcu_head rcu;
+
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	/* used to track busy poll napi_id */
 	unsigned int napi_id;
@@ -819,7 +822,8 @@ static void ep_free(struct eventpoll *ep)
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




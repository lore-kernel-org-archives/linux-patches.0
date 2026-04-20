Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C9433A70A;
	Mon, 20 Apr 2026 16:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701340; cv=none; b=rR8T1xpVnnlnWGBNE0xKEls2jytO2ZVdh86OwFjgMvtITD2bEt3AOwuRYp9e3YDJWwCQgbbRawDKDSAXrVgMWiKz7lkXyLehTKuN3tuu0UK0oEdt01NVdLbfBgrn694OOSxyvhWCnYptZmESCZlIktHCLtajw0SAhY04tVmgG/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701340; c=relaxed/simple;
	bh=zWcud3pZQHoPHpd6i/t6qtf6choR8oqpsZBUZldRIAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZAgyN0SuWLL0Vi2yB84eprmvOlMU5ECsZhBJoJSO/Ebc61RxjfTWJolvXuPKA9nxY5EsMJ2AfOV1o8PsDT6W1zc+oMj7ukLD19eOajCcwxsgx7YIw4XfimRQ48xLdSRQVY4qtV+Cy6bYhtwWFkycBwXpBm7QiPb/uO8k6/JJ0kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=16T6yLFf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="16T6yLFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5FAC19425;
	Mon, 20 Apr 2026 16:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701340;
	bh=zWcud3pZQHoPHpd6i/t6qtf6choR8oqpsZBUZldRIAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=16T6yLFfK43JidrCjJCAWraBnDp4opiHGfgokF8ikvZtevTeS3S3f8TC0fMqy/xun
	 oSdLKcAkCs9Om/08YldeZs58DESFRPzmiI7FXAAgego2O0tteQ/2DvdVYH9wl4ZmWn
	 Hbcvw1Ao4yYdfExaZflrJBY1PqXKtEpThg3wRKK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <nicholas@carlini.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/162] eventpoll: defer struct eventpoll free to RCU grace period
Date: Mon, 20 Apr 2026 17:41:20 +0200
Message-ID: <20260420153928.766750698@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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
index aa4318271eee4..075aa8793aaa9 100644
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
@@ -790,7 +793,8 @@ static void ep_free(struct eventpoll *ep)
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




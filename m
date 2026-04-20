Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C4E33B970;
	Mon, 20 Apr 2026 15:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700744; cv=none; b=EBdCfsgjRtnphCAbf98bRxGtFcLIzRL5EWr3/rEf3Kqo+H+P0r2wfwIbH8wtrd4wtTsA7IT5ikAHHOKhVecdT43P5pgUtcyJs6Smc7DcL5Clu6ME6OwWAkUDiirHWRBzeKYsu1LrE/+LcePKxItY7dveEOLZCftLXEFVWZLJRGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700744; c=relaxed/simple;
	bh=A9CsL/iu3TsUHObuqKwqdlvjyMUgFjJuwhi8jcyMChs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJtBDeJvlRUc28p+PiSqhDlUvDam0q9pOcdtA65L1r6A8jStmFAB5CwdLk5Jd/H1BHf2gzLm+50XLu3nX3Cd2O+ErYwdYCgqLMBU6yUs+KoPN0/qI8WAfum4M0EmN590zRTAq7613f2wRGmB7092ZVNPaNP4bjlZNgo+eooDXv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1FIKblMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1FIKblMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3329C19425;
	Mon, 20 Apr 2026 15:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700744;
	bh=A9CsL/iu3TsUHObuqKwqdlvjyMUgFjJuwhi8jcyMChs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1FIKblMyPLjZxgpy8eTpI0o4SGi7D8nohZD33TdfohJSPGbUtlAqE9jhvmOXhM4X5
	 T2+l294SOIh/tJiK3xq4Wom7IeW8OIUbFVeHNt9hDxI9q9zky3oA/bbybzSHpINbjy
	 mKT/+6Bwj3Har1cfimgYWGDAEpgio6ljjQgggjck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <nicholas@carlini.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 069/198] eventpoll: defer struct eventpoll free to RCU grace period
Date: Mon, 20 Apr 2026 17:40:48 +0200
Message-ID: <20260420153938.095774487@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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
index bcc7dcbefc419..a8e30414d996c 100644
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




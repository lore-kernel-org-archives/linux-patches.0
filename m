Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654A43B0AD6;
	Wed, 20 May 2026 17:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299244; cv=none; b=hBbxW+H3y9qwii/Rn8T0ILN6hwVP9pj0czHsO8WhiHOS/laRJ5V19wgEmAooX9UkeXl/4AMsQI0XYbZ/g6nJ6pxRY+BmTKDTxdy/KSCr0Gb8Z/phN6tqQ5C/s2gSgibGmHFRNaPEX84bysNfI4ZA4Gc2vuB9JrrVdkEWDnXA7Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299244; c=relaxed/simple;
	bh=mFn2S7WZXGnLzaPsy60Xr2Gl0LhQRlt1zN4zQbQGjis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lzOmz/YwXoE/y2vKg+FU0noQl9/nAbkRVuOeDgGwLe1T2AOVvBZmasq1NCO4AvGolfiCnFtttDcaQ1SYpFNEvvh/tbEnuUhb0bewADxoMCYhnqmFCrPtLY/g/e7S9lyYNR1gxy997lh/Posq4XU/vwG6Y0Wg8dB6ertiVmAaqXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j4vWIVH0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j4vWIVH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9721F000E9;
	Wed, 20 May 2026 17:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299243;
	bh=TQNrHzCgRfdW/g0ERLZxgitto4ga++x1LivMbsW+egE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j4vWIVH0PKP7Rb8wcNmrIUu9ceFSZWfQ17QwdXnktRcjXVRC72jaQe5jGW1KQBpKy
	 JtVIZBm5QR1XOTIxuVwd3BpROkYbskIhBkvMFAIFKZHAqflEB5FHqNqMvswIClfHQ/
	 mWSDMvGfN6ar83pRv8pDlgpIbX8JnnBTB/VNGREI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 718/957] eventpoll: split __ep_remove()
Date: Wed, 20 May 2026 18:20:01 +0200
Message-ID: <20260520162150.119765155@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 0f7bdfd413000985de09fc39eb9efa1e091a3ce0 ]

Split __ep_remove() to delineate file removal from epoll item removal.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://patch.msgid.link/20260423-work-epoll-uaf-v1-2-2470f9eec0f5@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: a6dc643c6931 ("eventpoll: fix ep_remove struct eventpoll / struct file UAF")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 23602de08fed2..36f3545a71bfa 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -826,6 +826,9 @@ static void ep_free(struct eventpoll *ep)
 	kfree_rcu(ep, rcu);
 }
 
+static void __ep_remove_file(struct eventpoll *ep, struct epitem *epi, struct file *file);
+static bool __ep_remove_epi(struct eventpoll *ep, struct epitem *epi);
+
 /*
  * Removes a "struct epitem" from the eventpoll RB tree and deallocates
  * all the associated resources. Must be called with "mtx" held.
@@ -837,8 +840,6 @@ static void ep_free(struct eventpoll *ep)
 static bool __ep_remove(struct eventpoll *ep, struct epitem *epi, bool force)
 {
 	struct file *file = epi->ffd.file;
-	struct epitems_head *to_free;
-	struct hlist_head *head;
 
 	lockdep_assert_irqs_enabled();
 
@@ -854,8 +855,21 @@ static bool __ep_remove(struct eventpoll *ep, struct epitem *epi, bool force)
 		return false;
 	}
 
-	to_free = NULL;
-	head = file->f_ep;
+	__ep_remove_file(ep, epi, file);
+	return __ep_remove_epi(ep, epi);
+}
+
+/*
+ * Called with &file->f_lock held,
+ * returns with it released
+ */
+static void __ep_remove_file(struct eventpoll *ep, struct epitem *epi, struct file *file)
+{
+	struct epitems_head *to_free = NULL;
+	struct hlist_head *head = file->f_ep;
+
+	lockdep_assert_held(&ep->mtx);
+
 	if (hlist_is_singular_node(&epi->fllink, head)) {
 		/* See eventpoll_release() for details. */
 		WRITE_ONCE(file->f_ep, NULL);
@@ -869,6 +883,11 @@ static bool __ep_remove(struct eventpoll *ep, struct epitem *epi, bool force)
 	hlist_del_rcu(&epi->fllink);
 	spin_unlock(&file->f_lock);
 	free_ephead(to_free);
+}
+
+static bool __ep_remove_epi(struct eventpoll *ep, struct epitem *epi)
+{
+	lockdep_assert_held(&ep->mtx);
 
 	rb_erase_cached(&epi->rbn, &ep->rbr);
 
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC1151FCA4;
	Wed, 30 Sep 2026 18:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792680; cv=none; b=TjCpxjNefurOBcm95b0HMpIGxbIbsEB3FWUxSTIWBnHKR7ezoMZQb2fXgF2vwitt/Du5jjb+jo+oUz2KqJBvQl0yaW5zfBgOuA2TRQyAXlxw50Q63iyhi0QuFFTr069l+YBWujRFjGN24ylVZT8V8fiWeaIjPzjxB/K0JAZ8Ixo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792680; c=relaxed/simple;
	bh=EpakAWIVZtzS+s0BPbSw5E3+YbUf6p5N6qBPtBdZ/ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3q5YUysVhqeks2Od7Q+swrHXZzJxwK3/RoBlxL1M93Da79kGMeTzdBvV4RstpJpKgAWAKzF7YbCWgHB81ZJkpUQqy7xgnwwtS8eAAcWK6eP2c9nkUuJJvplFDbKXNYu8SExofYIPTUC6xJPyD+4ElE5E+p2/WbPnE0dtktaDMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlZftFcP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlZftFcP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277481F000FF;
	Wed, 30 Sep 2026 18:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792678;
	bh=Kg/RX8HCBUMR5o7DOfu3oYTpPem+7yZPAk6V6qLJSOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mlZftFcPSzNi05HOfIuFgjDx1Lorp0DQ6mYyhd0Owzz3L8myPUUCoQ6fvy6UQ1P+d
	 CNePT+ldMhRBUNbLUvR0Y8q0FKNdIuVhcISbOjL68basQm0WoDnk9ViiSXLHYhqKKP
	 DTcTV019CLnG3sA/NmsUS0nOnKQDdfnnBi5rJS/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Wentao Guan <guanwentao@uniontech.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 739/752] eventpoll: dont decrement ep refcount while still holding the ep mutex
Date: Wed, 30 Sep 2026 17:30:09 +0200
Message-ID: <20260930152414.208849417@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 8c2e52ebbe885c7eeaabd3b7ddcdc1246fc400d2 upstream.

Jann Horn points out that epoll is decrementing the ep refcount and then
doing a

    mutex_unlock(&ep->mtx);

afterwards. That's very wrong, because it can lead to a use-after-free.

That pattern is actually fine for the very last reference, because the
code in question will delay the actual call to "ep_free(ep)" until after
it has unlocked the mutex.

But it's wrong for the much subtler "next to last" case when somebody
*else* may also be dropping their reference and free the ep while we're
still using the mutex.

Note that this is true even if that other user is also using the same ep
mutex: mutexes, unlike spinlocks, can not be used for object ownership,
even if they guarantee mutual exclusion.

A mutex "unlock" operation is not atomic, and as one user is still
accessing the mutex as part of unlocking it, another user can come in
and get the now released mutex and free the data structure while the
first user is still cleaning up.

See our mutex documentation in Documentation/locking/mutex-design.rst,
in particular the section [1] about semantics:

	"mutex_unlock() may access the mutex structure even after it has
	 internally released the lock already - so it's not safe for
	 another context to acquire the mutex and assume that the
	 mutex_unlock() context is not using the structure anymore"

So if we drop our ep ref before the mutex unlock, but we weren't the
last one, we may then unlock the mutex, another user comes in, drops
_their_ reference and releases the 'ep' as it now has no users - all
while the mutex_unlock() is still accessing it.

Fix this by simply moving the ep refcount dropping to outside the mutex:
the refcount itself is atomic, and doesn't need mutex protection (that's
the whole _point_ of refcounts: unlike mutexes, they are inherently
about object lifetimes).

Reported-by: Jann Horn <jannh@google.com>
Link: https://docs.kernel.org/locking/mutex-design.html#semantics [1]
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
(cherry picked from commit b0821ec902d39062356cb644c16e17a705d1c9f5)
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 8762d09086376..9e63923196fc5 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -770,7 +770,7 @@ static bool __ep_remove(struct eventpoll *ep, struct epitem *epi, bool force)
 	call_rcu(&epi->rcu, epi_rcu_free);
 
 	percpu_counter_dec(&ep->user->epoll_watches);
-	return ep_refcount_dec_and_test(ep);
+	return true;
 }
 
 /*
@@ -778,14 +778,14 @@ static bool __ep_remove(struct eventpoll *ep, struct epitem *epi, bool force)
  */
 static void ep_remove_safe(struct eventpoll *ep, struct epitem *epi)
 {
-	WARN_ON_ONCE(__ep_remove(ep, epi, false));
+	if (__ep_remove(ep, epi, false))
+		WARN_ON_ONCE(ep_refcount_dec_and_test(ep));
 }
 
 static void ep_clear_and_put(struct eventpoll *ep)
 {
 	struct rb_node *rbp, *next;
 	struct epitem *epi;
-	bool dispose;
 
 	/* We need to release all tasks waiting for these file */
 	if (waitqueue_active(&ep->poll_wait))
@@ -818,10 +818,8 @@ static void ep_clear_and_put(struct eventpoll *ep)
 		cond_resched();
 	}
 
-	dispose = ep_refcount_dec_and_test(ep);
 	mutex_unlock(&ep->mtx);
-
-	if (dispose)
+	if (ep_refcount_dec_and_test(ep))
 		ep_free(ep);
 }
 
@@ -1001,7 +999,7 @@ void eventpoll_release_file(struct file *file)
 		dispose = __ep_remove(ep, epi, true);
 		mutex_unlock(&ep->mtx);
 
-		if (dispose)
+		if (dispose && ep_refcount_dec_and_test(ep))
 			ep_free(ep);
 		goto again;
 	}
-- 
2.53.0




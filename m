Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8CA3BBF2;
	Tue, 15 Jul 2025 13:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585353; cv=none; b=c6kkMMUxe86WawdR4KdFi3yK1qHfO7DrV2ymBJezZa7Zczl/xVZdMw5djmv81xZ8bVRuHbZSCSfV78IYMK3x4eMf2gWSQgj8cmZpRIFQwzzu2J6HuruIQH8YJyhUdUZYfbeIbujlDgsMSSe4cNf1uXeZcT+dT8V/Uuwijwmiv1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585353; c=relaxed/simple;
	bh=uqaohZq1krO6o9c/Jdq/RquVoJt2M1AsRyNzHy+dUng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+4NBi6PMJehd82o/k/CuY6okshipi6G11RvyPr7ysgjgwJJnNQC/JWNCEZCbFtIybf6Fh6xM3mVKYbl0Zl5YfkSPuMMVqOeBnVdnHJWcnZErhf5WyngyrCPFog9hnbxTC1ltXnlRZ9Q66uL9vIXI3dypd9N0itRYgp00KS22ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I2iLDSRn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2iLDSRn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0A9C4CEE3;
	Tue, 15 Jul 2025 13:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585353;
	bh=uqaohZq1krO6o9c/Jdq/RquVoJt2M1AsRyNzHy+dUng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2iLDSRnPq3T9hfS8jjrLcjYv+O4Gcp7bRogIeg//NHwx3b+emBoLl9Wo3mAW8Oyf
	 ogaNrTQr5D6F8JQNOaCf95CJpJF98nZsLcQU0ED6uWWRizt+Ce4Z1xDKSuzZO0P32O
	 xkuX9MjXgJun89xW4msRyjm5lNiKiuZqeYdwhOUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.12 001/163] eventpoll: dont decrement ep refcount while still holding the ep mutex
Date: Tue, 15 Jul 2025 15:11:09 +0200
Message-ID: <20250715130808.840375086@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
---
 fs/eventpoll.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -854,7 +854,7 @@ static bool __ep_remove(struct eventpoll
 	kfree_rcu(epi, rcu);
 
 	percpu_counter_dec(&ep->user->epoll_watches);
-	return ep_refcount_dec_and_test(ep);
+	return true;
 }
 
 /*
@@ -862,14 +862,14 @@ static bool __ep_remove(struct eventpoll
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
@@ -902,10 +902,8 @@ static void ep_clear_and_put(struct even
 		cond_resched();
 	}
 
-	dispose = ep_refcount_dec_and_test(ep);
 	mutex_unlock(&ep->mtx);
-
-	if (dispose)
+	if (ep_refcount_dec_and_test(ep))
 		ep_free(ep);
 }
 
@@ -1108,7 +1106,7 @@ again:
 		dispose = __ep_remove(ep, epi, true);
 		mutex_unlock(&ep->mtx);
 
-		if (dispose)
+		if (dispose && ep_refcount_dec_and_test(ep))
 			ep_free(ep);
 		goto again;
 	}



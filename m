Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D81434FF7A;
	Fri, 21 Nov 2025 13:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733033; cv=none; b=OE6HAoICJjZ1IGUF4d5K+gvMjwjtVlctiGp+s4RNn5iX/T9R+An8XaTTdbn8N7sENquJv9mSsfsgQujGaE4fqa1GhDd6Kh8HvDvtatjcvg+55nmwvuHlFpR0T8MGD3kLxQkn9/XSqYpFYdv+nsIJUyycmmkDm2gU6Ux2ZYNHSFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733033; c=relaxed/simple;
	bh=ABf7/qULSZpV4b5wWgNg9+dURdTrQQnYIgXjHYzFdR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlSlWgK2fHMh+ONQ0xf+kqZI6iHp6I/JFCGWgeART7OIyKXK//IZzPh+1ig873Aol0GTk/CEAtea7IHiFxWZ+Xxl4ZUij1O0nvFAkUEQdOnsopjwsG8bmUmWD8dj7chhVtVqJujrmEwQy7HfKeU/llcYLsMUn8tvM/EaFg1sfnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pE+dwoA7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pE+dwoA7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5874C4CEF1;
	Fri, 21 Nov 2025 13:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733033;
	bh=ABf7/qULSZpV4b5wWgNg9+dURdTrQQnYIgXjHYzFdR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pE+dwoA7VEDle0N9dO543G8KybpHNtVMi7QZH/w0QvKDSltH8t3Lxtm4kIC9Ei/7P
	 cWF03MByG9VQMAFslOHmaCeE5fA7+cI4hBzcdpsZar69aH8F6HlYHmn4ksCXYpmar7
	 lA0/HGKHnfI1JSXtEmZJPW0AzO4uKCjydFh0/2us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 328/529] ceph: refactor wake_up_bit() pattern of calling
Date: Fri, 21 Nov 2025 14:10:27 +0100
Message-ID: <20251121130242.698638094@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

[ Upstream commit 53db6f25ee47cb1265141d31562604e56146919a ]

The wake_up_bit() is called in ceph_async_unlink_cb(),
wake_async_create_waiters(), and ceph_finish_async_create().
It makes sense to switch on clear_bit() function, because
it makes the code much cleaner and easier to understand.
More important rework is the adding of smp_mb__after_atomic()
memory barrier after the bit modification and before
wake_up_bit() call. It can prevent potential race condition
of accessing the modified bit in other threads. Luckily,
clear_and_wake_up_bit() already implements the required
functionality pattern:

static inline void clear_and_wake_up_bit(int bit, unsigned long *word)
{
	clear_bit_unlock(bit, word);
	/* See wake_up_bit() for which memory barrier you need to use. */
	smp_mb__after_atomic();
	wake_up_bit(word, bit);
}

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/dir.c  | 3 +--
 fs/ceph/file.c | 6 ++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 1395b71df5ccc..529dd07fa459f 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1213,8 +1213,7 @@ static void ceph_async_unlink_cb(struct ceph_mds_client *mdsc,
 	spin_unlock(&fsc->async_unlink_conflict_lock);
 
 	spin_lock(&dentry->d_lock);
-	di->flags &= ~CEPH_DENTRY_ASYNC_UNLINK;
-	wake_up_bit(&di->flags, CEPH_DENTRY_ASYNC_UNLINK_BIT);
+	clear_and_wake_up_bit(CEPH_DENTRY_ASYNC_UNLINK_BIT, &di->flags);
 	spin_unlock(&dentry->d_lock);
 
 	synchronize_rcu();
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index e12657b4c3e04..0ec78d87519ba 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -539,8 +539,7 @@ static void wake_async_create_waiters(struct inode *inode,
 
 	spin_lock(&ci->i_ceph_lock);
 	if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
-		ci->i_ceph_flags &= ~CEPH_I_ASYNC_CREATE;
-		wake_up_bit(&ci->i_ceph_flags, CEPH_ASYNC_CREATE_BIT);
+		clear_and_wake_up_bit(CEPH_ASYNC_CREATE_BIT, &ci->i_ceph_flags);
 
 		if (ci->i_ceph_flags & CEPH_I_ASYNC_CHECK_CAPS) {
 			ci->i_ceph_flags &= ~CEPH_I_ASYNC_CHECK_CAPS;
@@ -716,8 +715,7 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
 	}
 
 	spin_lock(&dentry->d_lock);
-	di->flags &= ~CEPH_DENTRY_ASYNC_CREATE;
-	wake_up_bit(&di->flags, CEPH_DENTRY_ASYNC_CREATE_BIT);
+	clear_and_wake_up_bit(CEPH_DENTRY_ASYNC_CREATE_BIT, &di->flags);
 	spin_unlock(&dentry->d_lock);
 
 	return ret;
-- 
2.51.0




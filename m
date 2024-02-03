Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D1A168D7;
	Sat,  3 Feb 2024 04:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933392; cv=none; b=SP0d1sZfCbm9nCDGbilSpTYs2KJ3fOFWAmgo50vrEDkCtn9MGz3wyfmm8/ld1lmIvHCClqwXiOlZGEfuSmJy70FMBStOlLUX1zevwqhYCAtOgGv/iF/u5REm6jpj0u3OeXaWtV+DnEpYRwSMTcklaRECDi6WibR8wSWyWYS2qFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933392; c=relaxed/simple;
	bh=af5DWCOLLjRFiQKS6nOhxxtyloixYWShT1KHaLx6iDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXXNi05+U260if6wkWDym0SUn/pMxGzq0EfQqx/e6K37IYGndkXp0SXqS2julVJp/daa/LvbO4prJaCSm+Cmk3hiPf8ODS+q3jogQHJaQYZqXz+U3SIReCs3Vp1hGXzMy+OozXg47xouAJw+ZZnFncrpMLwnhSt3idGkqkqxA4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DYW3bVcc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DYW3bVcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36E0C43399;
	Sat,  3 Feb 2024 04:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933392;
	bh=af5DWCOLLjRFiQKS6nOhxxtyloixYWShT1KHaLx6iDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DYW3bVccSzFT1aGB4gmGH9/Ba0FU0DIj/FAowNpph8mo8zCh46IMTEtahyQOKsf0D
	 74NXHxbn4mW9YF5nMonvHi1WvdoqZNfaxeqne4kSxvL63F/iPnuAnsMskz9MYYeL1p
	 DpZ0mQlj0w7tcFKLbfBDueAx0mYpESJnQxCdHcFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/219] fast_dput(): handle underflows gracefully
Date: Fri,  2 Feb 2024 20:04:40 -0800
Message-ID: <20240203035332.467643100@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 504e08cebe1d4e1efe25f915234f646e74a364a8 ]

If refcount is less than 1, we should just warn, unlock dentry and
return true, so that the caller doesn't try to do anything else.

Taking care of that leaves the rest of "lockref_put_return() has
failed" case equivalent to "decrement refcount and rejoin the
normal slow path after the point where we grab ->d_lock".

NOTE: lockref_put_return() is strictly a fastpath thing - unlike
the rest of lockref primitives, it does not contain a fallback.
Caller (and it looks like fast_dput() is the only legitimate one
in the entire kernel) has to do that itself.  Reasons for
lockref_put_return() failures:
	* ->d_lock held by somebody
	* refcount <= 0
	* ... or an architecture not supporting lockref use of
cmpxchg - sparc, anything non-SMP, config with spinlock debugging...

We could add a fallback, but it would be a clumsy API - we'd have
to distinguish between:
	(1) refcount > 1 - decremented, lock not held on return
	(2) refcount < 1 - left alone, probably no sense to hold the lock
	(3) refcount is 1, no cmphxcg - decremented, lock held on return
	(4) refcount is 1, cmphxcg supported - decremented, lock *NOT* held
	    on return.
We want to return with no lock held in case (4); that's the whole point of that
thing.  We very much do not want to have the fallback in case (3) return without
a lock, since the caller might have to retake it in that case.
So it wouldn't be more convenient than doing the fallback in the caller and
it would be very easy to screw up, especially since the test coverage would
suck - no way to test (3) and (4) on the same kernel build.

Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dcache.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 52e6d5fdab6b..b09bc88dbbec 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -787,12 +787,12 @@ static inline bool fast_dput(struct dentry *dentry)
 	 */
 	if (unlikely(ret < 0)) {
 		spin_lock(&dentry->d_lock);
-		if (dentry->d_lockref.count > 1) {
-			dentry->d_lockref.count--;
+		if (WARN_ON_ONCE(dentry->d_lockref.count <= 0)) {
 			spin_unlock(&dentry->d_lock);
 			return true;
 		}
-		return false;
+		dentry->d_lockref.count--;
+		goto locked;
 	}
 
 	/*
@@ -850,6 +850,7 @@ static inline bool fast_dput(struct dentry *dentry)
 	 * else could have killed it and marked it dead. Either way, we
 	 * don't need to do anything else.
 	 */
+locked:
 	if (dentry->d_lockref.count) {
 		spin_unlock(&dentry->d_lock);
 		return true;
-- 
2.43.0




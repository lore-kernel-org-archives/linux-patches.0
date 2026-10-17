Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EE03BB9F1;
	Sat, 17 Oct 2026 17:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258810; cv=none; b=i9pmy3pSm9gJEpJYbbYOWxQZAd+7vDW0QyXZrkctPHyJ1yVKr/CP3vXoHESF7LfeDTLJkg+qWRei3YOhuBm46EnwkFL8Zpkc2oQOG6UoaHdXUrCrZzdaR4KwzfNByljblwSx/8/ZfvTm9wK4JmlBPQlNTjmn03kktDXOBk4k2kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258810; c=relaxed/simple;
	bh=kF4ifWZEPXLLOh6QSIfjMked2cJrvKNbK17nX+K0uPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKfsN3dFSex4FUkoUU/mgTB1PsA50mK5aTbffdXAJa1QUk7ytpplbMBTqeHHJ45Yb93br+WFF7MZxoDsdBS2WhFZ3pciKA6rXkyaAZOOsr4zlTE27DaQgxL/M/WhTpb7Sioodd2ByuoXHwF78KRyBjbNafYD3g3DdkiFSzLpVIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AH4lRolu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AH4lRolu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64CB1F000C5;
	Sat, 17 Oct 2026 17:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258809;
	bh=bxAbzA7IsQwhbDObNTBGVxQZcGXpqtETlQQeoy31Ix8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AH4lRoluGwJwWd1LRvpJcedtSxjamv2MdgcxEANyD9LvzUcGAc5jQfimZkX9QAs1c
	 8CiL0O2OujYeKug6YO+N0TZxhNAyyioJVn5mYgmI1iXDIl3KF83IHfKQI+Ihb9AO7X
	 vB8QrVdKm9FHwJSPM1cgN0Fd67q+SshDmsDJ66aE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyungjung Joo <jhj140711@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1005/1674] fs/mbcache: cancel shrink work before destroying the cache
Date: Sat, 17 Oct 2026 17:54:37 +0200
Message-ID: <20261017160456.929505234@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: HyungJung Joo <jhj140711@gmail.com>

[ Upstream commit d227786ab1119669df4dc333a61510c52047cce4 ]

mb_cache_destroy() calls shrinker_free() and then frees all cache
entries and the cache itself, but it does not cancel the pending
c_shrink_work work item first.

If mb_cache_entry_create() schedules c_shrink_work via schedule_work()
and the work item is still pending or running when mb_cache_destroy()
runs, mb_cache_shrink_worker() will access the cache after its memory
has been freed, causing a use-after-free.

This is only reachable by a privileged user (root or CAP_SYS_ADMIN)
who can trigger the last put of a mounted ext2/ext4/ocfs2 filesystem.

Cancel the work item with cancel_work_sync() before calling
shrinker_free(), ensuring the worker has finished and will not be
rescheduled before the cache is torn down.

Fixes: c2f3140fe2ec ("mbcache2: limit cache size")
Signed-off-by: Hyungjung Joo <jhj140711@gmail.com>
Link: https://patch.msgid.link/20260317054556.1821600-1-jhj140711@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/mbcache.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index 82aa7a35db26b..f8cd2e820fbb9 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -408,6 +408,7 @@ void mb_cache_destroy(struct mb_cache *cache)
 {
 	struct mb_cache_entry *entry, *next;
 
+	cancel_work_sync(&cache->c_shrink_work);
 	shrinker_free(cache->c_shrink);
 
 	/*
-- 
2.53.0




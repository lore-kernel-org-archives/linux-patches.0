Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE4116D9B8;
	Mon,  6 Jan 2025 15:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178471; cv=none; b=lXgYUENeBJx1RrCgST72PFQjEhg9B4/ZXjX4VP0nhP+mocXND6/DYWjbRoLSvRtLK7JDa0E3ADsk7DNjJldxP+/n96a5T6e1Owo99v7AmDsvtIpp09kFEOlibZHhD0somICCGgMiyZMslORkyA6Z9J64cQ1qVLQvjY+z2LFiH6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178471; c=relaxed/simple;
	bh=K1dw0xbAcakC/pIXscgxiDnS4WQSISD1XjWflTrGg84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJCBf46vHQXtj1etmsUavciLKzgNT2YVlti8Z8hBYIcJJRXOkD0SXo+6pKfPnEm+WoD80YT53qOYuQtqQV+pWPVjeJKhlAmZ1wgdLHcG8Pip2KAp+Tk0SnMvFn06fY6veGxNHIQ/yvOeXhsvYAjAL2xiv4xGPNEObVanrG8xgFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RoGOg8bB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RoGOg8bB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4EAC4CED2;
	Mon,  6 Jan 2025 15:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178471;
	bh=K1dw0xbAcakC/pIXscgxiDnS4WQSISD1XjWflTrGg84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RoGOg8bBBRMDYwjqz4aOKb4sap5V3uW2XommffoGTbHFMgz5rIm4O35BYUcgn5rYA
	 CmR6TfsxS7B1kk372S7aettzXXitaQOiwxSV/DH5G29VxiQssEzBDcIdJtpexLzysy
	 exN345I895LIaL6VQDpOtNddHoqn3Zp+3H+XPzLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Borisov <nborisov@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/138] btrfs: dont set lock_owner when locking extent buffer for reading
Date: Mon,  6 Jan 2025 16:17:34 +0100
Message-ID: <20250106151138.156141653@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>

[ Upstream commit 97e86631bccddfbbe0c13f9a9605cdef11d31296 ]

In 196d59ab9ccc "btrfs: switch extent buffer tree lock to rw_semaphore"
the functions for tree read locking were rewritten, and in the process
the read lock functions started setting eb->lock_owner = current->pid.
Previously lock_owner was only set in tree write lock functions.

Read locks are shared, so they don't have exclusive ownership of the
underlying object, so setting lock_owner to any single value for a
read lock makes no sense.  It's mostly harmless because write locks
and read locks are mutually exclusive, and none of the existing code
in btrfs (btrfs_init_new_buffer and print_eb_refs_lock) cares what
nonsense is written in lock_owner when no writer is holding the lock.

KCSAN does care, and will complain about the data race incessantly.
Remove the assignments in the read lock functions because they're
useless noise.

Fixes: 196d59ab9ccc ("btrfs: switch extent buffer tree lock to rw_semaphore")
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/locking.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 1e36a66fcefa..3d177ef92ab6 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -47,7 +47,6 @@ void __btrfs_tree_read_lock(struct extent_buffer *eb, enum btrfs_lock_nesting ne
 		start_ns = ktime_get_ns();
 
 	down_read_nested(&eb->lock, nest);
-	eb->lock_owner = current->pid;
 	trace_btrfs_tree_read_lock(eb, start_ns);
 }
 
@@ -64,7 +63,6 @@ void btrfs_tree_read_lock(struct extent_buffer *eb)
 int btrfs_try_tree_read_lock(struct extent_buffer *eb)
 {
 	if (down_read_trylock(&eb->lock)) {
-		eb->lock_owner = current->pid;
 		trace_btrfs_try_tree_read_lock(eb);
 		return 1;
 	}
@@ -92,7 +90,6 @@ int btrfs_try_tree_write_lock(struct extent_buffer *eb)
 void btrfs_tree_read_unlock(struct extent_buffer *eb)
 {
 	trace_btrfs_tree_read_unlock(eb);
-	eb->lock_owner = 0;
 	up_read(&eb->lock);
 }
 
-- 
2.39.5




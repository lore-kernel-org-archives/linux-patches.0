Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5BB1A704B;
	Sun,  7 Sep 2025 20:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277455; cv=none; b=MDtK3WNidN3E9sWMURuIKgg4kGfkmhL3HOEQpne2NCiGc9UYJ0M1k9PUGAl3vQ+OiSBmMNhV7PC+NUCnHirW7quBCAjYBW1sE0lX0LJ2SVpgXwIb2BSEjA+5dMU+ZdNKZtTKEVDe+G1nCs6VtYLaUQ3TVCrWY1H8ugjRquHI71o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277455; c=relaxed/simple;
	bh=892khP/4Dv/hErkdtrDMj6u6nVGvdU9fyyx5Zo3nCTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FajhKJOk59tRa44IRdGN3k+btWO0aeayDRLd11MSVf1MpNOFnp9ZAd+VBiOIRjO6W6mYwgr5Ho5VZ+ybyMMFW0ZPrHLII7KWWox7PIsvKfzJd4m3jqt/qWXQDPHpoDttIZxHGHdHpLfacz7Mxl6A+b7ob3RuiaeHtRNX9doYbxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GWp5uKHO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWp5uKHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A14EC4CEF0;
	Sun,  7 Sep 2025 20:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277455;
	bh=892khP/4Dv/hErkdtrDMj6u6nVGvdU9fyyx5Zo3nCTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GWp5uKHO78D8uW9/ggxrg1awladbI5A4Fy4HEbDpsfbk8gR61E6nGve58UYgpVvRH
	 BI/KReNfv0U8ex3VcpLeO/CQyBthJbAJIZpt3OddOH6jzryGIWESjysTSNQQ0CT30r
	 G0GWcg8XYyJB31HmdEGGm3HzHOAcFOJMfh7ePnH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 003/183] btrfs: avoid load/store tearing races when checking if an inode was logged
Date: Sun,  7 Sep 2025 21:57:10 +0200
Message-ID: <20250907195615.883918984@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 986bf6ed44dff7fbae7b43a0882757ee7f5ba21b ]

At inode_logged() we do a couple lockless checks for ->logged_trans, and
these are generally safe except the second one in case we get a load or
store tearing due to a concurrent call updating ->logged_trans (either at
btrfs_log_inode() or later at inode_logged()).

In the first case it's safe to compare to the current transaction ID since
once ->logged_trans is set the current transaction, we never set it to a
lower value.

In the second case, where we check if it's greater than zero, we are prone
to load/store tearing races, since we can have a concurrent task updating
to the current transaction ID with store tearing for example, instead of
updating with a single 64 bits write, to update with two 32 bits writes or
four 16 bits writes. In that case the reading side at inode_logged() could
see a positive value that does not match the current transaction and then
return a false negative.

Fix this by doing the second check while holding the inode's spinlock, add
some comments about it too. Also add the data_race() annotation to the
first check to avoid any reports from KCSAN (or similar tools) and comment
about it.

Fixes: 0f8ce49821de ("btrfs: avoid inode logging during rename and link when possible")
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 5f82e8c59cd17..56d30ec0f52fc 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3351,15 +3351,32 @@ static int inode_logged(const struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 	int ret;
 
-	if (inode->logged_trans == trans->transid)
+	/*
+	 * Quick lockless call, since once ->logged_trans is set to the current
+	 * transaction, we never set it to a lower value anywhere else.
+	 */
+	if (data_race(inode->logged_trans) == trans->transid)
 		return 1;
 
 	/*
-	 * If logged_trans is not 0, then we know the inode logged was not logged
-	 * in this transaction, so we can return false right away.
+	 * If logged_trans is not 0 and not trans->transid, then we know the
+	 * inode was not logged in this transaction, so we can return false
+	 * right away. We take the lock to avoid a race caused by load/store
+	 * tearing with a concurrent btrfs_log_inode() call or a concurrent task
+	 * in this function further below - an update to trans->transid can be
+	 * teared into two 32 bits updates for example, in which case we could
+	 * see a positive value that is not trans->transid and assume the inode
+	 * was not logged when it was.
 	 */
-	if (inode->logged_trans > 0)
+	spin_lock(&inode->lock);
+	if (inode->logged_trans == trans->transid) {
+		spin_unlock(&inode->lock);
+		return 1;
+	} else if (inode->logged_trans > 0) {
+		spin_unlock(&inode->lock);
 		return 0;
+	}
+	spin_unlock(&inode->lock);
 
 	/*
 	 * If no log tree was created for this root in this transaction, then
-- 
2.50.1




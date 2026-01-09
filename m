Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0539735B14E;
	Fri,  9 Jan 2026 12:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962938; cv=none; b=NbbSSXKpJZ2dU23VmMZzs14ZdbGZ/smIZIJV3/wZ+3jISWAZKMOudcyNLTdEfOsTqbJiLcnD4xOw0MSftb9XnvTK8B2bvezjVpRvDOn2ltqWuVifgMP50u6bF85yVTKOvz8JtlebibXNy3L8QkgQOeea+R1vUijSG3XnN6zabBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962938; c=relaxed/simple;
	bh=oMNqkaoYXbVoiW5ysTOqaRhtc/iLjsMxvHTdeCGB7iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQlFO0Cq2u2haDoIrGOuto+vFTJ3YJPU4PEOovUdGjGRmF0jggzUufmwt2+6yYhh6PU6Gm4+bCQFQdsgZrW4DVpOkuuFrtuI6cyYjDuJbmaBcxxWPjwVkOoLrAcwBJhEpA7hGI6OIONz6yO7EzNJGeQKP0nwcKqjybv1HyHAmKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YwwuuYWg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YwwuuYWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48ED1C4CEF1;
	Fri,  9 Jan 2026 12:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962937;
	bh=oMNqkaoYXbVoiW5ysTOqaRhtc/iLjsMxvHTdeCGB7iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YwwuuYWgvC2fSW7VXxRbrHsdx6PoUeKMfZAH7GmmvO9EZCRpQKgPQzhZTkq9qyt/8
	 goWWIXzuYjsZKGNzksplvM8qr2oFbPyzKFrSB2dMYmALrqKTVG79M1o7EFpDSMF98q
	 131UQsqO/92+GFRs8fjNMmiZu6PejUy6UM0f05VY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Daniel Vacek <neelx@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 541/634] btrfs: dont rewrite ret from inode_permission
Date: Fri,  9 Jan 2026 12:43:39 +0100
Message-ID: <20260109112137.942409895@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 0185c2292c600993199bc6b1f342ad47a9e8c678 ]

In our user safe ino resolve ioctl we'll just turn any ret into -EACCES
from inode_permission().  This is redundant, and could potentially be
wrong if we had an ENOMEM in the security layer or some such other
error, so simply return the actual return value.

Note: The patch was taken from v5 of fscrypt patchset
(https://lore.kernel.org/linux-btrfs/cover.1706116485.git.josef@toxicpanda.com/)
which was handled over time by various people: Omar Sandoval, Sweet Tea
Dorminy, Josef Bacik.

Fixes: 23d0b79dfaed ("btrfs: Add unprivileged version of ino_lookup ioctl")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add note ]
Signed-off-by: David Sterba <dsterba@suse.com>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2897,10 +2897,8 @@ static int btrfs_search_path_in_tree_use
 			ret = inode_permission(mnt_userns, temp_inode,
 					       MAY_READ | MAY_EXEC);
 			iput(temp_inode);
-			if (ret) {
-				ret = -EACCES;
+			if (ret)
 				goto out_put;
-			}
 
 			if (key.offset == upper_limit.objectid)
 				break;



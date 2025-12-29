Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70F725F797;
	Mon, 29 Dec 2025 16:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025528; cv=none; b=H0IbgFpRHX/jkEj1IpZHioDLetFbWcZBHZNI7B0EBRf+LyAgHxwmbLGRK/gBkUh1QhZBeof0B57MkzWKYNO7QycqmU7MnDAkgwnR+uprGcvjQNRtixOBNIOT1/Xg9WSyUu7KwLWv4wYSm0+PehHtjmGwSHX3Wd2rgPdy72SK1Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025528; c=relaxed/simple;
	bh=0fqDnxRmZ4edNrIKrCmbpjp9sNxAAVA4zPlod+FLakg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCzw+tvmxv36PgYdGfohsgZwu6JET2JoED6EA3w5bkd9XBf/uQXV/v4CQhSpHhXdB2RDIE6kfq/1XR5mvU6uX3rVNbPpHqcZ9gEHT+IAglJJIoZNwMqM8+x+tKauboOydy3mOip5T2CrAK74vRmWpM+qPVm441+c03McElRdSa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNoHxzG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNoHxzG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF1FC4CEF7;
	Mon, 29 Dec 2025 16:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025528;
	bh=0fqDnxRmZ4edNrIKrCmbpjp9sNxAAVA4zPlod+FLakg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNoHxzG7HS+t0ahKZwS0OhN2kGbIydOZleLvjpalaXP7nTv20WWSOH/vvxUL1UzCt
	 kqO4LFqaYy2YPk7/kIp1RpKWLUSnSY1n9lqD3Kf0jBLiwe+iqICY75LqJNq36k7e0J
	 w1wE8oY8wbzIB3zy87OQi66MV1GZUTj84TrVnpLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Daniel Vacek <neelx@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.18 246/430] btrfs: dont rewrite ret from inode_permission
Date: Mon, 29 Dec 2025 17:10:48 +0100
Message-ID: <20251229160733.406762941@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit 0185c2292c600993199bc6b1f342ad47a9e8c678 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1913,10 +1913,8 @@ static int btrfs_search_path_in_tree_use
 			ret = inode_permission(idmap, &temp_inode->vfs_inode,
 					       MAY_READ | MAY_EXEC);
 			iput(&temp_inode->vfs_inode);
-			if (ret) {
-				ret = -EACCES;
+			if (ret)
 				goto out_put;
-			}
 
 			if (key.offset == upper_limit)
 				break;



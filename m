Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF64E3BF309;
	Thu, 15 Jan 2026 17:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498439; cv=none; b=Omz7gXK4cAQ31UK3qPkuT+oks9pe4aXxx/OMtuSV51ydl9WbBAeq1Zn/iHnSSnqQf3hanTLFEibJ2FLxblBJEVqiPlVyRHF9SIufOMMZ6gMrpVjFO654XOAaZn9S9onVCvlXKsfwxsJjqWXQx+bS19mRAlzSp+c3NoHeM3m4PH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498439; c=relaxed/simple;
	bh=oTWgznFtJTutcZhFHGSt5Md2EgDRglB4rN7WyIW+BI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DSQKnHlKZE0f4Y76hmoAZ24Xw1GpTpsHDtTVs5Tim/Qbd2ngkcv3SSTGpPW7/Nyddtpkkwzqd5HCiY9xyEqkyGqJWj9HcW6BK3AFhd3TvKDijRZI2pqqHTgOWKO3urrQ4BG6kF7rpr+tqB/mU2OJJnaN5sJ1Yj9/6yUL2M2gquA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rYlJ2ZVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rYlJ2ZVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F00DC19422;
	Thu, 15 Jan 2026 17:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498439;
	bh=oTWgznFtJTutcZhFHGSt5Md2EgDRglB4rN7WyIW+BI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rYlJ2ZVxyXJOs4PUHAj7DXFmXqctx7xAqxEJNTQjn3n/LEcSfo17r1A8YmHDj1E5A
	 YTKecYh2Jk7h2eFAAdYHYe9yF9+nUrlkyvKDR/FCs/3pQOU/lqjxd991/6Ca+daAjD
	 WFyJcl+/+f9Z/XL/oBqPt9NG8LWKnXTlsPs1uj4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Daniel Vacek <neelx@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 433/554] btrfs: dont rewrite ret from inode_permission
Date: Thu, 15 Jan 2026 17:48:19 +0100
Message-ID: <20260115164301.933133813@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
@@ -2553,10 +2553,8 @@ static int btrfs_search_path_in_tree_use
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



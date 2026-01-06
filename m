Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7911F1F1932;
	Tue,  6 Jan 2026 17:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721276; cv=none; b=fweNfg4dR5Sn2HAh3QDOlCqAC5doO2CmIW/vNTV6NGQGrqVOdM/E/J+l1F4fyduvNWsDLXkrksg42BMzbgko/bxfyvSdRRjB1tU/f4b3w6CWTQ9/2uRPo/JBVnCDFIIq59bB5r1HBIlwm/Ef1g21SqoAXtBF/KenbPEocZvO2gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721276; c=relaxed/simple;
	bh=CmgLKdB93tm3Bnc5prh1Oo1AlKCPqb3USnCHATZS46c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGnWcOD/8VgD+Tk49FHjgVc54GPyw1Si/cJBzt36/e9IZFCGg6B0XNyTWjmBfKbrqZe09jvt+ZEBglviP86gLZTzTKoB5BQdL7tJOfn2u+h2DSSzu9YFlqtP/EvJIIafGRh72j1DgtK3FO1Z5QZa2XIHOh+vWHFXN/9vb7BlcA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BOas0PkR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BOas0PkR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4663C16AAE;
	Tue,  6 Jan 2026 17:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721276;
	bh=CmgLKdB93tm3Bnc5prh1Oo1AlKCPqb3USnCHATZS46c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BOas0PkRLYcp4Apxhpk1BltXGY++h4s2UyURVoYlBwkkSatoJ47c5PRe2UvSCi6fo
	 8+CQESsmUFuNMXzUkLk/+Qjf+oXv2r5Z6P2P0UxjkeCcfQCO/OfvUnEjoK/4awmC7l
	 Rnsz79mWRj0Ovr+Q3bQRQSW1K6sztZr7Vq1mKUYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Daniel Vacek <neelx@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 487/567] btrfs: dont rewrite ret from inode_permission
Date: Tue,  6 Jan 2026 18:04:29 +0100
Message-ID: <20260106170509.375415662@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2012,10 +2012,8 @@ static int btrfs_search_path_in_tree_use
 			ret = inode_permission(idmap, temp_inode,
 					       MAY_READ | MAY_EXEC);
 			iput(temp_inode);
-			if (ret) {
-				ret = -EACCES;
+			if (ret)
 				goto out_put;
-			}
 
 			if (key.offset == upper_limit)
 				break;



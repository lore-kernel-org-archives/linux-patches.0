Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571562153DD;
	Thu, 12 Dec 2024 17:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024769; cv=none; b=Wb+kZxpWbku4lVGUEwGQoiqulrOnH6Aj+cC9K6qvKSScqC1rZy/jvqIaTcTWDYya67xNBnGyMNGxev9VoLpnAraxtV1fwJ3hTWDpj5ruGWMzR7q3B/EZ2ccvB018Ph+8UAd21dAswZ6t7KryFPRhskHGLDvUukuC81LiPSvUVqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024769; c=relaxed/simple;
	bh=+Nj/pP4t6fuxgrSyBtbQ+Nuu94+Nr1b+e24PKajKleM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZolTBRB7gIdIoEPGEQ7zrdRlZ9z68FYMU76SFtd9vb+HHBMw3Ep0HeyNFV/t6vPF5AO6MEm8ABbpMtorasBfiuan10dLBwgFGh8KBGggB+K3Ld9BQGJDPGLkZeSzymb8Nh/KKZ6Yr7eqZbQGZRNqmipT11qwk1Hae+h4wUK3KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BHjJ4PvJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BHjJ4PvJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1705C4CECE;
	Thu, 12 Dec 2024 17:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024769;
	bh=+Nj/pP4t6fuxgrSyBtbQ+Nuu94+Nr1b+e24PKajKleM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BHjJ4PvJX1c/Qpl9vEqI3BbazpBB/MldpyuO3ydm0lejdk8JTh9+4H8XX033lYbIv
	 QF3xLmwnWsCx5a5J9FK7CanFh+bRRkaGne7flu0JTJQy22FMspWqXdlxK8ec0VhSFM
	 ftLhfOBeqBNHi84jIQM4pYL07khfX4d/4ZhaRAuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b5ca8a249162c4b9a7d0@syzkaller.appspotmail.com,
	Ghanshyam Agrawal <ghanshyam1898@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 405/459] jfs: fix shift-out-of-bounds in dbSplit
Date: Thu, 12 Dec 2024 16:02:23 +0100
Message-ID: <20241212144309.766105949@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ghanshyam Agrawal <ghanshyam1898@gmail.com>

[ Upstream commit a5f5e4698f8abbb25fe4959814093fb5bfa1aa9d ]

When dmt_budmin is less than zero, it causes errors
in the later stages. Added a check to return an error beforehand
in dbAllocCtl itself.

Reported-by: syzbot+b5ca8a249162c4b9a7d0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b5ca8a249162c4b9a7d0
Signed-off-by: Ghanshyam Agrawal <ghanshyam1898@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 559f6ebebfc0c..c61fcf0e88d29 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -1886,6 +1886,9 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
 			return -EIO;
 		dp = (struct dmap *) mp->data;
 
+		if (dp->tree.budmin < 0)
+			return -EIO;
+
 		/* try to allocate the blocks.
 		 */
 		rc = dbAllocDmapLev(bmp, dp, (int) nblocks, l2nb, results);
-- 
2.43.0




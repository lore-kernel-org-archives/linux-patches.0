Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFDA1DE8A2;
	Wed,  6 Nov 2024 12:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895347; cv=none; b=rTA1lv2YS6l9d+9Vg0B50I98AZVdkSKMkkPfL+Rw+lWj0uVOrqhhX7/dPSiLDbIq7wnl33tEC2J1V8AfD2gEV2l9F1NCKxlEytD5m+Xu5Ljv1CDQDdDvwBCzkOVrGg6vvEDy1cS3BjGW2BvqIsBnSHiJupA6R6phj+0wTnB3K0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895347; c=relaxed/simple;
	bh=Zos4tI3lgLYk+YIotm/2C8IZOB6t7/Gou096R8WoklA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=luaqX4od/WjXWV58XogMS49CQRkR0H5i1qfNjeXN9W301KjJV802h+e6ui3B+yq1L9/0J4nmCclq1PDbYHrE+6Kzx1nOJtOLxe6IB80iK8i6WwT58W95+iLa3ieWkUjmSlRKIIr/e6exL1bRGrC+cr5LXpoj5qqu0bp6wXr7Qe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j/hEvp4t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j/hEvp4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9FAC4CECD;
	Wed,  6 Nov 2024 12:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895347;
	bh=Zos4tI3lgLYk+YIotm/2C8IZOB6t7/Gou096R8WoklA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j/hEvp4tAXg5c7IvQsw6ecZ4VgkWMqgzMkLzJoSat5WFcUSgfJl8Dg1+oYTVLeZfB
	 aCnwQw/zOzE2LN01YtW21zM1AeuCiWNyFL/l8CEr/tGYUb5p924Ydq3Mtgg6J6UBwx
	 EAV7CgAlZWYV7U0W1LmaYNU+UZUEZmmcREESR7PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+dca05492eff41f604890@syzkaller.appspotmail.com
Subject: [PATCH 4.19 170/350] jfs: check if leafidx greater than num leaves per dmap tree
Date: Wed,  6 Nov 2024 13:01:38 +0100
Message-ID: <20241106120325.124437073@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit d64ff0d2306713ff084d4b09f84ed1a8c75ecc32 ]

syzbot report a out of bounds in dbSplit, it because dmt_leafidx greater
than num leaves per dmap tree, add a checking for dmt_leafidx in dbFindLeaf.

Shaggy:
Modified sanity check to apply to control pages as well as leaf pages.

Reported-and-tested-by: syzbot+dca05492eff41f604890@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=dca05492eff41f604890
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 9f731847ae634..21597e8b727c6 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -3019,9 +3019,10 @@ static void dbAdjTree(dmtree_t *tp, int leafno, int newval, bool is_ctl)
 static int dbFindLeaf(dmtree_t *tp, int l2nb, int *leafidx, bool is_ctl)
 {
 	int ti, n = 0, k, x = 0;
-	int max_size;
+	int max_size, max_idx;
 
 	max_size = is_ctl ? CTLTREESIZE : TREESIZE;
+	max_idx = is_ctl ? LPERCTL : LPERDMAP;
 
 	/* first check the root of the tree to see if there is
 	 * sufficient free space.
@@ -3053,6 +3054,8 @@ static int dbFindLeaf(dmtree_t *tp, int l2nb, int *leafidx, bool is_ctl)
 		 */
 		assert(n < 4);
 	}
+	if (le32_to_cpu(tp->dmt_leafidx) >= max_idx)
+		return -ENOSPC;
 
 	/* set the return to the leftmost leaf describing sufficient
 	 * free space.
-- 
2.43.0




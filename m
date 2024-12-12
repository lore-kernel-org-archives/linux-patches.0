Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA32623A180;
	Thu, 12 Dec 2024 16:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021350; cv=none; b=jQnuMjHbGIp+PhBrMuJPktYhdP6tSYLUFAzL+UJXe0Vm0TooyjPLpBmA53StYzSDCU1bD4w6jB20jIt6wSl2VInPQFh6JIfufqKfIQT4EDFKTk+FjLryvbkTJ1ymx8lU4HM3W8VOwZH1rpp3LHuBWsSh3LXQGeHJLh1y4sdTPIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021350; c=relaxed/simple;
	bh=BDiHpkfnH4hpmhbUJ1XLdL+xVa0mbdizKPvN2/vmU3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3MiWA533JGUNcZbFrJIbMBkvMr2yXYB6wUeKa0pyaPURG37ZulasR7lwIV9//8MGRcKNnw8YhE2FaZ1ylgnxA5yiumQ/xE2fpag1nG0neZoUA6mBB0Z1mCtYoSi5kPYogYR6d0mT1aghtLS8JQlpOxbAeK1OGZnA3GRPhYx5xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2OkJWasZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2OkJWasZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B40C4CED0;
	Thu, 12 Dec 2024 16:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021350;
	bh=BDiHpkfnH4hpmhbUJ1XLdL+xVa0mbdizKPvN2/vmU3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2OkJWasZTxVI2UVCiNeyAT85Ng4Rq1EK7hLdhF/cFXBHspYIszpu3S367cKufrYDZ
	 8+yQ2JIEGztoV3BTRjCkLdyVmVWU7gxM1VLzduaPQ7419jR7onTRqgSnt7rq3oFcZd
	 8lybaDy/jkEz/PcCH6AGQiMOv9zs5eD5zwNmtYyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+65fa06e29859e41a83f3@syzkaller.appspotmail.com,
	Ghanshyam Agrawal <ghanshyam1898@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 683/772] jfs: array-index-out-of-bounds fix in dtReadFirst
Date: Thu, 12 Dec 2024 16:00:28 +0100
Message-ID: <20241212144418.135214728@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Ghanshyam Agrawal <ghanshyam1898@gmail.com>

[ Upstream commit ca84a2c9be482836b86d780244f0357e5a778c46 ]

The value of stbl can be sometimes out of bounds due
to a bad filesystem. Added a check with appopriate return
of error code in that case.

Reported-by: syzbot+65fa06e29859e41a83f3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=65fa06e29859e41a83f3
Signed-off-by: Ghanshyam Agrawal <ghanshyam1898@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dtree.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index 5d3127ca68a42..69fd936fbdb37 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -3086,6 +3086,13 @@ static int dtReadFirst(struct inode *ip, struct btstack * btstack)
 
 		/* get the leftmost entry */
 		stbl = DT_GETSTBL(p);
+
+		if (stbl[0] < 0 || stbl[0] > 127) {
+			DT_PUTPAGE(mp);
+			jfs_error(ip->i_sb, "stbl[0] out of bound\n");
+			return -EIO;
+		}
+
 		xd = (pxd_t *) & p->slot[stbl[0]];
 
 		/* get the child page block address */
-- 
2.43.0




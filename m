Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE42215710;
	Thu, 12 Dec 2024 17:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024766; cv=none; b=CUPoZ0rKQAfVlodX7nrE0DXvXEuadYuDpY8V69cUP+fJ8WsfkDGM7/oz8WLy0pUMd4hlBgM8NQ2RrZiK6h+FXBc04syPH35kuSeus2r7sTqn5z0jeqZRuxHY5JSyVd5JdYwBDyqHEKcdPqRAYAVbpGaTqtrd0/YOOdd9Bat1r2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024766; c=relaxed/simple;
	bh=k+4sWLlxIHkpCaz0cw/Gui7K68VEqXIsUmBQqpU6GLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKjKBf8N17yTTcj+1oZrmSU+iY5uZACXdaFHIjcHlgLm9ZSt2lk9h/jPR8UTRCuX/8NevCzf5k4QbyPC+Z5tkbcF0NPHHVswyg/ADbTqXVDGu5hb4yyrlQ+QH9IFya93m1uQV0uHWd8TEO5tjuZj6ASkbv+F/pBCCCUatmKN4pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1Te2AQV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1Te2AQV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D929AC4CECE;
	Thu, 12 Dec 2024 17:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024766;
	bh=k+4sWLlxIHkpCaz0cw/Gui7K68VEqXIsUmBQqpU6GLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1Te2AQVGsAcCVq9fRRs63EwoZ1eJYG6ETaYj+j/4kP48rjerP2CI79/D5ruljlqu
	 nm8OFnQkTKfZ6MRoaYYpm4uIRboVVGhRdscNfbQ3snkVz74z7D1Cs25PZyZswSP92i
	 pQcS804dbC2JspCfbUT36aVc9hZ1W7v/zrHzC3wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+65fa06e29859e41a83f3@syzkaller.appspotmail.com,
	Ghanshyam Agrawal <ghanshyam1898@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 404/459] jfs: array-index-out-of-bounds fix in dtReadFirst
Date: Thu, 12 Dec 2024 16:02:22 +0100
Message-ID: <20241212144309.727365475@linuxfoundation.org>
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
index a222a9d71887f..8f7ce1bea44c5 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -3382,6 +3382,13 @@ static int dtReadFirst(struct inode *ip, struct btstack * btstack)
 
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




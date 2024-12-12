Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B0C22330D;
	Thu, 12 Dec 2024 17:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023338; cv=none; b=tQ2F8K9AbUpCdE3MwZRTpc58HfeeU0mSaRAz+44K44BtcgrdE9eJ2GwVbuU4RSF5f93KccUvVdZfecYLNUdTOtGr976eugDHkGrz+aptitr+V1NauNwhyebi6kbCdEkq/kgAobqoGS4fRuJTtStZWzWv91iP1h+08UVibOMqsPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023338; c=relaxed/simple;
	bh=Q6N6TR1UmqktXwnPrMjmjH4RDJR/LRhpyZ+cY+Ytjz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GfegzBMrPQ26QxdyCJe2AqV9T1Au57GWmVN/6lSjm17H8zSrBvubFRONGYj7Su798Owo9I/e0B+wAudnst0MJ4T5+JErMuIX4PilnaE7I4uiRVxmr2MuuH/N6FNXzfIWvUWPe673gIYqbtBrSUlgoaBOPQL78RVvOU65JgmmI1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kE77HZnS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kE77HZnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CB4C4CECE;
	Thu, 12 Dec 2024 17:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023337;
	bh=Q6N6TR1UmqktXwnPrMjmjH4RDJR/LRhpyZ+cY+Ytjz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kE77HZnSNqr2HoE0KebPi0HEesowhcQN18Lt8ACKXXv+cwTX/qB0t7/AEKKCzmN54
	 0znfuXAgxLcMgoIBN/STCChGrBs92hS3OsjMi2ht9SmeUwZxUSnXyHxLO0HsMnxyNZ
	 hfyvPNJal9pDdcne3vaNaaE/v4AHZN/ePHmVOv7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0315f8fe99120601ba88@syzkaller.appspotmail.com,
	Ghanshyam Agrawal <ghanshyam1898@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 501/565] jfs: fix array-index-out-of-bounds in jfs_readdir
Date: Thu, 12 Dec 2024 16:01:36 +0100
Message-ID: <20241212144331.568916482@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ghanshyam Agrawal <ghanshyam1898@gmail.com>

[ Upstream commit 839f102efb168f02dfdd46717b7c6dddb26b015e ]

The stbl might contain some invalid values. Added a check to
return error code in that case.

Reported-by: syzbot+0315f8fe99120601ba88@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0315f8fe99120601ba88
Signed-off-by: Ghanshyam Agrawal <ghanshyam1898@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dtree.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index 8f7ce1bea44c5..a3d1d560f4c86 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -3187,6 +3187,14 @@ int jfs_readdir(struct file *file, struct dir_context *ctx)
 		stbl = DT_GETSTBL(p);
 
 		for (i = index; i < p->header.nextindex; i++) {
+			if (stbl[i] < 0 || stbl[i] > 127) {
+				jfs_err("JFS: Invalid stbl[%d] = %d for inode %ld, block = %lld",
+					i, stbl[i], (long)ip->i_ino, (long long)bn);
+				free_page(dirent_buf);
+				DT_PUTPAGE(mp);
+				return -EIO;
+			}
+
 			d = (struct ldtentry *) & p->slot[stbl[i]];
 
 			if (((long) jfs_dirent + d->namlen + 1) >
-- 
2.43.0




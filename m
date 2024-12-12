Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F7313792B;
	Thu, 12 Dec 2024 15:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017149; cv=none; b=fXMdhslQdtLtHYWKFOhshTZjlLwKx4XvIDX9811oP3TEXTC51Y4dPNRPa9VCZAZ/RP073LrUs6xhkv6B2F+2pj4bM9PoY7GKhA/MYthMpgMbZkMIr5mWDYobnoF6U0hUpWZRK2idowro9BB+OqEXlsJON7mojw1QeBEWOiZ2diU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017149; c=relaxed/simple;
	bh=ZO43cznYBHTHlfdYf44pQFblYoLKWyLWVPxf60GmDxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDAzkH5WD/EpZ52EqiEDofTMnuL9jCDLcJ8Gu7KdBN6oR8Ei1K+LDkbR+bm/aVEVC9w4xFRLEiIStfpY/ysR88zXzYkMUusFpkTv5q/y3wluJ6Elw1uLTSTA65YDVmCbhb/DUY9ge1JC31keDiYj+Vq19R0OXEYX91+JX0gKWgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWm8xz7i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWm8xz7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A97C4CECE;
	Thu, 12 Dec 2024 15:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017149;
	bh=ZO43cznYBHTHlfdYf44pQFblYoLKWyLWVPxf60GmDxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yWm8xz7i5rRtCIICJ3IkmocI3e6hzpW6+KdNhI0gIfy0E6qESPeHXYmLFE1gA6NhM
	 7gRb+6+kCrST5sV0j+06sLt3OgbeptN/vihbpEPF0T5xIdlSXId/E6bh+BVa9ShFKh
	 tlIJvsfZ3d5W4iS6UIEFz/0XJKNJgQrRoDoZvQx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+aa0730b0a42646eb1359@syzkaller.appspotmail.com,
	Qianqiang Liu <qianqiang.liu@163.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 389/466] KMSAN: uninit-value in inode_go_dump (5)
Date: Thu, 12 Dec 2024 15:59:18 +0100
Message-ID: <20241212144322.141423582@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianqiang Liu <qianqiang.liu@163.com>

[ Upstream commit f9417fcfca3c5e30a0b961e7250fab92cfa5d123 ]

When mounting of a corrupted disk image fails, the error message printed
can reference uninitialized inode fields.  To prevent that from happening,
always initialize those fields.

Reported-by: syzbot+aa0730b0a42646eb1359@syzkaller.appspotmail.com
Signed-off-by: Qianqiang Liu <qianqiang.liu@163.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index e22c1edc32b39..b9cef63c78717 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1537,11 +1537,13 @@ static struct inode *gfs2_alloc_inode(struct super_block *sb)
 	if (!ip)
 		return NULL;
 	ip->i_no_addr = 0;
+	ip->i_no_formal_ino = 0;
 	ip->i_flags = 0;
 	ip->i_gl = NULL;
 	gfs2_holder_mark_uninitialized(&ip->i_iopen_gh);
 	memset(&ip->i_res, 0, sizeof(ip->i_res));
 	RB_CLEAR_NODE(&ip->i_res.rs_node);
+	ip->i_diskflags = 0;
 	ip->i_rahead = 0;
 	return &ip->i_inode;
 }
-- 
2.43.0




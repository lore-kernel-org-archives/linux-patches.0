Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C530B21578E;
	Thu, 12 Dec 2024 15:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016875; cv=none; b=IpbfRPXMfFQstLKn6XA/6s5ewTGxApJIqmpWMglELViAUk5rwK1J3AFMre9HEmBBlJBuVGdFJh04vFL3VLHsVSrm+QXQyjV7z8+O+pxddZU8zOdVpQp2vzQjId8seCphA3JAk0dAzNCLgtIlb/uGO/DvVgp0SqqNLQqtLCBb13o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016875; c=relaxed/simple;
	bh=WgjfDnQoYsdrJ6B/NHP6Wngup37s6D+UPJ9MKQd+Tyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L3jM2MBIR9nwGPk2nfhL4/+KQ4Z13+LcGHEmWL4Z25y2cy1hP6iRqjUrJPUzc+yjtCTmqGRa0/8LifWOmVrec+ItzFUMPt2IqqbKWshSiOG4S3YTbox1Wa0ckKja2VHOll5p++1vZMzcSpiCJNL0P6tcMKQqYru82fbXXvHJxZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iLGl/oRR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iLGl/oRR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30566C4CED7;
	Thu, 12 Dec 2024 15:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016875;
	bh=WgjfDnQoYsdrJ6B/NHP6Wngup37s6D+UPJ9MKQd+Tyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iLGl/oRRtFVO3zbk5+MO6Rwgzyb+6vROgQnTaLJ4Y/qwQ559+j5iQ24Pd4SWN0rJ6
	 e5gkNs+XuIsAM8powe2YH33/qLkSFxkFYVTWyvrbIyLes68DnJ399JvyLq1OX8H4m0
	 UtkIlBGNuMz/0fnFFsmU6abM/G7Jkca++qXqpA+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b5ca8a249162c4b9a7d0@syzkaller.appspotmail.com,
	Ghanshyam Agrawal <ghanshyam1898@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 320/466] jfs: fix shift-out-of-bounds in dbSplit
Date: Thu, 12 Dec 2024 15:58:09 +0100
Message-ID: <20241212144319.438842314@linuxfoundation.org>
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
index 3ab410059dc20..39957361a7eed 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -1820,6 +1820,9 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F6823EA9E;
	Thu, 12 Dec 2024 16:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021354; cv=none; b=R4tCa1krnW4ftPE7nVM6C/eKKUovrhOrbj6vAEVwXe6qadaqfrX2AfA7iMATKLS8AN5oUWy+FrjnXw9l9kkOvZEf0M3+FNMOe6FtxJCQZa5N+3C4L1IZcRcJMxgej5xmDWrhhxQPMOIL3VgIf16rUOv8O6SrQFfpLVpO2MoPppw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021354; c=relaxed/simple;
	bh=5gu4Oaw9BFo6TxMrdw6bL5BmTOhsUvZ1oEy7wv1mwYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/t3LVMnd5F8fFtHsNtbAXvZ/TRJz/FLBw6yPFFuUro7vInM3dxjgWZvaVbrLONwdI6Y950G4ILVQdyEK5csPmYoDIMHR5Y7LQf9nhKWgI+W3lBLXwAnbCsnJThLzWkAkUOsLr8MP+J1QdNvU2rPV/07LhqN7BBrFk+ZQoM5gnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0uQn03dm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0uQn03dm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C389C4CED0;
	Thu, 12 Dec 2024 16:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021354;
	bh=5gu4Oaw9BFo6TxMrdw6bL5BmTOhsUvZ1oEy7wv1mwYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0uQn03dmj1sDyhJyywxAdFcdYYze8/shsBIxZkzLseLfwhlQcY2jO6jOsYSG7aTh6
	 wBsP1OF4rEAJG4oF/nkPGwP51v9RUXBssTMr9WdpPLX5o/tFFIt0IXElZXiREuPl/U
	 fZ0aakVGNYaVY3YmhfmSLFPl7jIyG8ZJ81XJVjNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b5ca8a249162c4b9a7d0@syzkaller.appspotmail.com,
	Ghanshyam Agrawal <ghanshyam1898@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 684/772] jfs: fix shift-out-of-bounds in dbSplit
Date: Thu, 12 Dec 2024 16:00:29 +0100
Message-ID: <20241212144418.179646296@linuxfoundation.org>
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
index a6b1d748df16b..30a56c37d9ecf 100644
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




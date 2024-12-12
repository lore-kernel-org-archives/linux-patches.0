Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3DE21CFF0;
	Thu, 12 Dec 2024 15:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018263; cv=none; b=sxThv7oo0AjaDs71jzLyM2/0/MPjZw02RhZag1cQqZq5nRuk7lbEjuOzv3IpV+i5SMw8ya8+9OdavSIX9TfuRYViUVXtO9njSG3DyyceZuBnPftT0zlUt3rdbkfm8DgNBscO3v4B8jMrqAcNSYYbJKYtaLR2XLIAtHmGo4rfTfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018263; c=relaxed/simple;
	bh=FOh1CZcR++iyJs8+chJiVSTa2LUWPYATIwNz3p1GohA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPhFYUD8aLgaHL9/a6efSLfofKMj56UhzblN9C8x4Xcw3BVSDO2QKBriF/HUeS1Op/BIC6dmY5js1e3RF7NZwm0mJG3PqEI0OSaB5znSI+FrCvJO3xWVtVqYOenp4JLULbtftFPV9k+CIJ/4wNwyw8M3jFmxhILxPONtDmgSIsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWYykP82; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWYykP82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF974C4CECE;
	Thu, 12 Dec 2024 15:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018263;
	bh=FOh1CZcR++iyJs8+chJiVSTa2LUWPYATIwNz3p1GohA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWYykP82U8lZhSvVl7Z5xcm8jdCxhtKkTX6pKvc6dkLYilxc3dRwWAIIoEjP3eLCS
	 iNfGKhBSvYQUE16cO681jwHeqbcxAIMv3LxjBzXo99G22kWdjMLmMcNjQqWNxIP3++
	 9q3o9akeK0ok7N9iIEWRsseCII4Yx8BcA44piro0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b5ca8a249162c4b9a7d0@syzkaller.appspotmail.com,
	Ghanshyam Agrawal <ghanshyam1898@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 244/356] jfs: fix shift-out-of-bounds in dbSplit
Date: Thu, 12 Dec 2024 15:59:23 +0100
Message-ID: <20241212144254.249952345@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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




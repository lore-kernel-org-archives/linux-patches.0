Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD34926B2C8;
	Tue, 12 Aug 2025 17:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020849; cv=none; b=amF5FXfgD7rsG8fCMvsSKj1k8Evsx8010eg9250yrGsAKVU3xsvVX52om2mRrvjUIfd5R8RNLJ93by9M1YM6oc2wzdKDSoR4k6oDhpgxUnbNXGA7NB8pdJq3R/aUR6dugXW7ei/DiIOOtX99ApOZ3ztXv2P4RDWLPw3NsksePcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020849; c=relaxed/simple;
	bh=bXYc2TaNfWHoJf8YSdyExbS8QM4jlt2KaSKbpTHeHx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0BFjcYx3MQjgRx82aDdscs3lNPh1+aG7Verrub3VCmRIGJzbUU439k8k7gZksIvAQvym/ROzW0sHo7zIgtQ9sgmt2Re4Ncs3CgiGDMNECJ12u43z+aMX8MIAig9xDl5iaBg6ufdTZDWvYzhJ+xW16CLnJYEUeiHBt0KxZsuDy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YYdMmvYp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YYdMmvYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD5BC4CEF0;
	Tue, 12 Aug 2025 17:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020849;
	bh=bXYc2TaNfWHoJf8YSdyExbS8QM4jlt2KaSKbpTHeHx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YYdMmvYp93yvfe9u4WlP9wTJuch49FmFt++WED5xBEszbU6jyrbr3x4yX99puQtfX
	 V5iTEv9YzljcrVOpR29UJjGUOUvooZX2MpWQIfh3FkD2GPpRpgwzmUZWMSvlN1Xygh
	 PjqfRTgidAcgfhezMP6x5A+k1f6eU3OLk/D2CdS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yu <zheng.yu@northwestern.edu>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 177/253] jfs: fix metapage reference count leak in dbAllocCtl
Date: Tue, 12 Aug 2025 19:29:25 +0200
Message-ID: <20250812172956.282699625@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Zheng Yu <zheng.yu@northwestern.edu>

[ Upstream commit 856db37592021e9155384094e331e2d4589f28b1 ]

In dbAllocCtl(), read_metapage() increases the reference count of the
metapage. However, when dp->tree.budmin < 0, the function returns -EIO
without calling release_metapage() to decrease the reference count,
leading to a memory leak.

Add release_metapage(mp) before the error return to properly manage
the metapage reference count and prevent the leak.

Fixes: a5f5e4698f8abbb25fe4959814093fb5bfa1aa9d ("jfs: fix shift-out-of-bounds in dbSplit")

Signed-off-by: Zheng Yu <zheng.yu@northwestern.edu>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 32ae408ee699..c761291f59ac 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -1809,8 +1809,10 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
 			return -EIO;
 		dp = (struct dmap *) mp->data;
 
-		if (dp->tree.budmin < 0)
+		if (dp->tree.budmin < 0) {
+			release_metapage(mp);
 			return -EIO;
+		}
 
 		/* try to allocate the blocks.
 		 */
-- 
2.39.5




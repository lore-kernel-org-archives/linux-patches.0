Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C44F222D7E;
	Thu, 12 Dec 2024 17:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023335; cv=none; b=A0WloEl2oVyZQK+cJJ30Q7fDOyZm1hU9qMOdpEGvmm5apkUlGfL9Yfn+4HQebYxlJYLjGDofuwDKv566RM0fzUOGiaxhTBb4c6CHqeUZdk3Z1vY3dMN5BlcEu6G3XWnr2zt1GP7QJDZUNm4jbeokhU9eO6hRocWrRPND65BNi4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023335; c=relaxed/simple;
	bh=ynZo7XeTzCMRYZWwjKN/on03uiHl8HFDP15I4BA/k9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVxHW73kv9FxZ9uaALH6z5Rmh35d0oc0fdz+OO4t1qu86lu66mf9acy9SF/XdYurJxI7Js3VUtz6hdjJKeILNFcRevYqEm+vBTS0C2/qmSE3wcGvjDER14Eo8h9lHNEoU3t+gNcqv4yZj43o4pJp7AqhvO49EWGa8GagclxzWOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a87FwJOS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a87FwJOS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0D4C4CECE;
	Thu, 12 Dec 2024 17:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023334;
	bh=ynZo7XeTzCMRYZWwjKN/on03uiHl8HFDP15I4BA/k9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a87FwJOSdlQEkz3tTCA2l+YcCQCXz3nHpY6dlsM7D7j0hSAWl6mh5QlwFxwHGWZmH
	 dQjeV7Nf0r92VvTVREsVh551yI3yYvEa+j6Se7zfeTi6pfRIYAjw2G0Od9pd0AW3kP
	 Lr/ufJTSn2qbB8gMsR8L7AEd+GlrFAiACRyR+kB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b5ca8a249162c4b9a7d0@syzkaller.appspotmail.com,
	Ghanshyam Agrawal <ghanshyam1898@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 500/565] jfs: fix shift-out-of-bounds in dbSplit
Date: Thu, 12 Dec 2024 16:01:35 +0100
Message-ID: <20241212144331.529040324@linuxfoundation.org>
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
index 3fa78e5f9b21e..7486c79a5058b 100644
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233D413D24D;
	Thu, 11 Apr 2024 10:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831574; cv=none; b=WsXlOCn8FoDflHIhDj0GyWRDaZX0JJpT+R+lIeaOwSpd5e6o7N9hVvblroOI2SLkHX8mwFEytw8P7lQpl3atCZWAbyGNXOIv3MrSku8L25BCaahoVHKu8Gm7naXW1qox5zeUIXo824ZkgPe5H4cHMwxZIIu+MofolCp77zEOj48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831574; c=relaxed/simple;
	bh=ZTAyDEnlHvmtolPRTA+4U0HO6ZmfSFi9qxd3+F3IA0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2efpFugzez87U0ydEl8e+gdovi1gnrSgPOdUZAnXg1e6yU1qyUMmn0TSS6dTAgBBY6XBL88y10ZjX2elcoeDXxS/biHzdzMHXVtyRkxSCbhjIS0AyfkTpiRn4ypAQzsFMCO8MYVI0KZgPMh+A/qK4VrgJzqMSWjNjNYvy0QDNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LEfWnodi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LEfWnodi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5ECC433F1;
	Thu, 11 Apr 2024 10:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831574;
	bh=ZTAyDEnlHvmtolPRTA+4U0HO6ZmfSFi9qxd3+F3IA0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LEfWnodi8LifPBret6/nYlZZzBarGarNsr0EtDf4eujwpzjUGqyZm4QOyPpu3vJwf
	 X+7ITpSO2rCq/4JbSL3lGnHqc4z0ah+yEMjYhyhUMpMu2n8jW1VZl4ZDNPXnE9d093
	 FVpD3GjHo8kKNFEHadcKhMW5lUwghORksR7eSaao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio SJ Musumeci <trapexit@spawn.link>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/294] fuse: fix root lookup with nonzero generation
Date: Thu, 11 Apr 2024 11:53:36 +0200
Message-ID: <20240411095437.237814158@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 68ca1b49e430f6534d0774a94147a823e3b8b26e ]

The root inode has a fixed nodeid and generation (1, 0).

Prior to the commit 15db16837a35 ("fuse: fix illegal access to inode with
reused nodeid") generation number on lookup was ignored.  After this commit
lookup with the wrong generation number resulted in the inode being
unhashed.  This is correct for non-root inodes, but replacing the root
inode is wrong and results in weird behavior.

Fix by reverting to the old behavior if ignoring the generation for the
root inode, but issuing a warning in dmesg.

Reported-by: Antonio SJ Musumeci <trapexit@spawn.link>
Closes: https://lore.kernel.org/all/CAOQ4uxhek5ytdN8Yz2tNEOg5ea4NkBb4nk0FGPjPk_9nz-VG3g@mail.gmail.com/
Fixes: 15db16837a35 ("fuse: fix illegal access to inode with reused nodeid")
Cc: <stable@vger.kernel.org> # v5.14
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dir.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index b0c701c007c68..d131f34cd3e13 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -451,6 +451,10 @@ int fuse_lookup_name(struct super_block *sb, u64 nodeid, const struct qstr *name
 		goto out_put_forget;
 	if (fuse_invalid_attr(&outarg->attr))
 		goto out_put_forget;
+	if (outarg->nodeid == FUSE_ROOT_ID && outarg->generation != 0) {
+		pr_warn_once("root generation should be zero\n");
+		outarg->generation = 0;
+	}
 
 	*inode = fuse_iget(sb, outarg->nodeid, outarg->generation,
 			   &outarg->attr, entry_attr_timeout(outarg),
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89557D07C;
	Mon,  8 Apr 2024 13:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581474; cv=none; b=LMTuQz34EgZxGiD+OFO6i6Bvk4Tvzf31586NkP26DYjBE0oLvaG4o6ynnGp6cHejHi575UdTNABqRficK8JJCHiREIxpyZ4uGoce1G9OtavI2g/X7lBTjZNeC+BAsHqidzOxnGqoP8/b0Fg4sbO3JMyJZ7Yrxq6NYyQpSlBaM+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581474; c=relaxed/simple;
	bh=SaA6Xj5WiaSyWzSfN+hAXEvx5u8Q4AuENMp1y3+kRZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqI0lFNwyQ+JpptT5d9S/bY1B28XRts2jvyiV5Iy3Rc1hox6JapD12XcbrvKD4QPyUVFx7cquJMcV75gT3cVOM0a0P5XMPxQJ//ebymPuwqeJRiiG3l7OhrYvHgwsdrmaqfp1s6ul1jkd9LwL2vUhKhdz1jGlFAUM3ZzHpZz9UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9N1rQRx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9N1rQRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1F4C433F1;
	Mon,  8 Apr 2024 13:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581474;
	bh=SaA6Xj5WiaSyWzSfN+hAXEvx5u8Q4AuENMp1y3+kRZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P9N1rQRxDAUpk9QbPA66NcA4R8/P6OXdjEQoo8FCCNcgUdSfwKXMaGujNlmjUmlFs
	 eoujPhOcTtFKsFuynk54eBwodB2Hhh9D5dubm3EJbl2/x8BNi5DZaE82zSXLdtYN+m
	 ZKKa/MgiRgHb0kvqA2bTj3k5OA2hFpHmzbgBHJRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio SJ Musumeci <trapexit@spawn.link>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/690] fuse: fix root lookup with nonzero generation
Date: Mon,  8 Apr 2024 14:48:40 +0200
Message-ID: <20240408125401.476856946@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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
index 4ea52906ae150..44d1c8cc58a42 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -390,6 +390,10 @@ int fuse_lookup_name(struct super_block *sb, u64 nodeid, const struct qstr *name
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




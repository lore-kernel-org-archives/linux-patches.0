Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369FA2F617C;
	Sat, 12 Sep 2026 09:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204640; cv=none; b=N6EI27ScpARo98jYTEt829ehQ39tfycZ9BHdO6PlHuOUjMRdfFkBLxwN4LcQBaf+trL7J/NhcWFmhNsHiXcKI/bjrYltqXS/oybBW8Qqrfcg/8EyL5Egkl13ire1sCVUhA/NqII8F3svZLyvQHt1clav/b0Ex1JE3QhpFZkwQf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204640; c=relaxed/simple;
	bh=M3x47DTHbzR2aeDhdUC7m/QyC2JtX2byRZSWXjq0DQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYGlXlEQw2XoXMuI0MiSA3XYJUfO+7js4XzAmESvqnpHRKkRNi90nZJDScDxtczfeRrwzkHHui4A3TDeBbBEtedKQ9yT5+M4xaGmR7HYp1CbhYGlPW4igoiTUudUx5Hmw8G+MXC6vm+WGnlC6kGKlhzFFsnpZj3KzDqAsKH2KPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uRwX0a7Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uRwX0a7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA201F000FF;
	Sat, 12 Sep 2026 09:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204638;
	bh=7uKm1ZiLlW5oF4Q7UduQJNkcsAcOM+4CXFNQ0hpXYLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uRwX0a7YQThZ/XnTIawVuKVEqSWCI5y5UmVpgnXBLVysZ+icohGtN+z/Ent5//c+i
	 YBfd72PMqesnYLLX4O6RIUAU6hJkaIkBSfNCRL7sbXRykHYW0b+KTlWq9uFQY3y1Pl
	 ZSTS5v8/uPXUaxrpddWF+qXM4LpbgIHfQQmKLgdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Tighe <dennis.tighe@gmail.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1655/1815] ntfs: fix off-by-one page overflow in ntfs_decompress()
Date: Sat, 12 Sep 2026 08:56:45 +0200
Message-ID: <20260912065727.845494613@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dennis Tighe <dennis.tighe@gmail.com>

[ Upstream commit 98716c9fce21f6c8a9d71e08cf53e7504fa562f4 ]

The per-token range check in ntfs_decompress() uses

	if (cb >= cb_sb_end || dp_addr > dp_sb_end)
		break;

so dp_addr == dp_sb_end falls through to the symbol copy
`*dp_addr++ = *cb++`, writing one byte past the destination page.  Since
NTFS_SB_SIZE == PAGE_SIZE the destination is a single page, so the byte
lands in the adjacent page, and *dest_ofs is left one past the sub-block
end (the later `*dest_ofs &= ~PAGE_MASK` then yields 1, not 0, so the page
is never finalized and later sub-blocks keep writing further past it).  A
corrupted compressed $DATA attribute thus produces a bounded run of
out-of-bounds writes when the file is read.

Break as soon as dp_addr reaches dp_sb_end; a full sub-block still
completes, as its final copy advances dp_addr to exactly dp_sb_end.

Fixes: 1e9ea7e04472 ("Revert "fs: Remove NTFS classic"")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Dennis Tighe <dennis.tighe@gmail.com>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/compress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
index e866f43ca30b2..4ea1a6bfb3eb7 100644
--- a/fs/ntfs/compress.c
+++ b/fs/ntfs/compress.c
@@ -349,7 +349,7 @@ static int ntfs_decompress(struct page *dest_pages[], int completed_pages[],
 		u8 *dp_back_addr;
 
 		/* Check if we are done / still in range. */
-		if (cb >= cb_sb_end || dp_addr > dp_sb_end)
+		if (cb >= cb_sb_end || dp_addr >= dp_sb_end)
 			break;
 
 		/* Determine token type and parse appropriately.*/
-- 
2.53.0




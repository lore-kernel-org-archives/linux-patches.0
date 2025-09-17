Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D49F2F7ABF;
	Wed, 17 Sep 2025 12:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113186; cv=none; b=IOMXCZ7vl6iD7GXQ89qKjm8CuMkfYkk/p/wtOyYfT6iy1j4wdUE7i2OJ9+Be68lU6zPbCIb2NKV2I8tRVGGNrsDcUt8RoDAIw08/Nq3mcURSu1SXqAt8NLMXyu81KoRUXwvBDFgrsCPJ7iNzL4UhFRL6PfcISTVEvoK63VGhw8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113186; c=relaxed/simple;
	bh=ZR0669riC6ElZ2HCHzEOdR9VeQVPs8CqBN5N8i65XzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFcFzuO+mh6uoLw9QJJHyt3eSqDhkZkWW/OEKGFhrpJgvO3Yk9bOyiiRVyDWRoO8jDv6ZHLZzrL5CS2hbC4yi3ZuCFJYACLVf9eQtKZSwspFmKt+2rFAlFSa3wl04KBLTrwdBXmgZijCfQsIWtg3uDN80wMXkijxkS5GRGQ0qaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTkgXD8X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTkgXD8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169A5C4CEF0;
	Wed, 17 Sep 2025 12:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113185;
	bh=ZR0669riC6ElZ2HCHzEOdR9VeQVPs8CqBN5N8i65XzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTkgXD8XPkU2t6fvkOep9yfuuUKSoOfhitj2OpFQ4uzw85nyF09KduLLtFYybUMmX
	 PGzJHbkXRHrZ+6k4N+r/ndpbj5x+gKNGeQrSKeMeONgq9do3fgl5fms//3w6xN0829
	 tIFryEjYPcAZe1hmQeatmIZ/C5B6mWIpVVE/eAjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 001/140] fhandle: use more consistent rules for decoding file handle from userns
Date: Wed, 17 Sep 2025 14:32:53 +0200
Message-ID: <20250917123344.356821311@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit bb585591ebf00fb1f6a1fdd1ea96b5848bd9112d ]

Commit 620c266f39493 ("fhandle: relax open_by_handle_at() permission
checks") relaxed the coditions for decoding a file handle from non init
userns.

The conditions are that that decoded dentry is accessible from the user
provided mountfd (or to fs root) and that all the ancestors along the
path have a valid id mapping in the userns.

These conditions are intentionally more strict than the condition that
the decoded dentry should be "lookable" by path from the mountfd.

For example, the path /home/amir/dir/subdir is lookable by path from
unpriv userns of user amir, because /home perms is 755, but the owner of
/home does not have a valid id mapping in unpriv userns of user amir.

The current code did not check that the decoded dentry itself has a
valid id mapping in the userns.  There is no security risk in that,
because that final open still performs the needed permission checks,
but this is inconsistent with the checks performed on the ancestors,
so the behavior can be a bit confusing.

Add the check for the decoded dentry itself, so that the entire path,
including the last component has a valid id mapping in the userns.

Fixes: 620c266f39493 ("fhandle: relax open_by_handle_at() permission checks")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://lore.kernel.org/20250827194309.1259650-1-amir73il@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fhandle.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/fhandle.c b/fs/fhandle.c
index 82df28d45cd70..ff90f8203015e 100644
--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -176,6 +176,14 @@ static int vfs_dentry_acceptable(void *context, struct dentry *dentry)
 	if (!ctx->flags)
 		return 1;
 
+	/*
+	 * Verify that the decoded dentry itself has a valid id mapping.
+	 * In case the decoded dentry is the mountfd root itself, this
+	 * verifies that the mountfd inode itself has a valid id mapping.
+	 */
+	if (!privileged_wrt_inode_uidgid(user_ns, idmap, d_inode(dentry)))
+		return 0;
+
 	/*
 	 * It's racy as we're not taking rename_lock but we're able to ignore
 	 * permissions and we just need an approximation whether we were able
-- 
2.51.0




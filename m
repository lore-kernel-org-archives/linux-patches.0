Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6A01F5611;
	Tue, 21 Jan 2025 17:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482364; cv=none; b=D5QLCtF1L+4DsCF7y2TLUVVtoUvgnRmRTpbBwVVKF10TNQi/zYC5fBEFjjCB2YH4Efn3lzCxSP4skRGYtnsL/EmMxW4NjIMa7RER7lB1Z7626Ejjl3buNEH0f9ZSWkhOZZUwp0GvQZFsG2UESPsV5MWfmV7ZpAZSGObRYjQHyUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482364; c=relaxed/simple;
	bh=EpdpTMdaVv/cqReksGBDbdFzHCe952IW9Qnq9U9pEYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tLzv+lgqpRcjSgbKm3pBqpdng0tYS77dSUkmmcFxGddmzJ3UdZJEfct1qCputmPnI0Z0YSILNKI7fKTBQeI9/Af5KEhc09osluRx3P6izq2YlvQogsx7a8vWYxlSwWzCRfOg+AAms5NdeZU7EhRNkRwEzpFr5iNuQX9vd2Fqy2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNDujkxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNDujkxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21115C4CEDF;
	Tue, 21 Jan 2025 17:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482364;
	bh=EpdpTMdaVv/cqReksGBDbdFzHCe952IW9Qnq9U9pEYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNDujkxMIBmuGKOZHFR07mC5RoKlvDyEV3URUD+lGAOLm+fsIOJW8yahvkFuOVA8I
	 PNe/s9lg1T/LCAACb2ABTDFWnA3W3s3QbliJ8rRHNCxor/BR+Rwa3z0rq2PVN7xRsG
	 xqlH0IhYjM4Vlf5oKtE8qApMQtAt/fPhjSpV7zUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brahmajit Das <brahmajit.xyz@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/122] fs/qnx6: Fix building with GCC 15
Date: Tue, 21 Jan 2025 18:51:39 +0100
Message-ID: <20250121174534.958139071@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brahmajit Das <brahmajit.xyz@gmail.com>

[ Upstream commit 989e0cdc0f18a594b25cabc60426d29659aeaf58 ]

qnx6_checkroot() had been using weirdly spelled initializer - it needed
to initialize 3-element arrays of char and it used NUL-padded
3-character string literals (i.e. 4-element initializers, with
completely pointless zeroes at the end).

That had been spotted by gcc-15[*]; prior to that gcc quietly dropped
the 4th element of initializers.

However, none of that had been needed in the first place - all this
array is used for is checking that the first directory entry in root
directory is "." and the second - "..".  The check had been expressed as
a loop, using that match_root[] array.  Since there is no chance that we
ever want to extend that list of entries, the entire thing is much too
fancy for its own good; what we need is just a couple of explicit
memcmp() and that's it.

[*]: fs/qnx6/inode.c: In function ‘qnx6_checkroot’:
fs/qnx6/inode.c:182:41: error: initializer-string for array of ‘char’ is too long [-Werror=unterminated-string-initialization]
  182 |         static char match_root[2][3] = {".\0\0", "..\0"};
      |                                         ^~~~~~~
fs/qnx6/inode.c:182:50: error: initializer-string for array of ‘char’ is too long [-Werror=unterminated-string-initialization]
  182 |         static char match_root[2][3] = {".\0\0", "..\0"};
      |                                                  ^~~~~~

Signed-off-by: Brahmajit Das <brahmajit.xyz@gmail.com>
Link: https://lore.kernel.org/r/20241004195132.1393968-1-brahmajit.xyz@gmail.com
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/qnx6/inode.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/qnx6/inode.c b/fs/qnx6/inode.c
index 85925ec0051a9..3310d1ad4d0e9 100644
--- a/fs/qnx6/inode.c
+++ b/fs/qnx6/inode.c
@@ -179,8 +179,7 @@ static int qnx6_statfs(struct dentry *dentry, struct kstatfs *buf)
  */
 static const char *qnx6_checkroot(struct super_block *s)
 {
-	static char match_root[2][3] = {".\0\0", "..\0"};
-	int i, error = 0;
+	int error = 0;
 	struct qnx6_dir_entry *dir_entry;
 	struct inode *root = d_inode(s->s_root);
 	struct address_space *mapping = root->i_mapping;
@@ -189,11 +188,9 @@ static const char *qnx6_checkroot(struct super_block *s)
 	if (IS_ERR(folio))
 		return "error reading root directory";
 	dir_entry = kmap_local_folio(folio, 0);
-	for (i = 0; i < 2; i++) {
-		/* maximum 3 bytes - due to match_root limitation */
-		if (strncmp(dir_entry[i].de_fname, match_root[i], 3))
-			error = 1;
-	}
+	if (memcmp(dir_entry[0].de_fname, ".", 2) ||
+	    memcmp(dir_entry[1].de_fname, "..", 3))
+		error = 1;
 	folio_release_kmap(folio, dir_entry);
 	if (error)
 		return "error reading root directory.";
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E6F42AB0;
	Wed,  6 Nov 2024 12:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895317; cv=none; b=hEmsO8xGrsSN0ek1ftZBbLXXw/SUY5yvJ/gNjns/5NTpYZeQKlae0WuXNQHEVlJDVXpUmjL78h04/ugUzqhofySSBhT4knIRoSNigoBVoh9oMlgQqPKchwUn+XQFNqCuEWezYi300DaZatxA2GNaE1loSMFNDhIMUSBnxuLjFKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895317; c=relaxed/simple;
	bh=oM17XWEA85onLmibRd8bnocTA45pVp32Zj1heKfLxhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xuy/lVkUi7Z83X3fyfL5AFXMxk/C+KR3/lUeXblXR4ld7qzGyWHNEyhhCmVWAzqTff59PmrxH9PP2EWfZRzsgqkNVAYHDEbO4GWALnCkhDoveI5YVtPM2Wbw/mUbIJjk59gGUEvlGT8cB59pqWy46/tpN1n+dONME7Ahsg2w6+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N8wx5R3Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N8wx5R3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED7DC4CED3;
	Wed,  6 Nov 2024 12:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895317;
	bh=oM17XWEA85onLmibRd8bnocTA45pVp32Zj1heKfLxhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N8wx5R3ZD1TuqUgN2LA+c+w1JGxRbqMyUiDLqs2K2jZ+gSR2YWxTsDbRqGOWOSheZ
	 SHO861ywYni1JiFLeTZLdh/qUEi24XiXM95OS/TmeWygfVX7GhSIgQaXAmx4MHYlid
	 ZIX/pVkBHCgh8TUA20A1tllyI2GNZr8rfUario1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 178/350] ext4: ext4_search_dir should return a proper error
Date: Wed,  6 Nov 2024 13:01:46 +0100
Message-ID: <20241106120325.328148389@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

[ Upstream commit cd69f8f9de280e331c9e6ff689ced0a688a9ce8f ]

ext4_search_dir currently returns -1 in case of a failure, while it returns
0 when the name is not found. In such failure cases, it should return an
error code instead.

This becomes even more important when ext4_find_inline_entry returns an
error code as well in the next commit.

-EFSCORRUPTED seems appropriate as such error code as these failures would
be caused by unexpected record lengths and is in line with other instances
of ext4_check_dir_entry failures.

In the case of ext4_dx_find_entry, the current use of ERR_BAD_DX_DIR was
left as is to reduce the risk of regressions.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Link: https://patch.msgid.link/20240821152324.3621860-2-cascardo@igalia.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/namei.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 8594feea2d932..d85be8255d790 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1334,7 +1334,7 @@ static inline bool ext4_match(const struct ext4_filename *fname,
 }
 
 /*
- * Returns 0 if not found, -1 on failure, and 1 on success
+ * Returns 0 if not found, -EFSCORRUPTED on failure, and 1 on success
  */
 int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 		    struct inode *dir, struct ext4_filename *fname,
@@ -1355,7 +1355,7 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 			 * a full check */
 			if (ext4_check_dir_entry(dir, NULL, de, bh, search_buf,
 						 buf_size, offset))
-				return -1;
+				return -EFSCORRUPTED;
 			*res_dir = de;
 			return 1;
 		}
@@ -1363,7 +1363,7 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 		de_len = ext4_rec_len_from_disk(de->rec_len,
 						dir->i_sb->s_blocksize);
 		if (de_len <= 0)
-			return -1;
+			return -EFSCORRUPTED;
 		offset += de_len;
 		de = (struct ext4_dir_entry_2 *) ((char *) de + de_len);
 	}
@@ -1514,8 +1514,10 @@ static struct buffer_head *__ext4_find_entry(struct inode *dir,
 			goto cleanup_and_exit;
 		} else {
 			brelse(bh);
-			if (i < 0)
+			if (i < 0) {
+				ret = ERR_PTR(i);
 				goto cleanup_and_exit;
+			}
 		}
 	next:
 		if (++block >= nblocks)
@@ -1609,7 +1611,7 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
 		if (retval == 1)
 			goto success;
 		brelse(bh);
-		if (retval == -1) {
+		if (retval < 0) {
 			bh = ERR_PTR(ERR_BAD_DX_DIR);
 			goto errout;
 		}
-- 
2.43.0




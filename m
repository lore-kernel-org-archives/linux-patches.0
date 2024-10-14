Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C077C3A1B6;
	Mon, 14 Oct 2024 15:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919073; cv=none; b=JPiOO0WSc2uRj7iPGFZZ40YjuMNY5nZ2l2zrM2EtFJn29sOuZJQgPfqqMfqxfABydvEP57qvNebQ9UHki+WFnUVh1e01P95DhaNpTNWgDEn0r1lcN+tYWKOe63VL+2BjUYtSKvq5YNoaxtUq6W4mqFk2RqPYKiw49S9lLKa5HQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919073; c=relaxed/simple;
	bh=BZcIDiNsRFKZQlElFjQLgDAMlRIKsyXD2c4tM60IxFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVE4aySucwFzTwF3vQpp7mrkbA/1mFcGsXvgbuV61haIk/8V4VQcHxDe2SrfKMKtPk4VeBzfV9kVFwc533tHZN0tBXC0MMSCJpxXfHJHkBd1fKfABOI20l/VCi/cbcxy4n39R6yv/ucaM5Zt8M0kHSl3CT6z6qTGOtWv3rIg1SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gv/0esVK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gv/0esVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31187C4CEC3;
	Mon, 14 Oct 2024 15:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919073;
	bh=BZcIDiNsRFKZQlElFjQLgDAMlRIKsyXD2c4tM60IxFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gv/0esVKp+x5UbgSxurY/3Pun+AYEbPn991bEesVcAMypxEeuGdjquo4r2wVPWo3I
	 KABjA7ip+ML+Gc1hAkIrHuqBCwxW6d7fbS7FhlShvmBoZgs0tK5fzdhbSpIdv6SJ0z
	 sOL11WKbXwETnZp/mv6+V2+LIDRqdzrlBqs8Nki0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 506/798] ext4: ext4_search_dir should return a proper error
Date: Mon, 14 Oct 2024 16:17:40 +0200
Message-ID: <20241014141237.860644283@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index 173f46fa10687..883d0aa35325c 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1526,7 +1526,7 @@ static bool ext4_match(struct inode *parent,
 }
 
 /*
- * Returns 0 if not found, -1 on failure, and 1 on success
+ * Returns 0 if not found, -EFSCORRUPTED on failure, and 1 on success
  */
 int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 		    struct inode *dir, struct ext4_filename *fname,
@@ -1547,7 +1547,7 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 			 * a full check */
 			if (ext4_check_dir_entry(dir, NULL, de, bh, search_buf,
 						 buf_size, offset))
-				return -1;
+				return -EFSCORRUPTED;
 			*res_dir = de;
 			return 1;
 		}
@@ -1555,7 +1555,7 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 		de_len = ext4_rec_len_from_disk(de->rec_len,
 						dir->i_sb->s_blocksize);
 		if (de_len <= 0)
-			return -1;
+			return -EFSCORRUPTED;
 		offset += de_len;
 		de = (struct ext4_dir_entry_2 *) ((char *) de + de_len);
 	}
@@ -1707,8 +1707,10 @@ static struct buffer_head *__ext4_find_entry(struct inode *dir,
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
@@ -1803,7 +1805,7 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
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




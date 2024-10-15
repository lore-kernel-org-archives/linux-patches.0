Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E221A76DA;
	Tue, 15 Oct 2024 11:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992760; cv=none; b=fdYcoUYQ1n4Wrwg4Bbys4xFJv9KacGWO/r9igfYktRjcGRtz2AQ7kvESjwJDba4i3aODEOptkPolg8Wud9OYascUEDkdaBMSFftLxAgafwGIE11qjg+CVoLYww9vgFKykm7gcdc4a5CRUKqGyNNpKTSEZLY5hojcEM83BMpAcGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992760; c=relaxed/simple;
	bh=y5T0eGv+Stq217awY0Ss1OIAXW9bG7DtyoUGgrqS4pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WX+00QiYh7qs1zVrNAICwN3sHloE2OcA5mFwavHlcMkif447eM8CwQ4TBcNiI9jJ263JJAkiKq1WY4FsAr3efoa9R18hVLGMJR42xAsaX8Ieis+1nXDgBhEc2ywbmZMpkuWeTn6WkuQVSawyb8Fgd+6kvfMdUCQEr7111R7Bz3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EXgtfR8u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EXgtfR8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426ADC4CEC6;
	Tue, 15 Oct 2024 11:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992760;
	bh=y5T0eGv+Stq217awY0Ss1OIAXW9bG7DtyoUGgrqS4pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EXgtfR8uj1p0js1k+XNfLgdYo8Xxm2U5aSil/0nmWUNlM/A9Lt8/ORqslVlwSI+V/
	 3oYJjXH6HbvcVZIr6Q8YzLUGHnt5kZdhMz5KEoXsHHvsgzDQsEjkVODcsVcVeljboH
	 2AlKPhRjy40OvbuSUL++Vs+Kdc0vobcW6Dkv796U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 208/691] ext4: return error on ext4_find_inline_entry
Date: Tue, 15 Oct 2024 13:22:36 +0200
Message-ID: <20241015112448.616413597@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

[ Upstream commit 4d231b91a944f3cab355fce65af5871fb5d7735b ]

In case of errors when reading an inode from disk or traversing inline
directory entries, return an error-encoded ERR_PTR instead of returning
NULL. ext4_find_inline_entry only caller, __ext4_find_entry already returns
such encoded errors.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Link: https://patch.msgid.link/20240821152324.3621860-3-cascardo@igalia.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: c6b72f5d82b1 ("ext4: avoid OOB when system.data xattr changes underneath the filesystem")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inline.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index bc7f6417888dc..9e42c3b18458a 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1676,8 +1676,9 @@ struct buffer_head *ext4_find_inline_entry(struct inode *dir,
 	void *inline_start;
 	int inline_size;
 
-	if (ext4_get_inode_loc(dir, &iloc))
-		return NULL;
+	ret = ext4_get_inode_loc(dir, &iloc);
+	if (ret)
+		return ERR_PTR(ret);
 
 	down_read(&EXT4_I(dir)->xattr_sem);
 	if (!ext4_has_inline_data(dir)) {
@@ -1708,7 +1709,10 @@ struct buffer_head *ext4_find_inline_entry(struct inode *dir,
 
 out:
 	brelse(iloc.bh);
-	iloc.bh = NULL;
+	if (ret < 0)
+		iloc.bh = ERR_PTR(ret);
+	else
+		iloc.bh = NULL;
 out_find:
 	up_read(&EXT4_I(dir)->xattr_sem);
 	return iloc.bh;
-- 
2.43.0




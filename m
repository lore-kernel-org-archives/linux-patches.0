Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765282FAC06;
	Tue, 12 Aug 2025 18:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024328; cv=none; b=PckhNjB3qZ07y0vKpG6+UP/9czsBfcWHjUNC9SmKw7dTkvtbFknRyI2a/1ul60yqzOTuAYgGq5fQtV2EzIwJHGS4n/3OJ8+BDIZmpAkL11Agu/5VHN8z1CLmM0jfHMN1c0FCNmygo42q4HPe3o+1MyJYDbI3nsqtwslw6fvWpY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024328; c=relaxed/simple;
	bh=h8KVtH2id83X7SZZfTQTdNk24zgdwH5OfuujWhZmSsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BZ7nIsIrbz2aQNEhn1NC5IynQX3cGx0xrnbZVx1Q4oUQApRvzlomXTKHpd+5mQy9AeER7muvbdtkcm6RI2zHv52n7BcK5DYuAd18Jn6hkX8B92fYO98n9mq1mMeRBDfPMQHFrvuNvGELA1fOKv9ASxpxQGLS7SEQUIenfr3l2aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eaxm20bl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eaxm20bl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E59C4CEF1;
	Tue, 12 Aug 2025 18:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024328;
	bh=h8KVtH2id83X7SZZfTQTdNk24zgdwH5OfuujWhZmSsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eaxm20blZ2NY8QNC9qm9Myxobzw8FMDCU0rfn8BEi8wy9lfYW8gIMaXDYI+OeKqfY
	 o3MczjLGsYbjVe4TMNoMIk2qknQlVvthZpEARM3b68WWFN+aotG0usiy9T7rbQKkfA
	 htIRzeH8OFOluzVJBqcae17/MsmIyf1WqIHd/KJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 339/627] fanotify: sanitize handle_type values when reporting fid
Date: Tue, 12 Aug 2025 19:30:34 +0200
Message-ID: <20250812173432.180251137@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 8631e01c2c5d1fe6705bcc0d733a0b7a17d3daac ]

Unlike file_handle, type and len of struct fanotify_fh are u8.
Traditionally, filesystem return handle_type < 0xff, but there
is no enforecement for that in vfs.

Add a sanity check in fanotify to avoid truncating handle_type
if its value is > 0xff.

Fixes: 7cdafe6cc4a6 ("exportfs: check for error return value from exportfs_encode_*()")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20250627104835.184495-1-amir73il@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 3083643b864b..bfe884d624e7 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -454,7 +454,13 @@ static int fanotify_encode_fh(struct fanotify_fh *fh, struct inode *inode,
 	dwords = fh_len >> 2;
 	type = exportfs_encode_fid(inode, buf, &dwords);
 	err = -EINVAL;
-	if (type <= 0 || type == FILEID_INVALID || fh_len != dwords << 2)
+	/*
+	 * Unlike file_handle, type and len of struct fanotify_fh are u8.
+	 * Traditionally, filesystem return handle_type < 0xff, but there
+	 * is no enforecement for that in vfs.
+	 */
+	BUILD_BUG_ON(MAX_HANDLE_SZ > 0xff || FILEID_INVALID > 0xff);
+	if (type <= 0 || type >= FILEID_INVALID || fh_len != dwords << 2)
 		goto out_err;
 
 	fh->type = type;
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1225FDC0;
	Tue, 23 Jan 2024 01:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974648; cv=none; b=Jl6H/ovS3eXEvqSWjq/XJ8oa6gZwY9FRGslBXJXj69qSM+Y2n0QQHPwpO8Taiox8+iVES5HR+cBp9vOC9OviiU2wEuLqRfBsQC/9QXh6KZvfeTwKm8c6HWnO8zWsfDWDJdHIxYWPc1iLx6AGGgU32GNKtdDdOWZc2PohF3oGc1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974648; c=relaxed/simple;
	bh=3t7VvC+JCMdgIRuh6nxUy9lDPX9TnnHhGk5nI/bokac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVAS45wwAlBWZGrLbJnuEAIdeOCxXkl/OZ+vOteGxHVi4sHNBa+sRK2sPxNyqrd0HPdTECQQLfNL8URUWaGyP4P0iPj4Qj61+gzMG/BBp6ndNb6Ur+x25STE45qUJo7Zw8K3Q4GtZG1sFryJMN5YWryfnTGYDkl3iPauuBnUe+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKUb9Wt4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKUb9Wt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1535DC433F1;
	Tue, 23 Jan 2024 01:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974648;
	bh=3t7VvC+JCMdgIRuh6nxUy9lDPX9TnnHhGk5nI/bokac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nKUb9Wt4kEycugMDYOgkvG/ZIgE6zEgdDwWkisAROub0IfpSzhRJfGQp0pqUnzja4
	 e6wiMrHPCeZuqKlZ4gu4c5QR2CCsdEwDigVxhrWxe6dmEapFkFsc+u+dhGl5xLjZtI
	 gvgfBsjYG7CBdBTFAxo9xvCbHjawLWrZwru8Rrac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 203/374] f2fs: fix to check compress file in f2fs_move_file_range()
Date: Mon, 22 Jan 2024 15:57:39 -0800
Message-ID: <20240122235751.675329600@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit fb9b65340c818875ea86464faf3c744bdce0055c ]

f2fs_move_file_range() doesn't support migrating compressed cluster
data, let's add the missing check condition and return -EOPNOTSUPP
for the case until we support it.

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 58fd32db025d..0669ac4c0f12 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2780,6 +2780,11 @@ static int f2fs_move_file_range(struct file *file_in, loff_t pos_in,
 			goto out;
 	}
 
+	if (f2fs_compressed_file(src) || f2fs_compressed_file(dst)) {
+		ret = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
 	ret = -EINVAL;
 	if (pos_in + len > src->i_size || pos_in + len < pos_in)
 		goto out_unlock;
-- 
2.43.0




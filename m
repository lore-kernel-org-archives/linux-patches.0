Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8749347FCF;
	Tue, 16 Dec 2025 12:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888143; cv=none; b=kuVgzeWCRrEM+Sn8UNw4zjGa2Aw4kjFxU4B7+3CYxURqom5fYrIqtGOOhWZymIyK4qMtQQC4EQBgmdoAezw+wUiIwfOsaKFPk67furvEMEoMTfjY7pLWRihxJ3+LJJe9F3Wmz9DFwkcLyTgkW+DhuUAllcu6ezVhhJH5jm09BlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888143; c=relaxed/simple;
	bh=VYKeUBzxdX8VhGRshfvOIiLgba4fGiC/G2PU/jTVsho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hu8lrAI3uP1RgpJ79BBA1Zjyl3yUx+KnmGIuJ5DzKcEPKipmE6pqFa++LlnqMapXP8aCoJPvP4jKT1Fh0dJa9ua1b9X/++g7cKAg7UGS8JZ7RZ7jC5Dq+YjZAfYAYQut6NWXHDlms4HpfuTKR3rWXcB9DbBcQ1EaUK7aQ1nvjw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlpIVUqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlpIVUqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35680C4CEF1;
	Tue, 16 Dec 2025 12:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888143;
	bh=VYKeUBzxdX8VhGRshfvOIiLgba4fGiC/G2PU/jTVsho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vlpIVUqdwpB6YhcI900OZqtl72GgN+bQ1JcpsEKuj60GfpWJHFPzsqc1XpXmU1xuN
	 ebHmszOq7TgzOXKUnlDH+jBmbXYABab3OgB+y0PpniLCBGfzoE8nzey2E0M904kNVc
	 mG+uOC+/lierM3rSMYt2zEvrhXOFIqoQWZXfWjXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 445/614] fs: lift the FMODE_NOCMTIME check into file_update_time_flags
Date: Tue, 16 Dec 2025 12:13:32 +0100
Message-ID: <20251216111417.496408551@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 7f30e7a42371af4bba53f9a875a0d320cead9f4b ]

FMODE_NOCMTIME used to be just a hack for the legacy XFS handle-based
"invisible I/O", but commit e5e9b24ab8fa ("nfsd: freeze c/mtime updates
with outstanding WRITE_ATTRS delegation") started using it from
generic callers.

I'm not sure other file systems are actually read for this in general,
so the above commit should get a closer look, but for it to make any
sense, file_update_time needs to respect the flag.

Lift the check from file_modified_flags to file_update_time so that
users of file_update_time inherit the behavior and so that all the
checks are done in one place.

Fixes: e5e9b24ab8fa ("nfsd: freeze c/mtime updates with outstanding WRITE_ATTRS delegation")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20251120064859.2911749-3-hch@lst.de
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 540f4a28c202d..2c55ec49b0239 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2332,6 +2332,8 @@ static int file_update_time_flags(struct file *file, unsigned int flags)
 	/* First try to exhaust all avenues to not sync */
 	if (IS_NOCMTIME(inode))
 		return 0;
+	if (unlikely(file->f_mode & FMODE_NOCMTIME))
+		return 0;
 
 	now = current_time(inode);
 
@@ -2403,8 +2405,6 @@ static int file_modified_flags(struct file *file, int flags)
 	ret = file_remove_privs_flags(file, flags);
 	if (ret)
 		return ret;
-	if (unlikely(file->f_mode & FMODE_NOCMTIME))
-		return 0;
 	return file_update_time_flags(file, flags);
 }
 
-- 
2.51.0




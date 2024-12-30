Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE215537E9;
	Mon, 30 Dec 2024 15:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574213; cv=none; b=lGLNlNlDKDVlNhtpkpLAryKVv1kWIzO7FA3aJJEbu8Nz9tpB7onBTDBfwki0JPXnPx71t3l77pm9UQcuyKpRVh6jR5DW6y7c9RkejzothSbl+cvjtUGQ1FWpRoQE+SEN2ADwF4czVoA/jV9fG8vK3rnfXe+OGrSTcCH8ghHp7gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574213; c=relaxed/simple;
	bh=AzqT5sdLyLMM6z3qB4hj/fXy7a1V//94ijxfbKJQoTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lieA5q2/iDRVwA551QWQAVkQnGFdKAhtIs+OsUgFU1yS8gXXAA+SPtAdO5dTHWM+p2tz3JWhHvkb2lakHgsckbTVaOgbJalJBEQr4TAMN+4MWLPOsUt5S5tf4mxZPAoaYxzet9BSeYpy3btYh4N8Ld5gmgPPHm6m2RZE47JQp2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FylwTFnI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FylwTFnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1AE3C4CED0;
	Mon, 30 Dec 2024 15:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574212;
	bh=AzqT5sdLyLMM6z3qB4hj/fXy7a1V//94ijxfbKJQoTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FylwTFnIZnsxhrhWRlYjVktSwUSvJzqmvcJhi/yqxDKDbcqSrULZ5mYoLTXMttqss
	 A8F54tQkrtXNLD2wdELB7YVy8YsPabBiAY5SnX1/5ZabaKAV4YobVdJDhHXrt10E6T
	 J/B9DW2oimdM0Rz7KzWhg5s5ls5rYP0rpsP74pCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/114] udf: Skip parent dir link count update if corrupted
Date: Mon, 30 Dec 2024 16:42:49 +0100
Message-ID: <20241230154220.061388209@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit c5566903af56dd1abb092f18dcb0c770d6cd8dcb ]

If the parent directory link count is too low (likely directory inode
corruption), just skip updating its link count as if it goes to 0 too
early it can cause unexpected issues.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/namei.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 78a603129dd5..2be775d30ac1 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -517,7 +517,11 @@ static int udf_rmdir(struct inode *dir, struct dentry *dentry)
 			 inode->i_nlink);
 	clear_nlink(inode);
 	inode->i_size = 0;
-	inode_dec_link_count(dir);
+	if (dir->i_nlink >= 3)
+		inode_dec_link_count(dir);
+	else
+		udf_warn(inode->i_sb, "parent dir link count too low (%u)\n",
+			 dir->i_nlink);
 	udf_add_fid_counter(dir->i_sb, true, -1);
 	inode_set_mtime_to_ts(dir,
 			      inode_set_ctime_to_ts(dir, inode_set_ctime_current(inode)));
-- 
2.39.5




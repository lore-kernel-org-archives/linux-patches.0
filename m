Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695E6335BAC;
	Mon, 18 Aug 2025 13:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523219; cv=none; b=bqVHFg0RTxRrlHerpNTDmZd1piONhcRE9YWzMqln42ML0bELW3Rn9VdfmK+7JfOtW3OioAnX8lLC/FsNy5Ay5oOXTnrBr5b+YRNsTv2FtTDToJH5du8MM/T+UC3ToqBSUVwbsZHmGZTboDlUog0nzShVIgLnh9wiP5tjC/ohOoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523219; c=relaxed/simple;
	bh=6jGQRY8sacjGcKALG6CK9gRFKI8Rtk2qfEiO96+yxiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqwEQEEEDEp1aLdohmAFqmCI+uYRu6xoCOYz0JO5TmI8hCtgxwYwSNfD7Ynr+FSzMsVZ0IFwPM1FC3OP99bczUz+Oa2U2qQ+BCFh+j+AEdEom3EgNGwK+ZbuhGjT0vI5soeQjFY9jpu0CtMjpnVK8R2Tvsj6EcxWC+vE8M01bII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRs/ZZ5N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRs/ZZ5N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0159C4CEEB;
	Mon, 18 Aug 2025 13:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523219;
	bh=6jGQRY8sacjGcKALG6CK9gRFKI8Rtk2qfEiO96+yxiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tRs/ZZ5NRVXsVyYzP1jqVN/RoWDS22docu4yXWJTy0L93EV0wTHlBMhTDzCLmtbmE
	 iey8zRiHbJAh3qndDrBNjk1nixTnCswjYjbIxqIVGZeaMKnui95YuZGL/KHYEuL/1A
	 M5ZVOIw1fFdH1KfL052K70EgXQuGEEMe3moa3HAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 106/515] pidfs: raise SB_I_NODEV and SB_I_NOEXEC
Date: Mon, 18 Aug 2025 14:41:32 +0200
Message-ID: <20250818124502.447516258@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 1a1ad73aa1a66787f05f7f10f686b74bab77be72 ]

Similar to commit 1ed95281c0c7 ("anon_inode: raise SB_I_NODEV and SB_I_NOEXEC"):
it shouldn't be possible to execute pidfds via
execveat(fd_anon_inode, "", NULL, NULL, AT_EMPTY_PATH)
so raise SB_I_NOEXEC so that no one gets any creative ideas.

Also raise SB_I_NODEV as we don't expect or support any devices on pidfs.

Link: https://lore.kernel.org/20250618-work-pidfs-persistent-v2-1-98f3456fd552@kernel.org
Reviewed-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pidfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index 005976025ce9..b8fe3495ccbf 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -854,6 +854,8 @@ static int pidfs_init_fs_context(struct fs_context *fc)
 	if (!ctx)
 		return -ENOMEM;
 
+	fc->s_iflags |= SB_I_NOEXEC;
+	fc->s_iflags |= SB_I_NODEV;
 	ctx->ops = &pidfs_sops;
 	ctx->eops = &pidfs_export_operations;
 	ctx->dops = &pidfs_dentry_operations;
-- 
2.39.5




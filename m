Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D443F335BBA;
	Mon, 18 Aug 2025 13:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524968; cv=none; b=bNQZPOPU/MSJrdV/9cmdqh1JCwIxRYD5cOCPENuY7wdIt9CLFFhgEOXBroclH0Lc/uIRuPlxlmu3l0TTXFN0UO5yJNChUjSYLVCKG9TfFwvqz1r3HCOF64P1tvqB0W5IWg1dUPDpXnLsCAMT2MksPYSpozeVP1FHPwWLKjHkryQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524968; c=relaxed/simple;
	bh=0zMNUoekzUs14v/zUjDzIZPhYUcl8AbaBE280Ko2nu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5lpzZwKxL7UTEbYWIbs0c6yxg+YoXlUyy0LsXpbU4Q3nbCAcJ4y/zGLOdXCQ/h3s4ePlbU5asZF0Y7B7aZovzfCIJuPVpSgCFvsq61sI0jEgP3vPjj9vIjtvaAqNpmyH7qz0atROhaEWIkFYZ2TJdOSKhZgN3G3SQj9KsKqMxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UHNsuIGN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UHNsuIGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E867EC4CEEB;
	Mon, 18 Aug 2025 13:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524968;
	bh=0zMNUoekzUs14v/zUjDzIZPhYUcl8AbaBE280Ko2nu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UHNsuIGNMw93mnJX3dcgiG8CM8DAVMA1B4W5ivRqa3CEsROawE/tz7KbE5lbadFgg
	 w3jdJZqP4kqvnV4A/C0oXRA+hnismX4V2tPbebw9QjHOuQEjcb6RjkDdBa3Lj5lYfn
	 OzCVBbjIt6xQeNn29Jba3+/dRjHpQbR1wE9v9y8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 118/570] pidfs: raise SB_I_NODEV and SB_I_NOEXEC
Date: Mon, 18 Aug 2025 14:41:45 +0200
Message-ID: <20250818124510.364135434@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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
index 4625e097e3a0..4c551bfa8927 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -891,6 +891,8 @@ static int pidfs_init_fs_context(struct fs_context *fc)
 	if (!ctx)
 		return -ENOMEM;
 
+	fc->s_iflags |= SB_I_NOEXEC;
+	fc->s_iflags |= SB_I_NODEV;
 	ctx->ops = &pidfs_sops;
 	ctx->eops = &pidfs_export_operations;
 	ctx->dops = &pidfs_dentry_operations;
-- 
2.39.5




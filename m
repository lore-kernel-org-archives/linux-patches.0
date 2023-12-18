Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA571D146;
	Mon, 18 Dec 2023 14:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pe/xqRyE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D8BC433C7;
	Mon, 18 Dec 2023 14:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908324;
	bh=FSvqXxyoEW1Uc+TxL94rdIeRKxVRTOi+HnX1MzJDmwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pe/xqRyEfxlW9FVzyRK3dfCJPBzSwvKSSLTBC2tjzAxHHjoqZ6hkmgNmBg0EyYWH1
	 js6DEXehs6MeGs6jLZmABD1fvThmrNf8sKTUl6LqAy3zBHqu1BJy2HXX9EkZlAOd4H
	 Zf1mwiPImGu4/rN5ceYDzXg05mbimZI3nq2No9VA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Josef Bacik <josef@toxicpanda.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/166] eventfs: Do not allow NULL parent to eventfs_start_creating()
Date: Mon, 18 Dec 2023 14:51:24 +0100
Message-ID: <20231218135110.314728459@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit fc4561226feaad5fcdcb55646c348d77b8ee69c5 ]

The eventfs directory is dynamically created via the meta data supplied by
the existing trace events. All files and directories in eventfs has a
parent. Do not allow NULL to be passed into eventfs_start_creating() as
the parent because that should never happen. Warn if it does.

Link: https://lkml.kernel.org/r/20231121231112.693841807@goodmis.org

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/tracefs/inode.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index 891653ba9cf35..0292c6a2bed9f 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -509,20 +509,15 @@ struct dentry *eventfs_start_creating(const char *name, struct dentry *parent)
 	struct dentry *dentry;
 	int error;
 
+	/* Must always have a parent. */
+	if (WARN_ON_ONCE(!parent))
+		return ERR_PTR(-EINVAL);
+
 	error = simple_pin_fs(&trace_fs_type, &tracefs_mount,
 			      &tracefs_mount_count);
 	if (error)
 		return ERR_PTR(error);
 
-	/*
-	 * If the parent is not specified, we create it in the root.
-	 * We need the root dentry to do this, which is in the super
-	 * block. A pointer to that is in the struct vfsmount that we
-	 * have around.
-	 */
-	if (!parent)
-		parent = tracefs_mount->mnt_root;
-
 	if (unlikely(IS_DEADDIR(parent->d_inode)))
 		dentry = ERR_PTR(-ENOENT);
 	else
-- 
2.43.0




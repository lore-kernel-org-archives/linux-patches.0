Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252C815689A;
	Thu, 13 Feb 2025 14:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458506; cv=none; b=Ds0804lAiLLv7OeYqOT9oKeT7dgGelPZ6P2lNlzJOmdXTXwmfwwCWA5BSyQ+D+nBoZAq2f7pYMAj9JWd9vsFRw70h9bVYeeBiU7rVFUSc6pvGFZhzg9xeZOET6UC4/4eoy5oCCoHiZL/KspcOsw/ZCnVV9i4dce8v+Flg6E6z5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458506; c=relaxed/simple;
	bh=92PhqNrwZ4SCH1QTlvFERVKZjWGNgJvaIuaeyHzdO+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrYaxNYjwnb0N4F+YmWmu0PxhX8WBUhl/x9uXpGxbUMpXPmBnO/oVwP11x2qjAIFC8/dwjAJiycyl3XClyAOTc7dMTY9Vz9rxo430a7hMkXS43+dL4jilLd8Yraj6DMIdLyqkYiE2UoWjZpzatE3fzKt6O4ECMa+VKK4WbglfGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9lp9PJO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9lp9PJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C37C4CED1;
	Thu, 13 Feb 2025 14:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458505;
	bh=92PhqNrwZ4SCH1QTlvFERVKZjWGNgJvaIuaeyHzdO+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a9lp9PJOut0eZRHO5W9wC4keS41EHXY4v1F815WALN3HYsQ9janurMKIM4h5arVzN
	 YWokZGR4I3CJxO5Hnp+zXkbh3ZuYysd4wri2qcsxJzNp1VQGquJ2L/XlXrnn8JIwMg
	 YmSd8QQGts0jK9rQFHoaxNdsFX4d1VtTEq+ZZnLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 420/422] statmount: let unset strings be empty
Date: Thu, 13 Feb 2025 15:29:29 +0100
Message-ID: <20250213142452.773668291@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

From: Miklos Szeredi <mszeredi@redhat.com>

commit e52e97f09fb66fd868260d05bd6b74a9a3db39ee upstream.

Just like it's normal for unset values to be zero, unset strings should be
empty instead of containing random values.

It seems to be a typical mistake that the mask returned by statmount is not
checked, which can result in various bugs.

With this fix, these bugs are prevented, since it is highly likely that
userspace would just want to turn the missing mask case into an empty
string anyway (most of the recently found cases are of this type).

Link: https://lore.kernel.org/all/CAJfpegsVCPfCn2DpM8iiYSS5DpMsLB8QBUCHecoj6s0Vxf4jzg@mail.gmail.com/
Fixes: 68385d77c05b ("statmount: simplify string option retrieval")
Fixes: 46eae99ef733 ("add statmount(2) syscall")
Cc: stable@vger.kernel.org # v6.8
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Link: https://lore.kernel.org/r/20250130121500.113446-1-mszeredi@redhat.com
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -5053,22 +5053,29 @@ static int statmount_string(struct kstat
 	size_t kbufsize;
 	struct seq_file *seq = &s->seq;
 	struct statmount *sm = &s->sm;
+	u32 start, *offp;
+
+	/* Reserve an empty string at the beginning for any unset offsets */
+	if (!seq->count)
+		seq_putc(seq, 0);
+
+	start = seq->count;
 
 	switch (flag) {
 	case STATMOUNT_FS_TYPE:
-		sm->fs_type = seq->count;
+		offp = &sm->fs_type;
 		ret = statmount_fs_type(s, seq);
 		break;
 	case STATMOUNT_MNT_ROOT:
-		sm->mnt_root = seq->count;
+		offp = &sm->mnt_root;
 		ret = statmount_mnt_root(s, seq);
 		break;
 	case STATMOUNT_MNT_POINT:
-		sm->mnt_point = seq->count;
+		offp = &sm->mnt_point;
 		ret = statmount_mnt_point(s, seq);
 		break;
 	case STATMOUNT_MNT_OPTS:
-		sm->mnt_opts = seq->count;
+		offp = &sm->mnt_opts;
 		ret = statmount_mnt_opts(s, seq);
 		break;
 	default:
@@ -5090,6 +5097,7 @@ static int statmount_string(struct kstat
 
 	seq->buf[seq->count++] = '\0';
 	sm->mask |= flag;
+	*offp = start;
 	return 0;
 }
 



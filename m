Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152F526B0BC;
	Thu, 13 Feb 2025 15:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460012; cv=none; b=sHfUB2HtBidF7uAcwJeW5kpBCi0JtsdZ9a24oSkN0iwEajL+dT2uDvYfop0delWgR2jFKHcK1ImF7jlM7Ggj1uxh1ol2e0Jh9AztNEtGDk1M+oREPtPaHMFzmRxf6GavBQYGxqOhOceNktf0aoIlU22/aj3O/2PSP2k8WlJ3HuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460012; c=relaxed/simple;
	bh=+IrBRqB0JIGIwiPw0wx9f08DQ3I9dcyqxNzHxMx9zAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEms0K1hp9H/Cnjij1/QI55bgGde2iV1XCHqYYv8/uVkJycmYITaXS802A6Kr/89AwuuxyHeLVHTrovOcCGEUmj4dPSmdnGQ8B/HOSQS6k7/hS1sHcpQDyJP1SYF5qfntfpdmi0h63mMdn1d8OiytWwn45i8B8jQwKUb+Klkzjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/SjFT0v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/SjFT0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73CE9C4CED1;
	Thu, 13 Feb 2025 15:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460011;
	bh=+IrBRqB0JIGIwiPw0wx9f08DQ3I9dcyqxNzHxMx9zAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z/SjFT0vVNKyiJ6Rudq0XIkpZgym0JcCacpkSNRn8iMarzKCzDvK7XSGosoTN+1XF
	 EdgT4ndWiUxiZyiraKT3YdKq2cTvXnBRS/tVUKXVRWnrnjsoMAFoeCg3RgITo24mdg
	 YKVsiJcKcU7GuTLLJp6Nh+YxTc/e+O3dUcV6bxMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.13 431/443] statmount: let unset strings be empty
Date: Thu, 13 Feb 2025 15:29:56 +0100
Message-ID: <20250213142457.250661826@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 fs/namespace.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -5137,39 +5137,45 @@ static int statmount_string(struct kstat
 	size_t kbufsize;
 	struct seq_file *seq = &s->seq;
 	struct statmount *sm = &s->sm;
-	u32 start = seq->count;
+	u32 start, *offp;
+
+	/* Reserve an empty string at the beginning for any unset offsets */
+	if (!seq->count)
+		seq_putc(seq, 0);
+
+	start = seq->count;
 
 	switch (flag) {
 	case STATMOUNT_FS_TYPE:
-		sm->fs_type = start;
+		offp = &sm->fs_type;
 		ret = statmount_fs_type(s, seq);
 		break;
 	case STATMOUNT_MNT_ROOT:
-		sm->mnt_root = start;
+		offp = &sm->mnt_root;
 		ret = statmount_mnt_root(s, seq);
 		break;
 	case STATMOUNT_MNT_POINT:
-		sm->mnt_point = start;
+		offp = &sm->mnt_point;
 		ret = statmount_mnt_point(s, seq);
 		break;
 	case STATMOUNT_MNT_OPTS:
-		sm->mnt_opts = start;
+		offp = &sm->mnt_opts;
 		ret = statmount_mnt_opts(s, seq);
 		break;
 	case STATMOUNT_OPT_ARRAY:
-		sm->opt_array = start;
+		offp = &sm->opt_array;
 		ret = statmount_opt_array(s, seq);
 		break;
 	case STATMOUNT_OPT_SEC_ARRAY:
-		sm->opt_sec_array = start;
+		offp = &sm->opt_sec_array;
 		ret = statmount_opt_sec_array(s, seq);
 		break;
 	case STATMOUNT_FS_SUBTYPE:
-		sm->fs_subtype = start;
+		offp = &sm->fs_subtype;
 		statmount_fs_subtype(s, seq);
 		break;
 	case STATMOUNT_SB_SOURCE:
-		sm->sb_source = start;
+		offp = &sm->sb_source;
 		ret = statmount_sb_source(s, seq);
 		break;
 	default:
@@ -5197,6 +5203,7 @@ static int statmount_string(struct kstat
 
 	seq->buf[seq->count++] = '\0';
 	sm->mask |= flag;
+	*offp = start;
 	return 0;
 }
 



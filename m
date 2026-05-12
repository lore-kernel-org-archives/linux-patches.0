Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC973EDE45;
	Tue, 12 May 2026 18:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609332; cv=none; b=KgCdzekgfrUrCKb+vk9ycw0K9LxxeOGGa57t8plEFEA3KpTQR2bX6WhIlLI+W0R/0J3sarqGpSj2M4zGChPTbKqwdqUr6QtMQPy3+e/DGQp7EWI5ZQAcu4A1AM/f3LYgvZNaZIi/Ahx8QzFR+KvwbeeJXOH1+Hwbso1pnIZyrbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609332; c=relaxed/simple;
	bh=yPmwlCgJlBlyxuzcWuWJSMD9UJhU2uA+ungm+WYeYig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaswtiC6t0Nv02g//7fdxBijVnpFexObNeUdAF13KtYV87ZkWeOg2Fo3QHw91EaW9x0w0tLOLkAbBTZ/+xClXCGtTz1mhy85WPBonEcDTpcqSguHL2qbpwp00dQebN7PqToEg1sPdlEIjvtK9zDs+4GaP53hSF6D6OhGyScqt1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hbpje1EN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hbpje1EN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12462C4AF12;
	Tue, 12 May 2026 18:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609331;
	bh=yPmwlCgJlBlyxuzcWuWJSMD9UJhU2uA+ungm+WYeYig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hbpje1ENqoK2Ae52Fial/5Wkm3stchC/eRxLiwz1H6ikcczBGouWjMprrs+/Joapn
	 BxwHlAa87phPU6duV3+c6kmgJOl3k8V7u5cnDUGSH7O4stkamI4k/uMOqV1F8oC9Fr
	 rUmd5jDp6YxhZ/27HMdmfsK3yEEzmyfZQSXupSa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 7.0 152/307] tracefs: Fix default permissions not being applied on initial mount
Date: Tue, 12 May 2026 19:39:07 +0200
Message-ID: <20260512173943.334776625@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit e8368d1f4bedbb0cce4cfe33a1d2664bb0fd4f27 upstream.

Commit e4d32142d1de ("tracing: Fix tracefs mount options") moved the
option application from tracefs_fill_super() to tracefs_reconfigure()
called from tracefs_get_tree(). This fixed mount options being ignored
on user-space mounts when the superblock already exists, but introduced
a regression for the initial kernel-internal mount.

On the first mount (via simple_pin_fs during init), sget_fc() transfers
fc->s_fs_info to sb->s_fs_info and sets fc->s_fs_info to NULL. When
tracefs_get_tree() then calls tracefs_reconfigure(), it sees a NULL
fc->s_fs_info and returns early without applying any options. The root
inode keeps mode 0755 from simple_fill_super() instead of the intended
TRACEFS_DEFAULT_MODE (0700).

Furthermore, even on subsequent user-space mounts without an explicit
mode= option, tracefs_apply_options(sb, true) gates the mode behind
fsi->opts & BIT(Opt_mode), which is unset for the defaults. So the
mode is never corrected unless the user explicitly passes mode=0700.

Restore the tracefs_apply_options(sb, false) call in tracefs_fill_super()
to apply default permissions on initial superblock creation, matching
what debugfs does in debugfs_fill_super().

Cc: stable@vger.kernel.org
Fixes: e4d32142d1de ("tracing: Fix tracefs mount options")
Link: https://patch.msgid.link/20260404134747.98867-1-devnexen@gmail.com
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -491,6 +491,7 @@ static int tracefs_fill_super(struct sup
 		return err;
 
 	sb->s_op = &tracefs_super_operations;
+	tracefs_apply_options(sb, false);
 	set_default_d_op(sb, &tracefs_dentry_operations);
 
 	return 0;



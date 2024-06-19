Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997C7AD58;
	Wed, 19 Jun 2024 13:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802919; cv=none; b=piUnbAiaSEpR7PFRN060uG/XkEbsJXLZCkOkCwwRO6FzaCJDmlWIQN3EzMZDwrbXB4Qw/S+E1ZZD42VIwgusUcFHPFrcrNeH/JLnPyOf9uD7o9Bv58LKyl/JTOS0Bj7ikGgeDaenwf9Lzum4sTcDxBwlSlxE8hWbhSTdmQnPxmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802919; c=relaxed/simple;
	bh=RIJQfuwpJ6OY7N7yJAASBfGlhJ1ti21/Qh1QSoGIiJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IIXm+f4iL2LObqSoFG/PbNWP547LCfLeHuFzvFVWFep5LjAfpiMP0CSWqABV77pYpLoHq3q1ttsTR8VXNSdrFrTUYctFEra6dc3rGSIUhO4c3NUXeKIDcN0Hv2nTcSjg595GZiDy465zSApqnYKaPGspsEmV7UQxzk7u2FwUPFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSZguHtO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSZguHtO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE040C2BBFC;
	Wed, 19 Jun 2024 13:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802919;
	bh=RIJQfuwpJ6OY7N7yJAASBfGlhJ1ti21/Qh1QSoGIiJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSZguHtOKbKyDfyhn0KLUiQgJVE+jTuBgNmV9DR5ALmDCWQEJKSWs9897sHl/yVyf
	 4nfuhCuRVUM/r4zdmhhMyZyMxjG+hOadDKTGQeyvGtW4KF5LVhb1ElU5y2MVknJwWM
	 rRjB4u86HRCsN44voq4CgHuM1E56C6mpgCkLQk50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Paul Moore <paul@paul-moore.com>,
	syzbot+bf4903dc7e12b18ebc87@syzkaller.appspotmail.com,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.9 092/281] landlock: Fix d_parent walk
Date: Wed, 19 Jun 2024 14:54:11 +0200
Message-ID: <20240619125613.390629199@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

commit 88da52ccd66e65f2e63a6c35c9dff55d448ef4dc upstream.

The WARN_ON_ONCE() in collect_domain_accesses() can be triggered when
trying to link a root mount point.  This cannot work in practice because
this directory is mounted, but the VFS check is done after the call to
security_path_link().

Do not use source directory's d_parent when the source directory is the
mount point.

Cc: Günther Noack <gnoack@google.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: stable@vger.kernel.org
Reported-by: syzbot+bf4903dc7e12b18ebc87@syzkaller.appspotmail.com
Fixes: b91c3e4ea756 ("landlock: Add support for file reparenting with LANDLOCK_ACCESS_FS_REFER")
Closes: https://lore.kernel.org/r/000000000000553d3f0618198200@google.com
Link: https://lore.kernel.org/r/20240516181935.1645983-2-mic@digikod.net
[mic: Fix commit message]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/fs.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -950,6 +950,7 @@ static int current_check_refer_path(stru
 	bool allow_parent1, allow_parent2;
 	access_mask_t access_request_parent1, access_request_parent2;
 	struct path mnt_dir;
+	struct dentry *old_parent;
 	layer_mask_t layer_masks_parent1[LANDLOCK_NUM_ACCESS_FS] = {},
 		     layer_masks_parent2[LANDLOCK_NUM_ACCESS_FS] = {};
 
@@ -997,9 +998,17 @@ static int current_check_refer_path(stru
 	mnt_dir.mnt = new_dir->mnt;
 	mnt_dir.dentry = new_dir->mnt->mnt_root;
 
+	/*
+	 * old_dentry may be the root of the common mount point and
+	 * !IS_ROOT(old_dentry) at the same time (e.g. with open_tree() and
+	 * OPEN_TREE_CLONE).  We do not need to call dget(old_parent) because
+	 * we keep a reference to old_dentry.
+	 */
+	old_parent = (old_dentry == mnt_dir.dentry) ? old_dentry :
+						      old_dentry->d_parent;
+
 	/* new_dir->dentry is equal to new_dentry->d_parent */
-	allow_parent1 = collect_domain_accesses(dom, mnt_dir.dentry,
-						old_dentry->d_parent,
+	allow_parent1 = collect_domain_accesses(dom, mnt_dir.dentry, old_parent,
 						&layer_masks_parent1);
 	allow_parent2 = collect_domain_accesses(
 		dom, mnt_dir.dentry, new_dir->dentry, &layer_masks_parent2);



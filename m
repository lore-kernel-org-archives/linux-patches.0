Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DF7133987;
	Tue, 20 Feb 2024 21:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463150; cv=none; b=XRm+BRWIKW27WaRl5y3Muik+hpsP1DHncnmL4nFn88iL04xBeDVqYhiyHCEQjmx4Yxu6hA6prrT3aMskLfOC4KjwCD4LDSjB+3wQhC3cubpVM+v7OgvsYBE/hAgpdlTgG8mivdzw5V4kI3JF8MGmlRufJNPmPzjBjBC1vYKP/aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463150; c=relaxed/simple;
	bh=GRUGCw4JXwwUvEDUa9ER15yUrPpZKp6fJydSiX1UenA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rL52Ixt7uwUF5hmIOS18hZpB9mCbteVjsPANof9EDa27p9ZViSFZvBoryk6MkZRLDF29Smm5csoEn3F479B2US8dGQbRVj4X5QcEAgt42uMKM3JWSYyjd77XZbgbBTuaFtYnQiNLWhxhcTMnKMCTCKgV1gi3LR/fYq6uL2yo3CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WOsUc6Dv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WOsUc6Dv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15711C433F1;
	Tue, 20 Feb 2024 21:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463150;
	bh=GRUGCw4JXwwUvEDUa9ER15yUrPpZKp6fJydSiX1UenA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WOsUc6DvQa0XYzYIiGnyweWzxig/Mp5hps5MeCVWTeiWsCo2EOiiXZi3DyS6+SyWQ
	 q5vtDkcyDoMxD8kq9JL1dSFna8+BzJxW1BVYQWHD+DSloBO4gQ4xjwOuwV4a4hPaiY
	 gv04WT7rdB8NvrN6wOrZGGFo6lkcZ48GxeR6tSMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Karel Zak <kzak@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.1 152/197] fs: relax mount_setattr() permission checks
Date: Tue, 20 Feb 2024 21:51:51 +0100
Message-ID: <20240220204845.623334338@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 46f5ab762d048dad224436978315cbc2fa79c630 upstream.

When we added mount_setattr() I added additional checks compared to the
legacy do_reconfigure_mnt() and do_change_type() helpers used by regular
mount(2). If that mount had a parent then verify that the caller and the
mount namespace the mount is attached to match and if not make sure that
it's an anonymous mount.

The real rootfs falls into neither category. It is neither an anoymous
mount because it is obviously attached to the initial mount namespace
but it also obviously doesn't have a parent mount. So that means legacy
mount(2) allows changing mount properties on the real rootfs but
mount_setattr(2) blocks this. I never thought much about this but of
course someone on this planet of earth changes properties on the real
rootfs as can be seen in [1].

Since util-linux finally switched to the new mount api in 2.39 not so
long ago it also relies on mount_setattr() and that surfaced this issue
when Fedora 39 finally switched to it. Fix this.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=2256843
Link: https://lore.kernel.org/r/20240206-vfs-mount-rootfs-v1-1-19b335eee133@kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Reported-by: Karel Zak <kzak@redhat.com>
Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4172,10 +4172,15 @@ static int do_mount_setattr(struct path
 	/*
 	 * If this is an attached mount make sure it's located in the callers
 	 * mount namespace. If it's not don't let the caller interact with it.
-	 * If this is a detached mount make sure it has an anonymous mount
-	 * namespace attached to it, i.e. we've created it via OPEN_TREE_CLONE.
+	 *
+	 * If this mount doesn't have a parent it's most often simply a
+	 * detached mount with an anonymous mount namespace. IOW, something
+	 * that's simply not attached yet. But there are apparently also users
+	 * that do change mount properties on the rootfs itself. That obviously
+	 * neither has a parent nor is it a detached mount so we cannot
+	 * unconditionally check for detached mounts.
 	 */
-	if (!(mnt_has_parent(mnt) ? check_mnt(mnt) : is_anon_ns(mnt->mnt_ns)))
+	if ((mnt_has_parent(mnt) || !is_anon_ns(mnt->mnt_ns)) && !check_mnt(mnt))
 		goto out;
 
 	/*



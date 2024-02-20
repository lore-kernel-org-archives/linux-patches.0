Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34DB612D7;
	Tue, 20 Feb 2024 21:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465234; cv=none; b=j3AGhaH1eWD2IEFCcbsCADTJ3oPqUZRTrm0nwW72kZ2BJxKixK1tPlKdKhPlEEfibk0lGSpMbDwvsn/f0UsidZqY4qsDJynaDIaFuqa2zdY+EW/DecrG84+pJn/VolO3qfg3FGGT7cQfzHIBEXYx3RbcS2TTyH3uEFcBxcRJS/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465234; c=relaxed/simple;
	bh=OmVqubZoclkRKpx/De1n7JtzAPYDknkbXDxVSI3w0iU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVzo5aEXQy88n1oMEqm8FnHw4sEA5vwDk5JpnyHo5ABz0WbjinebX8LypYjAZcHuGPrdE0EXdFNc1dTmHv3+AbLdLCzDdRZeiMdCg3l2iPiHu3e+SXX0NEi7xDr0sS0D/P0GsiaFABbXlVwSpXtIT7wGA8LxZlfvFPWN11gRWa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G8T5em4i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G8T5em4i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50CF5C433C7;
	Tue, 20 Feb 2024 21:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465233;
	bh=OmVqubZoclkRKpx/De1n7JtzAPYDknkbXDxVSI3w0iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G8T5em4i8JC7NnDrhjPHa+Uyu+uNZa8VlDUgoalzYo+X2ZtGXK07uhynSLIMKl67l
	 hc+U9004IqRUQUldr7u0lSkhxv4XERLl1vDIkp6tDPVzHFCSLUYi084ZbDZ0e/MAo6
	 YZfR8ZgwseFTLUORv1pxM3elm9tZDYI2LiAV5144=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Karel Zak <kzak@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.7 278/309] fs: relax mount_setattr() permission checks
Date: Tue, 20 Feb 2024 21:57:17 +0100
Message-ID: <20240220205641.817188955@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4472,10 +4472,15 @@ static int do_mount_setattr(struct path
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



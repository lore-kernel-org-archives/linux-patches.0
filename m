Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38933290AA;
	Tue, 13 Oct 2026 12:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894434; cv=none; b=e4UA4UrF6YSzFxi+qkd3kDADzv2s9X55HT2zrBHZPvWCA2VkudgQDfBU0Abnc2qElmWsXbld+JOVZM9bR5BOdd2YbZ5CY3pG3ELDFSE1RrTV/5O4sLyTW2U2WekrJc39eqKKSArQdAfCLvLth+MnyXjBYs8oJ0FfGgwfzm9DtS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894434; c=relaxed/simple;
	bh=SVEOFBzZPjUtWAUBoO5mWooNum4r8n7JSkgq5wdT7Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lK77WxmeF+1QAH5lUNbhDLiTx9f2C3ZzD+6SLvXczrBLjUniLk/Vh1380eK8XY39Bx8fBGbQeAPv9wSfD3OmeIq8RlJjUCSJBAYHF4GjsGnGJuUG9/46xdba4G6DPEzx5nLB+bWcBgvsIVqnp1KKgyzNBdhcqBvs01XowfwQh/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j0M0hJo5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j0M0hJo5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6851F000FF;
	Tue, 13 Oct 2026 12:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894433;
	bh=vd8Z8Ym8qXraUU+nMY7jbeZ89HQV54T9VBQyHmgysUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j0M0hJo5dni62cAGVbr5TcIcVupNEwHHXN2BXQMN/HvcX/heBFC6D+j/cdlCZcB/F
	 iO6bR4Svp4hFICAZ6o/D1Rtko2tQSNknxx+1xJXeTlJ6gOWR+oWt7EG0t9pV0UmHCn
	 zm4Z3erl4wrlig+Lmp0nVIWX6jcY4D74XN4DyeaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 532/621] mount: refuse MOVE_MOUNT_SET_GROUP on an unbindable mount
Date: Tue, 13 Oct 2026 13:38:47 +0200
Message-ID: <20261013112933.444547097@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit a2b42babc912e4fb428cbb42adb4f6e1e067113d ]

do_set_group() only accepts mounts as targets that are neither shared
nor a slave. That encompasses undindable mounts.

If the source mount is a slave mount the target mount will end up with
source's master as its master. It keeps T_UNBINDABLE. That means we get
a mount that is both unbindable and a slave:

  mount --bind /tmp/src /tmp/src
  mount --make-shared /tmp/src
  mount --bind /tmp/src /tmp/b
  mount --make-slave /tmp/b
  mount --bind /tmp/src /tmp/c
  mount --make-unbindable /tmp/c
  move_mount(b, "", c, "", MOVE_MOUNT_SET_GROUP)
  grep /tmp/c /proc/self/mountinfo
  ... /tmp/c ... master:646 unbindable ...

This property cannot be produced any other way. change_mnt_propagation()
drops the master when it makes a mount unbindable (iow, it becomes
private) and doesn't touch an unbindable mount when it is supposed to
turned into a slave mount.

End-result is that the unbindable-slave mount receives everything
propagated from its master's peer group while it can't be bind mounted
itself. Not sure what that's supposed to do.

On the other side: if the source mount is shared, the target mount drops
T_UNBINDABLE because because set_mnt_shared() clears T_SHARED_MASK.

So teach do_set_group() to refuse an unbindable target mount the same
way a shared or slave target mount is refused.

The main user of MOVE_MOUNT_SET_GROUP is CRIU which restores sharing
first and applies MS_UNBINDABLE afterwards. It never hits this.

Link: https://patch.msgid.link/20260923-work-mount-fixes-v1-3-f424cf8d3242@kernel.org
Fixes: 9ffb14ef61ba ("move_mount: allow to add a mount into an existing group")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 76da6484ef4d6..0bc34cf8fe001 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3379,7 +3379,7 @@ static int do_set_group(const struct path *from_path, const struct path *to_path
 		return -EINVAL;
 
 	/* Setting sharing groups is only allowed on private mounts */
-	if (IS_MNT_SHARED(to) || IS_MNT_SLAVE(to))
+	if (IS_MNT_SHARED(to) || IS_MNT_SLAVE(to) || IS_MNT_UNBINDABLE(to))
 		return -EINVAL;
 
 	/* From should not be private */
-- 
2.53.0




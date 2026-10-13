Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272534EFFC2;
	Tue, 13 Oct 2026 12:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893173; cv=none; b=XIAiFSC5XY13U5ih6toD0ZK8poohW9qfHuPfGxyqBxv7srkIc/az9Gb6IRpeCL5a2amfcECR+D7rbMOemXJClVUuodkJmNKx9Mk4iOHlbOhio4oPUfe9AoriJZiu/bu8s4PJU6NOIdqCL53v+1Qo2hwQ3PE8KQH0tReowZerTqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893173; c=relaxed/simple;
	bh=0zXZRaU0lmiJveQXqnfe3ZmYP1Rf4qxYzDHQJjlTdEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGfPviIY8FAPAvaeN+e2Us6QjHsVvdS2Rd7NO4whaXXabFRYtp96Iv/NFtZmnuUUVYBHhOk+L1evhbYq/RapnZj5AUrOQW7I0NVuG2euNVt7mJ+MX0Yt8gSJnIv20++UpptoY9pGB4LT69IqZrWah3UHtbiTvCBt024QC2t92lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fZJ1COZw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fZJ1COZw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D2E1F000FF;
	Tue, 13 Oct 2026 12:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893172;
	bh=TSSKH1NrpNG4+v2uJmuVJDcNwIWmbAw8ZdwEHCJyS1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fZJ1COZwLXpDD1EO/4jzB0NkZKdWxpocw1+88osHFps71DDrEZ3bSz4++YuAeFMya
	 p9OFkixvmBhFyKghSobI6cnd511PsW3YEXjTSGlwoQq82sO7q8kjY5Gd81BuHVsOjK
	 jaQU+BsMoMFz2un17FZltwgrL2mR1MkbCgvVUyJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 137/621] namespace: check a recursive bind mount for mount namespace loops
Date: Tue, 13 Oct 2026 13:32:12 +0200
Message-ID: <20261013112924.108467937@linuxfoundation.org>
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

commit c640a01a78e42302879006ed7b7d5a9a943ba815 upstream.

do_loopback() refuses to bind mount the file of a mount namespace that
is as old as the caller's or older because a mount namespace that holds
a mount of its own file, or of an ancestor's, would cause a cycle. But
it only checks the dentry the bind mount starts from. With MS_REC
everything below it is copied and do_loopback() passes
CL_COPY_MNT_NS_FILE so mount namespace files below the source are
copied.

That's fine for a source in the caller's own mount namespace. Every
mount namespace file in there passed the same check when it was
bind-mounted. It isn't fine for a source in another mount namespace.
may_copy_tree() accepts a bind mount of any nsfs or pidfs file no matter
what mount namespace it lives in so that /proc/<pid>/ns/<ns> and pidfds
can be bind mounted. If we create a bind-mount stack of mount namespaces
file descriptors the kernel will copy them irrespective of their
ancestoral relationship to the mount namespace in question:

  151 146 0:7 net:[4026531833] /tmp/nrc/y rw - nsfs nsfs rw
  152 151 0:7 mnt:[4026532293] /tmp/nrc/y rw - nsfs nsfs rw

Mount 152 is a mount of the mount namespace file of mount namespace
4026532293 inside mount namespace 4026532293. That namespace and every
mount in it are leaked... All it takes is a process in an older mount
namespace that stacks the file and repeating it leaks without limit:

  after control: Shmem:               380 kB
  child: mount(/proc/self/fd/6, MS_BIND|MS_REC): ok
  after cycle: Shmem:             65916 kB

do_move_mount() runs check_for_nsfs_mounts() over a detached tree for
exactly that reason. Do the same for the copy before it is grafted.

Fixes: e149ed2b805f ("take the targets of /proc/*/ns/* symlinks to separate fs")
Fixes: ef4144ac2dec ("pidfs: allow bind-mounts")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260930-work-mount-fixes-3-v1-4-be34c83956ae@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3011,7 +3011,11 @@ static int do_loopback(const struct path
 	if (IS_ERR(mnt))
 		return PTR_ERR(mnt);
 
-	err = graft_tree(mnt, &mp);
+	/* the copy may carry mount namespace files from below the source */
+	if (recurse && !check_for_nsfs_mounts(mnt))
+		err = -EINVAL;
+	else
+		err = graft_tree(mnt, &mp);
 	if (err) {
 		lock_mount_hash();
 		umount_tree(mnt, UMOUNT_SYNC);



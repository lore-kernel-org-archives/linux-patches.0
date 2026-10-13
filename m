Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E184EBAD7;
	Tue, 13 Oct 2026 11:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892370; cv=none; b=MQaavIbCPpdBUrno1X0oCSix2onseE0oDzeq51kCe1bKBs64FJDdu9vccRAkVvW3VTF9r9gb4LQog5MM06Rr82VwiZFzTz4ETUsfhGuSMxCfYD3dhxOKnPTGiviIX2H34+WeG9SNgT3AcLxAk+UfFT94hL/QfvSqh/DgCFe3EUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892370; c=relaxed/simple;
	bh=kgs9ogSNJy0prs0WUA2UFbfQWfeLjRhh8LUyl+D6tJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUCFWCLrcRvqN5Ox0qWs+3q4yTlaVFE5INNMOlu+Le4Xs9tE7VPuu/VUYujryThEFSckiQuwi42be94jz0FZgkXCbNYZEeFXdG9TRlSfa1mEorIj0XKicuka4A8w+gshY4LYNN7NoL2bPIXlfrv7EOgraobp/2+6ECi7XeS9H8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HiXAgEv9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HiXAgEv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A631F000FF;
	Tue, 13 Oct 2026 11:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892368;
	bh=1GLbVTxTFE+6Dxp/2b0vqbZEUEhRIXcDNZ0QcqHlCW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HiXAgEv9UFNiUfgU8YOTd9tLf8q8j+FQ2esdSNAuFqFfeqtolOcbnt6+fJlcNh9D2
	 pr3ggDC/hONP9fh0KMrXn745jj3iia6Bxdj+KD7hlArkyJAprPuyZDJczFBBUczGEl
	 7jzatF4kXy6RDAfpmG3xIx2BSDSL9gpp+fobkYLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 150/281] statmount: read the parent of an unmounted mount under mount_lock
Date: Tue, 13 Oct 2026 13:37:46 +0200
Message-ID: <20261013112858.799942260@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit bb46094057520304073130920c223451c2a694a7 upstream.

statmount_mnt_basic() reads the ids of the parent through m->mnt_parent
with namespace_sem held for reading. That's fine for a mount that is
in a namespace. Everything above it is pinned by that namespace.

STATMOUNT_BY_FD also accepts a file descriptor on a mount that has
been unmounted on purpose and that only the file descriptor keeps alive.
If that mount stayed attached to its parent when it was unmounted the
parent is unmounted as well and nothing pins it for the child.

The final mntput() unmounts the children under mount_lock alone and
frees the parent afterwards. Concurrently, statmount_mnt_basic() reads
m->mnt_parent twice while that can happen and can easily dereference a
mount that's already gone.

Read the parent of an unmounted mount under mount_lock. The parent
can't be put while it is held and both ids come from the same mount. A
mounted mount's parent is pinned by the namespace and a mount can't
leave its namespace while namespace_sem is held, so the common case
takes no global lock.

Fixes: 0e5032237ee5 ("statmount: accept fd as a parameter")
Cc: stable@vger.kernel.org # v7.0+
Link: https://patch.msgid.link/20260926-work-mount-fixes-2-v1-2-f357abf3d17b@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -5316,15 +5316,25 @@ static void statmount_sb_basic(struct ks
 	s->sm.sb_flags = sb->s_flags & (SB_RDONLY|SB_SYNCHRONOUS|SB_DIRSYNC|SB_LAZYTIME);
 }
 
+static void statmount_mnt_parent(struct kstatmount *s, const struct mount *m)
+{
+	s->sm.mnt_parent_id = m->mnt_parent->mnt_id_unique;
+	s->sm.mnt_parent_id_old = m->mnt_parent->mnt_id;
+}
+
 static void statmount_mnt_basic(struct kstatmount *s)
 {
 	struct mount *m = real_mount(s->mnt);
 
 	s->sm.mask |= STATMOUNT_MNT_BASIC;
 	s->sm.mnt_id = m->mnt_id_unique;
-	s->sm.mnt_parent_id = m->mnt_parent->mnt_id_unique;
 	s->sm.mnt_id_old = m->mnt_id;
-	s->sm.mnt_parent_id_old = m->mnt_parent->mnt_id;
+	/* An unmounted mount is cut loose from its parent under mount_lock alone. */
+	if (likely(is_mounted(s->mnt)))
+		statmount_mnt_parent(s, m);
+	else
+		scoped_guard(mount_locked_reader)
+			statmount_mnt_parent(s, m);
 	s->sm.mnt_attr = mnt_to_attr_flags(&m->mnt);
 	s->sm.mnt_propagation = mnt_to_propagation_flags(m);
 	s->sm.mnt_peer_group = m->mnt_group_id;



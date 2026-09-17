Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7043B1ED7;
	Thu, 17 Sep 2026 17:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666585; cv=none; b=TAVDOrcqrbxc9jEz17csha6pdrfxp9hOSsnJkV/rRBITohoUXGjmlHWbDmHFuHGPcxuNM5h16rn2DJEkIp5G1ABQBwfgM8GYta2W524CKAAJHI/tuu339uAWYs2xZrtu/u0Pseq/3KPFe9XFD0pWdCps0OhZUczs/vKM9A9wrZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666585; c=relaxed/simple;
	bh=hXjwbgTroPRgLTQcfgPVbPp0mxIhckpxYLK5LwvGbe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sp64NyOnTQ1iuIHfUM+p/MEZlWN4qTiBikmJacF16L7QeB2om9JtefkVALUrnnDm475YU3relxiOL9sxi1K0Vf+sB3XOqPEdIGBRlUY/XRfkTSNu8BCioud3JOJIgDDh3UA8Ssw6qznEbmIDZpC15OY1COiW0rpzuLYKZ0HdVis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dD4Sbr6t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dD4Sbr6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F203E1F000FF;
	Thu, 17 Sep 2026 17:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666583;
	bh=OPYj/93fYrUtj5plRZC/XoE6hIjw5HiWBxXA2Ja+b5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dD4Sbr6t1Sw6dH0k9zBNGP0lEUogiqeAdDJa6GSSOyQx3+LxLb5dWX8chL6NMvJEJ
	 YfKWeIvl3kv7eE8ABsDLYeH35jH8ORMxYQSoJ2FVaP6wXiNV3nvIC5meNH8kSzw0+d
	 fkZEo8Tlq6j8k8pf7nrDtBV+sZlOt9BluvYRlxzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjoern Doebel <doebel@amazon.de>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 1086/1250] smb: client: avoid leaking refcount when cifs_sb_tlink() fails
Date: Thu, 17 Sep 2026 16:14:41 +0100
Message-ID: <20260917151621.590735606@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Bjoern Doebel <doebel@amazon.de>

commit 23b26f4408ac3f35a482d2e5cf6fc865d4201b71 upstream.

cifs_oplock_break() takes over the reference that
cifs_queue_oplock_break() acquired when it queued the work, and drops it
with _cifsFileInfo_put() once the break has been processed.

Only in setups with "-o multiuser", cifs_sb_tlink() may fail, at which
point cifs_oplock_break() returns without putting the file reference,
mirroring the reference leak we already fixed in the companion patch to
cifs_queue_oplock_break().

This would trigger a crash due to busy inodes on the next unmount:

  BUG: Dentry ... still in use (1) [unmount of cifs cifs]
  VFS: Busy inodes after unmount of cifs (cifs)

Drop the reference on that path as well. Doing so before the out label
mirrors the normal path, which also puts the reference before
cifs_done_oplock_break().

Found by Sashiko code review. The failure path was not exercised at
runtime.

Fixes: e8f5f849ffce2 ("cifs: fix potential oops in cifs_oplock_break")
Cc: stable@vger.kernel.org
Assisted-by: Kiro:claude-opus-5
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -3151,8 +3151,11 @@ void cifs_oplock_break(struct work_struc
 			TASK_UNINTERRUPTIBLE);
 
 	tlink = cifs_sb_tlink(cifs_sb);
-	if (IS_ERR(tlink))
+	if (IS_ERR(tlink)) {
+		/* drop the reference taken when the break was queued */
+		_cifsFileInfo_put(cfile, false /* do not wait for ourself */, false);
 		goto out;
+	}
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
 



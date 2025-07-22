Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A8127468;
	Tue, 22 Jul 2025 13:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192182; cv=none; b=pK+JIr8e5s/NpUlOmBDKF1/2CVFpmCscMu7h0rd92Cp4nIqqX5RT0szJ93LMtDCVOD+srK/LNUVhg9+t6XKBk9irDADfBv2uVdvjWPOFYWtKHiJiH4xbhDEkTPNXo+dh8XK1WPu8/i49qZjw64Qhx57BDgH6rQARRzNyEZo4hg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192182; c=relaxed/simple;
	bh=j9s9U4mznGeONOz6stf0Gusa6hm4qLc9eaOeoc0adEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0vOrG+WVr3a5yRIx3K22sdkoZh6KX8AMvCH4XJCzZYNEoFGIHYjD/Hg2sVz3JkLGRpYr7mvzSJGQZ/MTA/vJpph3YJA+4eDo4+cjPDOf3gNVjMBXIX4ekPjGxa6qNeMgUE9lwR6CtEwlhzUXCF6qM/9NrbuiXuFycJc9CVqmtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jx7sKDzK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jx7sKDzK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EABDC4CEF5;
	Tue, 22 Jul 2025 13:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192182;
	bh=j9s9U4mznGeONOz6stf0Gusa6hm4qLc9eaOeoc0adEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jx7sKDzKKuyIcuSJzlcrE3pgXLJVlQRJMdzzTjqhT6To3yjs4scAE3ETZLPQjTQNy
	 EMEt1EqmUORffMUXaTqbK0GeiJQpYrMGOiJBwvW6SGPKPZcQ2GHVePJ9Dxq0NQ0QhC
	 z3TPNbqRPDLrl+E4JS6WR9SlVCv3qiRaM3/yOi1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	"Orlando, Noah" <Noah.Orlando@deshaw.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 6.1 68/79] clone_private_mnt(): make sure that caller has CAP_SYS_ADMIN in the right userns
Date: Tue, 22 Jul 2025 15:45:04 +0200
Message-ID: <20250722134330.883352928@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit c28f922c9dcee0e4876a2c095939d77fe7e15116 upstream.

What we want is to verify there is that clone won't expose something
hidden by a mount we wouldn't be able to undo.  "Wouldn't be able to undo"
may be a result of MNT_LOCKED on a child, but it may also come from
lacking admin rights in the userns of the namespace mount belongs to.

clone_private_mnt() checks the former, but not the latter.

There's a number of rather confusing CAP_SYS_ADMIN checks in various
userns during the mount, especially with the new mount API; they serve
different purposes and in case of clone_private_mnt() they usually,
but not always end up covering the missing check mentioned above.

Reviewed-by: Christian Brauner <brauner@kernel.org>
Reported-by: "Orlando, Noah" <Noah.Orlando@deshaw.com>
Fixes: 427215d85e8d ("ovl: prevent private clone if bind mount is not allowed")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
[ merge conflict resolution: clone_private_mount() was reworked in
  db04662e2f4f ("fs: allow detached mounts in clone_private_mount()").
  Tweak the relevant ns_capable check so that it works on older kernels ]
Signed-off-by: Noah Orlando <Noah.Orlando@deshaw.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2018,6 +2018,11 @@ struct vfsmount *clone_private_mount(con
 	if (!check_mnt(old_mnt))
 		goto invalid;
 
+	if (!ns_capable(old_mnt->mnt_ns->user_ns, CAP_SYS_ADMIN)) {
+		up_read(&namespace_sem);
+		return ERR_PTR(-EPERM);
+	}
+
 	if (has_locked_children(old_mnt, path->dentry))
 		goto invalid;
 



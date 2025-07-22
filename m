Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575092B9A5;
	Tue, 22 Jul 2025 13:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192540; cv=none; b=nCeYF3SncRKiO7aB9FPR04uiWpLfKpr2lQ7J+XXgTsEYIz8QHbO3CiQd/Vo6aYEYdoI0/L8bfASh3KjorEP2FyOLXhZr0yVg1dv2deUruRe17GOowVxSFZxLG97CYvM+YqT7vcketFsJTThuM0nGMv779jgYeHlef2GmaT+iZUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192540; c=relaxed/simple;
	bh=xawtXyHqOSwF6Pn7LbGW1yQWNLbaqk2xL2AehzTGpnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJTK9vg2ZGBQrYyq/dkF4rRozdzLr2QIgeWqe9+28+ibO+R5JElSsts6hROveBXcx2phyb/seWXhKYOSiJryX0V8bmf4vXh+IG9e3bCiUbOsoyQZQh/SchRgwvLnrbJrknykkIAhg+xY8NAj0gU0j+QFWvJyuq+CQa1WkqSh3uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BknddRsA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BknddRsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A8AC4CEEB;
	Tue, 22 Jul 2025 13:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192538;
	bh=xawtXyHqOSwF6Pn7LbGW1yQWNLbaqk2xL2AehzTGpnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BknddRsAe1vEv8mWar1CxYS6hs/LeigAcHtSJQ/UHynu040BOJSgdYqiUbq4oPKNN
	 VQ72smWRpxCCteT9e5wnAloFHtQQKMAuqEYl5+UGh6qa1SRP6ywh9Ddus0TNxkjj55
	 hl62dTHrAzooUHHGIT7NtR0N16qPKU9UGOn+cxIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	"Orlando, Noah" <Noah.Orlando@deshaw.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 6.6 095/111] clone_private_mnt(): make sure that caller has CAP_SYS_ADMIN in the right userns
Date: Tue, 22 Jul 2025 15:45:10 +0200
Message-ID: <20250722134336.959568788@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2110,6 +2110,11 @@ struct vfsmount *clone_private_mount(con
 	if (!check_mnt(old_mnt))
 		goto invalid;
 
+	if (!ns_capable(old_mnt->mnt_ns->user_ns, CAP_SYS_ADMIN)) {
+		up_read(&namespace_sem);
+		return ERR_PTR(-EPERM);
+	}
+
 	if (has_locked_children(old_mnt, path->dentry))
 		goto invalid;
 



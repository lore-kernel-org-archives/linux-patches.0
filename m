Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDB32F84F;
	Tue, 26 Aug 2025 13:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215555; cv=none; b=PbW4jYGrKVjnkNn06hCoXcdeWxqeZ9y4xbA05YyV3BN7aTmT52spqVuxV7w7Cu532rx1+8n+fH4dhEMDGa0NraJraFxdo6RSiLY2SoE8VOudOB9r2PsYEMiJqgPOZzkCTTTR8Cb0yWoixqDZRue084ShaFuevpmguBwak5NR1r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215555; c=relaxed/simple;
	bh=txTYXXeNd/KR5zEIVIPPi9gfCrd8sW7agI6p8Sqvybw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BmARuFOuRl3AQKMC6HBWa39eW2rgrPO2C/Jku5JioTGX8XI8AagyVo+6tYgwKe8KpWb79bxytXRm3szsTInYU0NiZMdRKUrkCIGqUOg+tmPKTGagkl7LPZdCtDmQWRVqgf0Jp9KzHlbc8MxKZZY1ZFpC0GiK1jMHgxb/9f++jI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IBqDm0ZI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IBqDm0ZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B39C4CEF1;
	Tue, 26 Aug 2025 13:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215553;
	bh=txTYXXeNd/KR5zEIVIPPi9gfCrd8sW7agI6p8Sqvybw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBqDm0ZIiz7wGNZNd41d5n+6nOCyYEaxp7oyigzQ1ZbDZEJFj8RKKyQvPFc80NYfK
	 L1A9DveUmwl+tAL5H1G2JR1CuDEQqal+pRBh0CcqpuJwsoLGv517GS4/RhATe18Nab
	 FwYVOUGqInAeJO55971v92mvPtdxJ1m3LjaOySgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	"Orlando, Noah" <Noah.Orlando@deshaw.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.15 060/644] clone_private_mnt(): make sure that caller has CAP_SYS_ADMIN in the right userns
Date: Tue, 26 Aug 2025 13:02:31 +0200
Message-ID: <20250826110947.989007651@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1975,6 +1975,11 @@ struct vfsmount *clone_private_mount(con
 	if (!check_mnt(old_mnt))
 		goto invalid;
 
+	if (!ns_capable(old_mnt->mnt_ns->user_ns, CAP_SYS_ADMIN)) {
+		up_read(&namespace_sem);
+		return ERR_PTR(-EPERM);
+	}
+
 	if (has_locked_children(old_mnt, path->dentry))
 		goto invalid;
 



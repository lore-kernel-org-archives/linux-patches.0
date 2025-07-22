Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F72288CA2;
	Tue, 22 Jul 2025 14:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193143; cv=none; b=phwiwdhy6uSl82HJoSneJLFxDPZkUHLb8xvq3l+ReuK+3h+jQabP5r+vNEr2AzFbhN+7eSjJo8RQcRawfCetxe5LApVPMrcESCAxAxG/h25gK6F7zCK2/NnoXuxYnCxm+dZOYS1FPsmKPJoMXSH0oWI/CPSg2Xk9yLg0DPF6B6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193143; c=relaxed/simple;
	bh=KVkvBNZQX0AV0m2FlVwks3XCSfWaoO+k+V2sOIlPLXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qccIEdZDboIm4fXQohxvaJT1tAGjioqLdD81MFITKBMpVRCIzAONaPozw4STr47As0FkVLuGwtTyqW8N15mQ5fWwNlcYurOuWQcnyaPKkO5AhIxqpcRmN9JwnUybe/VuGf5MFN+z4vThNL21qPqQsfeU220+2t4+qaYQt34aQOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v8QA55ln; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v8QA55ln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65FD8C4CEEB;
	Tue, 22 Jul 2025 14:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193142;
	bh=KVkvBNZQX0AV0m2FlVwks3XCSfWaoO+k+V2sOIlPLXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v8QA55ln9Tc+BjuUIkgdRoCANoNZCFceZWmpJ7/YlRBFMUJLhlnS1Di8bqPLDJLRP
	 OmuSmZ8Fax2Rz62lXXXCGDV7AipfiKlgcfFYgPiRJeHVfUNIqVkjWeu5xI2h9Et8Uj
	 yuuGd823i62zJQ58AMqTo9vj3ZQabEnvdVfVtF9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	"Orlando, Noah" <Noah.Orlando@deshaw.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 6.12 141/158] clone_private_mnt(): make sure that caller has CAP_SYS_ADMIN in the right userns
Date: Tue, 22 Jul 2025 15:45:25 +0200
Message-ID: <20250722134345.985934377@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2263,6 +2263,11 @@ struct vfsmount *clone_private_mount(con
 	if (!check_mnt(old_mnt))
 		goto invalid;
 
+	if (!ns_capable(old_mnt->mnt_ns->user_ns, CAP_SYS_ADMIN)) {
+		up_read(&namespace_sem);
+		return ERR_PTR(-EPERM);
+	}
+
 	if (has_locked_children(old_mnt, path->dentry))
 		goto invalid;
 



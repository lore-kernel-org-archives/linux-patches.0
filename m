Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC9128EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D442C433EF;
	Mon, 30 Jan 2023 14:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088231;
	bh=NpE4qk2r3b6JEYuQ0FQRJxbacoXtu3zARHZ14KdC/Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mlJ1rHl3dDOk9XjJPYCXqxjPfPwZsqs6OG65M+grUCy28yiFE1qAcngMfBtMiGhr6
	 RbIvJLAfkVeA4wUjVDmtfiIc6/xeRM5RfcisDpr43McFADxc2xPltkETuGnKes1Hv2
	 gZvWfNjUENylOkm/yanNOdon3tk+Qq4MtwI/Yo50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Seth Forshee <sforshee@kernel.org>
Subject: [PATCH 5.15 159/204] ovl: fail on invalid uid/gid mapping at copy up
Date: Mon, 30 Jan 2023 14:52:04 +0100
Message-Id: <20230130134323.540562837@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miklos Szeredi <mszeredi@redhat.com>

commit 4f11ada10d0ad3fd53e2bd67806351de63a4f9c3 upstream.

If st_uid/st_gid doesn't have a mapping in the mounter's user_ns, then
copy-up should fail, just like it would fail if the mounter task was doing
the copy using "cp -a".

There's a corner case where the "cp -a" would succeed but copy up fail: if
there's a mapping of the invalid uid/gid (65534 by default) in the user
namespace.  This is because stat(2) will return this value if the mapping
doesn't exist in the current user_ns and "cp -a" will in turn be able to
create a file with this uid/gid.

This behavior would be inconsistent with POSIX ACL's, which return -1 for
invalid uid/gid which result in a failed copy.

For consistency and simplicity fail the copy of the st_uid/st_gid are
invalid.

Fixes: 459c7c565ac3 ("ovl: unprivieged mounts")
Cc: <stable@vger.kernel.org> # v5.11
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Reviewed-by: Seth Forshee <sforshee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/copy_up.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -960,6 +960,10 @@ static int ovl_copy_up_one(struct dentry
 	if (err)
 		return err;
 
+	if (!kuid_has_mapping(current_user_ns(), ctx.stat.uid) ||
+	    !kgid_has_mapping(current_user_ns(), ctx.stat.gid))
+		return -EOVERFLOW;
+
 	ctx.metacopy = ovl_need_meta_copy_up(dentry, ctx.stat.mode, flags);
 
 	if (parent) {



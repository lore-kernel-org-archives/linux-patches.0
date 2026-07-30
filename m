Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBDD431E60;
	Thu, 30 Jul 2026 15:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426350; cv=none; b=fDWfVXBML5JdFD8tZqdedoazWXDKhOd0RYiehJ+fI+Y42iXc6wCSuv5+MZoJvzrz3aoX1xkzNSgkRbxBoKuTUMotCYe+OFCnAAssv3y2/of4TZDWsOT4Nwyximo+SmsemBJNl20mEA4oIVEkRdRrTdYX0sr7q6JCtQs1M8VrBpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426350; c=relaxed/simple;
	bh=oyFSO8uEfmEFPGupteQPiYzBwCoIyp7g9P9v7W3nIQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlOOUeP28BfMamgS5FOF+p/OZp6oWgrKOB7aJDwHaGbIH38K/GylXJeh4LwCz/qVcRDtKyIR8QpduujVwHBYxAJrfn2uEUjKMCtnmhhai/aEHAUKcRJsQlKVrZr5+wm9f2rs7kSurWzLFVslw5iCcZcL7v+4bYYDwgQAI8SPrgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/p3P9a4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/p3P9a4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BCA61F000E9;
	Thu, 30 Jul 2026 15:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426349;
	bh=a1ciDATdijDgu4zxGZhpYXIvYd9FJ1XbGNnJdy676WI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R/p3P9a4OmhRTPj5xjVJi3z9vme5xmGanN9Wd+XJym9Db6249biTztE6QwWVoloKs
	 jaGlIKi32M+dd32/iy2YObaiCtXMZeYuxHe0/xFjP/WLcxHgIXDrVxdICkjI3eOgBQ
	 XShZyw5SUhzMYvle8qwcPad9JD5dbBnpuvz/894s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Xiubo Li <xiubo.li@clyso.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.12 389/602] ceph: add owner/capability checks for CEPH_IOC_SET_LAYOUT*
Date: Thu, 30 Jul 2026 16:13:01 +0200
Message-ID: <20260730141444.131774875@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

commit cee38bbf5556a8e0a232ccae41649580827d7806 upstream.

These permission checks were already missing in the initial
impementation of these ioctls.  This Ceph allows any user who owns a
file descriptor to manipulate the layout of any file, even if they
don't have write permissions.

It might be a good idea to guard other ioctls with permission checks
as well or even disallow regular users (even if they own the file) to
manipulate layout settings completely, as this may be abused to DoS
the Ceph servers, but right now, I find it most urgent to have setter
checks at all.

Cc: stable@vger.kernel.org
Fixes: 8f4e91dee2a2 ("ceph: ioctls")
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Xiubo Li <xiubo.li@clyso.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/ioctl.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ceph/ioctl.c
+++ b/fs/ceph/ioctl.c
@@ -72,6 +72,9 @@ static long ceph_ioctl_set_layout(struct
 	struct ceph_ioctl_layout nl;
 	int err;
 
+	if (!inode_owner_or_capable(&nop_mnt_idmap, inode))
+		return -EACCES;
+
 	if (copy_from_user(&l, arg, sizeof(l)))
 		return -EFAULT;
 
@@ -142,6 +145,9 @@ static long ceph_ioctl_set_layout_policy
 	int err;
 	struct ceph_mds_client *mdsc = ceph_sb_to_fs_client(inode->i_sb)->mdsc;
 
+	if (!inode_owner_or_capable(&nop_mnt_idmap, inode))
+		return -EACCES;
+
 	/* copy and validate */
 	if (copy_from_user(&l, arg, sizeof(l)))
 		return -EFAULT;



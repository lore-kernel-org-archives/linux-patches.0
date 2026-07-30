Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991CA451989;
	Thu, 30 Jul 2026 15:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424896; cv=none; b=HdHGVJ1M1tSwLnbP3Qoy6g473aBfv5Hi7+CXOyACOIjUhmv92QvSX96DkVtE1yZvTh9D0CA+1bQHlB0lCELoh7kNFUOlO+h1SZuwoEmIuRqe8bb3iHCXgjr/l4XunAO4LpIn+bxVA/modEUNzagmUpwy1Y3HFxwbE2qV1e+2zuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424896; c=relaxed/simple;
	bh=rficcNlLefBbJl7ehxztEMARUL6zG/odpC3B/dD3skk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFsu+PpWiHeeC2JdXdpEBwBeyImMtF+qzEFY2W9IlDKe8mmeEUFXQp02XYtsAxfGdKd9TcIaxqhUfSiyX8VixZpmsf0ZBlqhy1YHHmlU2IUQzQy706Q3YJo+T6TdsrVeOgnI8WputTcjV+jUYXOsMHFsyZlwZaiKC5o/YdJ+cKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ip9K8FB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ip9K8FB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9B21F00A3A;
	Thu, 30 Jul 2026 15:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424894;
	bh=Spzr1gNapNsy6j2kdkerZFuiOkWWH3Hm8lKUVt3H19w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ip9K8FBZtvOCJ4ZSQ37Cv2yP+XZ0EbQ2DrwQHF7a6bMXBDEXW1i+rVPwuQkSW+Ys
	 dmZD/7Yg6ZAdFGtQJnmPH4HzYzUkqA/PGtxBIKSINnJ1acFq6vDXaO9Ucox46qqsgt
	 MdPvTJDAaVGuUipXiv5tgLZQODnrO7YiPYOo29qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Xiubo Li <xiubo.li@clyso.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.18 510/675] ceph: add owner/capability checks for CEPH_IOC_SET_LAYOUT*
Date: Thu, 30 Jul 2026 16:14:00 +0200
Message-ID: <20260730141455.967176535@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74063793A9;
	Thu, 30 Jul 2026 14:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422985; cv=none; b=NJ5PC0B6QH680qAZ4y9hCA8QZxriD5wOea1DFwkIbN0xben4KALXr+wAsTPL6pLF1vwxGiCfX9aWLIJXBdUWkcjXDHS55KBk5O5W7672miemsd/X6oYQjU/zNnEjfhDOSKZmEBHRUbDev2urwqIyur2sGQGLmH+MsP5DKYtpO7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422985; c=relaxed/simple;
	bh=yuleUqPlWas4aoV1+pvmFjpqp3k4ZmqkzAZYF7W0cuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFc2/kKV8pW1JhCvr2BAT9Sp899uhBCOlGZDnQUt33jI7TEgJ5bACK8KtA+Rgz2PjR6Jqz/jYscLEbv3BmkzyFgLqDfSdhrfF+tbCXGMf1rhioTCdwFyYZDD1ZjQsPDE9bTQvHATlYRltHjsLowxkxFp+GbhlZ4rLmXL78BCYLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ewRLO6tn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ewRLO6tn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6541F000E9;
	Thu, 30 Jul 2026 14:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422983;
	bh=t3CZysRs6yQEln8kdRCpTNKIJOhCVtp1Ph6KHHa66jY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ewRLO6tneVJejw4/t45eY0anBOk/yirrgSYu0/ibZJ9BfSV8TZXL96QoQ0GbhGON/
	 XLP3FqxehWnYSPWtFExOTeR2Id3yUhIlDojyN7lYN0mROhuWAtCZ4/Y++Xy3pr1kAQ
	 ESE7TIqApLqpcsJNI8Zkz3kkLTXHy7OxPgiIKNIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Xiubo Li <xiubo.li@clyso.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 7.1 625/744] ceph: add owner/capability checks for CEPH_IOC_SET_LAYOUT*
Date: Thu, 30 Jul 2026 16:14:58 +0200
Message-ID: <20260730141457.560203325@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D22A1494B3;
	Tue, 23 Apr 2024 21:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908663; cv=none; b=p444CVu0jcMhqb8KHO5OpyKeIcfM28ebXhgYhNkL6dkbxJW1PbQ052Y06YpsL9uC8dRfuwuJiWoDJhBSsPotS+Zigu+QuLVTdnr4wC8RQip+tquboQlYAlU/NXDNfM/w2cKE6jOdc3wznxvNCi3DConlyAMEvlnLgoVn0qBRT5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908663; c=relaxed/simple;
	bh=W/yhIfUc+d6gGlt2kHry4rFirmpCqcZypVD8jzwCiwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1i+W9GrUO0brr3Scxs4MBJdeQsLHllZtnYQIUfRjQHXS7w/EFZVBjkdyYME2McYkeWaKePA2BNyPftJDhG5EMzYDiSCny3eVkeYye1hTHvmPgWnKJnZ4b7CzLk4bp6LuLb3GuUf1LWIIRbFRGjLl+sJY/OSl1+pa1GWFItCxsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZ2Pe0F/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZ2Pe0F/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142A1C116B1;
	Tue, 23 Apr 2024 21:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908663;
	bh=W/yhIfUc+d6gGlt2kHry4rFirmpCqcZypVD8jzwCiwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OZ2Pe0F/ZQJX/+YdP3PRQxulGA2KSyNadXIc5OiR2EQRLorfxNgtFdya5ht4N+WrR
	 1hVJtnFUAXI0J/LllHails09GJWrZ6kS12/0puyAtdgvznWWQbMoRVkntuYXrJ6osV
	 XqpYUmVij/L2I+k8OjFWbdW43WudC2ByorNN7sj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marios Makassikis <mmakassikis@freebox.fr>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 156/158] ksmbd: clear RENAME_NOREPLACE before calling vfs_rename
Date: Tue, 23 Apr 2024 14:39:53 -0700
Message-ID: <20240423213900.729293413@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marios Makassikis <mmakassikis@freebox.fr>

commit 4973b04d3ea577db80c501c5f14e68ec69fe1794 upstream.

File overwrite case is explicitly handled, so it is not necessary to
pass RENAME_NOREPLACE to vfs_rename.

Clearing the flag fixes rename operations when the share is a ntfs-3g
mount. The latter uses an older version of fuse with no support for
flags in the ->rename op.

Cc: stable@vger.kernel.org
Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -745,10 +745,15 @@ retry:
 		goto out4;
 	}
 
+	/*
+	 * explicitly handle file overwrite case, for compatibility with
+	 * filesystems that may not support rename flags (e.g: fuse)
+	 */
 	if ((flags & RENAME_NOREPLACE) && d_is_positive(new_dentry)) {
 		err = -EEXIST;
 		goto out4;
 	}
+	flags &= ~(RENAME_NOREPLACE);
 
 	if (old_child == trap) {
 		err = -EINVAL;



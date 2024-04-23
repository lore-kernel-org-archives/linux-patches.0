Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFADC143897;
	Tue, 23 Apr 2024 21:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908554; cv=none; b=Wuqwt46nEhVtbnpFbjk9D+GSiBk3VEHOHe9vziRTumpAO4oIx1AQU+9hVLOIv9AXXI1j4/uknNfppTWDxDVxFAtzBYpEBTNY0Hv+K0jrL7Y9hXLL68y5x2qOI3+mT35q04NcEP+IZpfhFSsZ0UxHKwaiEM+XwU+ALxM86dmjbzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908554; c=relaxed/simple;
	bh=UvYABCm7qh5pHBzFDRYGz+iLma7lSaL0lJyRCdMSJBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZvqwntw8Gyw9Gy4iGKckm0ysn2hs7lCpvdwoYJ/+dPx4Jk49cCzu5y1wyRA7Mxemobmtw0ZJtQU4x27LKYa1EI8ZBZCVlN8QFKn8fc3AwFTmzxWlZ5nL+3Na7X0NwfCMeGW/LYonPbeEYfkaZF98GR0r8DnpFMsWUz3CuOefas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nT5QZ8O4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nT5QZ8O4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64C4C116B1;
	Tue, 23 Apr 2024 21:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908554;
	bh=UvYABCm7qh5pHBzFDRYGz+iLma7lSaL0lJyRCdMSJBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nT5QZ8O4rMMCkcSMDgvWo8KMyiFAGpYXaeK2nnSlpklqo7eTKjfLMh6d/+vOCAtDU
	 /krh/QPN9Y2Mw5r2I/Uy4npOdNgxnmC3D2QARTLPuqjYX77lLqEfJGjyH3VpuYfGjo
	 56mbZDz03BcI88EbbcOVUVMTN/cWuFUaO04/DYvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marios Makassikis <mmakassikis@freebox.fr>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.8 157/158] ksmbd: clear RENAME_NOREPLACE before calling vfs_rename
Date: Tue, 23 Apr 2024 14:39:39 -0700
Message-ID: <20240423213900.946875132@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -754,10 +754,15 @@ retry:
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



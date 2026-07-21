Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB52442107;
	Tue, 21 Jul 2026 21:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668024; cv=none; b=FrMBCx3aqP6jPzcwnFdUhCLC4SDc1mSR4W3i7cISOjvT9xajhvzU86yLjBG8sI/QJVasZ5JomTLXmbsD7PozJkfT2SsGYJikhX4HVg0iLTX3kksps31Dh5JOzrmQNYi2k28w416EJQ8Nms0AYk+vkALIufBmh0KZgUggts1Cq9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668024; c=relaxed/simple;
	bh=8AJ4NmVCQbpdGs6FpYK3DJMcvYI3N0qeTftY9S2Q6m0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hEkJxHM2c0BYhkY1UqbLm6PtGQ6PP0AamFBkji/UeZdPi92Z1KVuN8YJ2vxXcxVzFQQpNNiY+O0Oc6C/1garh12Wnt1BDFdCIGCUJsiGWZBTsyZmHOeDd0ytisTuOH9kJw4mMSw3HU/T5gmnAH3aJdNL/kOVvWqzX/2Ofc/JQSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCWc9c+h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCWc9c+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF70E1F000E9;
	Tue, 21 Jul 2026 21:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668023;
	bh=oLFWxN0rr/xJuxMo1AQDVkFMjL+NaGZDG5InUnwkmuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cCWc9c+hllhwD86Lg8X5SIWiuMeD5uRI17JXu9Z/Oom17anbMr4NT3TEmpJc+WWxX
	 kq0zzMdxUA0rc2tcFK0HL7p5Wkc5HnJwoScrsKk79xVA6qTkem6U7+z88N1gL4i1wy
	 vFk+Wm2w8YpWvsdgHtfu2+Vfwi0YMqYftF44bmus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Keshav Verma <iganschel@gmail.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0020/1067] f2fs: fix listxattr handling of corrupted xattr entries
Date: Tue, 21 Jul 2026 17:10:21 +0200
Message-ID: <20260721152424.985725622@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keshav Verma <iganschel@gmail.com>

[ Upstream commit 5ef5bc304f23c3fe255d4936472378dcb74d0e94 ]

Validate the xattr entry before reading its fields in f2fs_listxattr().
Return -EFSCORRUPTED when the entry is outside the valid xattr storage
area instead of returning a successful partial result.

Fixes: 688078e7f36c ("f2fs: fix to avoid memory leakage in f2fs_listxattr")
Cc: stable@kernel.org
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Keshav Verma <iganschel@gmail.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/xattr.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -576,8 +576,7 @@ ssize_t f2fs_listxattr(struct dentry *de
 	last_base_addr = (void *)base_addr + XATTR_SIZE(inode);
 
 	list_for_each_xattr(entry, base_addr) {
-		const struct xattr_handler *handler =
-			f2fs_xattr_handler(entry->e_name_index);
+		const struct xattr_handler *handler;
 		const char *prefix;
 		size_t prefix_len;
 		size_t size;
@@ -589,9 +588,11 @@ ssize_t f2fs_listxattr(struct dentry *de
 			set_sbi_flag(F2FS_I_SB(inode), SBI_NEED_FSCK);
 			f2fs_handle_error(F2FS_I_SB(inode),
 						ERROR_CORRUPTED_XATTR);
-			break;
+			error = -EFSCORRUPTED;
+			goto cleanup;
 		}
 
+		handler = f2fs_xattr_handler(entry->e_name_index);
 		if (!handler || (handler->list && !handler->list(dentry)))
 			continue;
 



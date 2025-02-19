Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84361D5CC6;
	Wed, 19 Feb 2025 09:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957584; cv=none; b=mjd5b4fP1xEE5JZkJQQU3Jn/eDb56qhAuC/02XBhb+veCKzCTjdo/KsAzXjLYYrTuPLAYA8OemRuK+6evG4R8J/6ZfV69pi5lwHyVgjlHn8OaV5HfF+2awOwOQxuEO1jO/IrveoVPuTwnbEu9eC1ND5Vg7i017+f1afCvRZsMgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957584; c=relaxed/simple;
	bh=RmJrRhkCmuvsL7lVnnciFEnYWd40QYgtdGne85d3HwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdz6jRGZZMg2qP1eULuv8lWftXVuu6XX/FgxwmL23X9Ov39Wi6QPw2hREU2gyLTkgHEaBsJZdzhkNmj4poMpzJ/cbdPX/qE2XJMIOw0mW8NB37+qF5Y+Yhd09EQOeOnQYiUp9DVZDcM/kHIRl2yDrBQh4g0aa45ji3+NjzV+0Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C+bPbrhc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C+bPbrhc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A12AC4CED1;
	Wed, 19 Feb 2025 09:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957583;
	bh=RmJrRhkCmuvsL7lVnnciFEnYWd40QYgtdGne85d3HwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C+bPbrhcEbuvg7dxP+Zlb+AGEfjDV5k8hIcatoHlPzPoVh9j3ClflsWRLOqmc0/2q
	 qoNvU1iInE05pzSjOUSpigD+JnIeXvbbX1qD3Oz0lD/+BqPaLKE+WwPUiS9xv7WyRn
	 ltKtUw0h9eLiz85xrqjZUXebZh72dFFrMDP9OjUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 6.1 576/578] f2fs: fix to wait dio completion
Date: Wed, 19 Feb 2025 09:29:40 +0100
Message-ID: <20250219082715.611198204@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit 96cfeb0389530ae32ade8a48ae3ae1ac3b6c009d upstream.

It should wait all existing dio write IOs before block removal,
otherwise, previous direct write IO may overwrite data in the
block which may be reused by other inode.

Cc: stable@vger.kernel.org
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1048,6 +1048,13 @@ int f2fs_setattr(struct user_namespace *
 				return err;
 		}
 
+		/*
+		 * wait for inflight dio, blocks should be removed after
+		 * IO completion.
+		 */
+		if (attr->ia_size < old_size)
+			inode_dio_wait(inode);
+
 		f2fs_down_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
 		filemap_invalidate_lock(inode->i_mapping);
 
@@ -1880,6 +1887,12 @@ static long f2fs_fallocate(struct file *
 	if (ret)
 		goto out;
 
+	/*
+	 * wait for inflight dio, blocks should be removed after IO
+	 * completion.
+	 */
+	inode_dio_wait(inode);
+
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		if (offset >= inode->i_size)
 			goto out;



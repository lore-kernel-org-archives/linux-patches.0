Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920227D09F;
	Mon,  8 Apr 2024 13:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583369; cv=none; b=O1h/2zi8bcp1m3L3Qvt9hBXLyM/t919qEJ1ej2uUUk6q1yB2ySqFFpVLMdKB4HLqDVRBl14Q2I5CXqx5zkjJl4E4bbru+CgUgXHgnPgPBnUNqGO6DVxQ/MQ2oEtXa42fip6S0NzMXxPuQSyzGq54xpFWki03+tDkG94yiLTBtuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583369; c=relaxed/simple;
	bh=Lt9tOrs5dX+S22wmpgYMl5ojbCp0wVJjR2TRHr575f4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BfI6lN81Ou75y0/vWOouv0Hj0vua96A6e+w3CuyNrf2qwbXo8dGkNj9m1Zhdo4WqgdWR0ql6ocVRfxMgEVweb+00XerYQQX23wfblHM5XgKr04n+9d7L/3vrGIBgfoqJENrGr6dfKxPAYyeJKG1YSOU5N5E7HOr/DnsZviGHyPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JvOd543d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JvOd543d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B89C433C7;
	Mon,  8 Apr 2024 13:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583369;
	bh=Lt9tOrs5dX+S22wmpgYMl5ojbCp0wVJjR2TRHr575f4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JvOd543dAEQUc4dTBMZXXDtQXRupTmxDs3oDqeqzOzh/ypprKNRfjJz5fzGrQHurU
	 AP6iJb04Yy67vjUdRrnB6vLDBDOc4ABS1rQH4aa0ezD3y+n0ljuDYunUjlZ3bAbrWk
	 L0sBEbflUoZVA0PM8k5FzwuaZfFLq6ToJUyeUySg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Theodore Tso <tytso@mit.edu>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 212/690] ext4: fix error code saved on super block during file system abort
Date: Mon,  8 Apr 2024 14:51:18 +0200
Message-ID: <20240408125407.217006926@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit 124e7c61deb27d758df5ec0521c36cf08d417f7a ]

ext4_abort will eventually call ext4_errno_to_code, which translates the
errno to an EXT4_ERR specific error.  This means that ext4_abort expects
an errno.  By using EXT4_ERR_ here, it gets misinterpreted (as an errno),
and ends up saving EXT4_ERR_EBUSY on the superblock during an abort,
which makes no sense.

ESHUTDOWN will get properly translated to EXT4_ERR_SHUTDOWN, so use that
instead.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Link: https://lore.kernel.org/r/20211026173302.84000-1-krisman@collabora.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f69e7bf52c578..8b276b95a7904 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5851,7 +5851,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	}
 
 	if (ext4_test_mount_flag(sb, EXT4_MF_FS_ABORTED))
-		ext4_abort(sb, EXT4_ERR_ESHUTDOWN, "Abort forced by user");
+		ext4_abort(sb, ESHUTDOWN, "Abort forced by user");
 
 	sb->s_flags = (sb->s_flags & ~SB_POSIXACL) |
 		(test_opt(sb, POSIX_ACL) ? SB_POSIXACL : 0);
-- 
2.43.0




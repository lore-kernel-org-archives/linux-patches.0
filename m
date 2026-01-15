Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3D42D73A0;
	Thu, 15 Jan 2026 17:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496649; cv=none; b=gApBc4PjV/+r8GfQsVVa66S0pE+DyOeTemHwXeU826EuXz/DSLNnbY1hU8HgFpGtV3qb9fOge2KakBJttUwgbbbOi+2YrIBv97fCDJkSmb/prLVp+pW38R8XKH4TMRpdc0NLWCfKd53RVqfMZE7I23bYhIWbx8cObTILV+CAB6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496649; c=relaxed/simple;
	bh=tMO5CeY4+ivEOgLC33PootKWf6rVPG5mFc+iR4CQEEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LVgGNxEHKEexoxSeOjmLAAY4+AGakzCvF21LI4Trg+rH5HRik9n9LmqFVFSldKyy5N2LJdERJJvPPkfE1vN+kB3ZU2+fghd/GwnBqwO3WFPf84QHEp32cKKHRYvqGS+ERUWS/q9PUkXAFnC598qti17GdtjOQGLrliChJYISpCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LUrSMntd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LUrSMntd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF4BC116D0;
	Thu, 15 Jan 2026 17:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496648;
	bh=tMO5CeY4+ivEOgLC33PootKWf6rVPG5mFc+iR4CQEEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LUrSMntd/JbyOwMYE704y3WECzTaMLlSmqlNfjzIhVQ0x1g2vYiZJw4hfm2LUmqi+
	 u4oxY17k79SfQmWrc4oZdElvW25qd4BfmoLHiUSEEJeexs+aYWn0pBD06P+oV3FCE+
	 F8lh8X4Mh38+JMGCMnJJulttSxxXvIDQwPln+oHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timoth=C3=A9e=20Ravier?= <tim@siosm.fr>,
	=?UTF-8?q?Aleks=C3=A9i=20Naid=C3=A9nov?= <an@digitaltide.io>,
	Amir Goldstein <amir73il@gmail.com>,
	Alexander Larsson <alexl@redhat.com>,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>,
	Dusty Mabe <dusty@dustymabe.com>,
	Sheng Yong <shengyong1@xiaomi.com>
Subject: [PATCH 6.12 086/119] erofs: dont bother with s_stack_depth increasing for now
Date: Thu, 15 Jan 2026 17:48:21 +0100
Message-ID: <20260115164155.054102193@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 072a7c7cdbea4f91df854ee2bb216256cd619f2a ]

Previously, commit d53cd891f0e4 ("erofs: limit the level of fs stacking
for file-backed mounts") bumped `s_stack_depth` by one to avoid kernel
stack overflow when stacking an unlimited number of EROFS on top of
each other.

This fix breaks composefs mounts, which need EROFS+ovl^2 sometimes
(and such setups are already used in production for quite a long time).

One way to fix this regression is to bump FILESYSTEM_MAX_STACK_DEPTH
from 2 to 3, but proving that this is safe in general is a high bar.

After a long discussion on GitHub issues [1] about possible solutions,
one conclusion is that there is no need to support nesting file-backed
EROFS mounts on stacked filesystems, because there is always the option
to use loopback devices as a fallback.

As a quick fix for the composefs regression for this cycle, instead of
bumping `s_stack_depth` for file backed EROFS mounts, we disallow
nesting file-backed EROFS over EROFS and over filesystems with
`s_stack_depth` > 0.

This works for all known file-backed mount use cases (composefs,
containerd, and Android APEX for some Android vendors), and the fix is
self-contained.

Essentially, we are allowing one extra unaccounted fs stacking level of
EROFS below stacking filesystems, but EROFS can only be used in the read
path (i.e. overlayfs lower layers), which typically has much lower stack
usage than the write path.

We can consider increasing FILESYSTEM_MAX_STACK_DEPTH later, after more
stack usage analysis or using alternative approaches, such as splitting
the `s_stack_depth` limitation according to different combinations of
stacking.

Fixes: d53cd891f0e4 ("erofs: limit the level of fs stacking for file-backed mounts")
Reported-and-tested-by: Dusty Mabe <dusty@dustymabe.com>
Reported-by: Timothée Ravier <tim@siosm.fr>
Closes: https://github.com/coreos/fedora-coreos-tracker/issues/2087 [1]
Reported-by: "Alekséi Naidénov" <an@digitaltide.io>
Closes: https://lore.kernel.org/r/CAFHtUiYv4+=+JP_-JjARWjo6OwcvBj1wtYN=z0QXwCpec9sXtg@mail.gmail.com
Acked-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Alexander Larsson <alexl@redhat.com>
Reviewed-and-tested-by: Sheng Yong <shengyong1@xiaomi.com>
Reviewed-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/super.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 027fd567a4d9f..f0b83beec6b24 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -641,14 +641,20 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 		 * fs contexts (including its own) due to self-controlled RO
 		 * accesses/contexts and no side-effect changes that need to
 		 * context save & restore so it can reuse the current thread
-		 * context.  However, it still needs to bump `s_stack_depth` to
-		 * avoid kernel stack overflow from nested filesystems.
+		 * context.
+		 * However, we still need to prevent kernel stack overflow due
+		 * to filesystem nesting: just ensure that s_stack_depth is 0
+		 * to disallow mounting EROFS on stacked filesystems.
+		 * Note: s_stack_depth is not incremented here for now, since
+		 * EROFS is the only fs supporting file-backed mounts for now.
+		 * It MUST change if another fs plans to support them, which
+		 * may also require adjusting FILESYSTEM_MAX_STACK_DEPTH.
 		 */
 		if (erofs_is_fileio_mode(sbi)) {
-			sb->s_stack_depth =
-				file_inode(sbi->dif0.file)->i_sb->s_stack_depth + 1;
-			if (sb->s_stack_depth > FILESYSTEM_MAX_STACK_DEPTH) {
-				erofs_err(sb, "maximum fs stacking depth exceeded");
+			inode = file_inode(sbi->dif0.file);
+			if ((inode->i_sb->s_op == &erofs_sops && !sb->s_bdev) ||
+			    inode->i_sb->s_stack_depth) {
+				erofs_err(sb, "file-backed mounts cannot be applied to stacked fses");
 				return -ENOTBLK;
 			}
 		}
-- 
2.51.0




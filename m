Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B4436C9CD
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302243; cv=none; b=SOgyiJRuGTOBZlRyAs/trOv9pmMR/5rOIkHhJ1nurxyD0Md0Tx3PXAMrzJ0Z5a+Jq7JtdSqTYHPla85tZB5xylFNtS244KpNOjHomFXDjHuFyNCjIU0LquYSm+oM6DkfH0RcIroBX1qc/d4Dey5JNf5r+icmwDof5XuVPKPXoDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302243; c=relaxed/simple;
	bh=3Stt41bL6mx5bfmLD/cy3DpdMkI0cquujZCtb1fc9xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2ArUEllA08h9qYHAqJr7/fY3JfZTH2HzyJzfr98AUm5Y8SdpKsvc8N4KcwQJMrpW2uPGH3voGDR3ed8U7zKbeu0SJIMOACeG2tFE01MEYF59ysr4gca/I+0q7hzDqcz183QU9P8tsbBTolx1vLJaojwDp3i68v7B7UeakrhkVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZlCNpuaK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZlCNpuaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7207EC116D0;
	Sat, 28 Feb 2026 18:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302243;
	bh=3Stt41bL6mx5bfmLD/cy3DpdMkI0cquujZCtb1fc9xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZlCNpuaK/aiahnLcbnhoyXOlHYCJQBugmesQyFiWc5AbaK7BdrGC9d81NSR8tkSE7
	 T7Z1ujKTdBD4uw7m2KTVSM7kiQvzJ9ILEsuyS0pvRh3UryFsr+jfzOPSEgX0iz17Kd
	 +QRabU4+IOudTUGgRubmJ8DynYylnbekHq2r9W2jABUKA56F5CbO+X1OfdTq4riXYp
	 E2ykclIe4c/RN3JnOu3BSc3CmiilbZ5cv4GoWyg86ywtgB+n/fLiw/8yy8XufDdeVa
	 /mC5spvdGxs4MjpIe3/zHeaejKmyzBxjgrYssSNMQarvd5K6sr9g0hsaZ8Pwp6wIXS
	 xABxFMA6A/BYA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Edward Adam Davis <eadavis@qq.com>,
	syzbot+bcf9e1868c1a0c7e04f1@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 255/283] fs/ntfs3: prevent infinite loops caused by the next valid being the same
Date: Sat, 28 Feb 2026 13:06:37 -0500
Message-ID: <20260228180709.1583486-255-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 27b75ca4e51e3e4554dc85dbf1a0246c66106fd3 ]

When processing valid within the range [valid : pos), if valid cannot
be retrieved correctly, for example, if the retrieved valid value is
always the same, this can trigger a potential infinite loop, similar
to the hung problem reported by syzbot [1].

Adding a check for the valid value within the loop body, and terminating
the loop and returning -EINVAL if the value is the same as the current
value, can prevent this.

[1]
INFO: task syz.4.21:6056 blocked for more than 143 seconds.
Call Trace:
 rwbase_write_lock+0x14f/0x750 kernel/locking/rwbase_rt.c:244
 inode_lock include/linux/fs.h:1027 [inline]
 ntfs_file_write_iter+0xe6/0x870 fs/ntfs3/file.c:1284

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Reported-by: syzbot+bcf9e1868c1a0c7e04f1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bcf9e1868c1a0c7e04f1
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index a7fe2e02c32ee..212737a816d7a 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -901,8 +901,12 @@ static ssize_t ntfs_compress_write(struct kiocb *iocb, struct iov_iter *from)
 			goto out;
 
 		if (lcn == SPARSE_LCN) {
-			ni->i_valid = valid =
-				frame_vbo + ((u64)clen << sbi->cluster_bits);
+			valid = frame_vbo + ((u64)clen << sbi->cluster_bits);
+			if (ni->i_valid == valid) {
+				err = -EINVAL;
+				goto out;
+			}
+			ni->i_valid = valid;
 			continue;
 		}
 
-- 
2.51.0


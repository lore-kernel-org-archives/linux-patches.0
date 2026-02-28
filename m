Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33B3348895
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302632; cv=none; b=OaeygPFOOenDBcBST1QOy8h7riPZqrnqhubIuE8YNlsv5lgRj8hJSdZ4fIu3WS79RdkaaKGG4pidx6dtsODlfuvh6TYPrKReHKqM2Bnm+ADpkwNhdZpq4he8pxrKRS78pE7QuUsnDBFnAqeocvmJy+BPyYp5yfH66Z6Y0lBQxLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302632; c=relaxed/simple;
	bh=jxIhhfuDWAA+WmskhCtP6WCnDpQmGiy5i4f+jCh3FE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uG3o79AV6YPFxg5ZSO+O3/HFpyr+Pjx7wUx23GtvN0QF6qKfST4+rqElChG+fd529wzBra1qsu0gg4caqru1Vn0XPd2dojBncTAFni8s29WGMFSyag9itcVnuH8kjdK6RsGc9IzlOjcp6VYH0VyErqlusZcMdB/xRCXGGDmw0hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XvyfcStI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XvyfcStI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E434C2BC87;
	Sat, 28 Feb 2026 18:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302632;
	bh=jxIhhfuDWAA+WmskhCtP6WCnDpQmGiy5i4f+jCh3FE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvyfcStIub8JNOEkXmY13Fcd0rNqoIIEql2hzpVHiCF7NBYIlNws/Rf8AgH1WXvPh
	 4DFZ9EL8J0hFVTj/8maKnxe/a7zL1E5gEDcfK1Gyj+5KBbOe8lLgzfQxUedDNShHOK
	 vNCUGv2kObaxzkGjn32kDIpBEQvFqWjr3VPEhuCfT+GOmvIwhx/idKoeCWUFJwduOM
	 hoqFizM/+YiOt3HY0jjyLi0aoGj4R4XY4fhjKjzF8viyQbBJzoXB12/HV51S9/W1/c
	 FCuo3lVYvE57461aWae7Orr4a7c0D1YzDrxMGZzszAmnHUITzs3sP4YMRyEX76RgFO
	 Y63UlODesdqyA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Edward Adam Davis <eadavis@qq.com>,
	syzbot+bcf9e1868c1a0c7e04f1@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 152/164] fs/ntfs3: prevent infinite loops caused by the next valid being the same
Date: Sat, 28 Feb 2026 13:14:51 -0500
Message-ID: <20260228181505.1600663-152-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index ffb31420085f4..25788df25deeb 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -932,8 +932,12 @@ static ssize_t ntfs_compress_write(struct kiocb *iocb, struct iov_iter *from)
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


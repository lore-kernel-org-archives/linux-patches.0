Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2868C258ED5;
	Wed, 25 Feb 2026 01:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983572; cv=none; b=syLPI2s1KRSPGWLl5WFqCoMKkgSHZ7x9HJuDzqi46sNXBNDGVGbu1C/qVq4L6iWEc6NnuzrBGTaoMDnvbK1dvf4ng0zZWQx12uKgZqzo79h91u7ZVKcQzkiYd0HCXaId8W8Z8KFchFu4DJx2aCA5vnpeXkTDLqdSNmWyKULpgLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983572; c=relaxed/simple;
	bh=eATotnli9qFImWOVaoYMFR4/ges2PgmP8XjWzAsym/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcnDGfmwo1YrEOokmql+ZHCvFZcYzUCBuxlSHwnNG/cRzJve/fu7cGHV+BaovuLKTa2xVGGrXFbQnxjz9RtXXSP8dvIuQfbh5XAZ4nbmILgOZHocnxmRgqjGfz48I1Epr+zRLlYMgk5fcfTPMtuSCVqZUoQatrl2mJpc+VJpRk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0n9f0hlc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0n9f0hlc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C2FC116D0;
	Wed, 25 Feb 2026 01:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983572;
	bh=eATotnli9qFImWOVaoYMFR4/ges2PgmP8XjWzAsym/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0n9f0hlcs8MpAqGVWQ9mQprkSI96MFpuco3SdgVDkKMwVfzp6JIKGiO4YrWwcnW4Y
	 uwP1pWKGnz3fzV4b7LxDFhW4ls/VlgsYO8qyi8sLRy6iXY0xOzOHLCGOpfnATH/nas
	 Zka6eWiYoeHKfv/Rr0W0pNmF4rgQGde8cIzy8wlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bcf9e1868c1a0c7e04f1@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 619/781] fs/ntfs3: prevent infinite loops caused by the next valid being the same
Date: Tue, 24 Feb 2026 17:22:08 -0800
Message-ID: <20260225012414.989058046@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 732260087066d..5120bd7851694 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -1077,8 +1077,12 @@ static ssize_t ntfs_compress_write(struct kiocb *iocb, struct iov_iter *from)
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




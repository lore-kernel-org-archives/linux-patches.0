Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4393B1034;
	Tue, 21 Jul 2026 20:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665933; cv=none; b=iCjc3gEQAXxFT/r5rhwqgVK3z7e8ZRx0dVsOxshWzI8lcYZlP9ArUDkAP9dxEK+UwIuPI+26+hoU+4NggRCkS5C2ZTtWDSyxvEbRzdas5SNzk+Al6wyUKBpBnG+g6iCnmdr6NB1/hOBhJm+xiZY+wTulzVqD984MNupe7JfraMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665933; c=relaxed/simple;
	bh=bM1rUaPcXXlfDPyqIcfIa6RrjTMppP+vTbldq1U5oCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxdkKtiNR1g3XqRwfuCMNLs1Bzojwy1AP5u/Q5Bqj0n9BB8Z+qFNZLv2QAyMMwB9TRDIZjyyrasPl3iXSzzlXHCSNhvu4CspFaQ7pFx86RvLUM5Xl+4OOW9J+DmNP8ZlfXo/UnmMADIDcW6OWVphCo5uFQivdH4UT8peRkgg34Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ToL/+aWb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ToL/+aWb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81D81F00A3D;
	Tue, 21 Jul 2026 20:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665932;
	bh=8FVF/u435fNrkikoUyWcTL0kKJniaHdqEUT6i8d23Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ToL/+aWb0ErG3MMnCSzxywrEYsN3+oNJmQpzA/8cKtmITYxzQv6mZwllRa5WHb2bC
	 7gRjq/yVMOz4/b54iSDtnuh+2ZYhY/l3OCodokyx0HvjNnNIOvgrLMIFp9IcaUmhkh
	 I+DTvO3taHKovbmK5m0ukA8sHUyl/dPY/R1fasc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Cen <rollkingzzc@gmail.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0490/1266] ocfs2: reject FITRIM ranges shorter than a cluster
Date: Tue, 21 Jul 2026 17:15:27 +0200
Message-ID: <20260721152452.808367184@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Cen <rollkingzzc@gmail.com>

[ Upstream commit ca1afd88f5eaaff9168e1466e5401385edf59543 ]

ocfs2_trim_mainbm() trims the global bitmap in cluster units, but its
too-short range validation only checks sb->s_blocksize.

On filesystems with a cluster size larger than the block size, a FITRIM
range that is at least one block but shorter than one cluster is accepted
and shifted down to len == 0.  The later start + len - 1 and len -= ...
arithmetic then underflows and can drive trimming past the requested
range.

Reject ranges shorter than s_clustersize instead.  That preserves the
existing -EINVAL behavior for requests that cannot discard even one
allocation unit and keeps zero-cluster trims out of the group walk.

Link: https://lore.kernel.org/20260528151247.361854-1-rollkingzzc@gmail.com
Fixes: aa89762c5480 ("ocfs2: return EINVAL if the given range to discard is less than block size")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index af40f0da3a95ca..bcdd9f25b2f509 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -7546,7 +7546,7 @@ int ocfs2_trim_mainbm(struct super_block *sb, struct fstrim_range *range)
 	len = range->len >> osb->s_clustersize_bits;
 	minlen = range->minlen >> osb->s_clustersize_bits;
 
-	if (minlen >= osb->bitmap_cpg || range->len < sb->s_blocksize)
+	if (minlen >= osb->bitmap_cpg || range->len < osb->s_clustersize)
 		return -EINVAL;
 
 	trace_ocfs2_trim_mainbm(start, len, minlen);
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5668144AB7B;
	Tue, 21 Jul 2026 22:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671578; cv=none; b=s5yHrmsHz23zw2FJTivO6UnGuFLvWrpoQQxIC1SpVjHzr78AU7KVGiQ5ET38PUffX4zPhmbiHcd80TOQAuL3Km+yvYLB9aV2wITnoKVUH3X4Xx+DfsCnVD2bCq83vQRwn3fSNNrwhwPJP7P+CJZJaf7tXZPajv6XQ/gnUM1sJ8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671578; c=relaxed/simple;
	bh=iCw02Hdt04+1LQZXunJDhXu/G6VPRpZI55oaJBFr4hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYepiFlRdhDbAwCeXN1wRCyJGQYu63a+0AoYDS1vqXf1Tabd5nmfZ54bAtU/cTzuOP0ftJHp3Vnfi959xctDRfI21PBAhNQKoIJA0WcFc0K880m9CRxbMHRUIWRouKjAVZAladChZqXeIOWLcDtT7giamA2M5wr4dNzvxhoKn70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xW/zTDG9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xW/zTDG9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D411F000E9;
	Tue, 21 Jul 2026 22:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671577;
	bh=DdW81/ja2dJmSeT/WZPIMS7RQQm5UewByCkTcfH7foM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xW/zTDG9SLpA3hMMA8uhaET6vQkfuZutFxIyxz3VAQ1D1+VpfbJ2Nd5eyqjknnCPP
	 OlfrKYJigroUoanJdFe860BcF3/lI5qTiI6WUfNUSNz+DJnI0esvbJThK3V/hoZ/o0
	 2zT1O2DAewElWRy15B1IN0xec04JEJ1MledJAaBI=
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
Subject: [PATCH 5.15 298/843] ocfs2: reject FITRIM ranges shorter than a cluster
Date: Tue, 21 Jul 2026 17:18:53 +0200
Message-ID: <20260721152412.733650311@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 79e308fb9ea094..9132e8594db323 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -7539,7 +7539,7 @@ int ocfs2_trim_mainbm(struct super_block *sb, struct fstrim_range *range)
 	len = range->len >> osb->s_clustersize_bits;
 	minlen = range->minlen >> osb->s_clustersize_bits;
 
-	if (minlen >= osb->bitmap_cpg || range->len < sb->s_blocksize)
+	if (minlen >= osb->bitmap_cpg || range->len < osb->s_clustersize)
 		return -EINVAL;
 
 	trace_ocfs2_trim_mainbm(start, len, minlen);
-- 
2.53.0




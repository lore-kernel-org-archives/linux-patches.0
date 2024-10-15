Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4511EBFE4;
	Tue, 15 Oct 2024 11:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992092; cv=none; b=cdn+6xM5wjN+yUb38GLIJRSKthAo7Etn5Zk+FsoP4HcbR6hY59UCldGaMuNT4zPRTzJhaJ0h6UgQFPlhlv2k0fdJzr66lZsf4FTV4RJ427z09zdjfGvoA5IYS8ZRIN7mnBk6ssoe32AT6IE1gTMGqwDjLkua4llDb+Ae8tQYUrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992092; c=relaxed/simple;
	bh=eiUUEcpVjgixv55bL63Ld/vrIMrOfg0kkHa0q4OwvAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZVhQ1tLS88yM/cqHq4/SsznSukeP76ghNqSo6BnLQEPOIZGy7VGolA3tsqtTpuxHfWWtc5jk9xFx9z4eErTBr9xVZB2pOFEUJbtGBwboTOdaZbVqPDFvt1eBoeGwkTqxpCY87jkHmJ53uH4/6/k2ank/MT9BhevA+3S6lnhtvOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tZcjeOji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tZcjeOji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7839DC4CEC6;
	Tue, 15 Oct 2024 11:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992091;
	bh=eiUUEcpVjgixv55bL63Ld/vrIMrOfg0kkHa0q4OwvAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tZcjeOjimIe37yI6WD9btMACAQeI1gEP3gILH+Tl4f4yGinygvg62UfACmkA8nbLg
	 lnqWAYysQtdLesSbzGzialXQv0dGkcA0ajdnifuGhFSydSZUdAfImqwXaWYp6zwRBN
	 G2OKuzt4YuygxU9SjqMnquyDhWvSYf6PVL65Vcyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heming Zhao <heming.zhao@suse.com>,
	Su Yue <glass.su@suse.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Gang He <ghe@suse.com>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 008/691] ocfs2: fix the la space leak when unmounting an ocfs2 volume
Date: Tue, 15 Oct 2024 13:19:16 +0200
Message-ID: <20241015112440.660761453@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Heming Zhao <heming.zhao@suse.com>

commit dfe6c5692fb525e5e90cefe306ee0dffae13d35f upstream.

This bug has existed since the initial OCFS2 code.  The code logic in
ocfs2_sync_local_to_main() is wrong, as it ignores the last contiguous
free bits, which causes an OCFS2 volume to lose the last free clusters of
LA window on each umount command.

Link: https://lkml.kernel.org/r/20240719114310.14245-1-heming.zhao@suse.com
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Su Yue <glass.su@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/localalloc.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -1008,6 +1008,25 @@ static int ocfs2_sync_local_to_main(stru
 		start = bit_off + 1;
 	}
 
+	/* clear the contiguous bits until the end boundary */
+	if (count) {
+		blkno = la_start_blk +
+			ocfs2_clusters_to_blocks(osb->sb,
+					start - count);
+
+		trace_ocfs2_sync_local_to_main_free(
+				count, start - count,
+				(unsigned long long)la_start_blk,
+				(unsigned long long)blkno);
+
+		status = ocfs2_release_clusters(handle,
+				main_bm_inode,
+				main_bm_bh, blkno,
+				count);
+		if (status < 0)
+			mlog_errno(status);
+	}
+
 bail:
 	if (status)
 		mlog_errno(status);



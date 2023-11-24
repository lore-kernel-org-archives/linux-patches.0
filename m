Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF443307D;
	Fri, 24 Nov 2023 19:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxVXIMkG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C1AC433C7;
	Fri, 24 Nov 2023 19:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853325;
	bh=I+leSNNWDLI+bXiGBPmZ/plfV555qq92dowCz8tH+ZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wxVXIMkGhi8NOw3Rdjwu2XnWiIav3I64RJUezh8XLYYB5kivQ0FqZGMK+h4u5bswf
	 1Nx8jXQqWknesWDFLaGdpGI/lgq57g+T4DE2463DLPYCjK9QmsPuWLm0VUVkVgLV1S
	 K1qCcx5R8yEf67GezIN/SuALVdhcWiPz7+ijknbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 144/297] xfs: flush inode gc workqueue before clearing agi bucket
Date: Fri, 24 Nov 2023 17:53:06 +0000
Message-ID: <20231124172005.310441523@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 04a98a036cf8b810dda172a9dcfcbd783bf63655 ]

In the procedure of recover AGI unlinked lists, if something bad
happenes on one of the unlinked inode in the bucket list, we would call
xlog_recover_clear_agi_bucket() to clear the whole unlinked bucket list,
not the unlinked inodes after the bad one. If we have already added some
inodes to the gc workqueue before the bad inode in the list, we could
get below error when freeing those inodes, and finaly fail to complete
the log recover procedure.

 XFS (ram0): Internal error xfs_iunlink_remove at line 2456 of file
 fs/xfs/xfs_inode.c.  Caller xfs_ifree+0xb0/0x360 [xfs]

The problem is xlog_recover_clear_agi_bucket() clear the bucket list, so
the gc worker fail to check the agino in xfs_verify_agino(). Fix this by
flush workqueue before clearing the bucket.

Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_log_recover.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index aeb01d4c0423b..04961ebf16ea2 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2739,6 +2739,7 @@ xlog_recover_process_one_iunlink(
 	 * Call xlog_recover_clear_agi_bucket() to perform a transaction to
 	 * clear the inode pointer in the bucket.
 	 */
+	xfs_inodegc_flush(mp);
 	xlog_recover_clear_agi_bucket(mp, agno, bucket);
 	return NULLAGINO;
 }
-- 
2.42.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B6763B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1265BC433D2;
	Mon, 20 Feb 2023 13:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900978;
	bh=Wkq2vTW9ymiTqNYKWd/cIQkA2F9lQe7FdlDLjReXCmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HGgF3L+iUCH/npqK+lL/Fnsl5YBK4uFjB4s3wPLj/IQTl3Oh/U1rxGVgo6COUHcJt
	 8qgJB/45ypFJwWkZW03Owha08wSjxE5cuy6w//A+CjQLyR13izhB+NF9HZLkNrcqc3
	 ZdWqGVNMGIzwQACX2S4r5zFwN4P3Y5XYlvgNn5+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Scott <nathans@redhat.com>,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Brian Foster <bfoster@redhat.com>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 111/156] xfs: fix finobt btree block recovery ordering
Date: Mon, 20 Feb 2023 14:35:55 +0100
Message-Id: <20230220133607.166313288@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

commit 671459676ab0e1d371c8d6b184ad1faa05b6941e upstream.

[ In 5.4.y, xlog_recover_get_buf_lsn() is defined inside
  fs/xfs/xfs_log_recover.c ]

Nathan popped up on #xfs and pointed out that we fail to handle
finobt btree blocks in xlog_recover_get_buf_lsn(). This means they
always fall through the entire magic number matching code to "recover
immediately". Whilst most of the time this is the correct behaviour,
occasionally it will be incorrect and could potentially overwrite
more recent metadata because we don't check the LSN in the on disk
metadata at all.

This bug has been present since the finobt was first introduced, and
is a potential cause of the occasional xfs_iget_check_free_state()
failures we see that indicate that the inode btree state does not
match the on disk inode state.

Fixes: aafc3c246529 ("xfs: support the XFS_BTNUM_FINOBT free inode btree type")
Reported-by: Nathan Scott <nathans@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_log_recover.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2206,6 +2206,8 @@ xlog_recover_get_buf_lsn(
 	case XFS_ABTC_MAGIC:
 	case XFS_RMAP_CRC_MAGIC:
 	case XFS_REFC_CRC_MAGIC:
+	case XFS_FIBT_CRC_MAGIC:
+	case XFS_FIBT_MAGIC:
 	case XFS_IBT_CRC_MAGIC:
 	case XFS_IBT_MAGIC: {
 		struct xfs_btree_block *btb = blk;



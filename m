Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74B82566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C440C433EF;
	Tue, 18 Apr 2023 12:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821095;
	bh=dPdHkVAiarSeIk5b18CdbCAPSB++eKPQoDba17Za3RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WIklpMgq561NyXH7gDfVoUi/fOQfj+S8rMPCiUQ2sua0pHDYBAvmg/O35sKg4WCsr
	 J9LYsBqx/XhC4EGEluOcEAfB0zkOD40UkisD6ykTy5iHU25yeJXvIYFRByo+R1KDR+
	 SYJURWxIsX0YtYPjAKx9AKlPxVCuFn3opm31WoLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 89/92] xfs: shut down the filesystem if we screw up quota reservation
Date: Tue, 18 Apr 2023 14:22:04 +0200
Message-Id: <20230418120307.901727472@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

commit 2a4bdfa8558ca2904dc17b83497dc82aa7fc05e9 upstream.

If we ever screw up the quota reservations enough to trip the
assertions, something's wrong with the quota code.  Shut down the
filesystem when this happens, because this is corruption.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_trans_dquot.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -15,6 +15,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_quota.h"
 #include "xfs_qm.h"
+#include "xfs_error.h"
 
 STATIC void	xfs_trans_alloc_dqinfo(xfs_trans_t *);
 
@@ -700,9 +701,14 @@ xfs_trans_dqresv(
 					    XFS_TRANS_DQ_RES_INOS,
 					    ninos);
 	}
-	ASSERT(dqp->q_res_bcount >= be64_to_cpu(dqp->q_core.d_bcount));
-	ASSERT(dqp->q_res_rtbcount >= be64_to_cpu(dqp->q_core.d_rtbcount));
-	ASSERT(dqp->q_res_icount >= be64_to_cpu(dqp->q_core.d_icount));
+
+	if (XFS_IS_CORRUPT(mp,
+		dqp->q_res_bcount < be64_to_cpu(dqp->q_core.d_bcount)) ||
+	    XFS_IS_CORRUPT(mp,
+		dqp->q_res_rtbcount < be64_to_cpu(dqp->q_core.d_rtbcount)) ||
+	    XFS_IS_CORRUPT(mp,
+		dqp->q_res_icount < be64_to_cpu(dqp->q_core.d_icount)))
+		goto error_corrupt;
 
 	xfs_dqunlock(dqp);
 	return 0;
@@ -712,6 +718,10 @@ error_return:
 	if (flags & XFS_QMOPT_ENOSPC)
 		return -ENOSPC;
 	return -EDQUOT;
+error_corrupt:
+	xfs_dqunlock(dqp);
+	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+	return -EFSCORRUPTED;
 }
 
 



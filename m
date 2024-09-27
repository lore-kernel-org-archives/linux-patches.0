Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCA53C3C;
	Fri, 27 Sep 2024 12:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440342; cv=none; b=lLU6PcFMggfErYi0nzhng3VajtpbO9BbC734P9AcSrLGpJ+/XvmZ1GgSbCCv9qWlIV0anE06y9J6iw4KhIZnvjAiH8fd0iDtd/WnJ3oHrsG2r2bL+XXoeQKZBQ6hyVi+It0vLDrKvxceQSOOFLTGpv2RVscJ94klrNwJssWOm+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440342; c=relaxed/simple;
	bh=QGyVEhJmVC+LhSc+fHbYvM8LCp0jrpScE2GKG+XlWo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOUl4ky/M1MvdTCOLzxe5pu/5OBB4NX77JoA+x3Zd/EpGpU10gvvPQbscau47qbPoihF5ZdYgkn5c8gVfgG9YKCtECgB5Ic3e8U7V8sYvnsqJo0u4mRPpdnbCIeETROgNxULyk7MCihCCebmfTy62yuG+4AVBRLtY+eVoSaB/8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=10vcQqSp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="10vcQqSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5A1C4CEC4;
	Fri, 27 Sep 2024 12:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440342;
	bh=QGyVEhJmVC+LhSc+fHbYvM8LCp0jrpScE2GKG+XlWo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=10vcQqSpLLyXVBvHG6YM4ey7Ezd239x9hC6nQLRtdE38w3DxtFZnPMOfbsLgo8aVe
	 cpX26ZJQjcl+mHixszCHJ+k0C8JXAxFSnm9937Oax4jIqHsQ6sNoZmQ3fjYdwBdbwB
	 7DN0O1NaJFn5boPanPSDbMQXsO/sdZuEANL/ntvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 48/73] xfs: fix the calculation for "end" and "length"
Date: Fri, 27 Sep 2024 14:23:59 +0200
Message-ID: <20240927121721.856647329@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiyang Ruan <ruansy.fnst@fujitsu.com>

[ Upstream commit 5cf32f63b0f4c520460c1a5dd915dc4f09085f29 ]

The value of "end" should be "start + length - 1".

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_notify_failure.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -114,7 +114,8 @@ xfs_dax_notify_ddev_failure(
 	int			error = 0;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, daddr);
 	xfs_agnumber_t		agno = XFS_FSB_TO_AGNO(mp, fsbno);
-	xfs_fsblock_t		end_fsbno = XFS_DADDR_TO_FSB(mp, daddr + bblen);
+	xfs_fsblock_t		end_fsbno = XFS_DADDR_TO_FSB(mp,
+							     daddr + bblen - 1);
 	xfs_agnumber_t		end_agno = XFS_FSB_TO_AGNO(mp, end_fsbno);
 
 	error = xfs_trans_alloc_empty(mp, &tp);
@@ -210,7 +211,7 @@ xfs_dax_notify_failure(
 	ddev_end = ddev_start + bdev_nr_bytes(mp->m_ddev_targp->bt_bdev) - 1;
 
 	/* Ignore the range out of filesystem area */
-	if (offset + len < ddev_start)
+	if (offset + len - 1 < ddev_start)
 		return -ENXIO;
 	if (offset > ddev_end)
 		return -ENXIO;
@@ -222,8 +223,8 @@ xfs_dax_notify_failure(
 		len -= ddev_start - offset;
 		offset = 0;
 	}
-	if (offset + len > ddev_end)
-		len -= ddev_end - offset;
+	if (offset + len - 1 > ddev_end)
+		len = ddev_end - offset + 1;
 
 	return xfs_dax_notify_ddev_failure(mp, BTOBB(offset), BTOBB(len),
 			mf_flags);



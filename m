Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4206814A60C;
	Thu, 23 May 2024 13:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470429; cv=none; b=sCLldyQbIm6eolOQ789e4yKdLacprkWvsSStUCFjcOsSLuCjPvb9AuPxxcsFXbLNl/YvxG19VwycjY+YEqd6neBa4BMPqurRxx9IPeo/To+6bx4TIsdenFowqiHzgS1aS68AOtS4XGXZFTGl01BPpYbeQry60LRYMhBQNdmnscU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470429; c=relaxed/simple;
	bh=d+2Ncqa0GCsY94kPOLrqwI2LwNdiht8lslipLl8h7qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQ5JO+6G6fhUrtlFsG5OVdb0M96hemBDo3ME5hnyRRC4aNBPlbuG2E4z2f27fXAjzJxZg+4OI+LXxRVFy9/+sp0odNPnF2YcLGaaYh07SWcncG4I4ANTakVVJiSVDT835e3EKEInTbFuh+ku2GdUuMMy6v3gD9SEGQNyIFIIKpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NQhshYju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NQhshYju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97F3C2BD10;
	Thu, 23 May 2024 13:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470429;
	bh=d+2Ncqa0GCsY94kPOLrqwI2LwNdiht8lslipLl8h7qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NQhshYjutei16lti3jMjLwmBrN3/gEzfk0u7XUnkn6foNC0Hyy8m3rg1A6P0Eante
	 CwesmLkHyyyLk2yiA/Uy3/M+5wIT0gJFZnnr8f1Q9gjuMfb8NqcIpXaDroHqPTOVxI
	 dX01HMs0cloptrW21aUqTDhVQOzwvcjrh2h4+3X0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hironori Shiina <shiina.hironori@fujitsu.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 32/45] xfs: get root inode correctly at bulkstat
Date: Thu, 23 May 2024 15:13:23 +0200
Message-ID: <20240523130333.708698382@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
References: <20240523130332.496202557@linuxfoundation.org>
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

From: Hironori Shiina <shiina.hironori@gmail.com>

[ Upstream commit 817644fa4525258992f17fecf4f1d6cdd2e1b731 ]

The root inode number should be set to `breq->startino` for getting stat
information of the root when XFS_BULK_IREQ_SPECIAL_ROOT is used.
Otherwise, the inode search is started from 1
(XFS_BULK_IREQ_SPECIAL_ROOT) and the inode with the lowest number in a
filesystem is returned.

Fixes: bf3cb3944792 ("xfs: allow single bulkstat of special inodes")
Signed-off-by: Hironori Shiina <shiina.hironori@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -754,7 +754,7 @@ xfs_bulkstat_fmt(
 static int
 xfs_bulk_ireq_setup(
 	struct xfs_mount	*mp,
-	struct xfs_bulk_ireq	*hdr,
+	const struct xfs_bulk_ireq *hdr,
 	struct xfs_ibulk	*breq,
 	void __user		*ubuffer)
 {
@@ -780,7 +780,7 @@ xfs_bulk_ireq_setup(
 
 		switch (hdr->ino) {
 		case XFS_BULK_IREQ_SPECIAL_ROOT:
-			hdr->ino = mp->m_sb.sb_rootino;
+			breq->startino = mp->m_sb.sb_rootino;
 			break;
 		default:
 			return -EINVAL;



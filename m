Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DD88BFF;
	Thu, 30 Jan 2025 14:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247487; cv=none; b=dAjCWL7TNgVWMp7axu2i96THo2GoWHW6UoQVyiw5cb8gggNBzmwW5PRuq4QSw8DjxXEbK1wmcBYbOiEcbLnkY0axBHYTMzNcDVFQ8hs3TBCzTsbBt+KNHtF3Z48O/e4MZNqTQgLjSSyhVd5pIEBGZG3qa+e4ESoOiI6NiGVIqks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247487; c=relaxed/simple;
	bh=UwgrHpiQDba/xcxQtkQwMtjFTld5sFWEnrMsgFKmCjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwJb5EZnA2E5LATd3Rv6zHBpddtqhBNlbvGHtMuS78r7ITQFj6GNhdklK3jxSxJnv1JjOptNoPhHGEZBJWMcbE31RKzbHxO7h2cEjZJVdp5D8HyuSMs5rGkRcAs9qvqSW1XJvaB8w0wAg7QBsETMIc9puiBIMF0DSgcgXMJJWrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BM/bmzvK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BM/bmzvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68933C4CEE0;
	Thu, 30 Jan 2025 14:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247486;
	bh=UwgrHpiQDba/xcxQtkQwMtjFTld5sFWEnrMsgFKmCjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BM/bmzvKCn3/h4FsQF2BjeAQo6qqhhhdJfiLBspKIMvI5FZN/D5R8vUAsyHiTzlvR
	 S2rdnI5u//1Z4bLAkL9rEpbxOaejkeA9+VRelQlC/s+L8KxlIOV6bY5WSnvVZwJ0iV
	 sL+/vHIaYKLYKIcY28gqDVJnrIkVC/87mcdBL5dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 28/49] xfs: dquot recovery does not validate the recovered dquot
Date: Thu, 30 Jan 2025 15:02:04 +0100
Message-ID: <20250130140134.968887809@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 9c235dfc3d3f901fe22acb20f2ab37ff39f2ce02 ]

When we're recovering ondisk quota records from the log, we need to
validate the recovered buffer contents before writing them to disk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_dquot_item_recover.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -19,6 +19,7 @@
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
+#include "xfs_error.h"
 
 STATIC void
 xlog_recover_dquot_ra_pass2(
@@ -152,6 +153,19 @@ xlog_recover_dquot_commit_pass2(
 				 XFS_DQUOT_CRC_OFF);
 	}
 
+	/* Validate the recovered dquot. */
+	fa = xfs_dqblk_verify(log->l_mp, dqb, dq_f->qlf_id);
+	if (fa) {
+		XFS_CORRUPTION_ERROR("Bad dquot after recovery",
+				XFS_ERRLEVEL_LOW, mp, dqb,
+				sizeof(struct xfs_dqblk));
+		xfs_alert(mp,
+ "Metadata corruption detected at %pS, dquot 0x%x",
+				fa, dq_f->qlf_id);
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
+
 	ASSERT(dq_f->qlf_size == 2);
 	ASSERT(bp->b_mount == mp);
 	bp->b_flags |= _XBF_LOGRECOVERY;



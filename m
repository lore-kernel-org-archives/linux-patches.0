Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B22E1C84D7;
	Wed,  7 May 2025 18:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643603; cv=none; b=bYx26IC835DLQVkbbP/bXzic235wmnXFP1CBMtGGH/BhjKX60LFam2VrOOOc5m23xz7hfqlLf5l+GIZZixbUOFhp13xXj/WG+wD1MZljilMpII1pGkp3PV41K7B9XSzqLG1KX5mM3e77HZIejRz0Ek3yidSm7WRh0aErm1b8iIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643603; c=relaxed/simple;
	bh=KCrJZMdAZbqxdFuIaTn4roDxPoyLbVWV6IIcrIutMRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ph8mBOfpid/YUZl2/+R6FPay5/ff6VhadVmbA3350AQN/sNSfhs47unn3hSSmSCDBJIxujSfL4Ht1V/YcG3NnScz4XKIfNszXSXNCNvEC2JbSWWGEvCHBP1DElMXS8hoyts2Uw5e4mBs34pEpKRNSOk8lw01Uci99Dtea8CqnE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YIkqDG9f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YIkqDG9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF6BC4CEE2;
	Wed,  7 May 2025 18:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643603;
	bh=KCrJZMdAZbqxdFuIaTn4roDxPoyLbVWV6IIcrIutMRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YIkqDG9fodZGiOUO3osJdvoT/RhxRQCQcvSw2PdoCim2jy9zHW80y7WcZEWjm2kdv
	 zOf0ZyzQdpXQz3500qi9I8+fz5j5/bSFvOvrikpjSGS8Bb8tZA3BWhilC6j077eF6b
	 fwTcA6KsTxZnZzgZ0mKPWzD5uXjLjg3H1mepbPOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 27/97] xfs: check opcode and iovec count match in xlog_recover_attri_commit_pass2
Date: Wed,  7 May 2025 20:39:02 +0200
Message-ID: <20250507183808.079019162@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
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

[ Upstream commit ad206ae50eca62836c5460ab5bbf2a6c59a268e7 ]

Check that the number of recovered log iovecs is what is expected for
the xattri opcode is expecting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_attr_item.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -717,6 +717,7 @@ xlog_recover_attri_commit_pass2(
 	const void			*attr_value = NULL;
 	const void			*attr_name;
 	size_t				len;
+	unsigned int			op;
 
 	attri_formatp = item->ri_buf[0].i_addr;
 	attr_name = item->ri_buf[1].i_addr;
@@ -735,6 +736,32 @@ xlog_recover_attri_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
+	/* Check the number of log iovecs makes sense for the op code. */
+	op = attri_formatp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		/* Log item, attr name, attr value */
+		if (item->ri_total != 3) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		/* Log item, attr name */
+		if (item->ri_total != 2) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	default:
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				     attri_formatp, len);
+		return -EFSCORRUPTED;
+	}
+
 	/* Validate the attr name */
 	if (item->ri_buf[1].i_len !=
 			xlog_calc_iovec_len(attri_formatp->alfi_name_len)) {



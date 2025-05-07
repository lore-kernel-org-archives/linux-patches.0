Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163C8155389;
	Wed,  7 May 2025 18:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643601; cv=none; b=l9SAEEhAOIaV2VTA2jHuN9aRPavGnOEJfh/iGN5rCMHOtpCAfwlTSsysKd0NmNotBgSzYpxiwO97dq9AJldf/FjlMRgNgfEMmpI/pg/UzzNCRPJSdoHaS5+hfG0b98lfSq+cqJz4sXP2gIMMLJjea5NzQiZasdnhDs8HFrfiEZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643601; c=relaxed/simple;
	bh=31ZHyVlk9zlhwsKsFOEyycfrhqt6YHR0k1wAouMqOFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ah/XhFUvRQhde8Nm4aob/FhWLdWLxs7wbphf1xEChNsAWTNowkK+xvPNfXnCAVnRYDTK3/lq9Ey2uLkKt0cfAryA1BZBuMPH4+nLy1EgFks4ApDQKjW4Z8i5PpxXRX996gPcDH+YkfZrIY53+p6wLUlbNjrI+uIhuz0nvG9dtNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jzTATzjH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jzTATzjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C06CC4CEE2;
	Wed,  7 May 2025 18:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643600;
	bh=31ZHyVlk9zlhwsKsFOEyycfrhqt6YHR0k1wAouMqOFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jzTATzjHq2e2qyPgZYNfbiP+uWgvFxddblAz4+G3pvPPl6yGeiVacIrg9Tl7ggmCV
	 z7fpQ2v9v9See/XBLbi6AlYNRaqu2UfbAk8+P95IY+zMp8KR+6WX+f5doDKhFh8OSb
	 ZTf815E3E3n4EW4uZKtSMpG/LWgt86YOiJllqinE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 26/97] xfs: require XFS_SB_FEAT_INCOMPAT_LOG_XATTRS for attr log intent item recovery
Date: Wed,  7 May 2025 20:39:01 +0200
Message-ID: <20250507183808.040408668@linuxfoundation.org>
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

[ Upstream commit 8ef1d96a985e4dc07ffbd71bd7fc5604a80cc644 ]

The XFS_SB_FEAT_INCOMPAT_LOG_XATTRS feature bit protects a filesystem
from old kernels that do not know how to recover extended attribute log
intent items.  Make this check mandatory instead of a debugging assert.

Fixes: fd920008784ea ("xfs: Set up infrastructure for log attribute replay")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_attr_item.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -510,6 +510,9 @@ xfs_attri_validate(
 	unsigned int			op = attrp->alfi_op_flags &
 					     XFS_ATTRI_OP_FLAGS_TYPE_MASK;
 
+	if (!xfs_sb_version_haslogxattrs(&mp->m_sb))
+		return false;
+
 	if (attrp->__pad != 0)
 		return false;
 
@@ -601,8 +604,6 @@ xfs_attri_item_recover(
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
 			 XFS_DA_OP_LOGGED;
 
-	ASSERT(xfs_sb_version_haslogxattrs(&mp->m_sb));
-
 	switch (attr->xattri_op_flags) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:



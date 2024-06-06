Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D9419E7E3;
	Thu,  6 Jun 2024 14:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683522; cv=none; b=BQVfUAi30RHi9eIgGKpBzwwALJcSMu9XTPJV1aBAXJxrsYAtKMn21K5JMl6hwOJr9k9Wtky9lhnjnYg1n/2tceIprA6t/C3hUFoNRlPnmVoFjtxlq2PsWehRRCRyA2716YQ4gXdiF2buRPkS9pYu78ROrAQCrglV25jrSo7yD8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683522; c=relaxed/simple;
	bh=yrmvln2ageEiyDq+JGbJoUrWQ/BSXm2ZPgaO1i4jLJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YB4UnNgDxT8knTXZE+v45pGg68MLdgkebzI9qkWVR7Mds2oOe6RxTHH8AWrzF4vkWacQXRKOvTHsKLTjHT9F0XUrxBgFMitWhHyky86vvypVpzhsjYpUtlkOFzv5L8Sngx++fo6mKA2Cxk46BjFCP3D3uZhSMbht2nch9OG02hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oODbcTOv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oODbcTOv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0472FC32781;
	Thu,  6 Jun 2024 14:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683522;
	bh=yrmvln2ageEiyDq+JGbJoUrWQ/BSXm2ZPgaO1i4jLJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oODbcTOvEhi1/d8Ckpb4KAXmF+iCANbeC3Vqhlx/z7NNxrQSCi3XN8Z3Ha/g+mZxr
	 3vmZEr5wKXOlwc5IeiQTC1HFIlS6Xd7xYdYF9bC3AV+Wt/IH2AIq9VrQOCOEtlkPRI
	 QojGB8WYqpf7aSFjfJp+RRQ0A+r5+tAYpPZIDxkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 463/744] xfs: require XFS_SB_FEAT_INCOMPAT_LOG_XATTRS for attr log intent item recovery
Date: Thu,  6 Jun 2024 16:02:15 +0200
Message-ID: <20240606131747.322385394@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 8ef1d96a985e4dc07ffbd71bd7fc5604a80cc644 ]

The XFS_SB_FEAT_INCOMPAT_LOG_XATTRS feature bit protects a filesystem
from old kernels that do not know how to recover extended attribute log
intent items.  Make this check mandatory instead of a debugging assert.

Fixes: fd920008784ea ("xfs: Set up infrastructure for log attribute replay")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_attr_item.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 82775e9537df8..ebf656aaf3012 100644
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
 
@@ -602,8 +605,6 @@ xfs_attri_item_recover(
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
 			 XFS_DA_OP_LOGGED;
 
-	ASSERT(xfs_sb_version_haslogxattrs(&mp->m_sb));
-
 	switch (attr->xattri_op_flags) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
-- 
2.43.0




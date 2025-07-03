Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427B82EE272;
	Thu,  3 Jul 2025 14:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553923; cv=none; b=dGDBw59bfLteMnkctJdmTXva37ui+OlqQTmGbQd3L1WsP1TXUFOuTOgGsI6U5VqMnjN7KYYG2la4HNOPcSJeqqlxf9deEfVt2+gse+1xPjLz6cAhDRgrTtLylfDVW9Ui+8bMZn/0Cx2j3S0niTMP/hy8cL/zBvlToICYfEPT6Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553923; c=relaxed/simple;
	bh=BudDPDJgOtHR8mYpLD+J4M2vdEyHMWdnExtzzwOd6lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bMsO+3EDJYzDdLx2gsPxUaL2Ti4x4rMianGgRRcfLbyQFv79m0800MvHu83t63YV3wR0SvW5g2EPrdFwQyZ2nCV1gO5RofWzqLU340RidZR5jo3IZ7skdKj/eQHYAytHuauTicUsTSFhIFl0NexbpyXVD0xQ5rY1FxyX+yzzEmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gCZoCLli; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gCZoCLli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4130C4CEF6;
	Thu,  3 Jul 2025 14:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751553923;
	bh=BudDPDJgOtHR8mYpLD+J4M2vdEyHMWdnExtzzwOd6lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gCZoCLlixeQ7jix6O7Loid4RTTbrO3qrirrjHZUTwEqTFQnXoSETBRbV4Rw92N4C8
	 mkNWPYejbxZsuURMbufnykJVrB/LwDRzjSA8Ig8xyB1eSMvOnxYWdAKiG+mw+9DQF+
	 5Z1hCLOK39BHmS+SMImcAWD+CEpLOm1I/bhb1SW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Young <hanyang.tony@bytedance.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/218] NFSv4: Always set NLINK even if the server doesnt support it
Date: Thu,  3 Jul 2025 16:39:12 +0200
Message-ID: <20250703143956.135581301@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Han Young <hanyang.tony@bytedance.com>

[ Upstream commit 3a3065352f73381d3a1aa0ccab44aec3a5a9b365 ]

fattr4_numlinks is a recommended attribute, so the client should emulate
it even if the server doesn't support it. In decode_attr_nlink function
in nfs4xdr.c, nlink is initialized to 1. However, this default value
isn't set to the inode due to the check in nfs_fhget.

So if the server doesn't support numlinks, inode's nlink will be zero,
the mount will fail with error "Stale file handle". Set the nlink to 1
if the server doesn't support it.

Signed-off-by: Han Young <hanyang.tony@bytedance.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 330273cf94531..9f10771331007 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -557,6 +557,8 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr)
 			set_nlink(inode, fattr->nlink);
 		else if (fattr_supported & NFS_ATTR_FATTR_NLINK)
 			nfs_set_cache_invalid(inode, NFS_INO_INVALID_NLINK);
+		else
+			set_nlink(inode, 1);
 		if (fattr->valid & NFS_ATTR_FATTR_OWNER)
 			inode->i_uid = fattr->uid;
 		else if (fattr_supported & NFS_ATTR_FATTR_OWNER)
-- 
2.39.5




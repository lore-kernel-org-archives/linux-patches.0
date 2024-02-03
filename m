Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FA9F9FD;
	Sat,  3 Feb 2024 04:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933346; cv=none; b=CyuaIv9KMcQHqlIoUkc00J1TSX6f68UlLDrHdharuFwdBJuYkVWw5pRZkGQ++qTTkGCXzu3y6QzOPdgSpCURA1J4G5bmmHoBKIvaFB/SX7QAF6LWurln6DdPiPP/+mOrRgQzEOgck6683qrRxoBAvG+m1PwbgrVtsisnuSyY66g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933346; c=relaxed/simple;
	bh=08rJ0Tw9eGZ03J5bWmAjsogWFmKVXBTvJrFvomZ8ETg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LbPT8erka5dxnU1NBn01ABMCxO0XNXAUHsx+56Y9Q4sOfn+Z02nQajUKyqURsvz38Wnf5EGKAT44+wqsm8H7yiDFVQF6ScXgR0GiSFrS7BKDCyezvj0Dj/PUYG+p+6O+ePu5DKFH3IuUNen5VbbZqgTP0RWXmo3R+G8vEV37nD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yXQcZF2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yXQcZF2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CD0C433F1;
	Sat,  3 Feb 2024 04:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933346;
	bh=08rJ0Tw9eGZ03J5bWmAjsogWFmKVXBTvJrFvomZ8ETg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yXQcZF2SMopPwPtu2/3Gu0Cr7Pj8St/Ri8HS/74C4aTmlrICzifp+8z+Ur8iXXAyk
	 jHHyngwE9lNsQahriBktj+InQ8WuIyA+QQdnXVQqYikHCZiabmNvrKXRBWSQDmtpls
	 3GvVeZMfnbzY5CWdkrbRqlE9AhpiiWc8eFDwjGUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Eric Biggers <ebiggers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/219] ecryptfs: Reject casefold directory inodes
Date: Fri,  2 Feb 2024 20:03:33 -0800
Message-ID: <20240203035322.089872313@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

From: Gabriel Krisman Bertazi <krisman@suse.de>

[ Upstream commit cd72c7ef5fed44272272a105b1da22810c91be69 ]

Even though it seems to be able to resolve some names of
case-insensitive directories, the lack of d_hash and d_compare means we
end up with a broken state in the d_cache.  Considering it was never a
goal to support these two together, and we are preparing to use
d_revalidate in case-insensitive filesystems, which would make the
combination even more broken, reject any attempt to get a casefolded
inode from ecryptfs.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ecryptfs/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index c214fe0981bd..55340ac61456 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -76,6 +76,14 @@ static struct inode *__ecryptfs_get_inode(struct inode *lower_inode,
 
 	if (lower_inode->i_sb != ecryptfs_superblock_to_lower(sb))
 		return ERR_PTR(-EXDEV);
+
+	/* Reject dealing with casefold directories. */
+	if (IS_CASEFOLDED(lower_inode)) {
+		pr_err_ratelimited("%s: Can't handle casefolded directory.\n",
+				   __func__);
+		return ERR_PTR(-EREMOTE);
+	}
+
 	if (!igrab(lower_inode))
 		return ERR_PTR(-ESTALE);
 	inode = iget5_locked(sb, (unsigned long)lower_inode,
-- 
2.43.0




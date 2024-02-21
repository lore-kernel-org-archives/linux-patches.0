Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59873CF42;
	Wed, 21 Feb 2024 14:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525189; cv=none; b=tlbuU1DqWDfEr8yOMeQO/P8V0/M8w54cbHXBJyqAY+KIEN+rB4OhE3UbQ/y5ujMaGzAjqg36gLgmaYsI6/39hw2FL09dS3JvNQ+0vQbtxFiANU2gV616X7SrVq1YRvT3pdbb1goCLuvt1A1vhF/mmUurhE89Y7K3IwNEdfgW+LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525189; c=relaxed/simple;
	bh=GFUNbdbBPjFvd4MIqKO+W9PqBeJm1cS/Xs5fxmfqJBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=anIzW9W9gPbtv8P7zo2+Cm2O1WU/Io3rj0zdlQ787sIlFqHf6zFz5atKH9Dt8I/m9dODCv448it2dJpfW6llI6YOqe55dPWrkjPmiUn6p2TQ/P+TZzCC93uAo+YtHhcGQlPxjltXG83F9AR3Kozt9QMZz6X5Q9h/Brj19doiedM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JWyEWNjn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JWyEWNjn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F810C433F1;
	Wed, 21 Feb 2024 14:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525188;
	bh=GFUNbdbBPjFvd4MIqKO+W9PqBeJm1cS/Xs5fxmfqJBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JWyEWNjnLFLDWCuhXIh1dFimbtrRGpBrnVpb2sTHfLAWD7i2ROd3cubP9WUVvA3JQ
	 ccihvPnemtyCNw+ONqny8e07gfLESpnpucS+KRCdepeJhZH2VJtALoxTEupwW73CzV
	 VUvp+6qK1JB2EMINzl4TG8GXSXevUCMaA1EGVHzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Eric Biggers <ebiggers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/267] ecryptfs: Reject casefold directory inodes
Date: Wed, 21 Feb 2024 14:07:07 +0100
Message-ID: <20240221125942.661794900@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e23752d9a79f..c867a0d62f36 100644
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382DF13AD4;
	Sat,  3 Feb 2024 04:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933773; cv=none; b=TdIaL0hrDtctPgHqT9lXNESNOJCgvMIDm0OUNY/AJsRDklHFGnQ1aIYHj/+ncuziYXAJNCgHO8BEHuxxzw00nF0xOrx+Gve7vCSJiMo240AjIK6L0GSg2Dnt2cPG2C2TFJMgZpBszYhc4QXIqOYUa2/IlYjUR6R3/1Hcat8fTXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933773; c=relaxed/simple;
	bh=5KALVd266rX5OVIuDF5eQQGkB3s9CBOKvGPB+FvJ6bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZXAImkzaDzu2V/VbmyUqATnTpBaHPrRqGulMb6SQAw/P5TU46qJ9UaYmKyJGo0ohm8ipx7z1qXzgbMOVgSEzKMqS8PdaxI+SE+WaXJWAB/k+E9aO+TMEbzPArnQx8JqK/+Xt5/U6DlrmIk9JNYTHuUIaxWL5Ys7SX1GBr12y/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LPV1vps8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LPV1vps8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014FCC433A6;
	Sat,  3 Feb 2024 04:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933773;
	bh=5KALVd266rX5OVIuDF5eQQGkB3s9CBOKvGPB+FvJ6bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LPV1vps8K8d+b4wKttKYckRsmZzUy37c3I0+tPw+Bx/icfGenSRiECoAllZ8m7xQR
	 omMFjTivYiFJjMphnPtG5AsoJDXD2HrTcJhrVENVJtsUoY1lOnjHrRbEP+zodxWg2m
	 L1JNaKF4GRZWNqVxpqVVvRAx4SLCwS21XcMkqpYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Eric Biggers <ebiggers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 058/353] ecryptfs: Reject casefold directory inodes
Date: Fri,  2 Feb 2024 20:02:56 -0800
Message-ID: <20240203035405.638247424@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index b0e8774c435a..d7193687b9b4 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -78,6 +78,14 @@ static struct inode *__ecryptfs_get_inode(struct inode *lower_inode,
 
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




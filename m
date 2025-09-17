Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52725330D21;
	Wed, 17 Sep 2025 12:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113734; cv=none; b=VbwyJftoeh2C7McLRJVr5MCTjsev5kLNuODSHo6krS5YBuXl1tUeRN6dOlL4UOUCPM0dGjF3fouA1hAZqVrF8flwKU301fZ/0g7IZq2WLrQKDERbFdQvqfHvrr/HQBoRRMnxKGoIpe/d/7qkQTu+oi0wO65nELsxaiMGaBRFiM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113734; c=relaxed/simple;
	bh=zB+KSZQDJu/LiJIDDd+l+Z6CAGWY8ovAqDMcrde/xI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TFf0rPEtTveHpUUvBj9GIqzY1KMoZ1BFtPw9G28rJ5Psi2YlEA7V4nmjhLv9ZQV6wi/jRwYl9E8qnuGHGwpoZr2S2NoXK0JjpQVeEMHKYjJ4vcs9CeC8Jn0UI4JTxweBMeJ9giq/XocENzP9RNgt6xegHqiNjbtCVHtcHd4j7cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bKlZn0Zx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bKlZn0Zx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74174C4CEFA;
	Wed, 17 Sep 2025 12:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113733;
	bh=zB+KSZQDJu/LiJIDDd+l+Z6CAGWY8ovAqDMcrde/xI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bKlZn0ZxBOv4T0q2nCSPm55Wstku1vmOtq7CbG6HFiOycswAHbdNLvQRq5AxRCEst
	 q/774DhwciPResS01/Fg00YzTwGA7R6bRPmM0quOGhHMy2iQhih5FdMzA0KAY7DZM6
	 Xdx+ztUe9IuFLT3OPc1cppAWaKSa1VHEssQ0oiz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/101] NFSv4.2: Serialise O_DIRECT i/o and clone range
Date: Wed, 17 Sep 2025 14:34:02 +0200
Message-ID: <20250917123337.324160706@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit c80ebeba1198eac8811ab0dba36ecc13d51e4438 ]

Ensure that all O_DIRECT reads and writes complete before cloning a file
range, so that both the source and destination are up to date.

Fixes: a5864c999de6 ("NFS: Do not serialise O_DIRECT reads and writes")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index 02788c3c85e5b..befdb0f4e6dc3 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -282,9 +282,11 @@ static loff_t nfs42_remap_file_range(struct file *src_file, loff_t src_off,
 
 	/* flush all pending writes on both src and dst so that server
 	 * has the latest data */
+	nfs_file_block_o_direct(NFS_I(src_inode));
 	ret = nfs_sync_inode(src_inode);
 	if (ret)
 		goto out_unlock;
+	nfs_file_block_o_direct(NFS_I(dst_inode));
 	ret = nfs_sync_inode(dst_inode);
 	if (ret)
 		goto out_unlock;
-- 
2.51.0




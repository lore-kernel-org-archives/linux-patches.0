Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E322AE96;
	Tue, 29 Apr 2025 18:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949982; cv=none; b=HpNnD6TZ2fUhhCxgYVhToMX3AcccQkCPSsCoEL/ffMeVH7wnRV7ti6BKW1qvgOYkcAiekx0FMNbmIYxWIYRwj0fmfDprpVXywRWwiI1KuTNRozV5fVG/KDoCXyOmnnVbqXk5+JJA9/HLGyeDWVukZCVrpp4RRmS7W4yjHlkEKGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949982; c=relaxed/simple;
	bh=AqeZQSI+J8fAoPZbetz6vbrQ2HlEwiG4xtaR42tDVeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDyWBVBZTX/Q/hrt9c0Jawu6x5pl+KnIE/vOzstPuhY+cd4JJNRI4GVQAveDs8AVcp5/kB3tH2E0b598foAX5nOl1Sr2UTRKVCK/M7NXXz/cnfR31mMQ7YvhZpMrIzzh4kbMz/rqdLWWvBl2BOYL2PvLiDF3/q2fEoapZDtFxfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YZx/oO34; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YZx/oO34"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C946DC4CEE3;
	Tue, 29 Apr 2025 18:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949982;
	bh=AqeZQSI+J8fAoPZbetz6vbrQ2HlEwiG4xtaR42tDVeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YZx/oO34hccCJo4Zo73DZGclOrAWbL1/25calxhdjpz88DolliQjt2N8FGexIYWFB
	 VEOIfOGzqSXO1lOMQVlhrltIT6HsKlSx9ru2EO85D0OAmj0zL0dqIFSvMLV+z4fGuJ
	 3WLX5DN8gUqp52noYCRH0+mCEq7nQpIgV1s9r6O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 118/167] qibfs: fix _another_ leak
Date: Tue, 29 Apr 2025 18:43:46 +0200
Message-ID: <20250429161056.516826857@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit bdb43af4fdb39f844ede401bdb1258f67a580a27 ]

failure to allocate inode => leaked dentry...

this one had been there since the initial merge; to be fair,
if we are that far OOM, the odds of failing at that particular
allocation are low...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qib/qib_fs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/qib/qib_fs.c b/drivers/infiniband/hw/qib/qib_fs.c
index 182a89bb24ef4..caade796bc3cb 100644
--- a/drivers/infiniband/hw/qib/qib_fs.c
+++ b/drivers/infiniband/hw/qib/qib_fs.c
@@ -55,6 +55,7 @@ static int qibfs_mknod(struct inode *dir, struct dentry *dentry,
 	struct inode *inode = new_inode(dir->i_sb);
 
 	if (!inode) {
+		dput(dentry);
 		error = -EPERM;
 		goto bail;
 	}
-- 
2.39.5




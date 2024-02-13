Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17F75FEFA;
	Tue, 13 Feb 2024 17:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845334; cv=none; b=PnNr7G0dJZnrWcwF+f+RJF/nX2ISxOyFkai1AlgAeszEk5+ijAYm5i8VHuv7PtPsAXgTDHEn/UBvP/QhOpF97O/uQfKAA+ddvLkyHpl36E++1wgFNif/n69W8ZfAcwKwBM1+3csR3UFUgoqmoeo51CKx+25IFSGl1tT//AQ9rwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845334; c=relaxed/simple;
	bh=uzDmbKXD0rCs+cXKJ59LeVwgrYsF9N6uRRIxhbbqao4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjVgBCacOxKGgX8jFtSrD7Z4LY3ynj9GYFtlciTIYuK3o6JvzpjGI6YooTp33kjZO4AXZXNkyB1VfqX3tzsUHSjFMV67e39ZE/T2nsy/+ofMcUJ9tBqCkZaIya7wRU+bRiOODEVojMmwnI45YW07Z+hGV3V66uAQ9FLheBl4A+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lK0ywoEt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lK0ywoEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23FECC433B1;
	Tue, 13 Feb 2024 17:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845334;
	bh=uzDmbKXD0rCs+cXKJ59LeVwgrYsF9N6uRRIxhbbqao4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lK0ywoEtlPDaZiGNjcRn3dmzSlcn06a5QMp1/CG2DLK8mdj1nbrsrUu3CO3LmVody
	 jC/HYsdYPwwI+5tl1Ew1Yu94UY75PPm63cBBWdTV34vzzSTcVAoca1baK9tvrFEnKy
	 fxrMJFGVjxB63u9jTOYOl8ZBcDSB/v4vy3ec2dSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/121] xfs: prevent rt growfs when quota is enabled
Date: Tue, 13 Feb 2024 18:20:29 +0100
Message-ID: <20240213171853.560831248@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

commit b73494fa9a304ab95b59f07845e8d7d36e4d23e0 upstream.

Quotas aren't (yet) supported with realtime, so we shouldn't allow
userspace to set up a realtime section when quotas are enabled, even if
they attached one via mount options.  IOWS, you shouldn't be able to do:

# mkfs.xfs -f /dev/sda
# mount /dev/sda /mnt -o rtdev=/dev/sdb,usrquota
# xfs_growfs -r /mnt

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_rtalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 16534e9873f6..31fd65b3aaa9 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -954,7 +954,7 @@ xfs_growfs_rt(
 		return -EINVAL;
 
 	/* Unsupported realtime features. */
-	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp))
+	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp) || xfs_has_quota(mp))
 		return -EOPNOTSUPP;
 
 	nrblocks = in->newblocks;
-- 
2.43.0




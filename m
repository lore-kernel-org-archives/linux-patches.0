Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C305F54E;
	Tue, 13 Feb 2024 17:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845241; cv=none; b=MsvXuoO9zj8fsOPvOWrIdFjZQNMOOyqkJeOZvpRyw+W99mxhYY0i8LDrpxEyAR9/IMzDeD6BJ5zlma8thFR7hrBsGfOxEiurNwnXUKy0p5ociGR4RFvk+zolFxflehydW1381nXT6hkBESGfeD9El3h+++toNhtt1x+ssOjWOCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845241; c=relaxed/simple;
	bh=B44iKJQRA5fa6sCfs/7UzpINMeiotHqjtFrah0aKq0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RHBx7cePy69dBu9bZQBEvKqmINQY+PiKFOmksdSf21aFr02Lf3eRdNphXagg0RDeZUQoFJNAYIwDCXMEiSktQlUfuXPiKjEMBQNtRU2S6NdPsXZ3nEffNHnflN+Bq5/gsG5nwWBcPwYhI+FYa21imG1QTonvIcixDJo29ILStwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eLm6QPAH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eLm6QPAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40606C433F1;
	Tue, 13 Feb 2024 17:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845240;
	bh=B44iKJQRA5fa6sCfs/7UzpINMeiotHqjtFrah0aKq0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eLm6QPAHxEbVoVFrYMWgczHodRJSQgcIvX1Kumgd+GRhxWJ9338w5nG2B9ITz6Erq
	 e37pBHx4m313n4L7sOsAlp/oO8+XUjsL45pAA6QtgZtjEI9fNWTv47qsscXEZBeXdj
	 8v2W276mZIRA9ZHPdJ+zDsQDa5nQ91b3DtsC09lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Lin <cheng.lin130@zte.com.cn>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/121] xfs: introduce protection for drop nlink
Date: Tue, 13 Feb 2024 18:20:33 +0100
Message-ID: <20240213171853.679407295@linuxfoundation.org>
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

From: Cheng Lin <cheng.lin130@zte.com.cn>

commit 2b99e410b28f5a75ae417e6389e767c7745d6fce upstream.

When abnormal drop_nlink are detected on the inode,
return error, to avoid corruption propagation.

Signed-off-by: Cheng Lin <cheng.lin130@zte.com.cn>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4d55f58d99b7..fb85c5c81745 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -918,6 +918,13 @@ xfs_droplink(
 	xfs_trans_t *tp,
 	xfs_inode_t *ip)
 {
+	if (VFS_I(ip)->i_nlink == 0) {
+		xfs_alert(ip->i_mount,
+			  "%s: Attempt to drop inode (%llu) with nlink zero.",
+			  __func__, ip->i_ino);
+		return -EFSCORRUPTED;
+	}
+
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
 	drop_nlink(VFS_I(ip));
-- 
2.43.0




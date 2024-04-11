Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9BD13DDDD;
	Thu, 11 Apr 2024 09:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829548; cv=none; b=WeTQQcp5/j5tHI1Kku5xOfG758ND16+MpBFZQ/KqnAuOKyp9KAxWjniKglsMbxI75QTz/buncjPaJ8ZAM3iP95wzBAa+JeEp2nZy2H/pboa/As3q1Q/1GBbN/pbU47nXx58QYIldHBUSLbdq6rL7cHUi3mgcx4Jsd/zU2xn6++A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829548; c=relaxed/simple;
	bh=1bOzYIPfAWrbXCy3VqWswpIj3dQLBY788atgK9EYLvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DeMNItTj0qsNd4F1jGdixsmyntybI+T2jm6sGjaK/BM4DpYwo47NCTJc4E37Wtb0XzQ68pNZclp6lRMTg4fh9EKUbYNigaA8tmW8X+E1jiRfm2TmTu7zGxKVGccW14CoDcbhggMuSbKZQscr2NtFXBv1jsg1w66zMZYg3CcVoHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B38yOfrN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B38yOfrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A73C433C7;
	Thu, 11 Apr 2024 09:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829548;
	bh=1bOzYIPfAWrbXCy3VqWswpIj3dQLBY788atgK9EYLvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B38yOfrNVDAB7ClcNBR3FSB1FM4SsVB8ev9tBL1lq+yBhSpJSqt/Qd7PK5UjBTgBW
	 OnQrk6w59VAyajwVG/5Ba8hc1wp4RtflO7JUr84XD66TUPJ/Jl/rBekWHHeIxQ2mC0
	 4KhXnC/eYJmnGaKFUZlq6VZjhR5+bve4cYJEeGJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 024/175] ubi: correct the calculation of fastmap size
Date: Thu, 11 Apr 2024 11:54:07 +0200
Message-ID: <20240411095420.282837045@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 7f174ae4f39e8475adcc09d26c5a43394689ad6c ]

Now that the calculation of fastmap size in ubi_calc_fm_size() is
incorrect since it miss each user volume's ubi_fm_eba structure and the
Internal UBI volume info. Let's correct the calculation.

Cc: stable@vger.kernel.org
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/fastmap.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index d45c1d6587d18..e24fc0131d794 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -95,9 +95,10 @@ size_t ubi_calc_fm_size(struct ubi_device *ubi)
 		sizeof(struct ubi_fm_scan_pool) +
 		sizeof(struct ubi_fm_scan_pool) +
 		(ubi->peb_count * sizeof(struct ubi_fm_ec)) +
-		(sizeof(struct ubi_fm_eba) +
-		(ubi->peb_count * sizeof(__be32))) +
-		sizeof(struct ubi_fm_volhdr) * UBI_MAX_VOLUMES;
+		((sizeof(struct ubi_fm_eba) +
+		  sizeof(struct ubi_fm_volhdr)) *
+		 (UBI_MAX_VOLUMES + UBI_INT_VOL_COUNT)) +
+		(ubi->peb_count * sizeof(__be32));
 	return roundup(size, ubi->leb_size);
 }
 
-- 
2.43.0




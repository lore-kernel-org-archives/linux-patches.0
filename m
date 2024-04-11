Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25648146D61;
	Thu, 11 Apr 2024 10:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831510; cv=none; b=l0p+cOvHQuarzfIwdcoaRynDutRi8DEWNG7hv+krwOPkxPPKYxAaU4kJ/GUCblkCBAq8LH+RqSHYKhhyg3TWFDFA2ZYw5HyqA0kJWkvzDYJi/B9FZYM9E1figxajHlqbMSXxS+4BBP9ZFzkQGgzJgRBu04qiLc2hRdsVexMQe7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831510; c=relaxed/simple;
	bh=SAMaiN1oOQnyfhMBBPuARC1Xjj04gYCEwO9Qjf32kOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=El70e/m9lKjejX5PSjENwkiPtrL2Wue+Z2rjOEFP0qzcrZWwoHpJHOGzAdf+5AmIzyQlEpFFzznMoV5trEbt/cFn6b2SA/hgKv/znXknnlY9CSubs4k4XGgzbv9ncEFXTEbKIW+I1qkS0MauIacmckNmBR/27S1rhtwMAKSv1gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UU6gFLTf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UU6gFLTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42614C433F1;
	Thu, 11 Apr 2024 10:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831509;
	bh=SAMaiN1oOQnyfhMBBPuARC1Xjj04gYCEwO9Qjf32kOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UU6gFLTfx0eU+NgOZHzbrlIUuaown8bJ0Khq52mNK1J1mv4rvbb0+/lM9xt6fJXm+
	 lnSlRU4tBj08SzysxWS2mMqTcVLq5F+3RQrVNjj3zLPF5ltZm6v28xpw2fGlYZ6Rij
	 o46AxfO21TUqkOAIXxYp1jshYBGeC+RHPC/BIoLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/294] ubi: correct the calculation of fastmap size
Date: Thu, 11 Apr 2024 11:53:16 +0200
Message-ID: <20240411095436.634376227@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6e95c4b1473e6..8081fc760d34f 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -86,9 +86,10 @@ size_t ubi_calc_fm_size(struct ubi_device *ubi)
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




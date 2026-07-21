Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9851F44AB6D;
	Tue, 21 Jul 2026 21:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669217; cv=none; b=smMMtYU27B+WyntMHjTAKFKDZ+j3MMQx5dAIBpGmHhKrb3uzYv45Nwvaa8SR755/clnC8snpfAIBqm3KS6gjLVPccSqfSuOHwUJdjcg3lHhdadQrYjvHu1OQ4fsIA7Kj3JRFfbaZXR01TKMfRmxg++q/fcAGCaqeBgDYOnQt8iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669217; c=relaxed/simple;
	bh=2E6zHaPFhjAlc/HkTrBGh6E2tjeUmZ73QxAmny2gFIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvPUJfEHm8aHpA6YskQyoHmDhj9fXuL1cb/QcpHM1xkf4XOqwsLWLqcLN5p9P7jpGsywwyOQjqQSdsb8Ud2a/GjtCRPpmCeKy/0Ll1uUdKltrvlaGdDa+WbRtVrAq25Rgr+UvMM+w9NHI9dz8D2xyPAJk6nTcGFHTUz4yPpqRQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ARlopKVN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ARlopKVN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C431F000E9;
	Tue, 21 Jul 2026 21:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669216;
	bh=uJWTfkx6dhDk4I8rxjbOhdUsQ5JbSx8fYCQICgbaODw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ARlopKVNbexWmXLSlp2ZJwYYarybehn66J4TYDrcpPh0VdNN3Wya7HPGGfsJCsEH2
	 ZGSQz6MFSR+rtc4TFsuZ+NpDfDztnJO/Ii+8J5+oTNC8DY/IdvzRtAwMDii1W8pyZ/
	 /e8jvv9ylj3RPgoTDQ8Zm/GG4zMXb+YVEJ58Gyh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0428/1067] =?UTF-8?q?RDMA/mlx5:=20Release=20the=20HW=E2=80=91provided=20UAR?= =?UTF-8?q?=20index=20rather=20than=20the=20SW=20one?=
Date: Tue, 21 Jul 2026 17:17:09 +0200
Message-ID: <20260721152434.194712827@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 449ae7927152e46acbe5f19f97eafdae6d3a96b1 ]

Free the UAR index returned by the hardware.

Fixes: 4ed131d0bb15 ("IB/mlx5: Expose dynamic mmap allocation")
Link: https://patch.msgid.link/r/20260611-fix-uar-release-v1-1-f5464d845dbf@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 45a414e8d35faf..7102c3a78ee9d3 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2229,7 +2229,7 @@ static int uar_mmap(struct mlx5_ib_dev *dev, enum mlx5_ib_mmap_cmd cmd,
 	if (!dyn_uar)
 		return err;
 
-	mlx5_cmd_uar_dealloc(dev->mdev, idx, context->devx_uid);
+	mlx5_cmd_uar_dealloc(dev->mdev, uar_index, context->devx_uid);
 
 free_bfreg:
 	mlx5_ib_free_bfreg(dev, bfregi, bfreg_dyn_idx);
-- 
2.53.0




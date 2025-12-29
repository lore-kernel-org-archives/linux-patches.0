Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D922222CB;
	Mon, 29 Dec 2025 16:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025335; cv=none; b=SonaWgbXtk+WF5ENg65MXjCZekRbD7Z8aywmIBhmJS66SpiVgz8Rk81qvj3Dg0q60XQY9E1Tct3KsWicMw9TROjmHe9U1R6EjHGeo9A34B/BBqAGnSUJAEzD+ueK2uOa+ggrh9k33X8rRPnmMm1YB43fyKs+mAM/9U4jU/Lx4ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025335; c=relaxed/simple;
	bh=fU1Z6CL0aVRITy8nClDbB9MPkI/WMODNXS7fx7dABrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kz+cCt1uCqvfCOaGrfHj1YTHGR0t9wybFkdgdWROwemOxh6Es9s5kgOnuI0xUz2oJ5or0NDQZWYQvVG/OfhzT7IUssC9/rPf78NxDBWFhIqZAl9hgXGUX8VOaM7VdyBXKN1+DVts7youVm1h8HB+gCcTtoWgdyxzPjNk0OynUWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1Z/Re6N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1Z/Re6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26782C4CEF7;
	Mon, 29 Dec 2025 16:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025335;
	bh=fU1Z6CL0aVRITy8nClDbB9MPkI/WMODNXS7fx7dABrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1Z/Re6Na6MuddobOYYojiZKmu4rDwV2SEPsa7knhgWenxlvMN3VGbo1EWinI7c94
	 yDAAEPyr7boZ9+ijSN6HTYlGmJbKS1F3AZGoEwq9ugEmGSaEzKvinVFAByUC9LYPmI
	 detnty0Hoie/VXgFiIQCPzJtP0B3+OAYZjbkxOlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Chun-Hung Wu <chun-hung.wu@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 178/430] scsi: ufs: host: mediatek: Fix shutdown/suspend race condition
Date: Mon, 29 Dec 2025 17:09:40 +0100
Message-ID: <20251229160730.910468683@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 014de20bb36ba03e0e0b0a7e0a1406ab900c9fda ]

Address a race condition between shutdown and suspend operations in the
UFS Mediatek driver. Before entering suspend, check if a shutdown is in
progress to prevent conflicts and ensure system stability.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Acked-by: Chun-Hung Wu <chun-hung.wu@mediatek.com>
Link: https://patch.msgid.link/20250924094527.2992256-6-peter.wang@mediatek.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-mediatek.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 758a393a9de1..d0cbd96ad29d 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2373,6 +2373,11 @@ static int ufs_mtk_system_suspend(struct device *dev)
 	struct arm_smccc_res res;
 	int ret;
 
+	if (hba->shutting_down) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	ret = ufshcd_system_suspend(dev);
 	if (ret)
 		goto out;
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F4B34D4D9;
	Tue,  6 Jan 2026 17:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720057; cv=none; b=CHDi8x9r5iSMhBNl1v9pAaNSVAqkvpHWC63qW7DJTw6p+LYR4IPmXkp8Jkkuc0PafmHiiFQMCkoLd3BcqOuMOhYwJ7vUPFOQzZtS1BcD93G5VUI2yopT0Qk0X0mdTVHC4a7/gLg3C7KQzZ1wqyVanABCR5ManTjaPG3nDCmvUXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720057; c=relaxed/simple;
	bh=eaLHbgAg97ElF244De1PLdKLsKUhJI1uaOp5MiWqlx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZ7R9vpCRydlYyeLc7XnS9A2nnHSf2soFI3yi2ykgGe4v9WBmxdZw76mx4K5a5OeNnGamKaw4HAkOcq24kYiP93MZf6lgV/NYDtg1fhxAvzD2bJEFHatAwZGzQzqy5byoZe8CqPKhATu22ZZ15FGxOE4yUB/qOKkNSzfCPpDGQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C0wMTlmc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C0wMTlmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C157FC116C6;
	Tue,  6 Jan 2026 17:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720057;
	bh=eaLHbgAg97ElF244De1PLdKLsKUhJI1uaOp5MiWqlx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C0wMTlmcBXeCUaRWqchWNfnt1ZebtSuzLzwtjuN1PJOA+Xdy6MS14Y6XepKs7XovV
	 2ZC8HRyKIEM1+3WLzf3Bx7xrQN7R2Rppzkf/dLgU6MsyycEbgO9rA8GL/gRU6qbRFR
	 C+76jRvOUSvhnCM5jecYjkT3d3MFtHA7ViKBYca8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Chun-Hung Wu <chun-hung.wu@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 121/567] scsi: ufs: host: mediatek: Fix shutdown/suspend race condition
Date: Tue,  6 Jan 2026 17:58:23 +0100
Message-ID: <20260106170455.804834820@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 00ecfe14c1fd..1fb98af4ac56 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1994,6 +1994,11 @@ static int ufs_mtk_system_suspend(struct device *dev)
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E198F2B9AD;
	Tue, 14 May 2024 11:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685052; cv=none; b=o4y0n3u5bwdc76KA5VJ+vbwGbwDhjiFTMUll/ljYs5lnOV6xBrjAVgBcOty7qU1fH+3EQ22gPFK7eYWXupvsODUdB/Y/UQd0+z8qk0O3uyZCiBm1UAL3MCfAqWtZDx2Umx0QzreA0pHPjagOyGy65qFcDvoRucTvhK9tVi9yHZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685052; c=relaxed/simple;
	bh=JPHSaVxIthyylBKBV+o5NCOR2Q1Mpgb+2caqJrA0d3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVX5tDM3TZ3NqhhrXiCMVI5BWNi47jRUNycvuEBDFlVwP0o0BYltV+i+VoYINDDOYlty/1G03dA4VGCns/pttZH2HHGYkqD9uRCEepvotF5tex+IMUXm0VSH3di5dVD1VwbFsjapE1ZiynwzRTQZDzqOq9MB9r0dd79sEUSYjzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GWyS8yZb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWyS8yZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068ECC2BD10;
	Tue, 14 May 2024 11:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685051;
	bh=JPHSaVxIthyylBKBV+o5NCOR2Q1Mpgb+2caqJrA0d3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GWyS8yZbNO4Qlv93fTRtGcpiLAnOHdtZWwUUMjDr0yjH+xS99bRj/AnOYqU7xyDAG
	 bQ6fxGO/vH/xDk3xiKTVfv3tU+CBjL677ltHRnVKdjX8ZI3+B47yvtj44WcDhXQDm4
	 9KrDy9LKP6XEp+g7e3WNEQAMla5hiJjqR4F11a8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohit Ner <rohitner@google.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Can Guo <quic_cang@quicinc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 096/301] scsi: ufs: core: Fix MCQ MAC configuration
Date: Tue, 14 May 2024 12:16:07 +0200
Message-ID: <20240514101035.877043382@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Rohit Ner <rohitner@google.com>

[ Upstream commit 767712f91de76abd22a45184e6e3440120b8bfce ]

As per JEDEC Standard No. 223E Section 5.9.2, the max # active commands
value programmed by the host sw in MCQConfig.MAC should be one less than
the actual value.

Signed-off-by: Rohit Ner <rohitner@google.com>
Link: https://lore.kernel.org/r/20240220095637.2900067-1-rohitner@google.com
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-mcq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 0787456c2b892..c873fd8239427 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -94,7 +94,7 @@ void ufshcd_mcq_config_mac(struct ufs_hba *hba, u32 max_active_cmds)
 
 	val = ufshcd_readl(hba, REG_UFS_MCQ_CFG);
 	val &= ~MCQ_CFG_MAC_MASK;
-	val |= FIELD_PREP(MCQ_CFG_MAC_MASK, max_active_cmds);
+	val |= FIELD_PREP(MCQ_CFG_MAC_MASK, max_active_cmds - 1);
 	ufshcd_writel(hba, val, REG_UFS_MCQ_CFG);
 }
 EXPORT_SYMBOL_GPL(ufshcd_mcq_config_mac);
-- 
2.43.0




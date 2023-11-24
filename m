Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F33B39FDD;
	Fri, 24 Nov 2023 18:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIiTBbVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6ABC433C7;
	Fri, 24 Nov 2023 18:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849123;
	bh=eZAghahEyEbr5TLOctdl7aM5gWb25B4zAeFu3jhi7zQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tIiTBbVXx/wI8ZSrO6A8+yhzaBXofwIcx7HgfmAdnyXkKBUAlI/OEssHNz5as6gx1
	 w3AQpqAqsihGJxPo6zoq36Vl0/K4fpZzRTpFiOWs9sgBDeCKwS2SqIgdzcwjUj7t+e
	 xBp4olZX9g3Ug3LRzvs59IPMseSeKqnOjjCylRkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/530] wifi: ath12k: mhi: fix potential memory leak in ath12k_mhi_register()
Date: Fri, 24 Nov 2023 17:43:18 +0000
Message-ID: <20231124172029.040858492@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Ma Ke <make_ruc2021@163.com>

[ Upstream commit 47c27aa7ded4b8ead19b3487cc42a6185b762903 ]

mhi_alloc_controller() allocates a memory space for mhi_ctrl. When some
errors occur, mhi_ctrl should be freed by mhi_free_controller() and set
ab_pci->mhi_ctrl = NULL.

We can fix it by calling mhi_free_controller() when the failure happens
and set ab_pci->mhi_ctrl = NULL in all of the places where we call
mhi_free_controller().

Signed-off-by: Ma Ke <make_ruc2021@163.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230922021036.3604157-1-make_ruc2021@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mhi.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mhi.c b/drivers/net/wireless/ath/ath12k/mhi.c
index 42f1140baa4fe..f83d3e09ae366 100644
--- a/drivers/net/wireless/ath/ath12k/mhi.c
+++ b/drivers/net/wireless/ath/ath12k/mhi.c
@@ -370,8 +370,7 @@ int ath12k_mhi_register(struct ath12k_pci *ab_pci)
 	ret = ath12k_mhi_get_msi(ab_pci);
 	if (ret) {
 		ath12k_err(ab, "failed to get msi for mhi\n");
-		mhi_free_controller(mhi_ctrl);
-		return ret;
+		goto free_controller;
 	}
 
 	mhi_ctrl->iova_start = 0;
@@ -388,11 +387,15 @@ int ath12k_mhi_register(struct ath12k_pci *ab_pci)
 	ret = mhi_register_controller(mhi_ctrl, ab->hw_params->mhi_config);
 	if (ret) {
 		ath12k_err(ab, "failed to register to mhi bus, err = %d\n", ret);
-		mhi_free_controller(mhi_ctrl);
-		return ret;
+		goto free_controller;
 	}
 
 	return 0;
+
+free_controller:
+	mhi_free_controller(mhi_ctrl);
+	ab_pci->mhi_ctrl = NULL;
+	return ret;
 }
 
 void ath12k_mhi_unregister(struct ath12k_pci *ab_pci)
-- 
2.42.0




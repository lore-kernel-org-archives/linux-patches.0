Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E803D41A80
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EIipBeK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF13C433CC;
	Wed, 15 Nov 2023 19:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077009;
	bh=sifnPevm8silH1SXpK5pXrpogjWBjx2sBGQLz1JxEFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EIipBeK/+b5MczfGe9pszI9f5sL89pWXnN7O5vZXuHbIodUzFVlNYvjC5uL4IapYS
	 mip+0bstIaqNVQYSw48DHoDLzt6mFKOqBzUpNlwcKQ5kFdDSkcKWu/xNsZe8TTwhgU
	 q/WnFvN+FTEDajpc+OQX9D6LmAt3fzUKSsToWeqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/603] wifi: ath: dfs_pattern_detector: Fix a memory initialization issue
Date: Wed, 15 Nov 2023 14:10:42 -0500
Message-ID: <20231115191619.880721688@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 79bd60ee87e1136718a686d6617ced5de88ee350 ]

If an error occurs and channel_detector_exit() is called, it relies on
entries of the 'detectors' array to be NULL.
Otherwise, it may access to un-initialized memory.

Fix it and initialize the memory, as what was done before the commit in
Fixes.

Fixes: a063b650ce5d ("ath: dfs_pattern_detector: Avoid open coded arithmetic in memory allocation")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/ad8c55b97ee4b330cb053ce2c448123c309cc91c.1695538105.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/dfs_pattern_detector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector.c
index 27f4d74a41c80..2788a1b06c17c 100644
--- a/drivers/net/wireless/ath/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
@@ -206,7 +206,7 @@ channel_detector_create(struct dfs_pattern_detector *dpd, u16 freq)
 
 	INIT_LIST_HEAD(&cd->head);
 	cd->freq = freq;
-	cd->detectors = kmalloc_array(dpd->num_radar_types,
+	cd->detectors = kcalloc(dpd->num_radar_types,
 				      sizeof(*cd->detectors), GFP_ATOMIC);
 	if (cd->detectors == NULL)
 		goto fail;
-- 
2.42.0




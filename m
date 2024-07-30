Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F016F1A616E;
	Tue, 30 Jul 2024 16:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356831; cv=none; b=sXzHHRNDaoN4a2tuphfOfPrtoK8VL2WW9x4tkdBiSWgy0R8EQNVNMC6BSSQuGvTYNuKGAfU/IdN1j/vLbssLtxiVkr/9w6xmvCDQNRX40XrmYc/40W3ECmpRjewdMydVCUyBauYK443bBOqRENY42pAa0q5C3d4H2jPlqu7DZc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356831; c=relaxed/simple;
	bh=c5LHCcuU2bM3vRTKLmf1S33oLcBvI1RnjAxmhApjZ6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CPJPyV8VIqfHGZipolpRETsTBZruxUEsUaSZnFUEBhjYTZhyIWiLcSLJs2xzEoGaFMuZ0jpcWxDcUGR7TYKeZ3Ft/Xr9KMrxsenOd5U3uPN+FmRfuduEEQ3/DNEpo1TvCL7aRI2iDInkpOwhtusgzTjphJhwRnbXoU5t5n2i+xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h1jRj1bY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h1jRj1bY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B09DC32782;
	Tue, 30 Jul 2024 16:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356830;
	bh=c5LHCcuU2bM3vRTKLmf1S33oLcBvI1RnjAxmhApjZ6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h1jRj1bYOGb5raPj8Ob488iZBHKPu2ckqJEwbLdg+adU3ezG96jkqJN7CX+7qXWgO
	 KipwOuXKcJHyRiFm9KWpKj5GDgiLoahFaFkGKanG59RDegxBRI1da6FJ/2nXnROTFn
	 wodvQimu9qxyW/okPNC/4t+ECiomvoEqiy1O80dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Kumar Singh <quic_adisi@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 191/809] wifi: ath12k: fix per pdev debugfs registration
Date: Tue, 30 Jul 2024 17:41:07 +0200
Message-ID: <20240730151732.153853728@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Kumar Singh <quic_adisi@quicinc.com>

[ Upstream commit 8dd65ccbdf91e2fe3ab6e4da158b38f81746c3b4 ]

Function ath12k_debugfs_register() is called once inside the function
ath12k_mac_hw_register(). However, with single wiphy model, there could
be multiple pdevs registered under single hardware. Hence, need to register
debugfs for each one of them.

Move the caller inside the loop which iterates over all underlying pdevs.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1

Fixes: f8bde02a26b9 ("wifi: ath12k: initial debugfs support")
Signed-off-by: Aditya Kumar Singh <quic_adisi@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240529043043.2488031-2-quic_adisi@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index b3530d1dd728b..2c68376a39fd3 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -8778,9 +8778,9 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
 			ath12k_err(ar->ab, "ath12k regd update failed: %d\n", ret);
 			goto err_unregister_hw;
 		}
-	}
 
-	ath12k_debugfs_register(ar);
+		ath12k_debugfs_register(ar);
+	}
 
 	return 0;
 
-- 
2.43.0




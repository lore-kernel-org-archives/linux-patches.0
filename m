Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34173248BA6;
	Wed, 15 Jan 2025 10:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938020; cv=none; b=gnTzN+kaYuMS+hLK02M7+C9ftB2f9hpjDRmcM7rp3lzK+iXWuS3T+tiuHm2FRxxeEt7UpETPpzWrLNVPAeeGb+90LKL0ul8YQip0J6V7i0TIrViCZ6uANV8Q5saQ8D05H5PxOjR/tPlKcHmh/9j5VQxYjpO/zmUrIEFaVvedgpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938020; c=relaxed/simple;
	bh=rxkmvwPBmdt7spE2nyn+4+sj0e6VwD7M/ujiiNTiBEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QaBhQzFFBBxOLHm0Gd074vqmj/V+16nM/3hq+6MKOsx5hwZGlwvOIEheVvuOQDaRIlPnEhBBKhtcQRyYmqLEpZ/O8Fdqm00awBxTV2+cD/ox9yFE6ugp1apnxr40zsC2t4SL0umGVZkJL1JBTWR8wC8IfZDIm4PvNZbU0M9LbXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBe/rhnQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBe/rhnQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63963C4CEDF;
	Wed, 15 Jan 2025 10:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938019;
	bh=rxkmvwPBmdt7spE2nyn+4+sj0e6VwD7M/ujiiNTiBEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yBe/rhnQO8BtaAuMyPRsgPHm0p8W6DUyK9upiKTx7qgmDgchnKaX9wzV8PUH4n3+d
	 mYunAb7hsSXUIPZ4S5UQL8KaUy65d4W30vk77dvRzFH8RNdC1c8+Tof7twilg7UR0Z
	 kgxG+umUV6CYmGsOkvqClkzmt19JvYBcUv7JdrSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/189] rtase: Fix a check for error in rtase_alloc_msix()
Date: Wed, 15 Jan 2025 11:35:54 +0100
Message-ID: <20250115103608.675792783@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 2055272e3ae01a954e41a5afb437c5d76f758e0b ]

The pci_irq_vector() function never returns zero.  It returns negative
error codes or a positive non-zero IRQ number.  Fix the error checking to
test for negatives.

Fixes: a36e9f5cfe9e ("rtase: Add support for a pci table in this module")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Link: https://patch.msgid.link/f2ecc88d-af13-4651-9820-7cc665230019@stanley.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/rtase/rtase_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/rtase/rtase_main.c b/drivers/net/ethernet/realtek/rtase/rtase_main.c
index 1bfe5ef40c52..14ffd45e9a25 100644
--- a/drivers/net/ethernet/realtek/rtase/rtase_main.c
+++ b/drivers/net/ethernet/realtek/rtase/rtase_main.c
@@ -1827,7 +1827,7 @@ static int rtase_alloc_msix(struct pci_dev *pdev, struct rtase_private *tp)
 
 	for (i = 0; i < tp->int_nums; i++) {
 		irq = pci_irq_vector(pdev, i);
-		if (!irq) {
+		if (irq < 0) {
 			pci_disable_msix(pdev);
 			return irq;
 		}
-- 
2.39.5




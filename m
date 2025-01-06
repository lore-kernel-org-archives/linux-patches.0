Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AE4282F5;
	Mon,  6 Jan 2025 15:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179054; cv=none; b=ZmhlOzlsKY7z06Ee2VpZpHUt2+3xLN+5L/qRuSwI+oCx9YISqvbxgjBhvqOathBIAc4CuIp1Xo54CuiOQnXQeUuJK6oAtA7Yv3ZBEnaMcuNzZD5XQlSWb+M0VdR4pkUYFRWw0SN6XKxkeJ4xzy7Xj4FbhXkmGTGddJl2TNGpzeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179054; c=relaxed/simple;
	bh=v8rIU4uMv2rxromXo3FVGIL5KjUW39LnIE9x/CROV58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQtaChrKaXt9+dq4HT8OQsgBba9tOSk8iK1l0SscQfwNP5/EjS80qGPpMOBSHa/Am0L1pOcsqfnTPB0eMjcfoSv8T1uN+OI0tl1NTWcQOYGFz8sVsWw1OWylowm4dORNQjEDekc2ESugBXHNUiaxeq+qSx8avSItiJ1MTfUmcmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGMnQU1y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGMnQU1y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3B5C4CED2;
	Mon,  6 Jan 2025 15:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179054;
	bh=v8rIU4uMv2rxromXo3FVGIL5KjUW39LnIE9x/CROV58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oGMnQU1y4uyYsmG1UphIdT7cmUT03dtXet448LZcB/LnuCE1rAGxloNBWzxoRsvgy
	 8ei3kxJOEd3QPWCRvdMLp9m6p2/t5azncf/LkCGwGrAsbzjHtBFBElxgvrW5OCRbKJ
	 NaIdB5jkQSfBRbICN0kJFERiDr/rBbW4Tc6i0Vqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 12/93] net: hinic: Fix cleanup in create_rxqs/txqs()
Date: Mon,  6 Jan 2025 16:16:48 +0100
Message-ID: <20250106151129.163800647@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 7203d10e93b6e6e1d19481ef7907de6a9133a467 ]

There is a check for NULL at the start of create_txqs() and
create_rxqs() which tess if "nic_dev->txqs" is non-NULL.  The
intention is that if the device is already open and the queues
are already created then we don't create them a second time.

However, the bug is that if we have an error in the create_txqs()
then the pointer doesn't get set back to NULL.  The NULL check
at the start of the function will say that it's already open when
it's not and the device can't be used.

Set ->txqs back to NULL on cleanup on error.

Fixes: c3e79baf1b03 ("net-next/hinic: Add logical Txq and Rxq")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/0cc98faf-a0ed-4565-a55b-0fa2734bc205@stanley.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 3f739ce40201..4361e56d7dd3 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -161,6 +161,7 @@ static int create_txqs(struct hinic_dev *nic_dev)
 		hinic_clean_txq(&nic_dev->txqs[j]);
 
 	devm_kfree(&netdev->dev, nic_dev->txqs);
+	nic_dev->txqs = NULL;
 	return err;
 }
 
@@ -221,6 +222,7 @@ static int create_rxqs(struct hinic_dev *nic_dev)
 		hinic_clean_rxq(&nic_dev->rxqs[j]);
 
 	devm_kfree(&netdev->dev, nic_dev->rxqs);
+	nic_dev->rxqs = NULL;
 	return err;
 }
 
-- 
2.39.5




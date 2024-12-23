Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2A81B3922;
	Mon, 23 Dec 2024 16:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970652; cv=none; b=P5+V0jsKi7v56do1vRxSGT+/I8T3msw1U7pHSxggoloaiDpMwXWHTjnmz8K9FSY+Mj3CWiaxhpCu4kXl7vHY71A11uo8nzx6nWiVlWXha0mSNTJ8Ez316kEhYGdwhEMEXg9XtR8AtVA017sJfb6r11MsTiTDPntPZffpM1lPdOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970652; c=relaxed/simple;
	bh=PnKpsbxhIOD7i6RN/ExMPdyuCOAFwsfyn5rjg/ETb6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+/kdJMHq6p634FyIHql0M8k/fdEDJH4pstTIS+x464LCe3Ah0nJkYM3rS9PHNASjQ9VRt+3RnOsP9vuh73jjC6repVM7VdadKbMfQuF+7Ie/frtg5azk4h09ThuR/bZI2/xx+V8Gw3xavpMlHvhTBkqMdH2QBx847w3YsJi3vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=se0pVvZk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="se0pVvZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A15EC4CED3;
	Mon, 23 Dec 2024 16:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970651;
	bh=PnKpsbxhIOD7i6RN/ExMPdyuCOAFwsfyn5rjg/ETb6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=se0pVvZktJUU1BujtKYXS1OXH7b/flvFrPLtU6wq2tdt2wUDA9mtJ6I1DUxxjb8om
	 qI/rjID924toVW6s4M5/FywXIwRzzPZnUlZGiMeZVLpmYJ8WmiIEtd2RXqZNeMFxJT
	 EuEgBD2owgtHNpyYJ8ut04QHZtgTJeANfAS/Ndis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 28/83] net: hinic: Fix cleanup in create_rxqs/txqs()
Date: Mon, 23 Dec 2024 16:59:07 +0100
Message-ID: <20241223155354.733906034@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2d6906aba2a2..af6100e5d9b9 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -172,6 +172,7 @@ static int create_txqs(struct hinic_dev *nic_dev)
 	hinic_sq_dbgfs_uninit(nic_dev);
 
 	devm_kfree(&netdev->dev, nic_dev->txqs);
+	nic_dev->txqs = NULL;
 	return err;
 }
 
@@ -268,6 +269,7 @@ static int create_rxqs(struct hinic_dev *nic_dev)
 	hinic_rq_dbgfs_uninit(nic_dev);
 
 	devm_kfree(&netdev->dev, nic_dev->rxqs);
+	nic_dev->rxqs = NULL;
 	return err;
 }
 
-- 
2.39.5




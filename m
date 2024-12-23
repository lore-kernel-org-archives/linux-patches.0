Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC74319E971;
	Mon, 23 Dec 2024 16:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970334; cv=none; b=FDbWlJ0NM2zi3GmpQ6agBScg1rtqlyenOLog1y82t4R+iJGoKuSCVVvO4IP+HQsr7CtpWXM7CYTrubIawN+8JRUxxmDiqclrSl57Q6vLT24bqAZupOoRN8Z0YIoDyrvGtJElu2vh4G8aAx4TukheDpFKG5DU2Q/hduQ/Da+x+Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970334; c=relaxed/simple;
	bh=0NIeXSBSYir6Q4pq0mTg4+NSgMFy+bUtwVNZFlI3hNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=invSdR+bm3VDX2XCZJH9Rdbhd8qrC76HJdEfijCun2A0VWtHb8gMZU5V80PhM4u6mR3OhFKwKhYuEfO9GAMKOc4hNYAVrvhJYCVdePCBoBlCTOegpXQZPOj8/mPfyOn7ZA7VLFAkiKPnbctGfdv/Sby7Xl1Wq5s8Y5Fmkn15YKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CWfGE6Ep; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CWfGE6Ep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA91C4CED3;
	Mon, 23 Dec 2024 16:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970334;
	bh=0NIeXSBSYir6Q4pq0mTg4+NSgMFy+bUtwVNZFlI3hNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CWfGE6Epl+bwjbACpEWmyizqtJJRc30QFqt6YS5liXM63pC+bK8ILS3/MELi2WyYt
	 NCy0XJkPW759gVP9Obg47CsygB9Up1iXi9KrvdA9qOQZi8rcneqM3/juyAJjom0UDY
	 iW2plAydEUJOt6CiDtS/VNK38uPrYJWePu3nUXn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/116] net: hinic: Fix cleanup in create_rxqs/txqs()
Date: Mon, 23 Dec 2024 16:58:42 +0100
Message-ID: <20241223155401.583951631@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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
index 499c657d37a9..579c3dc0014c 100644
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




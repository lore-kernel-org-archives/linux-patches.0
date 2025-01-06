Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19CF1D7999;
	Mon,  6 Jan 2025 15:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178561; cv=none; b=U3arpuziJmRTWNv5wQZNBNdG2hE3UK7wFfq2RBJo+CMPdpNQRstbNr4nu0vWsYsuuf7Rbb4NCOXZyQxqWHYNXC6DLsbJkf5rxs5YNkE6vtRVLAtBc9UA8GpUxVbiRjH7/8hf+DHqFvUzFWO/SLMN6wWkQtm/VLQJc3o4uTuQkOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178561; c=relaxed/simple;
	bh=PO0YhgN1DEWpkqT5RLEkrDgS0tephXKLJ+jzF47ypVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxyvYMXdpf9lgZglyOYL+kfKBeTiz4Qeis/4A01qqKH+w2z0IEfLdNbw1I0GK03uLJeY5ZwnMvDRSMdQkLYHfANj9/S/iuozgUT7UNhGQk9xRTB0/v+FPgByJK/yqiiBsUdZfSlRm4otQRgzaheHQhqSHHopSf8jH+4hApBNB5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IhBVmQp+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IhBVmQp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D60C4CED2;
	Mon,  6 Jan 2025 15:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178561;
	bh=PO0YhgN1DEWpkqT5RLEkrDgS0tephXKLJ+jzF47ypVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IhBVmQp+9GopzThtkx6T9hGFXMV3LKxdMW/GiJUdsKIprhL9QrOqWuxA5hcDvAq1t
	 OKf9WQP8+q2BsRtUSbaUqbCtJe8JVshhMkSil3chz1uTjPLiDYUm4jqklZowmKUibf
	 bk1+wUb5l33UAW3C6s2RNyy9jGh+ESMcFAy5LRwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/168] net: hinic: Fix cleanup in create_rxqs/txqs()
Date: Mon,  6 Jan 2025 16:15:28 +0100
Message-ID: <20250106151139.226130916@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 92fba9a0c371..a65b20bafcb0 100644
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




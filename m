Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD463AB277;
	Mon, 23 Mar 2026 15:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278259; cv=none; b=eNL6mBYVOdUNVQqYhyaA8W3+I5H+54LmDIjTPwyBbk223eP1bY3TYvYXgMv5asBgUWLeEHjNp+mIIxSk415AK1FbCmDpE7NQd0hJLumHHR63aeiL16r9vxAD9yZxNL1F2MrWmYgqKR+RYUz2+c4glK+YqGq7K8DLmmdhj5trwVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278259; c=relaxed/simple;
	bh=ArLrOOjLH+TjQnqOjuMqE3olKb6HPPgutZA2Nrnl1GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5dtoYn0c/ouIFPnKRH4NIdqinqJ6BO797oennkPia09UOO8Vp8gzgVBNEEo0rZgsTkv31GT1u/7jgVruHNPYtzVP+vgrqdDJdYA6mo9uuQ9O8cYDHLrCQRr7OzhXuS4X4SwExVs73KQF6fbiMtbeqtVLA2r0WEmeF2YiEopcDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wkda3gDM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wkda3gDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54CF1C4CEF7;
	Mon, 23 Mar 2026 15:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278259;
	bh=ArLrOOjLH+TjQnqOjuMqE3olKb6HPPgutZA2Nrnl1GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wkda3gDM94LpBNpILt5xTN0dV4rDz7a+utiOR6nPqTIGK3Bnl25EPG7mlrXSGcAQ3
	 1tJUXd9lB5ZHDF6vlxVkNLs2OZswUlIwtVmp3AlowymbHbLzNIIr8+F9ssTVlM83A2
	 vEufjHXStoLQoiox5993AZOMw9KT8HRASNJLEApk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Vollrath <tactii@gmail.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 251/567] e1000/e1000e: Fix leak in DMA error cleanup
Date: Mon, 23 Mar 2026 14:42:51 +0100
Message-ID: <20260323134540.046239370@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Vollrath <tactii@gmail.com>

[ Upstream commit e94eaef11142b01f77bf8ba4d0b59720b7858109 ]

If an error is encountered while mapping TX buffers, the driver should
unmap any buffers already mapped for that skb.

Because count is incremented after a successful mapping, it will always
match the correct number of unmappings needed when dma_error is reached.
Decrementing count before the while loop in dma_error causes an
off-by-one error. If any mapping was successful before an unsuccessful
mapping, exactly one DMA mapping would leak.

In these commits, a faulty while condition caused an infinite loop in
dma_error:
Commit 03b1320dfcee ("e1000e: remove use of skb_dma_map from e1000e
driver")
Commit 602c0554d7b0 ("e1000: remove use of skb_dma_map from e1000 driver")

Commit c1fa347f20f1 ("e1000/e1000e/igb/igbvf/ixgb/ixgbe: Fix tests of
unsigned in *_tx_map()") fixed the infinite loop, but introduced the
off-by-one error.

This issue may still exist in the igbvf driver, but I did not address it
in this patch.

Fixes: c1fa347f20f1 ("e1000/e1000e/igb/igbvf/ixgb/ixgbe: Fix tests of unsigned in *_tx_map()")
Assisted-by: Claude:claude-4.6-opus
Signed-off-by: Matt Vollrath <tactii@gmail.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c | 2 --
 drivers/net/ethernet/intel/e1000e/netdev.c    | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index d015a0a85f078..8dcb5d7c5a4b3 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -2951,8 +2951,6 @@ static int e1000_tx_map(struct e1000_adapter *adapter,
 dma_error:
 	dev_err(&pdev->dev, "TX DMA map failed\n");
 	buffer_info->dma = 0;
-	if (count)
-		count--;
 
 	while (count--) {
 		if (i == 0)
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 7e4fea0e186b6..9e9138ccac421 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5633,8 +5633,6 @@ static int e1000_tx_map(struct e1000_ring *tx_ring, struct sk_buff *skb,
 dma_error:
 	dev_err(&pdev->dev, "Tx DMA map failed\n");
 	buffer_info->dma = 0;
-	if (count)
-		count--;
 
 	while (count--) {
 		if (i == 0)
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCC52FF140;
	Tue, 12 Aug 2025 18:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022514; cv=none; b=JIQsSvKMyJkZ2sV5jImD1pofglSUGynezCnHMqj6jQz5lXwvP/1FtN6kkqJGUrkaQ4ZIfu4r1ANHBSGJaWDxPtUMwSJTUFf5eFmhlEQa9LB+fxeE6463WF/1CsqSu1PkQWM0ZD+FqBTd86CLYwvAKgAEAGEWSJVfSdcoxf8ipks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022514; c=relaxed/simple;
	bh=6bnIt055m9ci9T9VLN9FqSK5qTviPH70pnSog6PTCTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQR3gHWhmFtq0oh7gAqURlJyJIvp3WSWOZx6HM5LbZidgV1/jPIkskKRqaAURVcIHVIiYPfXTELcjxvWV/Xgxkcou+qEDaZm6wp4f9BoiVTrYOvFycem1vfokVtMsGcEuO1DlFxiUAgjp/TB8zr2Nch4Q1ncuzpjC+uBp2aafYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0iIaopv+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0iIaopv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D41BC4CEF0;
	Tue, 12 Aug 2025 18:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022513;
	bh=6bnIt055m9ci9T9VLN9FqSK5qTviPH70pnSog6PTCTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0iIaopv+0IlAztXGjdObA64RfQ9930l8pf0nH7gZBwxy47CworbIV/QKlOrfUWJri
	 oYT1Oko9ib+Zdfth4NTJk1m6g3WL/t+g4nunTg9dbjjCi6hksxGT8+akIFFGnCAJFg
	 4UMdm/wrOFOo0u7Bn4/cXn9/nrL0mxeThkcrYbLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 143/369] stmmac: xsk: fix negative overflow of budget in zerocopy mode
Date: Tue, 12 Aug 2025 19:27:20 +0200
Message-ID: <20250812173020.152362988@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Jason Xing <kernelxing@tencent.com>

[ Upstream commit 2764ab51d5f0e8c7d3b7043af426b1883e3bde1d ]

A negative overflow can happen when the budget number of descs are
consumed. as long as the budget is decreased to zero, it will again go
into while (budget-- > 0) statement and get decreased by one, so the
overflow issue can happen. It will lead to returning true whereas the
expected value should be false.

In this case where all the budget is used up, it means zc function
should return false to let the poll run again because normally we
might have more data to process. Without this patch, zc function would
return true instead.

Fixes: 132c32ee5bc0 ("net: stmmac: Add TX via XDP zero-copy socket")
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Link: https://patch.msgid.link/20250723142327.85187-2-kerneljasonxing@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 36328298dc9b..058cd9e9fd71 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2500,7 +2500,7 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 
 	budget = min(budget, stmmac_tx_avail(priv, queue));
 
-	while (budget-- > 0) {
+	for (; budget > 0; budget--) {
 		struct stmmac_metadata_request meta_req;
 		struct xsk_tx_metadata *meta = NULL;
 		dma_addr_t dma_addr;
-- 
2.39.5




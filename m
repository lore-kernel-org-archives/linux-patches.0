Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C0686347;
	Tue, 27 May 2025 17:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367843; cv=none; b=V95JGzJWERSB2vsSgPOtVzuAdbniDekwcVwoWqnobN2hF/2R1PbVTvRs06WAE2cHyx6nx+577nWv4DQmFYk7wb3vPehauc227zLu2fOVX0V79u0Te3uNyQ4w0MkoFsBwkq2cmOR94JzV7aEqUbjnOjE3831lq2/JYlWrP6i8xXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367843; c=relaxed/simple;
	bh=sBTN21Ca1Rdv6rP3PrKY9P/+NmWaXg8ZpsKQQRz0uX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C03MSgf8dqqZT/rDcGk5VWwcJ+ItkMRUeRXkacc/lsK0js3WeAnyiH3c2mHor1Ru3c8why+lRxdETI3sG7MLd25zFSdVhNxVTmEAxpwkFGFCo1mtvysgjB70e1cBA1YN0e0Xr2EtbXaPXtKXAc7z5iVFnpDQIJ4za8Ez0pVNppk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9lAghuR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9lAghuR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F83C4CEE9;
	Tue, 27 May 2025 17:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367843;
	bh=sBTN21Ca1Rdv6rP3PrKY9P/+NmWaXg8ZpsKQQRz0uX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m9lAghuRZD4kv9bg5VHUqAdGx19RU1YbOg3DDZjhMo50vWd+0AgXbk5nf5uR7lddC
	 LhpAFLfIbo34NmYeDAkYn5SAjC8xqUyvnrCTRgBY7i5HnDTFtHJtqlWplIH4F/9ojy
	 8hK+q32m1IW6wFpa3JqCIGEdY0TxH3ogqPTIyjkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanteng Si <si.yanteng@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Chong Qiao <qiaochong@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 476/783] net: stmmac: dwmac-loongson: Set correct {tx,rx}_fifo_size
Date: Tue, 27 May 2025 18:24:33 +0200
Message-ID: <20250527162532.512214776@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 8dbf0c7556454b52af91bae305ca71500c31495c ]

Now for dwmac-loongson {tx,rx}_fifo_size are uninitialised, which means
zero. This means dwmac-loongson doesn't support changing MTU because in
stmmac_change_mtu() it requires the fifo size be no less than MTU. Thus,
set the correct tx_fifo_size and rx_fifo_size for it (16KB multiplied by
queue counts).

Here {tx,rx}_fifo_size is initialised with the initial value (also the
maximum value) of {tx,rx}_queues_to_use. So it will keep as 16KB if we
don't change the queue count, and will be larger than 16KB if we change
(decrease) the queue count. However stmmac_change_mtu() still work well
with current logic (MTU cannot be larger than 16KB for stmmac).

Note: the Fixes tag picked here is the oldest commit and key commit of
the dwmac-loongson series "stmmac: Add Loongson platform support".

Acked-by: Yanteng Si <si.yanteng@linux.dev>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Chong Qiao <qiaochong@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Link: https://patch.msgid.link/20250210134328.2755328-1-chenhuacai@loongson.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index ab7c2750c1042..702ea5a00b56d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -590,6 +590,9 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 	if (ret)
 		goto err_disable_device;
 
+	plat->tx_fifo_size = SZ_16K * plat->tx_queues_to_use;
+	plat->rx_fifo_size = SZ_16K * plat->rx_queues_to_use;
+
 	if (dev_of_node(&pdev->dev))
 		ret = loongson_dwmac_dt_config(pdev, plat, &res);
 	else
-- 
2.39.5




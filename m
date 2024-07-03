Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBFD17B4FF;
	Wed,  3 Jul 2024 11:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004873; cv=none; b=q1ja/H8svH51LkfeiEX8oigJz7dMUAXNURKTj6UsX1f6ApUT2PKQWkdcl+UQ8l2U4IpKAthmCCUBjqU4/oFpxWWZ6KSHdw6VpZNRFRIf1SmMD1BSkM3IJ4fSJ1qjlbqrMwvucu/ZaMjCs3bfmmNLEy2gtsjW3Tsq/YsgOCmp2ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004873; c=relaxed/simple;
	bh=nZinGYq71OO1im5OxhMBZiHghAYrr+PNApAKzscaRYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtqcnbDa3dF+GuEivnCdzl7Lcn8hRBtryLugWkxDClDUxQJkIwkv2V3vDS4qbfi7sUSjSA72Iwu/tWU7O627WgwCe//tSdWU0wmduPsxIicoB1XfakG1mV4YI8E64oI2aSOcP4jz5YwfOBceTCFJULvGyEyRZrISY33B3ZzjSI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FDXN4hy5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FDXN4hy5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B51DC2BD10;
	Wed,  3 Jul 2024 11:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004873;
	bh=nZinGYq71OO1im5OxhMBZiHghAYrr+PNApAKzscaRYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FDXN4hy5culKGc92lihzXEzoIcqzpOBYmNNwQwrc6WO85hfuVQgKHxAQBCZvEMqJ3
	 KkCaAOo/Vbyd3hLQfwwPF8m/3viPwtZBP19btw1a44BJvLinRNy/ir0COl3+VjNqgR
	 7GdPZgW9N+5hRH3QXxKVfCJj0aOHypHQmeEH3Jis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 184/290] r8169: remove unneeded memory barrier in rtl_tx
Date: Wed,  3 Jul 2024 12:39:25 +0200
Message-ID: <20240703102911.121316346@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 3a689e34973e8717cd57991c6fcf527dc56062b5 ]

tp->dirty_tx isn't changed outside rtl_tx(). Therefore I see no need
to guarantee a specific order of reading tp->dirty_tx and tp->cur_tx.
Having said that we can remove the memory barrier.
In addition use READ_ONCE() when reading tp->cur_tx because it can
change in parallel to rtl_tx().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/2264563a-fa9e-11b0-2c42-31bc6b8e2790@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c71e3a5cffd5 ("r8169: Fix possible ring buffer corruption on fragmented Tx packets.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index c29d43c5f4504..84c8362a65cd1 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4472,9 +4472,8 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 	unsigned int dirty_tx, tx_left, bytes_compl = 0, pkts_compl = 0;
 
 	dirty_tx = tp->dirty_tx;
-	smp_rmb();
 
-	for (tx_left = tp->cur_tx - dirty_tx; tx_left > 0; tx_left--) {
+	for (tx_left = READ_ONCE(tp->cur_tx) - dirty_tx; tx_left; tx_left--) {
 		unsigned int entry = dirty_tx % NUM_TX_DESC;
 		struct sk_buff *skb = tp->tx_skb[entry].skb;
 		u32 status;
-- 
2.43.0




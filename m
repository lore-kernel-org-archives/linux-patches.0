Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60EAD37AA71;
	Mon,  9 Feb 2026 14:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648251; cv=none; b=NYBCKcJzt+3og6JrHMWSYoIvOnjqHoOWfl/Rh55vJmijCATLUm5BzlvO4UnqBuYhc0oh3h9ui745sjPFf87wdEI58RO22HItDyuc9CDpdR0rM6jJvjWQGEo4Q911xoc2a73EJr1JKNtqxkkM5GpqrHQfnpjdc3f60qTM/2rkOWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648251; c=relaxed/simple;
	bh=/SE5cmkL83MPj9PtO90Fnn5AsGQPd9luilVS8TWUS34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDFggJ1p7cW3rE5Wr2WP4G64bevFV0meM4en7BZ79a7i5Iz9K40FIVPrhMnQwid09AGZtR6TBba/m3+CpLSAGlo8zyuxiUldTt88KE3xt8745OIXMvIubSZsLLBuQ2Xdb4GBJA3+85NLBThwHBuEx5rQyDHkw+7fF8a91JOyTr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nN1pZA9L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nN1pZA9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B3DC116C6;
	Mon,  9 Feb 2026 14:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648251;
	bh=/SE5cmkL83MPj9PtO90Fnn5AsGQPd9luilVS8TWUS34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nN1pZA9Lyra86qscrPHSXKd6uxwWH5S1QIVeL2uWGAH2lics8tHZh82MxMY37vyrP
	 UsdIykXtX2qREo8+D0AAohjFjUIjuX3W5hBpHVR8bz5uzzeFdiqqW+Zhb4BArR53GU
	 5fmfP6H9C86Jf20vCkv8nVg+jg3nX30FBqWX5MAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 52/69] dpaa2-switch: add bounds check for if_id in IRQ handler
Date: Mon,  9 Feb 2026 15:24:20 +0100
Message-ID: <20260209142303.796483405@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 31a7a0bbeb006bac2d9c81a2874825025214b6d8 ]

The IRQ handler extracts if_id from the upper 16 bits of the hardware
status register and uses it to index into ethsw->ports[] without
validation. Since if_id can be any 16-bit value (0-65535) but the ports
array is only allocated with sw_attr.num_ifs elements, this can lead to
an out-of-bounds read potentially.

Add a bounds check before accessing the array, consistent with the
existing validation in dpaa2_switch_rx().

Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Reported-by: Junrui Luo <moonafterrain@outlook.com>
Fixes: 24ab724f8a46 ("dpaa2-switch: use the port index in the IRQ handler")
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://patch.msgid.link/SYBPR01MB7881D420AB43FF1A227B84AFAF91A@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 801956c048752..c08d8d5e47e12 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1513,6 +1513,10 @@ static irqreturn_t dpaa2_switch_irq0_handler_thread(int irq_num, void *arg)
 	}
 
 	if_id = (status & 0xFFFF0000) >> 16;
+	if (if_id >= ethsw->sw_attr.num_ifs) {
+		dev_err(dev, "Invalid if_id %d in IRQ status\n", if_id);
+		goto out;
+	}
 	port_priv = ethsw->ports[if_id];
 
 	if (status & DPSW_IRQ_EVENT_LINK_CHANGED) {
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9C614293;
	Tue,  2 Jul 2024 17:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940906; cv=none; b=Hyn6a6yLFkWC+zWz8NQuaxQVm7kqRTYAElJimAKZGPRjTLqA+qocnJLE/8QujXHvrfna+qB+N73tgF8ArUoeGzLOpYiGwZ/CD+ZK3HbIT5RzaQHFrlV1LDLqqNr+p9eExDodvPNPQA2QplqX3CXcxqohp5hJcjO5e3hCoYWOlZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940906; c=relaxed/simple;
	bh=dhQBW0MW1rrYZ5ZAAuuBj38aw4qt1SZwjEDIiR6IcQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hr321D2+22kvXso8XtO5B2fu2CSwF1V1uGypQJoLb2w/RbJhEdDXiuZmZLQxeI0KqbztfS7QqQ1gisTVAXlE84FZlTfOeEXnLB5Zx13nLLEW2wKRwqIMVZl3gToXrUSHBBsR2UyhWD9cVY2UMzYXk8PO4DVcXrPNQNUcAOXz96Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpnvoHsO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpnvoHsO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5433EC116B1;
	Tue,  2 Jul 2024 17:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940905;
	bh=dhQBW0MW1rrYZ5ZAAuuBj38aw4qt1SZwjEDIiR6IcQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RpnvoHsOYkcYc4TL51bx1FtfdpTVSVzf8zIoj46VYuvpRk/DVGYOzvj/r9c7mnuG/
	 Elivsg9EcddRN6Wa/sZ/UEooSIAYIfmOXxpizV1eAitez/RJVxBPKafCIqzbIYRasR
	 vBm6vJLo22bO32bN9OEwbC6yiwt6IHwWYMHZqJ2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristram Ha <tristram.ha@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/163] net: dsa: microchip: fix wrong register write when masking interrupt
Date: Tue,  2 Jul 2024 19:02:35 +0200
Message-ID: <20240702170234.615504789@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

From: Tristram Ha <tristram.ha@microchip.com>

[ Upstream commit b1c4b4d45263241ec6c2405a8df8265d4b58e707 ]

The switch global port interrupt mask, REG_SW_PORT_INT_MASK__4, is
defined as 0x001C in ksz9477_reg.h.  The designers used 32-bit value in
anticipation for increase of port count in future product but currently
the maximum port count is 7 and the effective value is 0x7F in register
0x001F.  Each port has its own interrupt mask and is defined as 0x#01F.
It uses only 4 bits for different interrupts.

The developer who implemented the current interrupt mechanism in the
switch driver noticed there are similarities between the mechanism to
mask port interrupts in global interrupt and individual interrupts in
each port and so used the same code to handle these interrupts.  He
updated the code to use the new macro REG_SW_PORT_INT_MASK__1 which is
defined as 0x1F in ksz_common.h but he forgot to update the 32-bit write
to 8-bit as now the mask registers are 0x1F and 0x#01F.

In addition all KSZ switches other than the KSZ9897/KSZ9893 and LAN937X
families use only 8-bit access and so this common code will eventually
be changed to accommodate them.

Fixes: e1add7dd6183 ("net: dsa: microchip: use common irq routines for girq and pirq")
Signed-off-by: Tristram Ha <tristram.ha@microchip.com>
Link: https://lore.kernel.org/r/1719009262-2948-1-git-send-email-Tristram.Ha@microchip.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 3c2a2b5290e5b..1c3f186499989 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1973,7 +1973,7 @@ static void ksz_irq_bus_sync_unlock(struct irq_data *d)
 	struct ksz_device *dev = kirq->dev;
 	int ret;
 
-	ret = ksz_write32(dev, kirq->reg_mask, kirq->masked);
+	ret = ksz_write8(dev, kirq->reg_mask, kirq->masked);
 	if (ret)
 		dev_err(dev->dev, "failed to change IRQ mask\n");
 
-- 
2.43.0




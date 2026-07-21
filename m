Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D002E4071E3;
	Tue, 21 Jul 2026 18:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660281; cv=none; b=jqOZofBq7l1traHkqnZX1I7iHQeyPQPhfms4T3PZIEoSCjBHWwOub5x3D2NK3souA5gvWcmPxxEFCo/jBYqvSiXfb/yWX+9/jPDYHcMr/OF5BRClx3sAGEm9wJIIfBZSfvvIX4750a4q8pGBt7qtCUSAqV/mjQpQpVnx4t5NTuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660281; c=relaxed/simple;
	bh=T0RG8fPw197hkzX/+p5EZJAfmlt4QyAlguG9IpS8MJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUq88xlf4wRVyXVD92ntJZlFiijgMEcSvjqoBsNJJly8mNPrhQzXqRnYPXtOMpFvRrQXdzB8nItDj5nbvQc6nmTB+HAw4WWomrGgVU9buXJG2kdXEm9FmjgORuL/stt7dkD0JtRUkPIH7Spe8sSrJNJ/jSf9HZNMGFVbwQSG00I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJtkgUD1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJtkgUD1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3933A1F000E9;
	Tue, 21 Jul 2026 18:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660279;
	bh=Fuf2Tv8RHPMiwMZO/UVEIJjesQpdXHJ2Wot6iAWfsEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sJtkgUD12Hn6AJuoIayUwJ4fHxHsuP7zSAmF0K06QDBI6pMCh30Hj2RryMHIGC3f6
	 oVxYJNIZOiFpn9gzJePjUAXNHYhVB+veF3Zc+Mie50PrbIUcV4E6aQ156K3gpcrSiI
	 FKuoezQ5VaOV59aPVlcwfvtATok9a4TBt0DyYn00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0877/2077] mailbox: mpfs: fix check for syscon presence in mpfs_mbox_inbox_isr()
Date: Tue, 21 Jul 2026 17:09:10 +0200
Message-ID: <20260721152613.478900735@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit e30d8b2730a33e5e8789371e947c3529789a6070 ]

mpfs_mbox_inbox_isr() writes to the sysreg scb syscon, not the control
scb syscon, but checks for the presence of the latter. Ultimately this
makes little difference because if one syscon is present, both will be.

Fixes: a4123ffab9ece ("mailbox: mpfs: support new, syscon based, devicetree configuration")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox-mpfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/mailbox-mpfs.c b/drivers/mailbox/mailbox-mpfs.c
index d5d9effece9797..ef40fe2be30d65 100644
--- a/drivers/mailbox/mailbox-mpfs.c
+++ b/drivers/mailbox/mailbox-mpfs.c
@@ -201,7 +201,7 @@ static irqreturn_t mpfs_mbox_inbox_isr(int irq, void *data)
 	struct mbox_chan *chan = data;
 	struct mpfs_mbox *mbox = (struct mpfs_mbox *)chan->con_priv;
 
-	if (mbox->control_scb)
+	if (mbox->sysreg_scb)
 		regmap_write(mbox->sysreg_scb, MESSAGE_INT_OFFSET, 0);
 	else
 		writel_relaxed(0, mbox->int_reg);
-- 
2.53.0




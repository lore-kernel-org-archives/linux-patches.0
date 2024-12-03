Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6C91AB6C9;
	Tue,  3 Dec 2024 15:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241264; cv=none; b=DPxz7IVrXdF+gR7My2iDK12v4N1djaVegrTne2H7j3K2L1XSlsEw6bRvw1GnJLOZUvOXGBjJ8pkEYMwyfJ3V8RE/Cm/fyPxOJFDpjJCTlXPFVxwo6TQ5w5a0gfyyCEmu/oR1sb5K7nxRp2IDV7OrcsuYfJCSXnbsEWgRsfwS+Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241264; c=relaxed/simple;
	bh=Sii21n9pKipmWVgWPcFR+mvypjtOVBOuPKXVGclHcz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2mk5N0F9BbxSEDpKCHl78XQamUi2RvdB5vTiJB1KO+KeG9YcGS/pV3onb00aq1AntKm/ZdVWpvQcBpx/5NlE90S0WuAi5N/4U8KtX8n+Kz98F7okcwCjJX71ySUh+IpcCVARWynNzdE3VCErwkcV4dIfbixOcTPY9rf9G97bj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gV9n9Bjt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gV9n9Bjt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E39FC4CECF;
	Tue,  3 Dec 2024 15:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241264;
	bh=Sii21n9pKipmWVgWPcFR+mvypjtOVBOuPKXVGclHcz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gV9n9BjtSpZ53TtbgA98SKL5VdX+fRDg+FxsS9xKdRu6zunRYHIoQtLOh608JYcv9
	 EL6LTqGn0WgIV/cVwVRjDJn+nTkJ9kW2fctxm8y5RexqOT7xdVprFlWAH2qS9FvTmn
	 uoUoBzASIfIwbopaksgUG5TcjOwsMPABsz9jhAq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 370/826] mfd: tps65010: Use IRQF_NO_AUTOEN flag in request_irq() to fix race
Date: Tue,  3 Dec 2024 15:41:37 +0100
Message-ID: <20241203144758.197053622@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 2174f9a8c9db50f74df769edd5a4ab822c73b6d2 ]

As the comment said, disable_irq() after request_irq() still has a
time gap in which interrupts can come. request_irq() with IRQF_NO_AUTOEN
flag will disable IRQ auto-enable when request IRQ.

Fixes: 72cd799544f2 ("[PATCH] I2C: add i2c driver for TPS6501x")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://lore.kernel.org/r/20240912031530.2211654-1-ruanjinjie@huawei.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/tps65010.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/tps65010.c b/drivers/mfd/tps65010.c
index 2b9105295f301..710364435b6b9 100644
--- a/drivers/mfd/tps65010.c
+++ b/drivers/mfd/tps65010.c
@@ -544,17 +544,13 @@ static int tps65010_probe(struct i2c_client *client)
 	 */
 	if (client->irq > 0) {
 		status = request_irq(client->irq, tps65010_irq,
-				     IRQF_TRIGGER_FALLING, DRIVER_NAME, tps);
+				     IRQF_TRIGGER_FALLING | IRQF_NO_AUTOEN,
+				     DRIVER_NAME, tps);
 		if (status < 0) {
 			dev_dbg(&client->dev, "can't get IRQ %d, err %d\n",
 					client->irq, status);
 			return status;
 		}
-		/* annoying race here, ideally we'd have an option
-		 * to claim the irq now and enable it later.
-		 * FIXME genirq IRQF_NOAUTOEN now solves that ...
-		 */
-		disable_irq(client->irq);
 		set_bit(FLAG_IRQ_ENABLE, &tps->flags);
 	} else
 		dev_warn(&client->dev, "IRQ not configured!\n");
-- 
2.43.0




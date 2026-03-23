Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D3337F8A0;
	Mon, 23 Mar 2026 14:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275534; cv=none; b=TJHGR7iSx658lY8wzpkHgQe0edychz+yMo2Jx6pmrcGB4VvMQMunYvE0dpJ4BcS6QjGTCJdh1Dbxp9oG+ZVlBY90zCfBTIrwfiTK2Ng0yjV+RZ3Kl78S9IAGlEPyqXvYUDyhS8gouTIVrfI5qE/pxrTwlrHWMiGlHAnugt30O0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275534; c=relaxed/simple;
	bh=GhauMfbF2bKgyWoME98GNhxRU2NgENRYTJ5q8UoqNj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IC+xQPA2SHZ04zKU3sp4YOX1wDR1v0h1UXNwbvAB9cIMkJYUlHdFWTubfeEs5dSw5TXoy4bfHVckhg/Fh+Ju9ptC46VkDeIDqs4Ko9r8lKfgA9sSsVyqy1dzAiM+Z5oBAF6PD4MHl43v1198j6/s+f2rdCFgLc6BbIMtuY6pgDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NFNi6SCt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NFNi6SCt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1F7C4CEF7;
	Mon, 23 Mar 2026 14:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275534;
	bh=GhauMfbF2bKgyWoME98GNhxRU2NgENRYTJ5q8UoqNj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NFNi6SCt3zr8d+QSYslc+mv/g5G+CcPuncQ5nP+wZmS3VA///Y3tjI82jUL80t9CX
	 sbwS2IZp0MtPXN+ps4JJjdLvfC6+5Q00Gg4q9BsQ0tgBp0prrPQsxU4XmTw0BlLBko
	 3dGJB0dgIwcEjG6MmYMW8xI49HzGwpCi9iPPhvm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Ng Ho Yin <adrianhoyin.ng@altera.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 134/460] i3c: dw-i3c-master: Set SIR_REJECT in DAT on device attach and reattach
Date: Mon, 23 Mar 2026 14:42:10 +0100
Message-ID: <20260323134529.895455575@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Ng Ho Yin <adrianhoyin.ng@altera.com>

[ Upstream commit f311a05784634febd299f03476b80f3f18489767 ]

The DesignWare I3C master controller ACKs IBIs as soon as a valid
Device Address Table (DAT) entry is present. This can create a race
between device attachment (after DAA) and the point where the client
driver enables IBIs via i3c_device_enable_ibi().

Set DEV_ADDR_TABLE_SIR_REJECT in the DAT entry during
attach_i3c_dev() and reattach_i3c_dev() so that IBIs are rejected
by default. The bit is managed thereafter by the existing
dw_i3c_master_set_sir_enabled() function, which clears it in
enable_ibi() after ENEC is issued, and restores it in disable_ibi()
after DISEC.

Fixes: 1dd728f5d4d4 ("i3c: master: Add driver for Synopsys DesignWare IP")
Signed-off-by: Adrian Ng Ho Yin <adrianhoyin.ng@altera.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/53f5b8cbdd8af789ec38b95b02873f32f9182dd6.1770962368.git.adrianhoyin.ng@altera.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/dw-i3c-master.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i3c/master/dw-i3c-master.c b/drivers/i3c/master/dw-i3c-master.c
index 4c019c746f231..e0853a6bde0a4 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -1013,7 +1013,7 @@ static int dw_i3c_master_reattach_i3c_dev(struct i3c_dev_desc *dev,
 		master->free_pos &= ~BIT(pos);
 	}
 
-	writel(DEV_ADDR_TABLE_DYNAMIC_ADDR(dev->info.dyn_addr),
+	writel(DEV_ADDR_TABLE_DYNAMIC_ADDR(dev->info.dyn_addr) | DEV_ADDR_TABLE_SIR_REJECT,
 	       master->regs +
 	       DEV_ADDR_TABLE_LOC(master->datstartaddr, data->index));
 
@@ -1042,7 +1042,7 @@ static int dw_i3c_master_attach_i3c_dev(struct i3c_dev_desc *dev)
 	master->free_pos &= ~BIT(pos);
 	i3c_dev_set_master_data(dev, data);
 
-	writel(DEV_ADDR_TABLE_DYNAMIC_ADDR(master->devs[pos].addr),
+	writel(DEV_ADDR_TABLE_DYNAMIC_ADDR(master->devs[pos].addr) | DEV_ADDR_TABLE_SIR_REJECT,
 	       master->regs +
 	       DEV_ADDR_TABLE_LOC(master->datstartaddr, data->index));
 
-- 
2.51.0




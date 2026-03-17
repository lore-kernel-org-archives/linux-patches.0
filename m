Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88EB3EC2F1;
	Tue, 17 Mar 2026 16:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766190; cv=none; b=utOhDU95e0OWOIBb5y7dQup5LcN1FXhHyTrwLP7qFVPvdVwAfZYJzqHukWJatYOlrWcm4fbaJBguQZTkIuXpPNlTxDh7XLtyja9GH4Fm3UqdlxBuxFJCuAS5XMu0+CbcfLccLQb630miEaUawaSMRfJ/FbLafhDRKIVXgPk11ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766190; c=relaxed/simple;
	bh=FJsK7LQENqefdTVT8NCcOMJru6X8mShX6+wc73okjIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GsZNRkalJBUn4iUp7TIseH6n9Zaxw64PGGBwEkc5nl0+4wuM7sypRXOnhIaslCXEu3rCu+rEfnZ6g5hX35ME8w1dq/hSt76GsKH1pKJh0Uy8gQwy8naXbu3B4NarGFgNg+lB6S4yiSUsoAm3Gw/DBXh4NkI3IhCKzkGPaYVr2GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XGpiBXna; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XGpiBXna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0249DC4CEF7;
	Tue, 17 Mar 2026 16:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766190;
	bh=FJsK7LQENqefdTVT8NCcOMJru6X8mShX6+wc73okjIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XGpiBXnaCdkq2rN485/ULXMCJhC78h8A9kCk06O9j8iWQTcP+e0nXDvFniOzEdk5A
	 aXq6V+7TB3CN1YhMwEO9MKGj3ZFixwuy3OtFxSwo4yTCElXJRHxD0awyQkkPIVPbhR
	 piewTA9UAEADoQuoTxd5+tw6VaeZRsU6ceZ0s3hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Ng Ho Yin <adrianhoyin.ng@altera.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 189/378] i3c: dw-i3c-master: Set SIR_REJECT in DAT on device attach and reattach
Date: Tue, 17 Mar 2026 17:32:26 +0100
Message-ID: <20260317163013.960572431@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 4033bc16677ff..f9b981abd10c5 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -1010,7 +1010,7 @@ static int dw_i3c_master_reattach_i3c_dev(struct i3c_dev_desc *dev,
 		master->free_pos &= ~BIT(pos);
 	}
 
-	writel(DEV_ADDR_TABLE_DYNAMIC_ADDR(dev->info.dyn_addr),
+	writel(DEV_ADDR_TABLE_DYNAMIC_ADDR(dev->info.dyn_addr) | DEV_ADDR_TABLE_SIR_REJECT,
 	       master->regs +
 	       DEV_ADDR_TABLE_LOC(master->datstartaddr, data->index));
 
@@ -1039,7 +1039,7 @@ static int dw_i3c_master_attach_i3c_dev(struct i3c_dev_desc *dev)
 	master->free_pos &= ~BIT(pos);
 	i3c_dev_set_master_data(dev, data);
 
-	writel(DEV_ADDR_TABLE_DYNAMIC_ADDR(master->devs[pos].addr),
+	writel(DEV_ADDR_TABLE_DYNAMIC_ADDR(master->devs[pos].addr) | DEV_ADDR_TABLE_SIR_REJECT,
 	       master->regs +
 	       DEV_ADDR_TABLE_LOC(master->datstartaddr, data->index));
 
-- 
2.51.0




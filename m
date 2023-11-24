Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED7E2C1A2;
	Fri, 24 Nov 2023 18:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T8X86pda"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF97C433C8;
	Fri, 24 Nov 2023 18:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852362;
	bh=IuvZGcN6Open9V81m0hGtIDsuZg5tMI4diIvc98mRyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T8X86pdarhc4vTr60OajAbHV66DNoSH8Qlhrj+pd+kVl+FdDYEJ4GFyHk3F9+Ahmr
	 s1cVXvCkgXH2DaIvazDUigevkQLfR1cFnxo3EKZ4nbM/58wNCjURb5LWsUCB46K1KZ
	 bcTehJZSrbNR3CA4be0bkrb8HJNcNri1aoUobJyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 300/372] i3c: master: svc: fix random hot join failure since timeout error
Date: Fri, 24 Nov 2023 17:51:27 +0000
Message-ID: <20231124172020.434689263@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 9aaeef113c55248ecf3ab941c2e4460aaa8b8b9a ]

master side report:
  silvaco-i3c-master 44330000.i3c-master: Error condition: MSTATUS 0x020090c7, MERRWARN 0x00100000

BIT 20: TIMEOUT error
  The module has stalled too long in a frame. This happens when:
  - The TX FIFO or RX FIFO is not handled and the bus is stuck in the
middle of a message,
  - No STOP was issued and between messages,
  - IBI manual is used and no decision was made.
  The maximum stall period is 100 μs.

This can be considered as being just a warning as the system IRQ latency
can easily be greater than 100us.

Fixes: dd3c52846d59 ("i3c: master: svc: Add Silvaco I3C master driver")
Cc:  <stable@vger.kernel.org>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20231023161658.3890811-7-Frank.Li@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index 0263f30bae82e..f30d457e91196 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -93,6 +93,7 @@
 #define SVC_I3C_MINTMASKED   0x098
 #define SVC_I3C_MERRWARN     0x09C
 #define   SVC_I3C_MERRWARN_NACK BIT(2)
+#define   SVC_I3C_MERRWARN_TIMEOUT BIT(20)
 #define SVC_I3C_MDMACTRL     0x0A0
 #define SVC_I3C_MDATACTRL    0x0AC
 #define   SVC_I3C_MDATACTRL_FLUSHTB BIT(0)
@@ -220,6 +221,14 @@ static bool svc_i3c_master_error(struct svc_i3c_master *master)
 	if (SVC_I3C_MSTATUS_ERRWARN(mstatus)) {
 		merrwarn = readl(master->regs + SVC_I3C_MERRWARN);
 		writel(merrwarn, master->regs + SVC_I3C_MERRWARN);
+
+		/* Ignore timeout error */
+		if (merrwarn & SVC_I3C_MERRWARN_TIMEOUT) {
+			dev_dbg(master->dev, "Warning condition: MSTATUS 0x%08x, MERRWARN 0x%08x\n",
+				mstatus, merrwarn);
+			return false;
+		}
+
 		dev_err(master->dev,
 			"Error condition: MSTATUS 0x%08x, MERRWARN 0x%08x\n",
 			mstatus, merrwarn);
-- 
2.42.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CAE7364CB;
	Fri, 24 Nov 2023 18:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="inskGUUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E994C433C8;
	Fri, 24 Nov 2023 18:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851221;
	bh=yuxmeaBVL36MChSEsJcwJbETWP5o+CloVJOEZGsPilk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=inskGUUEuKIL/s22livG1AdLamRcQEbHDe9dqQJ15ipzlx1sSS+SWuIDvz7g9Sbh5
	 hWnZz1lZ/V5+H/LzkwUThij/MNRvImd7apIq2KE8CSMMcN6cVTF1vtmoa+/JUR6lQF
	 cnHKGsrSHEuyaaVcgNigj428OouXutnKi1YqwvFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.5 362/491] i3c: master: svc: fix random hot join failure since timeout error
Date: Fri, 24 Nov 2023 17:49:58 +0000
Message-ID: <20231124172035.454514232@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

commit 9aaeef113c55248ecf3ab941c2e4460aaa8b8b9a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/svc-i3c-master.c |    9 +++++++++
 1 file changed, 9 insertions(+)

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
@@ -227,6 +228,14 @@ static bool svc_i3c_master_error(struct
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



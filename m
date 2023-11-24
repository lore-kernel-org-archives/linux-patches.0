Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BC3364C1;
	Fri, 24 Nov 2023 18:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnsCSfeY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662D4C433C7;
	Fri, 24 Nov 2023 18:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851276;
	bh=edA7UZgMafqxNwxcSL6rZml4ZAa2f4BY74e/8VcxlcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnsCSfeY/5DVtjTMoWRnhW6OOBTUP0RVRupujBCrIU4x2vPJ4Yik82F7Z9OJpvr0+
	 or7rMDoA94aOvGnt6Kpkk6lmKjSS6leZRnZrC9QEdgaeMUHPxLflAiEJ3d7B++XF2n
	 +slCu7+vDleWR3M+uyLAcKJXVaQhXpnzrMWSa1hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.5 358/491] i3c: master: svc: fix wrong data return when IBI happen during start frame
Date: Fri, 24 Nov 2023 17:49:54 +0000
Message-ID: <20231124172035.332119848@linuxfoundation.org>
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

commit 5e5e3c92e748a6d859190e123b9193cf4911fcca upstream.

     ┌─────┐     ┏──┐  ┏──┐  ┏──┐  ┏──┐  ┏──┐  ┏──┐  ┏──┐  ┏──┐  ┌─────
SCL: ┘     └─────┛  └──┛  └──┛  └──┛  └──┛  └──┛  └──┛  └──┛  └──┘
     ───┐                       ┌─────┐     ┌─────┐     ┌───────────┐
SDA:    └───────────────────────┘     └─────┘     └─────┘           └─────
     xxx╱    ╲╱                                        ╲╱    ╲╱    ╲╱    ╲
   : xxx╲IBI ╱╲               Addr(0x0a)               ╱╲ RW ╱╲NACK╱╲ S  ╱

If an In-Band Interrupt (IBI) occurs and IBI work thread is not immediately
scheduled, when svc_i3c_master_priv_xfers() initiates the I3C transfer and
attempts to send address 0x7e, the target interprets it as an
IBI handler and returns the target address 0x0a.

However, svc_i3c_master_priv_xfers() does not handle this case and proceeds
with other transfers, resulting in incorrect data being returned.

Add IBIWON check in svc_i3c_master_xfer(). In case this situation occurs,
return a failure to the driver.

Fixes: dd3c52846d59 ("i3c: master: svc: Add Silvaco I3C master driver")
Cc:  <stable@vger.kernel.org>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20231023161658.3890811-3-Frank.Li@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/svc-i3c-master.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -1011,6 +1011,9 @@ static int svc_i3c_master_xfer(struct sv
 	u32 reg;
 	int ret;
 
+	/* clean SVC_I3C_MINT_IBIWON w1c bits */
+	writel(SVC_I3C_MINT_IBIWON, master->regs + SVC_I3C_MSTATUS);
+
 	writel(SVC_I3C_MCTRL_REQUEST_START_ADDR |
 	       xfer_type |
 	       SVC_I3C_MCTRL_IBIRESP_NACK |
@@ -1028,6 +1031,23 @@ static int svc_i3c_master_xfer(struct sv
 		ret = -ENXIO;
 		goto emit_stop;
 	}
+
+	/*
+	 * According to I3C spec ver 1.1.1, 5.1.2.2.3 Consequence of Controller Starting a Frame
+	 * with I3C Target Address.
+	 *
+	 * The I3C Controller normally should start a Frame, the Address may be arbitrated, and so
+	 * the Controller shall monitor to see whether an In-Band Interrupt request, a Controller
+	 * Role Request (i.e., Secondary Controller requests to become the Active Controller), or
+	 * a Hot-Join Request has been made.
+	 *
+	 * If missed IBIWON check, the wrong data will be return. When IBIWON happen, return failure
+	 * and yield the above events handler.
+	 */
+	if (SVC_I3C_MSTATUS_IBIWON(reg)) {
+		ret = -ENXIO;
+		goto emit_stop;
+	}
 
 	if (rnw)
 		ret = svc_i3c_master_read(master, in, xfer_len);



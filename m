Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66051144D16;
	Thu, 13 Jun 2024 11:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279691; cv=none; b=gm6J6wIjffDulPKtdF0xQ8Y3kx/XXqKqZbdDskZz8rgbhqtN6CtUtKpxnWuLD6iMN4UmdDAI1bXvWG5I5GPlRshCT9d7LsmIStraL1RbgNA1POEYSpjowlQoWeghF6vfwgrgDj6fBs1JSCp3CuPzZtCbGlIRVYC3SilHkyJQ7I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279691; c=relaxed/simple;
	bh=ni5dGz3Kcd5bfiBFbWdKsCG69Aodr6IpZ8fYUNuePwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWvxzY3Qhv3SU6RgocNhZga7xlSOuUV3ny7Wr9qC0GohghyARuMO6kEou4R2nPNc6w29CR/xP5YGWu9SoCLLfko2r+1X7s0thhCM4xJAadv24jBpdJXtStT/5uccX0S7Z4PA9aiWWxmyoI0Ly2fyDRSl6Zv6JpYA9KhCQjC86S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yAQEkmOp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yAQEkmOp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F341C2BBFC;
	Thu, 13 Jun 2024 11:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279691;
	bh=ni5dGz3Kcd5bfiBFbWdKsCG69Aodr6IpZ8fYUNuePwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yAQEkmOpk/7T1CrPm/Fk6rMniseVA/QrOWvzF3QkdMTVep0PTbqtNLGu6rvwX5CcN
	 uPlHQO+wSn1JYQYj7EdayjNsy+PcSrGDbbXG8hl0+ijJ2D7dMX6winU0ZtmMn+rlF3
	 VAOgBOypoWkoXidEz2gvT6xjINN4vzYX3WUjMjV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.9 130/157] i3c: master: svc: fix invalidate IBI type and miss call client IBI handler
Date: Thu, 13 Jun 2024 13:34:15 +0200
Message-ID: <20240613113232.438296046@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

commit 38baed9b8600008e5d7bc8cb9ceccc1af3dd54b7 upstream.

In an In-Band Interrupt (IBI) handle, the code logic is as follows:

1: writel(SVC_I3C_MCTRL_REQUEST_AUTO_IBI | SVC_I3C_MCTRL_IBIRESP_AUTO,
	  master->regs + SVC_I3C_MCTRL);

2: ret = readl_relaxed_poll_timeout(master->regs + SVC_I3C_MSTATUS, val,
                                    SVC_I3C_MSTATUS_IBIWON(val), 0, 1000);
	...
3: ibitype = SVC_I3C_MSTATUS_IBITYPE(status);
   ibiaddr = SVC_I3C_MSTATUS_IBIADDR(status);

SVC_I3C_MSTATUS_IBIWON may be set before step 1. Thus, step 2 will return
immediately, and the I3C controller has not sent out the 9th SCL yet.
Consequently, ibitype and ibiaddr are 0, resulting in an unknown IBI type
occurrence and missing call I3C client driver's IBI handler.

A typical case is that SVC_I3C_MSTATUS_IBIWON is set when an IBI occurs
during the controller send start frame in svc_i3c_master_xfer().

Clear SVC_I3C_MSTATUS_IBIWON before issue SVC_I3C_MCTRL_REQUEST_AUTO_IBI
to fix this issue.

Cc: stable@vger.kernel.org
Fixes: 5e5e3c92e748 ("i3c: master: svc: fix wrong data return when IBI happen during start frame")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20240506164009.21375-3-Frank.Li@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/svc-i3c-master.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -415,6 +415,19 @@ static void svc_i3c_master_ibi_work(stru
 	int ret;
 
 	mutex_lock(&master->lock);
+	/*
+	 * IBIWON may be set before SVC_I3C_MCTRL_REQUEST_AUTO_IBI, causing
+	 * readl_relaxed_poll_timeout() to return immediately. Consequently,
+	 * ibitype will be 0 since it was last updated only after the 8th SCL
+	 * cycle, leading to missed client IBI handlers.
+	 *
+	 * A typical scenario is when IBIWON occurs and bus arbitration is lost
+	 * at svc_i3c_master_priv_xfers().
+	 *
+	 * Clear SVC_I3C_MINT_IBIWON before sending SVC_I3C_MCTRL_REQUEST_AUTO_IBI.
+	 */
+	writel(SVC_I3C_MINT_IBIWON, master->regs + SVC_I3C_MSTATUS);
+
 	/* Acknowledge the incoming interrupt with the AUTOIBI mechanism */
 	writel(SVC_I3C_MCTRL_REQUEST_AUTO_IBI |
 	       SVC_I3C_MCTRL_IBIRESP_AUTO,
@@ -429,9 +442,6 @@ static void svc_i3c_master_ibi_work(stru
 		goto reenable_ibis;
 	}
 
-	/* Clear the interrupt status */
-	writel(SVC_I3C_MINT_IBIWON, master->regs + SVC_I3C_MSTATUS);
-
 	status = readl(master->regs + SVC_I3C_MSTATUS);
 	ibitype = SVC_I3C_MSTATUS_IBITYPE(status);
 	ibiaddr = SVC_I3C_MSTATUS_IBIADDR(status);



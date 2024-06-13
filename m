Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B7817FD;
	Thu, 13 Jun 2024 12:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282793; cv=none; b=uHITCCoZysgVXbXutU4cirNMUSBm+5ywIKFgr4evazgRv92ngAXWmUGDVC+R1d74T9V/HzvwUDvntej+ecWOT5EdgNmbiFNiCazLvbNNSMGSZVPrY+PzRH/eQjy0c3KojBk8Piq+cve2esFCKxCYikKEF7MHxWN3cGjVfCLQCo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282793; c=relaxed/simple;
	bh=Kl1ka0btppb6JppJVQRVw6zGbPKGyFj3HfrLgQcalzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZAuTXrRM5NN2laf8U9K7fDItyzahSfrcPs0iXJuh8Rmd3v7GGAGYFMVvSHnWmifp5XBLCrUOl6Pj3q2cpor6d/rEUdcxKTjdZcY5DBdTzFOrhIvlPnOXoDyidVODcjBeIKWMx0ssPiStuoiTijrZ96P92CU8a94agVzN1dyZeTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uhwwbEWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uhwwbEWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90F7C2BBFC;
	Thu, 13 Jun 2024 12:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282793;
	bh=Kl1ka0btppb6JppJVQRVw6zGbPKGyFj3HfrLgQcalzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhwwbEWyirP2altuluypFzNvJ1XZBtCdl2N/DkxzUfjVmtQkz77eOZK5k4fcWvQsi
	 BNEs0rLY3JpNbOnuBRS2zsC73d1w+tACMNDoeQnpyTzMkghem3Cp9pn6mAwwKEnvaU
	 wSIQtriPZ1bQFmnpN3/olUBq/lpkZSIsMIsOS9IQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.15 398/402] i3c: master: svc: fix invalidate IBI type and miss call client IBI handler
Date: Thu, 13 Jun 2024 13:35:55 +0200
Message-ID: <20240613113317.678010263@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -356,6 +356,19 @@ static void svc_i3c_master_ibi_work(stru
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
@@ -370,9 +383,6 @@ static void svc_i3c_master_ibi_work(stru
 		goto reenable_ibis;
 	}
 
-	/* Clear the interrupt status */
-	writel(SVC_I3C_MINT_IBIWON, master->regs + SVC_I3C_MSTATUS);
-
 	status = readl(master->regs + SVC_I3C_MSTATUS);
 	ibitype = SVC_I3C_MSTATUS_IBITYPE(status);
 	ibiaddr = SVC_I3C_MSTATUS_IBIADDR(status);



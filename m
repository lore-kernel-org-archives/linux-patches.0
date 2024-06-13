Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3F817FD;
	Thu, 13 Jun 2024 12:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718283043; cv=none; b=DPgRSg/E0fHG2ImHHgHPmOQlascs1o1BhmaM0ZkVK8dg5DBBPeDBEQzSbd5rZdd/ckMuPJDdxh1JkIQpttVE+0xW8QfIll7TPg+rxJZknHUERhZos9o/cFwSYxnNG8dyA/3kWymmv1OypwUeJoRTj+qKp3Wb40XpFIYoSu4hono=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718283043; c=relaxed/simple;
	bh=1m7IVIPGiEeKv9WhIAkaDZsj58I8pZChOJz+DZkMEwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FxihbNLl1pb3ljxHQlUpJAV6kol92f64pbNtSh7V6YT+zYT56lhGdt9RKZgH2LlFjcb96+kmZz1Cz6l5SBZpgtWBE5B3bccZZIBkXgdgvh81O+Ampn6Q/ID8KviY3hZOsWUNQtxbS5f+CatBWFBM4CXWekx6F9FMQtg+EujyeKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rBU9bU6k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rBU9bU6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9901FC2BBFC;
	Thu, 13 Jun 2024 12:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718283043;
	bh=1m7IVIPGiEeKv9WhIAkaDZsj58I8pZChOJz+DZkMEwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rBU9bU6kLz6kEEQqYJuxd1iBuJeM+ArVw9jLnQO+HtwABfpoGek8Th5Iy7GoM8tS+
	 EUV3YbqkpnEl0C3lThWlcCo6XcLfmIbnYLrqzL53mSF1EOZm48QobVskAIIKBBHXTG
	 pJh4/VwYjrvl2P4XUcgp3Gn+rLeMqudZtilAhOQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.1 79/85] i3c: master: svc: fix invalidate IBI type and miss call client IBI handler
Date: Thu, 13 Jun 2024 13:36:17 +0200
Message-ID: <20240613113217.183988167@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -397,6 +397,19 @@ static void svc_i3c_master_ibi_work(stru
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
@@ -411,9 +424,6 @@ static void svc_i3c_master_ibi_work(stru
 		goto reenable_ibis;
 	}
 
-	/* Clear the interrupt status */
-	writel(SVC_I3C_MINT_IBIWON, master->regs + SVC_I3C_MSTATUS);
-
 	status = readl(master->regs + SVC_I3C_MSTATUS);
 	ibitype = SVC_I3C_MSTATUS_IBITYPE(status);
 	ibiaddr = SVC_I3C_MSTATUS_IBIADDR(status);



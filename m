Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7073126F32;
	Thu, 13 Jun 2024 12:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280629; cv=none; b=DFcjwqsFdvO7SFfvCwHy2UxBnhyLo/tguk8w7Ukoj+nEFy/Hss5od1DBLJYrH3DAQGtIUbUhrSnwvOLBZNo/ttL15r7wgQcbdZpdyCvu3/DZkdYN+5Z0JWXH9+/VSxwjsZi8Xd3bQ7dBFoit8duzAaQyJeqXCR0urN1quTEY2gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280629; c=relaxed/simple;
	bh=7nAI4nHLCXSt2gNDRuzZaaRdfaRJmwDX86hm0LgaDTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFrKOd8117FZkHhWI+HCgGpsBjHmCOn0fXvEj0nT3txxKaPUaaPe5mUKf1eFENpIOHTMKiIqCD7O/OVNzTJGC3ruyASNzxmG/cVuur64Bf0IjYf5sz/77tqmOptX4slD1K5KUe7QMqjHTe7SZ9+vdJdCqy48Yp+Ow+p5alqyqik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sD18ctuc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sD18ctuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CD9C2BBFC;
	Thu, 13 Jun 2024 12:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280629;
	bh=7nAI4nHLCXSt2gNDRuzZaaRdfaRJmwDX86hm0LgaDTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sD18ctucvXDsnpHZrY5tefnC1cY5DswB4rfhxAX6f2BC1jnY8y9hFfsLDKUxFTP8a
	 HQL1iSCuVrvYLo83iHjx5pgIQ/935ojrr09ELAZx4nVGqbfJOHY3E9XFPgiShbtKo4
	 +QSuPZ0OrNLRMszLPRpqb4DCKM3W4yj0Xkyy/MxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.6 119/137] i3c: master: svc: fix invalidate IBI type and miss call client IBI handler
Date: Thu, 13 Jun 2024 13:34:59 +0200
Message-ID: <20240613113227.916808995@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -405,6 +405,19 @@ static void svc_i3c_master_ibi_work(stru
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
@@ -419,9 +432,6 @@ static void svc_i3c_master_ibi_work(stru
 		goto reenable_ibis;
 	}
 
-	/* Clear the interrupt status */
-	writel(SVC_I3C_MINT_IBIWON, master->regs + SVC_I3C_MSTATUS);
-
 	status = readl(master->regs + SVC_I3C_MSTATUS);
 	ibitype = SVC_I3C_MSTATUS_IBITYPE(status);
 	ibiaddr = SVC_I3C_MSTATUS_IBIADDR(status);



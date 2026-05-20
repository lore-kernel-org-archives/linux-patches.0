Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C482F363F;
	Wed, 20 May 2026 18:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300825; cv=none; b=DCsHwhbqhTbd30Cg5eetScZQoWMOY9Xpe443InLQ6fafyr1Zov8Q3wsm0ictqOTOIpmFyXXbPldhcliM0RAD/dSPrSj4eqsCd8FKQJlTz+fm/xoDjjOTwSM/e1C8j+vDkjkI+9SDmF3CHy7ROUcJe7h+820BRUasb9fQX0r3ZJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300825; c=relaxed/simple;
	bh=9W9k85n0RcwBwwdcYfcCMQQjqJ1pxXUsRsFLTBYw428=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cr+tzhght8GjHvddly1zc6FNMcmKMuawF5V4q3E57h+byNmUmUdOIis1VfDbNhC0zbTuEJf6B0n+gb1vKzVvFME2LUpj94jdw+XDMDT8GVaktClNAg0d6Mw1v7OQvAd0eWx4SFTSDC6qzcH7Xt0Ad+Ezi855g1YkPDMZS/w4WMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yqjPEYqa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqjPEYqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0191F1F00894;
	Wed, 20 May 2026 18:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300824;
	bh=YS6lWxSqjbdEROYjP1A+xyYRN7xR0OPoeHW/HAQ9d/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yqjPEYqaIo/7+yzPUKaiw89cyL5FiLRQS/Vy8D2Ibilrk2rMkBXhXu5nUvtG4m8wn
	 yvQne9w84n7oSCfHQzfxg/jBCeU1sBCsHSwRjYMySTSApiEGU0M6Um6oaBqJiiKr6N
	 Jh+Z+ymTmR1Zdc8NYOvLbVs0OvND5yYwDS5e762w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Norman Bintang <normanbt@google.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 322/666] soundwire: cadence: Clear message complete before signaling waiting thread
Date: Wed, 20 May 2026 18:18:53 +0200
Message-ID: <20260520162118.201908180@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit cbfea84f820962c3c5394ff06e7e9344c96bf761 ]

Clear the CDNS_MCP_INT_RX_WL interrupt before signaling completion.

This is to prevent the potential race where:
- The main thread is scheduled immediately the completion is signaled,
   and starts a new message
- The RX_WL IRQ for this new message happens before sdw_cdns_irq() has
  been re-scheduled.
- When sdw_cdns_irq() is re-scheduled it clears the new RX_WL interrupt.

MAIN THREAD                        |  IRQ THREAD
                                   |
  _cdns_xfer_msg()                 |
  {                                |
     write data to FIFO            |
     wait_for_completion_timeout() |
     <BLOCKED>                     |                       <---- RX_WL IRQ
                                   | sdw_cdns_irq()
                                   | {
                                   |    signal completion
                          <== RESCHEDULE <==
  Handle message completion        |
  }                                |
                                   |
Start new message                  |
  _cdns_xfer_msg()                 |
  {                                |
     write data to FIFO            |
     wait_for_completion_timeout() |
     <BLOCKED>                     |                       <---- RX_WL IRQ
                          ==> RESCHEDULE ==>
                                   |    // New RX_WL IRQ is cleared before
                                   |    // it has been handled.
                                   |    clear CDNS_MCP_INTSTAT

                                   |    return IRQ_HANDLED;
                                   | }

Before this change, this error message was sometimes seen on kernels
that have large amounts of debugging enabled:

   SCP Msg trf timed out

This error indicates that the completion has not been signalled after
500ms.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 956baa1992f9 ("soundwire: cdns: Add sdw_master_ops and IO transfer support")
Reported-by: Norman Bintang <normanbt@google.com>
Closes: https://issuetracker.google.com/issues/477099834
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260310113133.1707288-1-rf@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/cadence_master.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/soundwire/cadence_master.c b/drivers/soundwire/cadence_master.c
index 6f2b5ec5c87c6..a503ef606a62c 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -931,6 +931,14 @@ irqreturn_t sdw_cdns_irq(int irq, void *dev_id)
 
 		cdns_read_response(cdns);
 
+		/*
+		 * Clear interrupt before signalling the completion to avoid
+		 * a race between this thread and the main thread starting
+		 * another TX.
+		 */
+		cdns_writel(cdns, CDNS_MCP_INTSTAT, CDNS_MCP_INT_RX_WL);
+		int_status &= ~CDNS_MCP_INT_RX_WL;
+
 		if (defer && defer->msg) {
 			cdns_fill_msg_resp(cdns, defer->msg,
 					   defer->length, 0);
-- 
2.53.0




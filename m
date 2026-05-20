Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB043A3E90;
	Wed, 20 May 2026 16:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295854; cv=none; b=gl22tmepjOT6tG9spJzB2vF6Oaf5DsD1SCqh01RbRu2AHMk+icuuemk0V53pIJ543OvazpZmpbb0WseIP+wwdOQSJuuWSC//8t8PXnGSWrYEsiFkwiAXZk9ukvoCDSDe2h0wr/YPtWduNCJI7VCuTRA5KL5qPcNRnmpNSVnon8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295854; c=relaxed/simple;
	bh=ylxDz+B2tFA1PpvPYEkePO7+2qnOp+EUbE9utfWzoUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmmT7GryxwBxFFC+JChM7Q7OqrB0asmqRZI/3wmMpVYFAb/LIZSmXhwjKSAdqwhiNIWIejWboVyblupOgQIaXTRgKqyR9q8EA9I49kzpiOcASrzQGVwNYdxIuzXXlJkmVpq4bhdGnFzkquhXVkH0nHQunIMdDl56TtZ1/DsNQ3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/10BbtZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/10BbtZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243731F000E9;
	Wed, 20 May 2026 16:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295852;
	bh=xSJc5251VSBNWJaaKfZ2AiNWdgvITfYyLaQ0yohKQ4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P/10BbtZVW78WGBDunvTZu0q+k9Tgd7jK6D8it2zCfyfBMwYEnJT+rWVgQ2tjnOaP
	 KuizNhjcNCrlP9432QW9y9RejvMapFIAscYhDD55ZyKH1FkB1RO2YcIXo2ea/o0ebn
	 7wARraB5bbWYeODF9q7RqgS5wN+xrTIZ7XpNZ4h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Norman Bintang <normanbt@google.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0578/1146] soundwire: cadence: Clear message complete before signaling waiting thread
Date: Wed, 20 May 2026 18:13:48 +0200
Message-ID: <20260520162201.263584516@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index f245c3ffb9e97..b8b62735c8938 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -933,6 +933,14 @@ irqreturn_t sdw_cdns_irq(int irq, void *dev_id)
 
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




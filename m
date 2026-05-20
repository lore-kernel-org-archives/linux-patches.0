Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C50529D26E;
	Wed, 20 May 2026 17:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298540; cv=none; b=jV0+zkHJHvDKAC6/akI3twkNFxQ6QSPK6lVtidWLgpseWQmda1Xbps9zO19SKNrLop5VdaWezACW07Ra2e+vCeyaWvIQpzxi87gaKUEkGHkvARqoyrJkbqsXXzp9c50UW62D4yNnbEIqmd188UcMVBogwJBaV+45ZSZ7/mTYH7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298540; c=relaxed/simple;
	bh=4tYSR2eoC38ihJa83eTT/3mhs3AF3rA58vxUbW4ypzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E6qV7Vf8gpmm9NSvoFyVFOUp8xUiAJwiaN2eLYReQwgcm8DAg/bj1YKgrgmNDSChorl3M0CfWDwSw0rfAxXeH/PDvTBroDOvqCurQE+ArFzuC7FNKp5HlLFvf1ruKhPJLsFWitZ7FB+qq2dtJtXAZWtuI3TU+UcAp6zTtP1JUeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ziHmbtjJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ziHmbtjJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE261F000E9;
	Wed, 20 May 2026 17:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298539;
	bh=bptGYsGDsSZ51k8SnnOVcFjFv2GEkrdv2aDiZ2OQcxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ziHmbtjJqbSsLl/NFsY4RCpNTi1UswoODOShPR+vQpuwuMoPWYpf8ueI1OgIb3GGQ
	 INx3yLEqu8GJnYSbDZaxHlmoD0u8+KzNFNpMAEm5l5HHB9nLOSItzMIeFkX6kPyXgQ
	 8HYpAHH9vRHwNoHTt2lPfxq8Oe/fZ/wvuWs6qrlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Norman Bintang <normanbt@google.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 450/957] soundwire: cadence: Clear message complete before signaling waiting thread
Date: Wed, 20 May 2026 18:15:33 +0200
Message-ID: <20260520162144.278945606@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 21bb491d026b4..d7a0a14ad9626 100644
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E73520EB;
	Mon, 14 Oct 2024 14:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916269; cv=none; b=usrgSmiRunZ2nMoSYe8rsbKw6QoA/hlRhevuoAXxaYDWlzyCy/ePLV0GTa7tbbmF3OLI9e1qeXewimVuP4R6gBqsmoDOvfAFgQfy5Vx3yQ1rCWNtq5sMrjfYdja6lsPOXiPab1kHDf3EMFIDL3aVkZITc6w+qFw6hz217r8fXuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916269; c=relaxed/simple;
	bh=MP4fpq+lO2u5Hue3BCvyLqpyS3bwMy+XbcxlssV+bbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjYTkPXHXarKYxw0syyDhoM2SBSQpO//AkIs0zlMRUnFrYfiL42OkR2K1X4H7Rz8IZ1yNd0Wc47mGdWhkeJH5iHLB+HizrMacCXT/ZNl/7aSfaMwoOLFznzKDBhB2msB5waXM4DZ7nmM3ux9BsHGs2OYCzdLrvSqZYVvySlB5Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jJDZuGSP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJDZuGSP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4F9C4CEC3;
	Mon, 14 Oct 2024 14:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916269;
	bh=MP4fpq+lO2u5Hue3BCvyLqpyS3bwMy+XbcxlssV+bbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jJDZuGSPKoVb+wNKigRgGvnVASjO5gM4A5XnTOj6FvoCKoECJoTUZ5ZumZh6eRBgF
	 b6MbdC0akTsW5dccxSuigC4qfw2WqWIbP7Ju0qvhbUd84W7z/e44fPdVps1fXwSZB6
	 f8h9lV567/ldX2Jl2KM+3mlDco7ROUMMg6hoi9qI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yury Vostrikov <mon@unformed.ru>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 091/214] sfc: Dont invoke xdp_do_flush() from netpoll.
Date: Mon, 14 Oct 2024 16:19:14 +0200
Message-ID: <20241014141048.546355856@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 55e802468e1d38dec8e25a2fdb6078d45b647e8c ]

Yury reported a crash in the sfc driver originated from
netpoll_send_udp(). The netconsole sends a message and then netpoll
invokes the driver's NAPI function with a budget of zero. It is
dedicated to allow driver to free TX resources, that it may have used
while sending the packet.

In the netpoll case the driver invokes xdp_do_flush() unconditionally,
leading to crash because bpf_net_context was never assigned.

Invoke xdp_do_flush() only if budget is not zero.

Fixes: 401cb7dae8130 ("net: Reference bpf_redirect_info via task_struct on PREEMPT_RT.")
Reported-by: Yury Vostrikov <mon@unformed.ru>
Closes: https://lore.kernel.org/5627f6d1-5491-4462-9d75-bc0612c26a22@app.fastmail.com
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>
Link: https://patch.msgid.link/20241002125837.utOcRo6Y@linutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/efx_channels.c       | 3 ++-
 drivers/net/ethernet/sfc/siena/efx_channels.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index c9e17a8208a90..f1723a6fb082b 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -1260,7 +1260,8 @@ static int efx_poll(struct napi_struct *napi, int budget)
 
 	spent = efx_process_channel(channel, budget);
 
-	xdp_do_flush();
+	if (budget)
+		xdp_do_flush();
 
 	if (spent < budget) {
 		if (efx_channel_has_rx_queue(channel) &&
diff --git a/drivers/net/ethernet/sfc/siena/efx_channels.c b/drivers/net/ethernet/sfc/siena/efx_channels.c
index a7346e965bfe7..d120b3c83ac07 100644
--- a/drivers/net/ethernet/sfc/siena/efx_channels.c
+++ b/drivers/net/ethernet/sfc/siena/efx_channels.c
@@ -1285,7 +1285,8 @@ static int efx_poll(struct napi_struct *napi, int budget)
 
 	spent = efx_process_channel(channel, budget);
 
-	xdp_do_flush();
+	if (budget)
+		xdp_do_flush();
 
 	if (spent < budget) {
 		if (efx_channel_has_rx_queue(channel) &&
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864961C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03521C433EF;
	Mon, 20 Mar 2023 15:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325567;
	bh=fXGFdJhYV+PXpv7qzl8L1ATb9+K9VRxi83TYZva0h7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1FCiK1W9IuIinR2fz9gAIgmH/S0GS9j7m6tl0xQHUlgwLQdMGAhHiiWScp28c71zO
	 U3lMCbX7iST5FIAAbJjfzzIMYMQx0kog932VqzQcPuRDVRT5FWaIr9jGNS5UJqV43N
	 YXfqdWFVizk3M4fzUX4t9IL0tELHDhN3JASar5zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Schramm <t.schramm@manjaro.org>,
	Ludovic Desroches <ludovic.desroches@microchip.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/198] mmc: atmel-mci: fix race between stop command and start of next command
Date: Mon, 20 Mar 2023 15:54:01 +0100
Message-Id: <20230320145511.890567097@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tobias Schramm <t.schramm@manjaro.org>

[ Upstream commit eca5bd666b0aa7dc0bca63292e4778968241134e ]

This commit fixes a race between completion of stop command and start of a
new command.
Previously the command ready interrupt was enabled before stop command
was written to the command register. This caused the command ready
interrupt to fire immediately since the CMDRDY flag is asserted constantly
while there is no command in progress.
Consequently the command state machine will immediately advance to the
next state when the tasklet function is executed again, no matter
actual completion state of the stop command.
Thus a new command can then be dispatched immediately, interrupting and
corrupting the stop command on the CMD line.
Fix that by dropping the command ready interrupt enable before calling
atmci_send_stop_cmd. atmci_send_stop_cmd does already enable the
command ready interrupt, no further writes to ATMCI_IER are necessary.

Signed-off-by: Tobias Schramm <t.schramm@manjaro.org>
Acked-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Link: https://lore.kernel.org/r/20221230194315.809903-2-t.schramm@manjaro.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/atmel-mci.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index bb9bbf1c927b6..dd18440a90c58 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1817,7 +1817,6 @@ static void atmci_tasklet_func(struct tasklet_struct *t)
 				atmci_writel(host, ATMCI_IER, ATMCI_NOTBUSY);
 				state = STATE_WAITING_NOTBUSY;
 			} else if (host->mrq->stop) {
-				atmci_writel(host, ATMCI_IER, ATMCI_CMDRDY);
 				atmci_send_stop_cmd(host, data);
 				state = STATE_SENDING_STOP;
 			} else {
@@ -1850,8 +1849,6 @@ static void atmci_tasklet_func(struct tasklet_struct *t)
 				 * command to send.
 				 */
 				if (host->mrq->stop) {
-					atmci_writel(host, ATMCI_IER,
-					             ATMCI_CMDRDY);
 					atmci_send_stop_cmd(host, data);
 					state = STATE_SENDING_STOP;
 				} else {
-- 
2.39.2




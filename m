Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341302D73A6;
	Sat, 17 Oct 2026 17:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256933; cv=none; b=jTYsIlJQhlUz17oIbcTw6+Fe6L5RHkUsMzalHMyFivgBG3i1g6eaVAQJxa67EYfWjzyC8rgWiGj/zNmflwnu2t6Auyg+AqEnwsThDbq5Wyd4z7x/+f9v1Kt4cdAFDaBTOuwucROyCuhYOMlOdDvDbK78+0ur/eIdiUx6nolpQG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256933; c=relaxed/simple;
	bh=VJ71xWL9Ihz2D/1cGE8uzynUDyMhuJ39kQp2Jj52gqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jto+L8Go/HCaAWLe4HrjKkFJGBvM5EhWQK9KtiMxubkPRXU+F7zZdsGXzVBcipXzuj8dYQ/KiR5ZgwDGGMlifk1rSbtyz+op65h3cXBkzORt2b65iXVClC5Rh29iojyv4rD1zk7aqc/6tVDSDtKnfwuAgJcVB6IYyDDJQIrRv08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRnPBKle; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRnPBKle"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DED41F000C4;
	Sat, 17 Oct 2026 17:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256932;
	bh=+9sQiDoY3oKyfrktKkn0dR69HCPLOKXGs5r/QTvjP4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dRnPBKlepa/yHPdR9hrsOAHJ9qqfS0GavfRMLBevZTFJUGUpzyvKFkzZxJjmsBVo4
	 e8LAZpVg/xAje6pwb7HHZWBdGwPLdyFDCop9391pUTh1I9fLGk/27O3fxwSS7A0POs
	 SONRsBqKRmv3GMDI4SbJcYn2SePk6O8qOBQas9Oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	stable@kernel.org,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0399/1674] serial: fix TIOCMIWAIT race
Date: Sat, 17 Oct 2026 17:44:31 +0200
Message-ID: <20261017160441.360625362@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 40adffec8c0090533dfaa863ced7901b60bbf1dc ]

The task state must be updated before checking the wakeup condition to
avoid missing a racing modem status update.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: sashiko-bot@kernel.org
Link: https://lore.kernel.org/r/20260904115542.E20D11F00A3D@smtp.kernel.org
Cc: stable@kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260910130816.642699-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: Retained direct spinlock calls instead of the upstream UART port locking helpers. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index c3a51bd59ff74..87bd1be81f77c 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1253,12 +1253,12 @@ static int uart_wait_modem_status(struct uart_state *state, unsigned long arg)
 
 	add_wait_queue(&port->delta_msr_wait, &wait);
 	for (;;) {
+		set_current_state(TASK_INTERRUPTIBLE);
+
 		spin_lock_irq(&uport->lock);
 		memcpy(&cnow, &uport->icount, sizeof(struct uart_icount));
 		spin_unlock_irq(&uport->lock);
 
-		set_current_state(TASK_INTERRUPTIBLE);
-
 		if (((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
 		    ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
 		    ((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
-- 
2.53.0




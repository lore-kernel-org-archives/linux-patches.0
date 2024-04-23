Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACEC143898;
	Tue, 23 Apr 2024 21:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908519; cv=none; b=UsbWHCHWU4rIa5SozvX1LN9Kxi2Syr0hgMCNXNg/2pbZsBpUrreQ/WBX3jc8BgAQZ/bfqr1iH9jj/nWypn/MF1s2VyA9yYYrb0I3uAn1jhZum8B7XzgdcY41jlHYB90TNklDaRUApbTDw2ikP+Vqs1GlxbT2XLbyMMZDamREOZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908519; c=relaxed/simple;
	bh=0fHnDtelqmZiUEyOwL0OQlxSAVtViTTktrm150oh3zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFtXmL47zkVNYy8bQhce6QVyWmzly10n14lBuCeBWtiPmBhdYrtFx27zXVy0pdIkx5jpbsAzNndvCP2bbBos7/PcZtNeBaLpTVnN/ZG3VdFnu5FAECMokirSwSAfdySp12yT0ZUoSAP5PnFvtPdyFRuPvUT3wxPIMi7oQkHTrtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S+VaYmSn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+VaYmSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B50C116B1;
	Tue, 23 Apr 2024 21:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908518;
	bh=0fHnDtelqmZiUEyOwL0OQlxSAVtViTTktrm150oh3zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S+VaYmSn9ZykTczP1qUQwx2iwkRxrD137nsnILfNQxurdxC7ayor0H0VO9dzwjiSv
	 bBzSn3IeFndshmOoY3HLvWfdaMiP9uy9JMW0tnfk4drGFrw3u5kAHvzykMWCXgDSH1
	 XxmGlPzq1bPQTcQU/Vf/O2hLA6c6zTYcg2EeaSvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Nick Bowler <nbowler@draconx.ca>,
	Tony Lindgren <tony@atomide.com>
Subject: [PATCH 6.8 106/158] serial: core: Fix regression when runtime PM is not enabled
Date: Tue, 23 Apr 2024 14:38:48 -0700
Message-ID: <20240423213859.382762778@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

commit 5555980571cc744cd99b6455e3e388b54519db8f upstream.

Commit 45a3a8ef8129 ("serial: core: Revert checks for tx runtime PM state")
caused a regression for Sun Ultra 60 for the sunsab driver as reported by
Nick Bowler <nbowler@draconx.ca>.

We need to add back the check runtime PM enabled state for serial port
controller device, I wrongly assumed earlier we could just remove it.

Fixes: 45a3a8ef8129 ("serial: core: Revert checks for tx runtime PM state")
Cc: stable <stable@kernel.org>
Reported-by: Nick Bowler <nbowler@draconx.ca>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20240325071649.27040-1-tony@atomide.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index ff85ebd3a007..25a83820927a 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -156,7 +156,7 @@ static void __uart_start(struct uart_state *state)
 	 * enabled, serial_port_runtime_resume() calls start_tx() again
 	 * after enabling the device.
 	 */
-	if (pm_runtime_active(&port_dev->dev))
+	if (!pm_runtime_enabled(port->dev) || pm_runtime_active(&port_dev->dev))
 		port->ops->start_tx(port);
 	pm_runtime_mark_last_busy(&port_dev->dev);
 	pm_runtime_put_autosuspend(&port_dev->dev);
-- 
2.44.0




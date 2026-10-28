Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213189;
	b=EXqKtHZgybU3hwgr0cVJkQup5QGdURp3wvc0V+9V2rx9XX0NjBfF3D/1qJqGlF4MoxqU
	 RslAodIBPfB00wCoTXX04PRYV1gGGyEUTP8LprnVW2Yn6Iu7Znq2Qbmh3BCPXuznrr6rc
	 N0d7iNcYtLuKLH8vPsWdvcpjq4nRyecvxd+5CjsGPn8pKOz7ouXxrisGQAgAYgxe8Tnlo
	 FI1zuGaQ2aLfvOWPS9RKsmzAvowVs2esLDdfawUb3jM+VU5JTkpG3CuFmwfrCJIObnHOD
	 LvRplOQ7qCVXEBSTTI02vhQqpJej9zhG0EV3GxyphnbKL1cmBI/riDpNX+KvVCZiZOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jT892G+M3gkLEnuXTOx090i9FSAst2patIGngYsq5b4=;
	b=IMKkj/VCByapZ8YLPpQRa5A6dcaHNLp0ewKA2zWODznySZ4Fwnu5wWaQAPwj5TvvIKV/
	 5l3cyMprPlW0+O1ly4lzz6hKXfkdLLe8gDGUB08SdQuwmA13PeQ8csuQDyzoCCAbnfgCT
	 F9tPokypMkVLuoZHbknBHBGzL4ucXDKisTRlHfi040XKPsqFRcVbnxYd12x41ZUWMUV87
	 IlHGij6/ETMaBiKMHDWwXVrld+w2ocEtlk+/8QJh2pLAsPRjp119KhEDNNzn85xErg0cM
	 qKEXu+2F1DIN8eStfk3R4SBLklqUN6tK/iINL8I+t8kq5NisZzsHBG/O5ZW7eJzZ98g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="An/qsDvf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41930606A31C;
	Wed, 28 Oct 2026 18:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=An/qsDvf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9071F01825;
	Wed, 28 Oct 2026 18:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213189;
	bh=jT892G+M3gkLEnuXTOx090i9FSAst2patIGngYsq5b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=An/qsDvfEYOY/IWJASqw9ZsrONxLG0+kP5pn9nxPGDW7OUXT7K4mp/IMVl3Lp/sQz
	 d3Pmzszp5X0hS8hLA72oGDrEclzVG7civX1j9iNh1Oz+WKWv9R0U5OFKuT9hZ/VWtL
	 RfUq/UncSBtx6rSTxyywe50l/vNDGo8FUi3x0084=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	stable@kernel.org,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0391/1887] serial: fix TIOCMIWAIT race
Date: Wed, 28 Oct 2026 17:41:27 +0100
Message-ID: <20261028170508.133217128@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context for direct spinlock calls instead of uart_port locking helpers ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 2704eb8af5880..dafbd24b91484 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1222,12 +1222,12 @@ static int uart_wait_modem_status(struct uart_state *state, unsigned long arg)
 
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




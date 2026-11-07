Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062364;
	b=2bpbgqQkBIL5PRkgYX/OpcAiYnbRUJouJc1flUo+Q/o2grBCXJjYpC4zpuGeCYSJQDjN
	 wvwzV3HFoEAe32mfkCYStA5MRMTFI0D2lsFQw9ErKmg8l5CNsfdZZ1IXMft7KATB91989
	 2zRvNNUp2EEq7o22PjNd3l3VJxdZuqsq6rjE0s0urml5s2mb7xUhy1r6DimvzT7Pjoq0p
	 JbKb8yv+nxYlAhWAomqLRdxV+u0WiKclQ6OSiLqF0muEyvpbC3c3pA95/dVIhCf+YezQw
	 8MsL7CpMhefpfKZubcts/8eHkYtUopdYCBxCT7/u+w+kYvirDtJnqiMYziyezqTI6vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C6RBOePGZmWySqJTgW7lGKfk6JkvruFQY/uWb0po5qw=;
	b=EeoIGOeysxzWyx9cXVlFxSntfat4DsUWqlEZ/3V96qLDSu519asW8T+ptq92tqz2ZAY/
	 xPG+90AT9uiVRBzM0FUCf2fd+E14XKn2YIA/oRMxD9pBevSOo0sVnqS4P3ILzhTCzbGdl
	 AQI0EMnq7IqMreISoARiIPz/GeOMGAem7fjotp23KD16L01HzbzOWc/Cu+yWOvRQbIGpw
	 pQLxTZ0X3Fy1Q/efViBbVXHrkVqaWj9YifLBmM/S9A6aC0QQkw+yZ3ajqp91wyF2Cp/hs
	 FqeOcKWoMjbq36dGZcn8j51Apljg/Ji5rsz9Zf1uGmRWRz3BIpdeXPuRNLiX3TXnNNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YoNeaLYE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742A0606A32C;
	Sat,  7 Nov 2026 14:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YoNeaLYE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB6F1F0089F;
	Sat,  7 Nov 2026 14:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062364;
	bh=C6RBOePGZmWySqJTgW7lGKfk6JkvruFQY/uWb0po5qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YoNeaLYEqWTzW3p/R3dl5kqh3jn4plY2I2Ow4lsbIkANQ1AOGgmGNx0uPQlAC/4ei
	 p5udHL5obpiSi+TGxWaYQxgPMSPvtfoAaWImuogNSATvkvCyprR/OJNicwsq/s2n6d
	 qbRjFGATpOen98qGAhQIemQ6MLR3MfhNIMNEaQiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Douglas <me@timdoug.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1290/1536] serial: pmac_zilog: push received data to the port that received it
Date: Sat,  7 Nov 2026 08:55:06 -0500
Message-ID: <20261107135034.022221636@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Douglas <me@timdoug.com>

[ Upstream commit f3dc727da3af64abc12b625bbf1eb68d55d882cc ]

pmz_interrupt() drains both channels but, since commit 2e124b4a390c
("TTY: switch tty_flip_buffer_push"), pushes the flip buffer of the
port whose handler is running rather than the port that was drained.
With both ports open, data received on the other port can be left in
its flip buffer until something else pushes it, so its reader may not
see it.

Fixes: 2e124b4a390c ("TTY: switch tty_flip_buffer_push")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Tim Douglas <me@timdoug.com>
Link: https://patch.msgid.link/20261013013541.4535-2-me@timdoug.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/pmac_zilog.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/pmac_zilog.c b/drivers/tty/serial/pmac_zilog.c
index 8969b11cc0a9a..893c59ef2fab3 100644
--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -444,7 +444,7 @@ static irqreturn_t pmz_interrupt(int irq, void *dev_id)
  skip_a:
 	uart_port_unlock(&uap_a->port);
 	if (push)
-		tty_flip_buffer_push(&uap->port.state->port);
+		tty_flip_buffer_push(&uap_a->port.state->port);
 
 	if (!uap_b)
 		goto out;
@@ -469,7 +469,7 @@ static irqreturn_t pmz_interrupt(int irq, void *dev_id)
  skip_b:
 	uart_port_unlock(&uap_b->port);
 	if (push)
-		tty_flip_buffer_push(&uap->port.state->port);
+		tty_flip_buffer_push(&uap_b->port.state->port);
 
  out:
 	return rc;
-- 
2.53.0




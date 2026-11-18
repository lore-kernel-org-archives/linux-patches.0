Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045622;
	b=qZt1pzssywhjgeo5qMEAjo2ZZzRhngjainBDfLz0PAHwCFgkp3hhdrhX2neu+Cyfbha7
	 TYSY8PQmEpcpCW6AmDawD2COYp/uXbRQv4W4zm8X1ONcTPKVhJi9yNzMnkiZaDb4599ku
	 gPAULa1HsfDvzVyjG82H6d+5Lo3rP+V6/0giUuIKy4VRz0VGrttfFBwBKRU2+XCkGSZ/Y
	 jXEZD0TOk19kbiAPUynA1ol+28dtkykH9Aiyx/8ulw+trQHznsop9BzCxl40d9ejbns3p
	 qkLovxkkjjPuz8BN9Nz92KRsRdJFeLJXL4qEpFnXkTkxHrBhst1nsYkwvY7XH7+fWNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045622;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K0aVC4wgjJdfVGPZzKX7NppewLoZRh48D7teLi4Wpno=;
	b=yDsk6YDQJCPZHI6VEkR18MbT2Pi3/r65hL83eOXEfgkY97qJZ+HL7hk1uyKpwrtZu0qd
	 yjMEXJP3c8pygN/sDtNeaTL+mYYS+iDdeccZKs7PIciWwjpprIbSkyf/eaOa9E7moQN1Q
	 qXv+M5NBPLEtGaUvoTK+10HKaNH43B/ZxhIqD9iGeoljZOmxfu06T8GdbOIP7GjGrxrCe
	 qJk65bfsmCZXd3PnVJy3nOInbvMDlTszxDmI8/HYwJsaK5as4dqO42yOgSX+Evc2yR4MM
	 2LxsEV2+Sr3p2hbfzvgA3rWaLvOlrCKKysCDIzq9vPzMvEvkVisP3156qrg/hdOEIjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MfZdabp1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73818606A320;
	Wed, 18 Nov 2026 23:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MfZdabp1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE16F1F000C7;
	Wed, 18 Nov 2026 23:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045622;
	bh=K0aVC4wgjJdfVGPZzKX7NppewLoZRh48D7teLi4Wpno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MfZdabp1/PYo2hvMoo2q4SuBhBpGBNuUpAimJs/Fr8/jD6tvOa9hCdY4it6yqdZ97
	 /9uEALC7L/TRL9ByIjfq2kxuf+XHhRIOk098mOGdRwmcMJXUKwqMu0kO6GFI9dgDbM
	 Nsx44CXCgsYB5K4ityf3g6otRzAPvzBJmGnJCM/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Douglas <me@timdoug.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0949/2857] serial: pmac_zilog: push received data to the port that received it
Date: Wed, 18 Nov 2026 15:33:03 +0100
Message-ID: <20261118150235.774374872@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index daf15d23bb42e..67cb3905fed87 100644
--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -445,7 +445,7 @@ static irqreturn_t pmz_interrupt(int irq, void *dev_id)
  skip_a:
 	spin_unlock(&uap_a->port.lock);
 	if (push)
-		tty_flip_buffer_push(&uap->port.state->port);
+		tty_flip_buffer_push(&uap_a->port.state->port);
 
 	if (!uap_b)
 		goto out;
@@ -470,7 +470,7 @@ static irqreturn_t pmz_interrupt(int irq, void *dev_id)
  skip_b:
 	spin_unlock(&uap_b->port.lock);
 	if (push)
-		tty_flip_buffer_push(&uap->port.state->port);
+		tty_flip_buffer_push(&uap_b->port.state->port);
 
  out:
 	return rc;
-- 
2.53.0




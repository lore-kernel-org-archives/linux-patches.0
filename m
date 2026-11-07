Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063377;
	b=E46y9qq6WXVo8Drsw3iaei/mgzhtX0ndCS0nlnRJ1lYq8e9RU392o8H1HR7yoyBWbmsi
	 db2aL0/ZDiV45zIAftkjJXI9g717uDqJ+34C93VLR8jSH0wZhcoGw30xrdVRVgGb24WWh
	 eFC3BF6dLViCKbQxurCl5NMkuMEms3qQT5bTltlI2bY/0C8U80n58mw88NVoriQ8b7Nk3
	 oFipctam/CbCQ87zhcHV2Ybz2ESkHXDcDKfMqZ9WRkZjDGj3tdAzNoCeElnPogsSy6oAJ
	 LJ3JtaMWA7OPZfkUyeuldPAbmnW7OWWRDhoTuHA5NjdjGMw9L0+/KWoeTWO0LxE2EXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NGI+7zy+PyVFYsqZlRTrlAsG/GM0PMZBpPCtIS/ljO0=;
	b=tcRxYf1x+HQYo4itSYPABnKbO5Uanqmb9pAPMdCmLbZ7HH4Dk+/teN5j0HU/xcvKgHzQ
	 H/3Fbp/JQx9cT8VtL4r+Auig+N+chC+WWSpnLDK7ZG6la2sn1bHW8fVYwC86AH/DnKNWN
	 or49vfBdf4b6Ew8pSg5P0q1KINjqLyedpeDFw1btDz5SuO7p/FP0IjlPJQRIb/YIJK2bf
	 SVgGDr5+NF2w9UlTNlnH+9TOPyAIQHT4tEffvGvHkRbEGc639ugWy94ozmk2wgXuCvM28
	 DPawbD7tJA3Ni3GWk+bbewENf24/2ZJnUv1Iset+VFXAJ/rX2/8xBFe/lKF+dsk6nIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p+e+cTRJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3388C6082BDC;
	Sat,  7 Nov 2026 14:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p+e+cTRJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A0E1F008A7;
	Sat,  7 Nov 2026 14:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063377;
	bh=NGI+7zy+PyVFYsqZlRTrlAsG/GM0PMZBpPCtIS/ljO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p+e+cTRJ6+lfhD6MPT1UGBKXjC1WW4lJqBtp/oRCTCJHNSFGf4LJkc9SfqXBhBs2W
	 zg9URCjNztrJyLRZi1CN8YgSOhsLCgLdRdoq8nWudbVhr+SS7eUWyd04rw2A7+5lN4
	 qVTSMogUynlycchgzQX7YOblyihGOPXwE5sg8Uok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Douglas <me@timdoug.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 551/869] serial: pmac_zilog: push received data to the port that received it
Date: Sat,  7 Nov 2026 08:53:53 -0500
Message-ID: <20261107134912.044298488@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e3a9193286954..f49d6052d11be 100644
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0788115218A;
	Tue,  2 Jul 2024 17:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941055; cv=none; b=U9B3NOjEhkvcY4xqBbwY0P6RiFoyCt5R4OMX3t7KGxHNxE0DP9WVlAW5VAq3DU8LA5jK7MbtC0kEtF0XrOsyIWDEdmi0QiRWhPcxcZ2A+A66MVfPrjlqALnosaL3pfa+jBI1goGsAwhyvO3NwxLVCdo/MYqhqJdcDsSzgdX508k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941055; c=relaxed/simple;
	bh=RDo+G3RQom1oSaIk/nFqWCO1PoN74DjrfxlihDlQjf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+pHARDcEPN3n1SMXejA9EfHypQiw0ubKERtr4qj+0Z/0O36R6bgw116pX3AvsLsj/ZaF1F9pTZ2MnGQN7hnfhOm6Q1wdIQforQGi3N+kuFdwm1eUjdRXCXWrBM8/LG0f+WwgFQd5HbybCdpDNRSAWGZCGqOeEZRVw6ht1bc3og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sns+rWHL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sns+rWHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B092C116B1;
	Tue,  2 Jul 2024 17:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941054;
	bh=RDo+G3RQom1oSaIk/nFqWCO1PoN74DjrfxlihDlQjf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sns+rWHLvVr17DC9lt0dNPS48XUHTEpHAN7V+nCQoGRGfCDZFmmdLtNqUd05gc1/o
	 Z7a0t237vy005+fCWMX4olIcjPxih5B/s5rgZMy5TjzRp63M1eFhitKxDFN1/Fj8HO
	 9nAkvOh7sguLqx7zSQkGnO9sLJgd1hOWa19YDtL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Brown <doug@schmorgal.com>
Subject: [PATCH 6.6 115/163] Revert "serial: core: only stop transmit when HW fifo is empty"
Date: Tue,  2 Jul 2024 19:03:49 +0200
Message-ID: <20240702170237.408963252@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doug Brown <doug@schmorgal.com>

commit c5603e2a621dac10c5e21cc430848ebcfa6c7e01 upstream.

This reverts commit 7bfb915a597a301abb892f620fe5c283a9fdbd77.

This commit broke pxa and omap-serial, because it inhibited them from
calling stop_tx() if their TX FIFOs weren't completely empty. This
resulted in these two drivers hanging during transmits because the TX
interrupt would stay enabled, and a new TX interrupt would never fire.

Cc: stable@vger.kernel.org
Fixes: 7bfb915a597a ("serial: core: only stop transmit when HW fifo is empty")
Signed-off-by: Doug Brown <doug@schmorgal.com>
Link: https://lore.kernel.org/r/20240606195632.173255-2-doug@schmorgal.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/serial_core.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -787,8 +787,7 @@ enum UART_TX_FLAGS {
 	if (pending < WAKEUP_CHARS) {					      \
 		uart_write_wakeup(__port);				      \
 									      \
-		if (!((flags) & UART_TX_NOSTOP) && pending == 0 &&	      \
-		    __port->ops->tx_empty(__port))			      \
+		if (!((flags) & UART_TX_NOSTOP) && pending == 0)	      \
 			__port->ops->stop_tx(__port);			      \
 	}								      \
 									      \



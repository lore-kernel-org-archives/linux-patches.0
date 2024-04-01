Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBAC1DFFC;
	Mon,  1 Apr 2024 16:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988128; cv=none; b=hxFuSgGmMqnkfRojzOPacIzRyJ3q9q5YtYjFmOFnmUee4bSXudR8/uF+PQ6LezjCMkYGM4lJTzzLCS3UGBU8io83L2rEYsXbvaLMLEGhw7scNhxgkbC0Cw6+Xz9vGRGqLx/a9jzCl7f2tEKhzeN7TtxqXmJCaGvul5+TbquBKJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988128; c=relaxed/simple;
	bh=NpY84Ckdwfd5LHs9fe/a2vWYPqTmp4CeiP4e2VG9UoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MnMY/2ZFp+W97kWFQO1iFBR10nmtaU3/HJ/3VvbaYMUUazsKsulkQJqbtNa8Q1HvtVqx68Twe9Kl0Tz4/KaMZWFPqL2fpTjjkJAFYQ1HKPKMt8jtMggws8b1VH5FTJ/P7YsgSJD94POcBFDJq6ItjbROsCHe2qkC/am/QLiqUJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kS3BR0wM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kS3BR0wM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1853C433C7;
	Mon,  1 Apr 2024 16:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988128;
	bh=NpY84Ckdwfd5LHs9fe/a2vWYPqTmp4CeiP4e2VG9UoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kS3BR0wMk3UKka0DbmPTMda4xbvZFHHAcAIansJY5tMU496f6jXfnqR+hdy8WbMJK
	 sgOzZDGuJhF89tLnMe5kklibcYDRMzhmXgRq3bYy+jvUXKgyDnao2vT2jFXFcTxfOM
	 22z3v3bR2ruU9Duaatn/iesKCyaLxYziOEgi2LfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 092/432] serial: core: only stop transmit when HW fifo is empty
Date: Mon,  1 Apr 2024 17:41:19 +0200
Message-ID: <20240401152555.868731658@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 7bfb915a597a301abb892f620fe5c283a9fdbd77 ]

If the circular buffer is empty, it just means we fit all characters to
send into the HW fifo, but not that the hardware finished transmitting
them.

So if we immediately call stop_tx() after that, this may abort any
pending characters in the HW fifo, and cause dropped characters on the
console.

Fix this by only stopping tx when the tx HW fifo is actually empty.

Fixes: 8275b48b2780 ("tty: serial: introduce transmit helpers")
Cc: stable@vger.kernel.org
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Link: https://lore.kernel.org/r/20240303150807.68117-1-jonas.gorski@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/serial_core.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index f43aca7f3b01e..678409c47b885 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -786,7 +786,8 @@ enum UART_TX_FLAGS {
 	if (pending < WAKEUP_CHARS) {					      \
 		uart_write_wakeup(__port);				      \
 									      \
-		if (!((flags) & UART_TX_NOSTOP) && pending == 0)	      \
+		if (!((flags) & UART_TX_NOSTOP) && pending == 0 &&	      \
+		    __port->ops->tx_empty(__port))			      \
 			__port->ops->stop_tx(__port);			      \
 	}								      \
 									      \
-- 
2.43.0




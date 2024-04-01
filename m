Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFBD51C23;
	Mon,  1 Apr 2024 15:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986817; cv=none; b=RsG9KoDzkrEqvHoNKesTlJwsCI0B8IUKgeFoZVebfj4C7WX+yrL20d67BLJb27pFFB99mDHBheFHM8R7yWebk2trYKVbxd1nhYVZcqUpNFSQbWIwcKpz26rldxGZVuSKX/abd3//QVq99d25cwXLlwMfOSXGfy4qvgaaFxXopxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986817; c=relaxed/simple;
	bh=xfHUAAgagqCSBrr2ZRVbNwLNq62pD1dM15zW5tPnSRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhGCCLMWZawWh8dUfJ0UftGla632E4FmbVawHvsxeVVb2UNobSwdwXJCfQlt9VvN7TqW7Cp0mAdY7tUGighEp46+FSIboMLKvcubeorecMg4mFgsm8NPGRCKME9jpI8eExnugG4jDUtJ8AwrMwtQMoIAJO+XWdD+k7CFJpFv3v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07Zz1Cc1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07Zz1Cc1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E09C43390;
	Mon,  1 Apr 2024 15:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986816;
	bh=xfHUAAgagqCSBrr2ZRVbNwLNq62pD1dM15zW5tPnSRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=07Zz1Cc1liB43pULAS57J7p/cDTMYh+51TsjZ3PgW82TeDWh1vUnMo4H39n6ZrfsH
	 qxYwP74KuDmdxYmfAFp1bYqEl6CDfjbSvvMcmCUUul6ScdhZzM3HDKOG7AY0/sWm9a
	 1Hozyyr71HajdHdQKZfS46sTG3hIwNmpA4LHhTzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 094/399] serial: core: only stop transmit when HW fifo is empty
Date: Mon,  1 Apr 2024 17:41:00 +0200
Message-ID: <20240401152551.989629640@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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
index 55b1f3ba48ac1..bb0f2d4ac62f6 100644
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




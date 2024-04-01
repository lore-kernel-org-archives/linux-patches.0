Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164401EB37;
	Mon,  1 Apr 2024 16:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989662; cv=none; b=B7V4x5TmYfQa2lz/D+9bz6lt9kJpmjeoCtTxWJI+MYFRXyxOVnEYzI91GRsiX81lshKlFOglff50m8sTNI2u/7YSz+STsEy2JS0NWoq8VOf+4xVKRWngSTBIM5fmaERRcMJlSKqaKv1YLPAnIlC6dqZdZzCy/DJZ3a7JcwOhk54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989662; c=relaxed/simple;
	bh=HEYpWH8s0/ScymLZsozfQqW2ZGLAuv0zdZJGS1/K44g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFVbGS3cAE10vuIRxG1CUMYOf0yztXCVeFNM7W42glH9YmvWcPlJH6LNrVde+GO0zPRBPl8HpS7Gusf/Nu2Zs/zui0fd84ORrzUYzrOUzzW64hWEv3Sk8ebN/wBES34B34QAIKACJQASxeYGhPwM03z40DAd4daHgALNBpO8iag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1hlzmTet; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1hlzmTet"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77416C433F1;
	Mon,  1 Apr 2024 16:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989661;
	bh=HEYpWH8s0/ScymLZsozfQqW2ZGLAuv0zdZJGS1/K44g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1hlzmTetXMv9TqvSOaWL9iKCOtKIUCVh3H/b21e5Tf5azfrhuw1uQL9A15xSy3j9Z
	 C0ExUWbYdAlMH3qCkJt3gYv5Amys2uDs/hgDRDTfHT1fCS80TZVQerH87O7Az4GHhj
	 8uE85eWSbivhLopivJibpeiwvhmWSFw2R1Gt4VR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/396] serial: core: only stop transmit when HW fifo is empty
Date: Mon,  1 Apr 2024 17:42:17 +0200
Message-ID: <20240401152550.541395412@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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
index 27a26092493ad..a7d5fa892be26 100644
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




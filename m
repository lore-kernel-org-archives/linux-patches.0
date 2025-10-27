Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639B130147E;
	Mon, 27 Oct 2025 19:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591979; cv=none; b=VYWURwC54Jnn2uGAJFCfjoUlWmeau/z0iTFKhsXpd403jlY+aiRZSnTYiBHNDGY81Vl59S9kfkPrberf3SlUeDlssrunzO8Q+5eF2HpAxxkw2RXP6peZlDNMh4SYvzl1oRZ0UI7EcTmm3vzO6A6xZQapMCpphQK6pn6Zcoy9aFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591979; c=relaxed/simple;
	bh=DPa4Zxp9nXruOS85KvFrdV7qScWSLMCeqvF1B0CrTfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FfFffzjYW+mbyXSX/Bk/hpy9XAF9kjjOP+LH01oDYAj0dVNR5ndQk226FmhF+ZhZKGFrCN7z/oDIyGrX+dIuiqQe09huZO44nZAcJF2IkR7eIIeIWwT+O9bIFFJXe94+tV8pDfIOIWQu2Wa7AY025PO92Pk8s5DCecDHu276+Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t10uhfUP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t10uhfUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF5EC113D0;
	Mon, 27 Oct 2025 19:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591979;
	bh=DPa4Zxp9nXruOS85KvFrdV7qScWSLMCeqvF1B0CrTfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t10uhfUPTNjrRM03m1WC8rO9/Vhb8kcUvEzHgcEGrbx+Svp3b2/AQp39I/UViCUwW
	 Dbhx+deLsICYgx/2IIXx8m+M7/W0DOU46N10Q5N9WGP9UBZx3ApDwS5N92hmXlDmqT
	 jKGFp3xu+e8F/maD05kBY9Mt+N1nrKKKSLR0PlBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/123] net: tls: wait for async completion on last message
Date: Mon, 27 Oct 2025 19:35:05 +0100
Message-ID: <20251027183447.072214363@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit 54001d0f2fdbc7852136a00f3e6fc395a9547ae5 ]

When asynchronous encryption is used KTLS sends out the final data at
proto->close time. This becomes problematic when the task calling
close() receives a signal. In this case it can happen that
tcp_sendmsg_locked() called at close time returns -ERESTARTSYS and the
final data is not sent.

The described situation happens when KTLS is used in conjunction with
io_uring, as io_uring uses task_work_add() to add work to the current
userspace task. A discussion of the problem along with a reproducer can
be found in [1] and [2]

Fix this by waiting for the asynchronous encryption to be completed on
the final message. With this there is no data left to be sent at close
time.

[1] https://lore.kernel.org/all/20231010141932.GD3114228@pengutronix.de/
[2] https://lore.kernel.org/all/20240315100159.3898944-1-s.hauer@pengutronix.de/

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Link: https://patch.msgid.link/20240904-ktls-wait-async-v1-1-a62892833110@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b014a4e066c5 ("tls: wait for async encrypt in case of error during latter iterations of sendmsg")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 6b0fd0e5fc880..d2cb19f5cb8bc 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1164,7 +1164,7 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 
 	if (!num_async) {
 		goto send_end;
-	} else if (num_zc) {
+	} else if (num_zc || eor) {
 		int err;
 
 		/* Wait for pending encryptions to get completed */
-- 
2.51.0




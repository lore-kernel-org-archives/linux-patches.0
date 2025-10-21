Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7CA2749CF;
	Tue, 21 Oct 2025 19:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076480; cv=none; b=oy7oemG88ofG1s1VAoCprFQNHhiZEoEX2UlPXCyKjIoF5Oo5/a9hJQw4jdH5nYfnskc5bQl8zkOJcWCM8vbDk8Hnnro9WF/ayBgpfphIpwSsJcPUrBmwGX5P2q8tlzokEuo4HIDGoZ8ReCvlQwxWCNwyr3ahmTkO8juj6xgPyZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076480; c=relaxed/simple;
	bh=Vi18ai1mEMcv9k9P/563n37k9fvHToc2oun/gbU8mG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WByue2baLcvO0tf8VE0seIEoIPzGNxhdESmmHpYmVsHmucThIHzBU6bVLZSVzbsbx26KKX7POKVBHzTZ3IqnB35rEUgWMfML6wJdSAkFCKmYBq8g6S9RKlhFxAXhVADct+oDLElWLGjCKlK9LD+BAWsw59JWo3idePZH6mzXExM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aOLS232S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aOLS232S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F1FC4CEF1;
	Tue, 21 Oct 2025 19:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076480;
	bh=Vi18ai1mEMcv9k9P/563n37k9fvHToc2oun/gbU8mG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aOLS232S0DF4GSiYDwzFol226qPqc4fcNDpv+4+MxYrKj4aUb12aT1oCxdd7DZZ4A
	 J7a9ChoaPhvbhGeeImHfIv2Of7cbc/d7vTrBjbVeOmZgFuzneAHGVL9DQHnTQK26r6
	 +31XPGXJPyFkTpR0xLKhmKBxLb2mRlgzHmY07+10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/105] net: tls: wait for async completion on last message
Date: Tue, 21 Oct 2025 21:50:54 +0200
Message-ID: <20251021195022.757030632@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 21276ac1f81dc..1f22c7adf3e56 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1228,7 +1228,7 @@ static int tls_sw_sendmsg_locked(struct sock *sk, struct msghdr *msg,
 
 	if (!num_async) {
 		goto send_end;
-	} else if (num_zc) {
+	} else if (num_zc || eor) {
 		int err;
 
 		/* Wait for pending encryptions to get completed */
-- 
2.51.0




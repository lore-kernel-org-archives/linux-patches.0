Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C55F352027;
	Sat, 30 May 2026 18:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164562; cv=none; b=oIXtDOSLzW6uDCEf6u5m5+wNOcYnRj3MjB/RMeMr+Ibif9y1K1KIotE1N0Obk714FZXe9M0aq4O0RrijK70Zt2MoSnCVkVulsKfEA9yFnw5s4PNpa69RIqqa01a3OSHAStf4KeC78enDVcOQPYaqSX3ccaAbegf9JWidlL6RTug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164562; c=relaxed/simple;
	bh=m/K1REEzZjA9GBujtQrFxHeUaVUwz+lSY9bWVOTzlB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuZqqRbaUnR9mOmC+qsUb1QDpE65M90uqdv+2CFJCya9P431HuJedC8OYhOg/D7BJ68sXjQ5rLHrU+arhVl0bBFEfRRNJam8jguqdLEyQjwxDZafoJNiLwnvgAmMSGx3dxLSadCGLUxra4upNt/0y0XJTJW4yamFQR8xqnHC9Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ddXySWNP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ddXySWNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A072E1F00893;
	Sat, 30 May 2026 18:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164561;
	bh=dR9Rv1xKw8bbjQ5jmIMBK0DhFyEZzgyeokEoj3Lyy6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ddXySWNPofpyiKWmLJlWGPK3qmOwzV+/CA2gb0/2VVMDQZagkPSW4GRU+NHQMNoYv
	 Gj6WCrZidMT1JOzzvOg0BHdQDOgg/0AFmA6dbJMdlRxkxT+YG4Wobyj2WMjQjBlMjj
	 5xrkkS0cf8o9unUTqWtR7W6CCDiAzp4OURTTYOps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 562/776] tcp: annotate data-races around (tp->write_seq - tp->snd_nxt)
Date: Sat, 30 May 2026 18:04:36 +0200
Message-ID: <20260530160254.656262893@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3a63b3d160560ef51e43fb4c880a5cde8078053c ]

tcp_get_timestamping_opt_stats() intentionally runs lockless, we must
add READ_ONCE() annotations to keep KCSAN happy.

WRITE_ONCE() annotations are already present.

Fixes: e08ab0b377a1 ("tcp: add bytes not sent to SCM_TIMESTAMPING_OPT_STATS")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260416200319.3608680-14-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 36981a3e9013f..dbb834d7eaee4 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3961,7 +3961,8 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 	nla_put_u32(stats, TCP_NLA_SRTT, tp->srtt_us >> 3);
 	nla_put_u16(stats, TCP_NLA_TIMEOUT_REHASH, tp->timeout_rehash);
 	nla_put_u32(stats, TCP_NLA_BYTES_NOTSENT,
-		    max_t(int, 0, tp->write_seq - tp->snd_nxt));
+		    max_t(int, 0,
+			  READ_ONCE(tp->write_seq) - READ_ONCE(tp->snd_nxt)));
 	nla_put_u64_64bit(stats, TCP_NLA_EDT, orig_skb->skb_mstamp_ns,
 			  TCP_NLA_PAD);
 	if (ack_skb)
-- 
2.53.0




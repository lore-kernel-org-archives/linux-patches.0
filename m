Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB223D75C9;
	Wed,  8 Apr 2026 18:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674489; cv=none; b=GT2B5RV8l5IkHGwHfTvkRygr7p8srJLesF9mNVtelySZIONGsy7IPQP7rLQGQvHO597iLOdoK+PnUaarY2cPjOzgkG+F4oMLaADbzLAfF0iIqOS+OGMbrTCUjFIV3n5py3Px9fFZedLLF6kYkUqIzg7Ho5ja3DR40HS8ltkg75c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674489; c=relaxed/simple;
	bh=H3tlk6PBdCbBjxpXsqJVqWkuafhCtD3961lxHR07Gn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eeu4PXlaCI/VSMT3XVPU5VhsUTGegGL+7umyQfDk8mwdLFBecsD1QV9KlFp7IyOMMe7SXpUa4LlTzpRxH0sJqTTi2AkPIH5o0gCJlotXzULIQ1VqrPH6LWc9ASQZ6Ze3K5kQJSoqqhUoZAcXK2hb1VJaBxkMmSSaJM2kXZa5yb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Va2UTDhx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Va2UTDhx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D351C19421;
	Wed,  8 Apr 2026 18:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674489;
	bh=H3tlk6PBdCbBjxpXsqJVqWkuafhCtD3961lxHR07Gn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Va2UTDhx7y8lH7uE8UvOqVOi7LVzcEkn5DmaiiEqVPYFGkr3x115iQtIY03MIneZx
	 VLzNfN9Pwp65IS/wZ02NFG3NcQMtqwSplDFRA/ttfcu2IPsVyeXVqdJ+XwhM8szHtM
	 xFAI1ei/K2xkStTs7ubYxIYnDq2ikiUzgTx3Mizc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Martin Schiller <ms@dev.tdt.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 118/311] net/x25: Fix overflow when accumulating packets
Date: Wed,  8 Apr 2026 20:01:58 +0200
Message-ID: <20260408175943.822934787@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schiller <ms@dev.tdt.de>

[ Upstream commit a1822cb524e89b4cd2cf0b82e484a2335496a6d9 ]

Add a check to ensure that `x25_sock.fraglen` does not overflow.

The `fraglen` also needs to be resetted when purging `fragment_queue` in
`x25_clear_queues()`.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Suggested-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Martin Schiller <ms@dev.tdt.de>
Link: https://patch.msgid.link/20260331-x25_fraglen-v4-2-3e69f18464b4@dev.tdt.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/x25/x25_in.c   | 4 ++++
 net/x25/x25_subr.c | 1 +
 2 files changed, 5 insertions(+)

diff --git a/net/x25/x25_in.c b/net/x25/x25_in.c
index 0dbc73efab1cb..e47ebd8acd21b 100644
--- a/net/x25/x25_in.c
+++ b/net/x25/x25_in.c
@@ -34,6 +34,10 @@ static int x25_queue_rx_frame(struct sock *sk, struct sk_buff *skb, int more)
 	struct sk_buff *skbo, *skbn = skb;
 	struct x25_sock *x25 = x25_sk(sk);
 
+	/* make sure we don't overflow */
+	if (x25->fraglen + skb->len > USHRT_MAX)
+		return 1;
+
 	if (more) {
 		x25->fraglen += skb->len;
 		skb_queue_tail(&x25->fragment_queue, skb);
diff --git a/net/x25/x25_subr.c b/net/x25/x25_subr.c
index 0285aaa1e93c1..159708d9ad20c 100644
--- a/net/x25/x25_subr.c
+++ b/net/x25/x25_subr.c
@@ -40,6 +40,7 @@ void x25_clear_queues(struct sock *sk)
 	skb_queue_purge(&x25->interrupt_in_queue);
 	skb_queue_purge(&x25->interrupt_out_queue);
 	skb_queue_purge(&x25->fragment_queue);
+	x25->fraglen = 0;
 }
 
 
-- 
2.53.0




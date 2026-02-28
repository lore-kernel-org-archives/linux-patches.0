Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C1A35AC36
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302712; cv=none; b=mbsVmsaztrJN1jqITqKi+5H7LPuYNmuALXpRl6/JrYCX/TH1IanenLSsFJkctul/bXAe7poYu1FkE2b0hXIvHAEhL56UELtc11zYrlHEqIi67E2HCLs2/5LTGiM58++q54EwlGGvnSpsmZoBLguQIMUMLvoSH3DCercCXG5m8Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302712; c=relaxed/simple;
	bh=u5nC5aWAQ7zjFxaE15TZZw4SjwCBwZ+SXE3Jio+6/WA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uoyqKkQi4asK3aGClPsKbAqU8f5WsMvFEAN6hwoJuTH3VerC4k3k8a0MZwBIAsBFDOuJ0Tf5c2NOXtkJ3MwPk1k4SjwVmGHFde2dE6m/WoxWFlkve2aLeKnQDEZZ+qEdpyCcUikflBF9ihWbY+E4lT6nFBmwltRTuqKKNlOh5yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hcfR3rE3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hcfR3rE3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F256EC19423;
	Sat, 28 Feb 2026 18:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302712;
	bh=u5nC5aWAQ7zjFxaE15TZZw4SjwCBwZ+SXE3Jio+6/WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hcfR3rE3jbbuAAkNGdKkJeAiu8DFJtTRUe9tEgwjpbqjN/8zitO/nydSbiqrgwHFL
	 aQbmRlayjQbdNobjx7myuGySwX0oJ3gx861lwEzq8JyQ4BQk2uWYK5saRstETe3Lan
	 pcRe4ew1VLd6CBXaHB9jy/mHvk8ZOHwJbey0QMFuY3v7Dopok/b15+kqbr/eJXqAoW
	 E95rQbn6RhvrzR9uQpSFOtnOo02N1rlDFw6uOCPTuAVxfQwTeELD/VzQTFSSi9Pewc
	 SyHk1/bRqP4fPIMLnrOSAKNr8rlbD2QmHrdt4L4jIg4eFxs+BDoE3ovwMcC8KS3p0t
	 2wXm54gKmzB5A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Dumazet <edumazet@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/147] tcp: tcp_tx_timestamp() must look at the rtx queue
Date: Sat, 28 Feb 2026 13:16:19 -0500
Message-ID: <20260228181736.1605592-71-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 838eb9687691d29915797a885b861fd09353386e ]

tcp_tx_timestamp() is only called at the end of tcp_sendmsg_locked()
before the final tcp_push().

By the time it is called, it is possible all the copied data
has been sent already (transmit queue is empty).

If this is the case, use the last skb in the rtx queue.

Fixes: 75c119afe14f ("tcp: implement rb-tree based retransmit queue")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Link: https://patch.msgid.link/20260127123828.4098577-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 6ffda70e7e58e..5998e2b6f5ec7 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -464,6 +464,9 @@ static void tcp_tx_timestamp(struct sock *sk, u16 tsflags)
 {
 	struct sk_buff *skb = tcp_write_queue_tail(sk);
 
+	if (unlikely(!skb))
+		skb = skb_rb_last(&sk->tcp_rtx_queue);
+
 	if (tsflags && skb) {
 		struct skb_shared_info *shinfo = skb_shinfo(skb);
 		struct tcp_skb_cb *tcb = TCP_SKB_CB(skb);
-- 
2.51.0


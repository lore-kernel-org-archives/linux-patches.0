Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7B814290C;
	Sun,  1 Sep 2024 16:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207885; cv=none; b=kZb7V+NMRqR9tdw6j6Ew88GfEj7OQ7W44Ur9t4NAsXp2cxdmU0YuEOy+KT9V/btlqShV0q8cS8HLyP96Rio9spYr3nXjaC3UPTuhGpEQC8GLMcRZKGTlD9GrliY0w/bFDuOorbtgCMdNL+HjUrL/3g4+WA5IMMgl6Ncdh8p+C/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207885; c=relaxed/simple;
	bh=hx3HbfcNhzTm4gkSlp3stk1+CvdmsZEKbZecv7mBnZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghHQUc9g4pDgbOBVbuakZ98Pi0wRfSkx7V9u779zgdglvT9RDNjcsrV2k7BULyxp+DWZ4AEvzFXtAAsBtqUpPZqji/mReeJv+S0c9iGnRFOiupSGfAnTbGfY/PH2pd4ONQE+iqg4kql/j6pvdGSq8CUxy3ifI37DCrLTQtSXpu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xKUN1fxj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xKUN1fxj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01EFC4CEC3;
	Sun,  1 Sep 2024 16:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207885;
	bh=hx3HbfcNhzTm4gkSlp3stk1+CvdmsZEKbZecv7mBnZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xKUN1fxjDt7cDdKeO02fK+lpowBbOv0ebj33I+KcbBAd0MzzrUQhzggTm3qa5JD3t
	 p2iQgXtbqgPTq/Fe8/3+cCn7V4WykrZ2HjnJLBf1w7rUKGJwVhnht51ejIvAM2IXj0
	 IysXWlvvVivYx9vHpT0ZBwZIKmu1IxXXBxuMnhWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Mina Almasry <almasrymina@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Joe Damato <jdamato@fastly.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 89/98] net: busy-poll: use ktime_get_ns() instead of local_clock()
Date: Sun,  1 Sep 2024 18:16:59 +0200
Message-ID: <20240901160807.053982274@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0870b0d8b393dde53106678a1e2cec9dfa52f9b7 ]

Typically, busy-polling durations are below 100 usec.

When/if the busy-poller thread migrates to another cpu,
local_clock() can be off by +/-2msec or more for small
values of HZ, depending on the platform.

Use ktimer_get_ns() to ensure deterministic behavior,
which is the whole point of busy-polling.

Fixes: 060212928670 ("net: add low latency socket poll")
Fixes: 9a3c71aa8024 ("net: convert low latency sockets to sched_clock()")
Fixes: 37089834528b ("sched, net: Fixup busy_loop_us_clock()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Reviewed-by: Joe Damato <jdamato@fastly.com>
Link: https://patch.msgid.link/20240827114916.223377-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/busy_poll.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index 8f42f6f3af86f..c45253ee08c9f 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -73,7 +73,7 @@ static inline bool sk_can_busy_loop(struct sock *sk)
 static inline unsigned long busy_loop_current_time(void)
 {
 #ifdef CONFIG_NET_RX_BUSY_POLL
-	return (unsigned long)(local_clock() >> 10);
+	return (unsigned long)(ktime_get_ns() >> 10);
 #else
 	return 0;
 #endif
-- 
2.43.0




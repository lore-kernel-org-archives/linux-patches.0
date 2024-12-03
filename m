Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED521F7561;
	Tue,  3 Dec 2024 15:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239381; cv=none; b=Xmo4zHGowW240B7DXopR4gmP3dR93pJH3b7MxrAqil65ONY1ZRbFs6sd1CkQFyIti4WinygAN66HxgyWz/bMVr0gzsQzrTUD6YU2fOjX3buRwQ4qzSqc7qMd+hXhTJFO4N3fKtSZnlAnMMOygaVtAYhlMHanqRjT/DQ7wktcKcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239381; c=relaxed/simple;
	bh=y3qwlepG6EU/1sorVHovihlo1v8PtGvPPE6hFDyYtq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMHehlNE3not6nEDN7qSI4d6qg19M+lydVMWg7nHORevQ0YgrNQmOcdmjfRC74Tn8UdCmTQWEvxXoqaF1YcNrtFKLNZKdz6xw6WuhcRakr4plQR+QCmILnMCEUWOhP63ugTRqat1RnwqDRUtF4lrn0v3BnjAxJxWyNHVwSq2tQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qOl/H52V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qOl/H52V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257C2C4CECF;
	Tue,  3 Dec 2024 15:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239381;
	bh=y3qwlepG6EU/1sorVHovihlo1v8PtGvPPE6hFDyYtq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qOl/H52VxE8KOeKzB9H4g2JbNGMgWkrvOzN+OkOFdRket0pUMc8kCFajVoUIUQaQH
	 K9HO2TsRkTDQQwTGQ14CXA35x2T+1pNVJjpKKDXPcHT1x7QjJZ45UkSpM6kmjXCYB5
	 kfsjA/tbP6FrTqPenNm6aFr1HDR4xhCmkSQIh2gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Jian <liujian56@huawei.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 594/817] tcp: Fix use-after-free of nreq in reqsk_timer_handler().
Date: Tue,  3 Dec 2024 15:42:46 +0100
Message-ID: <20241203144019.110357585@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit c31e72d021db2714df03df6c42855a1db592716c ]

The cited commit replaced inet_csk_reqsk_queue_drop_and_put() with
__inet_csk_reqsk_queue_drop() and reqsk_put() in reqsk_timer_handler().

Then, oreq should be passed to reqsk_put() instead of req; otherwise
use-after-free of nreq could happen when reqsk is migrated but the
retry attempt failed (e.g. due to timeout).

Let's pass oreq to reqsk_put().

Fixes: e8c526f2bdf1 ("tcp/dccp: Don't use timer_pending() in reqsk_queue_unlink().")
Reported-by: Liu Jian <liujian56@huawei.com>
Closes: https://lore.kernel.org/netdev/1284490f-9525-42ee-b7b8-ccadf6606f6d@huawei.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Liu Jian <liujian56@huawei.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20241123174236.62438-1-kuniyu@amazon.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_connection_sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index cd7989b514eaa..f5592670420b5 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1188,7 +1188,7 @@ static void reqsk_timer_handler(struct timer_list *t)
 
 drop:
 	__inet_csk_reqsk_queue_drop(sk_listener, oreq, true);
-	reqsk_put(req);
+	reqsk_put(oreq);
 }
 
 static bool reqsk_queue_hash_req(struct request_sock *req,
-- 
2.43.0




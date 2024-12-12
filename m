Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555BA223C4B;
	Thu, 12 Dec 2024 16:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022629; cv=none; b=gyF6KRrZeTAKVRiizALoxKVcXXw+wy+twgSPDLxKi/YIhIr2FBUobRA/0lck92EYnutUMucIdrDHjK+2hl4N5ZyRg4b9YtAzIAOMA4HXhbB0VmByPQR/I+zqptdTQzl3HWYsaQZI7KJD0KZsWYgKlaOWmVrVGx1NW5uTlu1x8uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022629; c=relaxed/simple;
	bh=KLsftxmMm5o7qsITaqt0i2MPVrqYL/YpBnEZnMSo86A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P33K4xLkZ/LaYncuM1ymAwWXIE8LBfcBZQbQUbs0Bv5iKcWnu0sctX8NDzt6e9WNnDW+BKI+yJaEcwwc91R+n0avkObw8lV1091SgXRL9yKxa5MXAtSimTj05EoTU1Kma6/mGYaAcXGIcBRcQmgzzxKzbqOqj1jFo4nQGsF3rnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IFUhhkiS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IFUhhkiS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987F5C4CECE;
	Thu, 12 Dec 2024 16:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022629;
	bh=KLsftxmMm5o7qsITaqt0i2MPVrqYL/YpBnEZnMSo86A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IFUhhkiSMJ44mG9FeCCnsxyS0U3fiFPrWXhfNyTukHDHwHweGDWiqTLk5/BPJbF3f
	 CypNAgMXoQkN4V7pfUdlL7OjtAkU/NN9lovLJfXqpd/fQdmoppJYFgjl5YQMxoe4Uv
	 vGxKQpDltk2aOF2gd3VhTcwuyhFObfyCnSyn6F4o=
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
Subject: [PATCH 5.15 285/565] tcp: Fix use-after-free of nreq in reqsk_timer_handler().
Date: Thu, 12 Dec 2024 15:58:00 +0100
Message-ID: <20241212144322.716881533@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 63e5aa6d4b0bc..73ef8b4f57049 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -935,7 +935,7 @@ static void reqsk_timer_handler(struct timer_list *t)
 
 drop:
 	__inet_csk_reqsk_queue_drop(sk_listener, oreq, true);
-	reqsk_put(req);
+	reqsk_put(oreq);
 }
 
 static bool reqsk_queue_hash_req(struct request_sock *req,
-- 
2.43.0




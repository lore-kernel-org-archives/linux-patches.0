Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B6C31F98D;
	Sat, 30 May 2026 18:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164662; cv=none; b=j+K7QH2REsnc4Aqwy07CYX++rpTCi/E4iV09qCPpXiHDv6A/sr7z+KBPXD7UnIYMOG7inT7DrghfQc/rstUV6uE2YqL47T9N+LVkmUsJrRWF2xU5cJBEO2dLYD8+hNnQ5MNZbFBRargCxloL8MhKU2t2vr36JBtLE75eVSuo9h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164662; c=relaxed/simple;
	bh=rJNgLILPo0IUEaLMcL8CAtbB/93DAwZ1rhIjpBBoSY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2wQktszpzMFqDnrxMg0A2D9cNd0CIe0ZnZwsyUq7VIgMXp98Bp3L0Cyk9YSnrBPbk4C55xi52pS8U2ejM6W7i7HT9GjrgeTTrOMcM+/fKRdMDRb2TxydXg1P5uD1pjQSRzN7eM4rcZGL+AoCfGejum5oQNT82h8SYNP27Rj6k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FLDAqdYm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FLDAqdYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BC31F00893;
	Sat, 30 May 2026 18:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164661;
	bh=qblLaRqnpdGaVsACcnDYCVGvXfdTjc8gmle28wlVD24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FLDAqdYmP2cBJyx7PKpRRTYIg5FtK8RUPsK/u7K31T5Vu8gL5a5CETPzhaUp5UtUx
	 2zW6I4W5AcU2hX/BwvbwjNecCkuPo5T4LBeNL/PD3lSkCJsbFrKm4e1QhUZZ9sRMIX
	 smRM777R/oFJ1BK3p+nSD4he1lLWRVeRGoT2as64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Lee Jones <lee@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 592/776] tipc: fix double-free in tipc_buf_append()
Date: Sat, 30 May 2026 18:05:06 +0200
Message-ID: <20260530160255.354429630@linuxfoundation.org>
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

From: Lee Jones <lee@kernel.org>

[ Upstream commit d293ca716e7d5dffdaecaf6b9b2f857a33dc3d3a ]

tipc_msg_validate() can potentially reallocate the skb it is validating,
freeing the old one.  In tipc_buf_append(), it was being called with a
pointer to a local variable which was a copy of the caller's skb
pointer.

If the skb was reallocated and validation subsequently failed, the error
handling path would free the original skb pointer, which had already
been freed, leading to double-free.

Fix this by checking if head now points to a newly allocated reassembled
skb.  If it does, reassign *headbuf for later freeing operations.

Fixes: d618d09a68e4 ("tipc: enforce valid ratio between skb truesize and contents")
Suggested-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Signed-off-by: Lee Jones <lee@kernel.org>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/msg.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index 76284fc538ebd..b0bba0feef564 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -177,8 +177,20 @@ int tipc_buf_append(struct sk_buff **headbuf, struct sk_buff **buf)
 
 	if (fragid == LAST_FRAGMENT) {
 		TIPC_SKB_CB(head)->validated = 0;
-		if (unlikely(!tipc_msg_validate(&head)))
+
+		/* If the reassembled skb has been freed in
+		 * tipc_msg_validate() because of an invalid truesize,
+		 * then head will point to a newly allocated reassembled
+		 * skb, while *headbuf points to freed reassembled skb.
+		 * In such cases, correct *headbuf for freeing the newly
+		 * allocated reassembled skb later.
+		 */
+		if (unlikely(!tipc_msg_validate(&head))) {
+			if (head != *headbuf)
+				*headbuf = head;
 			goto err;
+		}
+
 		*buf = head;
 		TIPC_SKB_CB(head)->tail = NULL;
 		*headbuf = NULL;
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7BA79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95991C433EF;
	Thu, 12 Jan 2023 14:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534190;
	bh=L9FGUhW3sJUgrnlz/l6vXjkMxba9BAXjwVEp6MA726U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jY1wzWQqAJb5Wl92DZbPsu6KhtXJPnINwopdog/P1/euyVfaHdF0DZGDTqt+2P8nd
	 /CIo/hYBathm/fVXijhchOOWZ+rywfrPGOQyyJmy5q62tM504ogb0UEJ8zk887j1pG
	 V14HtgR6kjzN1Hmcemd8TOZIzM0gRqo1GjbiJIIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Parthasarathy <anpartha@meta.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Stanislav Fomichev <sdf@google.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 725/783] bpf: pull before calling skb_postpull_rcsum()
Date: Thu, 12 Jan 2023 14:57:21 +0100
Message-Id: <20230112135557.965267067@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 54c3f1a81421f85e60ae2eaae7be3727a09916ee ]

Anand hit a BUG() when pulling off headers on egress to a SW tunnel.
We get to skb_checksum_help() with an invalid checksum offset
(commit d7ea0d9df2a6 ("net: remove two BUG() from skb_checksum_help()")
converted those BUGs to WARN_ONs()).
He points out oddness in how skb_postpull_rcsum() gets used.
Indeed looks like we should pull before "postpull", otherwise
the CHECKSUM_PARTIAL fixup from skb_postpull_rcsum() will not
be able to do its job:

	if (skb->ip_summed == CHECKSUM_PARTIAL &&
	    skb_checksum_start_offset(skb) < 0)
		skb->ip_summed = CHECKSUM_NONE;

Reported-by: Anand Parthasarathy <anpartha@meta.com>
Fixes: 6578171a7ff0 ("bpf: add bpf_skb_change_proto helper")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/r/20221220004701.402165-1-kuba@kernel.org
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index e3cdbd4996e0..a5df0cf46bbf 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3201,15 +3201,18 @@ static int bpf_skb_generic_push(struct sk_buff *skb, u32 off, u32 len)
 
 static int bpf_skb_generic_pop(struct sk_buff *skb, u32 off, u32 len)
 {
+	void *old_data;
+
 	/* skb_ensure_writable() is not needed here, as we're
 	 * already working on an uncloned skb.
 	 */
 	if (unlikely(!pskb_may_pull(skb, off + len)))
 		return -ENOMEM;
 
-	skb_postpull_rcsum(skb, skb->data + off, len);
-	memmove(skb->data + len, skb->data, off);
+	old_data = skb->data;
 	__skb_pull(skb, len);
+	skb_postpull_rcsum(skb, old_data + off, len);
+	memmove(skb->data, old_data, off);
 
 	return 0;
 }
-- 
2.35.1




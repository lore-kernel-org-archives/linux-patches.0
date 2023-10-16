Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98CA1798F
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DhqpIcxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89C5C433C8;
	Mon, 16 Oct 2023 08:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446597;
	bh=ahue3Cg2KDW4TU61ELAGNIHYcUJaxc+fJq8fogKzNkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DhqpIcxxD4rCin/H+5yzAoFaXYd+t/TQSWxc0ncEy4RkzlDUaTcsTEvu0kJRtFsi/
	 O+GGxP0lhTly8qnwIbysTQ38evOsKm+9uATGp/ACb6epiS7oaHOqysJcYsfMQdxVIA
	 rd4HfLq71MXrgqfi5BqIeAnBjyFODnQT81joEq54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/131] net: refine debug info in skb_checksum_help()
Date: Mon, 16 Oct 2023 10:40:38 +0200
Message-ID: <20231016084001.440100088@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 26c29961b142444cd99361644c30fa1e9b3da6be ]

syzbot uses panic_on_warn.

This means that the skb_dump() I added in the blamed commit are
not even called.

Rewrite this so that we get the needed skb dump before syzbot crashes.

Fixes: eeee4b77dc52 ("net: add more debug info in skb_checksum_help()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20231006173355.2254983-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index a2e3c6470ab3f..5374761f5af2c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3274,15 +3274,19 @@ int skb_checksum_help(struct sk_buff *skb)
 
 	offset = skb_checksum_start_offset(skb);
 	ret = -EINVAL;
-	if (WARN_ON_ONCE(offset >= skb_headlen(skb))) {
+	if (unlikely(offset >= skb_headlen(skb))) {
 		DO_ONCE_LITE(skb_dump, KERN_ERR, skb, false);
+		WARN_ONCE(true, "offset (%d) >= skb_headlen() (%u)\n",
+			  offset, skb_headlen(skb));
 		goto out;
 	}
 	csum = skb_checksum(skb, offset, skb->len - offset, 0);
 
 	offset += skb->csum_offset;
-	if (WARN_ON_ONCE(offset + sizeof(__sum16) > skb_headlen(skb))) {
+	if (unlikely(offset + sizeof(__sum16) > skb_headlen(skb))) {
 		DO_ONCE_LITE(skb_dump, KERN_ERR, skb, false);
+		WARN_ONCE(true, "offset+2 (%zu) > skb_headlen() (%u)\n",
+			  offset + sizeof(__sum16), skb_headlen(skb));
 		goto out;
 	}
 	ret = skb_ensure_writable(skb, offset + sizeof(__sum16));
-- 
2.40.1




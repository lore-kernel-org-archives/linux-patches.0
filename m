Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84901D0798;
	Wed,  2 Oct 2024 14:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879306; cv=none; b=SaSQT7F40Pzl/9hJmdFbD/xhtjrsYqczQu6n7JJbXlN1LS8FPmIxWJLpZVSONNXr7vXtozitzRCLT0ny94Wp/e/k6oq3UKNyNpm9hjb7gKOp0yQ6NuxphRAAgATQE+SBQi1lnwVXUO2LXJr/hGCZqRYNV2SGHcKVoLtRIl1M1c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879306; c=relaxed/simple;
	bh=o/+quEcw8BvGQ4tTRgl1bp0fRcUUTNifb2J/NP3mx2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ac6Cem03B+ovNQ2ZxdT0ZSquNtxfDBHy8ajL7J8r4AOSAqugCbwYzfOD5ZDZe3hwjldGoVyzcOcrUxblc5a/GjiPFeB7Qqln51h/4o1vF7Yp8PmWZWQ1XSxoqAvtWa7v7vOx88ZLLSibemC9prTYD9p/wKHbwrDKfSIKI6EtsKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uNANokeR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uNANokeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72BFBC4CEC2;
	Wed,  2 Oct 2024 14:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879305;
	bh=o/+quEcw8BvGQ4tTRgl1bp0fRcUUTNifb2J/NP3mx2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uNANokeRyLMuWJduoNaVfMEPTngBwv9dXElw1+DUVv4ElNaBKHEqOdKy9Afv7A4m4
	 9KdwM2WTK3zaeIb6YpBfAEKLHFaBaYGKl+VVlMFXw1aNLROMot1hlclflA54b50zOZ
	 Ua4qzQKN2A9ZzqUR3XhRaQ+GNBbDuSU3rEqopDac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Justin Stitt <justinstitt@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/538] net: tipc: avoid possible garbage value
Date: Wed,  2 Oct 2024 14:55:13 +0200
Message-ID: <20241002125755.135379005@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 99655a304e450baaae6b396cb942b9e47659d644 ]

Clang static checker (scan-build) warning:
net/tipc/bcast.c:305:4:
The expression is an uninitialized value. The computed value will also
be garbage [core.uninitialized.Assign]
  305 |                         (*cong_link_cnt)++;
      |                         ^~~~~~~~~~~~~~~~~~

tipc_rcast_xmit() will increase cong_link_cnt's value, but cong_link_cnt
is uninitialized. Although it won't really cause a problem, it's better
to fix it.

Fixes: dca4a17d24ee ("tipc: fix potential hanging after b/rcast changing")
Signed-off-by: Su Hui <suhui@nfschina.com>
Reviewed-by: Justin Stitt <justinstitt@google.com>
Link: https://patch.msgid.link/20240912110119.2025503-1-suhui@nfschina.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/bcast.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/bcast.c b/net/tipc/bcast.c
index 593846d252143..114fef65f92ea 100644
--- a/net/tipc/bcast.c
+++ b/net/tipc/bcast.c
@@ -320,8 +320,8 @@ static int tipc_mcast_send_sync(struct net *net, struct sk_buff *skb,
 {
 	struct tipc_msg *hdr, *_hdr;
 	struct sk_buff_head tmpq;
+	u16 cong_link_cnt = 0;
 	struct sk_buff *_skb;
-	u16 cong_link_cnt;
 	int rc = 0;
 
 	/* Is a cluster supporting with new capabilities ? */
-- 
2.43.0




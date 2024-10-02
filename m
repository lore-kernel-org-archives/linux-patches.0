Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A991D043E;
	Wed,  2 Oct 2024 13:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875486; cv=none; b=ThhAIgRSf2cQrN0+/jN7TBh0D1Pg8ZZZwavflC9LH/RF59onw7t8h3ZgOGkvgJJTImSIRorQPqMFXf/Z6JYnkFOtcmC84UbsPGddvckUq8I7r5eilVzOclBq8Ed/vVVzByrot8DestQZnV3SOp0tjIqFvlSmoxVqO3kjuCfBFNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875486; c=relaxed/simple;
	bh=PJIjmgiV8OeOuSG+X15ZDTMLlrWoYOV8iXUNt5Rqx2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dstvzHVQNLZYerWieZwtZHYcUYpnixwS0OzbY2xmgE+Vo7Lx7WJWCnPaNmqJUO/4aOQdqUoUGk8hShf8Z6f9ehyktiiZz+XVXjFOv0yEVTORCheBxPL+cwoZTn5afDVXfHXcv0S6yzwqvETXQD/bAB9rqYg0x8fE2H9fTgi7NXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M/+3MbNA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M/+3MbNA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE345C4CEC5;
	Wed,  2 Oct 2024 13:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875486;
	bh=PJIjmgiV8OeOuSG+X15ZDTMLlrWoYOV8iXUNt5Rqx2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M/+3MbNAsD/2lbHK08687VVJt8mr1VEzNg5ebkMWn1bZ6elSPh3kUVPeFBy4GPnCb
	 YmPXuA4ryGAVlFJqLhT//8FJyXtuCjP9ONRdIubzI5ssidrfGuNoStah2liJdcJ3lT
	 triqhEDvJ+lYenK93FGLiTPIaRszTZbXOUjdzyC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Justin Stitt <justinstitt@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 116/695] net: tipc: avoid possible garbage value
Date: Wed,  2 Oct 2024 14:51:54 +0200
Message-ID: <20241002125827.104174244@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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




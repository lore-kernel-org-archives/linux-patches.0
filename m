Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F641A5A4
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0kDpYwGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BB9C433C7;
	Mon,  9 Oct 2023 13:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857766;
	bh=yYYJBQPgPQ9xfqLMfGffHHm1HaALFKDXPJr6rGhxRqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0kDpYwGhihDQs3K5o4AlSCFt88Oddv2b6o4xvJ9aVR5Ty8Z1KKqcf2BSLsWGrOv34
	 lhSSU2Lt+BzPzwvOMJb5JCrfpLJx1Ry6L+b5Z7Ez/d0FfVZYO53W6tqHkatajzYoNj
	 KUwSblEwMH2PZSjmPLTsPmo5RR0BbGj9WteJhe6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chentao.kernel@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 132/162] netlink: Fix potential skb memleak in netlink_ack
Date: Mon,  9 Oct 2023 15:01:53 +0200
Message-ID: <20231009130126.558860393@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

From: Tao Chen <chentao.kernel@linux.alibaba.com>

[ Upstream commit e69761483361f3df455bc493c99af0ef1744a14f ]

Fix coverity issue 'Resource leak'.

We should clean the skb resource if nlmsg_put/append failed.

Fixes: 738136a0e375 ("netlink: split up copies in the ack construction")
Signed-off-by: Tao Chen <chentao.kernel@linux.alibaba.com>
Link: https://lore.kernel.org/r/bff442d62c87de6299817fe1897cc5a5694ba9cc.1667638204.git.chentao.kernel@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: d0f95894fda7 ("netlink: annotate data-races around sk->sk_err")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 4ddb2ed7706ad..845ac56a3ac2e 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2444,7 +2444,7 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 
 	skb = nlmsg_new(payload + tlvlen, GFP_KERNEL);
 	if (!skb)
-		goto err_bad_put;
+		goto err_skb;
 
 	rep = nlmsg_put(skb, NETLINK_CB(in_skb).portid, nlh->nlmsg_seq,
 			NLMSG_ERROR, sizeof(*errmsg), flags);
@@ -2472,6 +2472,8 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 	return;
 
 err_bad_put:
+	nlmsg_free(skb);
+err_skb:
 	NETLINK_CB(in_skb).sk->sk_err = ENOBUFS;
 	sk_error_report(NETLINK_CB(in_skb).sk);
 }
-- 
2.40.1




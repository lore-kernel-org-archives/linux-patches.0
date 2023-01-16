Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8780846B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0316AC433EF;
	Mon, 16 Jan 2023 16:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885223;
	bh=1U4Mkb9V8DyVnckHBecy7fGVq7/rV/QKE9gyYrsz1Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rd2u/d2zG37bUmGrKBESEvetIQLc+Q1uCczeYijEIX9y5Sw4v/WmDqEo5SUQDoUAa
	 /i/dqDNACwinpYfR+uXbeMZf1wf18taznXjjqzH26go/WjgjRhrHBapDlXqOf2NWrL
	 xmL704eIjQiwTCJKfyOLeeG0gpFEfNDWU1INYbwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3d9866419b4aa8f985d6@syzkaller.appspotmail.com,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.10 34/64] xfrm: fix rcu lock in xfrm_notify_userpolicy()
Date: Mon, 16 Jan 2023 16:51:41 +0100
Message-Id: <20230116154744.749383933@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
References: <20230116154743.577276578@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit 93ec1320b0170d7a207eda2d119c669b673401ed upstream.

As stated in the comment above xfrm_nlmsg_multicast(), rcu read lock must
be held before calling this function.

Reported-by: syzbot+3d9866419b4aa8f985d6@syzkaller.appspotmail.com
Fixes: 703b94b93c19 ("xfrm: notify default policy on update")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_user.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1920,6 +1920,7 @@ static int xfrm_notify_userpolicy(struct
 	int len = NLMSG_ALIGN(sizeof(*up));
 	struct nlmsghdr *nlh;
 	struct sk_buff *skb;
+	int err;
 
 	skb = nlmsg_new(len, GFP_ATOMIC);
 	if (skb == NULL)
@@ -1938,7 +1939,11 @@ static int xfrm_notify_userpolicy(struct
 
 	nlmsg_end(skb, nlh);
 
-	return xfrm_nlmsg_multicast(net, skb, 0, XFRMNLGRP_POLICY);
+	rcu_read_lock();
+	err = xfrm_nlmsg_multicast(net, skb, 0, XFRMNLGRP_POLICY);
+	rcu_read_unlock();
+
+	return err;
 }
 
 static bool xfrm_userpolicy_is_valid(__u8 policy)



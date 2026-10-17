Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0140D35E93B;
	Sat, 17 Oct 2026 17:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258522; cv=none; b=fjHRI8rX801ieCa/BrfCHZ0B6OkcXnVpTl0bKYvSeil+BW9gBtj0GC8PZSHqiZ9DqZwmlxUmGHtqaTurE1lRkqsxS8dhsfLr3ccx5jDDZkLANsVXWvWDLqJIWNEXdM7004hzTQxEXqWQhmKoOuGLWSYtzoATlX00O1mlOgqqznA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258522; c=relaxed/simple;
	bh=nhMDEAxLuDSqanmBqb9f+wjeMs/NljxHP1TA7LczaZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYyOhREUclikHTAuBe/Crr2+lMfdOZLySQPcZGLumIJbnv2VC0290jX3YU/MjG/zlqzCt5/XCgbr85agnoufs6rRmQMY8AT8G9U/Sp1J5OxY45McLe0gAGzeQWepHSKNyXJDZMzuzSjsmpm4nkojiTHfM4ZsS2qoJzf94MJIZqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wLblY/BU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wLblY/BU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB761F000C4;
	Sat, 17 Oct 2026 17:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258520;
	bh=cZzDDMyJmtq4/oVisvmHJ6EZ+Yzbnt104d8uHe3tD4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wLblY/BUBXUa6xRyTfkFDpqzYyfEOCLGmExQUg3/F2ZrXAI5v7cxfXDOG203RXvg6
	 XrNcpMcnz2R2WXms62P/U3zvbY+IltSkKNMXOwBdmWkWDDqVPm9uymn+7F6iYUUk/Q
	 zaDhpLnJwIQ/gctJoMji+f9WwMAyrFpvdqZ2Tuo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keenan Dong <keenanat2000@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0912/1674] xfrm: account XFRMA_IF_ID in aevent size calculation
Date: Sat, 17 Oct 2026 17:53:04 +0200
Message-ID: <20261017160454.543282888@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keenan Dong <keenanat2000@gmail.com>

[ Upstream commit 7081d46d32312f1a31f0e0e99c6835a394037599 ]

xfrm_get_ae() allocates the reply skb with xfrm_aevent_msgsize(), then
build_aevent() appends attributes including XFRMA_IF_ID when x->if_id is
set.

xfrm_aevent_msgsize() does not include space for XFRMA_IF_ID. For states
with if_id, build_aevent() can fail with -EMSGSIZE and hit BUG_ON(err < 0)
in xfrm_get_ae(), turning a malformed netlink interaction into a kernel
panic.

Account XFRMA_IF_ID in the size calculation unconditionally and replace
the BUG_ON with normal error unwinding.

Fixes: 7e6526404ade ("xfrm: Add a new lookup key to match xfrm interfaces.")
Reported-by: Keenan Dong <keenanat2000@gmail.com>
Signed-off-by: Keenan Dong <keenanat2000@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index b926d4651c068..2f84d8ddc46d4 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2404,7 +2404,8 @@ static inline unsigned int xfrm_aevent_msgsize(struct xfrm_state *x)
 	       + nla_total_size_64bit(sizeof(struct xfrm_lifetime_cur))
 	       + nla_total_size(sizeof(struct xfrm_mark))
 	       + nla_total_size(4) /* XFRM_AE_RTHR */
-	       + nla_total_size(4); /* XFRM_AE_ETHR */
+	       + nla_total_size(4) /* XFRM_AE_ETHR */
+	       + nla_total_size(sizeof(x->if_id)); /* XFRMA_IF_ID */
 }
 
 static int build_aevent(struct sk_buff *skb, struct xfrm_state *x, const struct km_event *c)
@@ -2505,7 +2506,12 @@ static int xfrm_get_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
 	c.portid = nlh->nlmsg_pid;
 
 	err = build_aevent(r_skb, x, &c);
-	BUG_ON(err < 0);
+	if (err < 0) {
+		spin_unlock_bh(&x->lock);
+		xfrm_state_put(x);
+		kfree_skb(r_skb);
+		return err;
+	}
 
 	err = nlmsg_unicast(xfrm_net_nlsk(net, skb), r_skb, NETLINK_CB(skb).portid);
 	spin_unlock_bh(&x->lock);
-- 
2.53.0




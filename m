Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382EE1DE8AE;
	Sun,  7 Jun 2026 10:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826898; cv=none; b=kJB1lkVKTvfarimBJFS00JN68RpWwxlY6Tfz/RmCrgAD6k/LLCajLcrTOptaNQGCh+WDgPICm6rB63p1DXFqz+fbNLH3767MOpQ4ziUI7oUFJq454Bv9xgVVj2X5u8z9GEpm+yvfxrLYZbfTitZ14V0B2dGKxz6ov9gvXetncok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826898; c=relaxed/simple;
	bh=NbBApvIgM2sBGcXnE9c9e1M9OuL7ZRWXDDGmMGrSs9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rki2bNYGLXX2suihuFRvJr8+HnrJ9qVDnPnIra1R9l99bOGjK8/HYqCylXb2tN7kCYEX52f1EheTIj3LS7SEnsV0UmqDWcAh8AxVavqqYwMCFXB7bws1QRMvWm2XNQvgnXw5ZUnGiooWym1ExLLt/GgiqaFvIBkGnpdoVBuXrhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tmjHOfs0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tmjHOfs0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F94E1F00893;
	Sun,  7 Jun 2026 10:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826897;
	bh=wj+gpk04cvi96B3e5NrV0kYN1KXnQaWGn+X5xtd2nUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tmjHOfs0T3xLQ+320De9aYk76wfdp2gyfK5VJ9i20YmmVsDuSHJdc5f0aAGP2LJYK
	 r9ln9dmw2a8z3Rd06zqNgcl6xf8BnLA++dsx0bfORn2q1KRzHeazktU+I3GIOo9flE
	 80yPTC/zFGOnbV+3brjxBRU+xnRG4U1pmgkdEY3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 041/332] ethtool: rss: avoid modifying the RSS context response
Date: Sun,  7 Jun 2026 11:56:50 +0200
Message-ID: <20260607095729.624283502@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit c75b6f6eaacd0b74b832414cc3b9289c3686e941 ]

Gemini says that we're modifying the RSS_CREATE response skb.
I think it's right, the comment says that unicast() should
unshare the skb but I'm not entirely sure what I meant there.
netlink_trim() does a copy but only if skb is not well sized
(it's at least 2x larger than necessary for the payload).

Fixes: a166ab7816c5 ("ethtool: rss: support creating contexts via Netlink")
Link: https://patch.msgid.link/20260522230647.1705600-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/rss.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/ethtool/rss.c b/net/ethtool/rss.c
index da5934cceb0757..926be5698ba4cc 100644
--- a/net/ethtool/rss.c
+++ b/net/ethtool/rss.c
@@ -974,11 +974,17 @@ ethnl_rss_create_validate(struct net_device *dev, struct genl_info *info)
 }
 
 static void
-ethnl_rss_create_send_ntf(struct sk_buff *rsp, struct net_device *dev)
+ethnl_rss_create_send_ntf(const struct sk_buff *rsp, struct net_device *dev)
 {
-	struct nlmsghdr *nlh = (void *)rsp->data;
 	struct genlmsghdr *genl_hdr;
+	struct nlmsghdr *nlh;
+	struct sk_buff *ntf;
+
+	ntf = skb_copy_expand(rsp, 0, 0, GFP_KERNEL);
+	if (!ntf)
+		return;
 
+	nlh = nlmsg_hdr(ntf);
 	/* Convert the reply into a notification */
 	nlh->nlmsg_pid = 0;
 	nlh->nlmsg_seq = ethnl_bcast_seq_next();
@@ -986,7 +992,7 @@ ethnl_rss_create_send_ntf(struct sk_buff *rsp, struct net_device *dev)
 	genl_hdr = nlmsg_data(nlh);
 	genl_hdr->cmd =	ETHTOOL_MSG_RSS_CREATE_NTF;
 
-	ethnl_multicast(rsp, dev);
+	ethnl_multicast(ntf, dev);
 }
 
 int ethnl_rss_create_doit(struct sk_buff *skb, struct genl_info *info)
@@ -1094,12 +1100,8 @@ int ethnl_rss_create_doit(struct sk_buff *skb, struct genl_info *info)
 
 	genlmsg_end(rsp, hdr);
 
-	/* Use the same skb for the response and the notification,
-	 * genlmsg_reply() will copy the skb if it has elevated user count.
-	 */
-	skb_get(rsp);
-	ret = genlmsg_reply(rsp, info);
 	ethnl_rss_create_send_ntf(rsp, dev);
+	ret = genlmsg_reply(rsp, info);
 	rsp = NULL;
 
 exit_unlock:
-- 
2.53.0




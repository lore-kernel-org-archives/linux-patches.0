Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517CC280305;
	Tue, 27 May 2025 17:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367467; cv=none; b=h6ZovLv4N5x6tGnG3dRorH6Rn55QZunWpWUof6g2STfBw3IBs1eofF/mPOny+rjn+pe7SN5qTDAsti95pwGoRg692ydrWTLPALBn5rqkMflKccwPu5lvJjnXunM4vb/++9sYzDQHOAjRvIkwRd4sPElaWrwL+Ve9Cl0GBae6h6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367467; c=relaxed/simple;
	bh=MSxJeLgUIb+joyNf+2mrF6mNrjjZGo3At3zh+//8y9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3mkMmCb5pT/pOc1j9P04k71wbUwYWkaC4M8QeENtpGNzADizhKeCF/D/bq4ZaXqUZ1bvxhmoUQ4NrKk7C/OEq5ZwtYMdeadD6uv0/gLvO/QmGP35eUCZBW3vm9eZcl9f6HVNurffVP6E+Tv7kSDD+jE5YcfVm2+HFRaLjiaSbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mKXdaE+a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mKXdaE+a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46DBC4CEE9;
	Tue, 27 May 2025 17:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367467;
	bh=MSxJeLgUIb+joyNf+2mrF6mNrjjZGo3At3zh+//8y9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mKXdaE+aPcFKVZmSIm7tkwiyViZb8EX9lnrhCfAjKg8MFhljobyh9iX5hwDEs/ys4
	 u3+/DUXabMH1bhc1kk+dhnofbIklpp8R3VxJNPR7fg0pJc03PBxqbL69x9o/oMS9jX
	 +OKJbWGyrtpXJ6vE87o+MZTgqVQqKQMuOx+dGiIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 380/783] rtnetlink: Lookup device in target netns when creating link
Date: Tue, 27 May 2025 18:22:57 +0200
Message-ID: <20250527162528.567108709@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiao Liang <shaw.leon@gmail.com>

[ Upstream commit ec061546c6cffbb8929495bba3953f0cc5e177fa ]

When creating link, lookup for existing device in target net namespace
instead of current one.
For example, two links created by:

  # ip link add dummy1 type dummy
  # ip link add netns ns1 dummy1 type dummy

should have no conflict since they are in different namespaces.

Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250219125039.18024-2-shaw.leon@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 80e006940f51a..ab7041150f295 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3865,20 +3865,26 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 {
 	struct nlattr ** const tb = tbs->tb;
 	struct net *net = sock_net(skb->sk);
+	struct net *device_net;
 	struct net_device *dev;
 	struct ifinfomsg *ifm;
 	bool link_specified;
 
+	/* When creating, lookup for existing device in target net namespace */
+	device_net = (nlh->nlmsg_flags & NLM_F_CREATE) &&
+		     (nlh->nlmsg_flags & NLM_F_EXCL) ?
+		     tgt_net : net;
+
 	ifm = nlmsg_data(nlh);
 	if (ifm->ifi_index > 0) {
 		link_specified = true;
-		dev = __dev_get_by_index(net, ifm->ifi_index);
+		dev = __dev_get_by_index(device_net, ifm->ifi_index);
 	} else if (ifm->ifi_index < 0) {
 		NL_SET_ERR_MSG(extack, "ifindex can't be negative");
 		return -EINVAL;
 	} else if (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME]) {
 		link_specified = true;
-		dev = rtnl_dev_get(net, tb);
+		dev = rtnl_dev_get(device_net, tb);
 	} else {
 		link_specified = false;
 		dev = NULL;
-- 
2.39.5




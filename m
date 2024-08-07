Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0FC78C92;
	Wed,  7 Aug 2024 15:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043372; cv=none; b=CtanEme7LgBMQud1G5VS4ORwnHgywbCmJqwsw4W2+x+qmyOGpIkhkn9h3Oa0wqG87g3Kl2HQwatp/TdixJWTC3cAq6aCMZhwvOB3kaMNTN/0dfzN8ixxOQ8pauuW4h/wzA9djQFTAgySOh96m4Kkwbu9txVT8404Oh6qubylI8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043372; c=relaxed/simple;
	bh=KLR1kSojs+AFlghSWTZFLm2vDDtTSZeEEwBiS+0A6vY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCuORg9qUQoOUzMqjlFo5mjt7FH/SAKHR004NmtABjh7ZfIcuIV15Tg/PEu27En61JWsyKSwhrI+qNuCD0DQrPs/a5ZEn23v2pJlSsAf5+1nIjDTtMQ1cxXDPT/C4Hr4HDiITRv2OunX4BU1TlYd65VTnIOZyEyUDh5Sx7t1flQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NIqkuLwX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NIqkuLwX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B386C32781;
	Wed,  7 Aug 2024 15:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043372;
	bh=KLR1kSojs+AFlghSWTZFLm2vDDtTSZeEEwBiS+0A6vY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NIqkuLwXC6RV4uXGwxbOsNPk2zNXZkhOKmplBYtMs6StPkPFyUb7vJTObMhYx9qEM
	 yJgU95r/lpTAlnUyT6vtuInKpaZspmcE7msVy2BepD7L4mlyPaunIMGuOjso7x+WGq
	 4xea5HlZYk6qc4nUGM0d0tAo7LUrKKMx01/J6pS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/121] rtnetlink: Dont ignore IFLA_TARGET_NETNSID when ifname is specified in rtnl_dellink().
Date: Wed,  7 Aug 2024 16:59:59 +0200
Message-ID: <20240807150021.597716203@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 9415d375d8520e0ed55f0c0b058928da9a5b5b3d ]

The cited commit accidentally replaced tgt_net with net in rtnl_dellink().

As a result, IFLA_TARGET_NETNSID is ignored if the interface is specified
with IFLA_IFNAME or IFLA_ALT_IFNAME.

Let's pass tgt_net to rtnl_dev_get().

Fixes: cc6090e985d7 ("net: rtnetlink: introduce helper to get net_device instance by ifname")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 7ea66de1442cc..8573dad6d8171 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3263,7 +3263,7 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (ifm->ifi_index > 0)
 		dev = __dev_get_by_index(tgt_net, ifm->ifi_index);
 	else if (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME])
-		dev = rtnl_dev_get(net, tb);
+		dev = rtnl_dev_get(tgt_net, tb);
 	else if (tb[IFLA_GROUP])
 		err = rtnl_group_dellink(tgt_net, nla_get_u32(tb[IFLA_GROUP]));
 	else
-- 
2.43.0




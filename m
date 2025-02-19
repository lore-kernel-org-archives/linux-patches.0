Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F301C5F2F;
	Wed, 19 Feb 2025 08:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954733; cv=none; b=er9Y6RewEZ2IuHs74ywFpH5BERECtE8jGatY+vj0+jGLq+5ZSfAZQfFnEpLSWEVZVysmfLYGwv49FeIv11Qu4N9hnDz4ZS2MdrzIMnfVjaiDg2R9Yq3UKF6JPTQj78aUImw68DS/vyOJLUGsVCg0hALV4jz4V0UIQIKU+zXAxrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954733; c=relaxed/simple;
	bh=mDmtzJXPEGXtmQT9E8+7id4TdGQSfEWXoPpl8EFAYwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXZarmlRJDhe5mynCQZ4SbMlEcybP2XYiZjSBQiwxHkIeQfYzSBUE26aDTPEJyBSqTK2vnPg/aUcDbvIRxFW8ZXCJ89Sp0oIEGvKATXnRHr5GUyBPD9UUh4vPkQLR8QCm+HeFl+dXIT4qYKwx0q04FOxy/lUtG4+oXK8IXZoleQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0dsnTsr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0dsnTsr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C58C4CED1;
	Wed, 19 Feb 2025 08:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954732;
	bh=mDmtzJXPEGXtmQT9E8+7id4TdGQSfEWXoPpl8EFAYwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0dsnTsrLGoXsi4K5iBXkvEnfLVt5iT7PQHJsFgJtW/Yro9kQFmxGEn9vUphFR+xD
	 gcEj9SeveHLYK7pP6JtXgOY8oUI2sf8Re33E4t3cdDzr2lTkp42jJG828GjKQOVmqM
	 /i22a4QVDSgOxYbAor1b2q8w2iaWlxUwmRgIOL8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Stephen Suryaputra <ssuryaextr@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/230] ndisc: ndisc_send_redirect() must use dev_get_by_index_rcu()
Date: Wed, 19 Feb 2025 09:25:36 +0100
Message-ID: <20250219082602.455115468@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 48145a57d4bbe3496e8e4880b23ea6b511e6e519 ]

ndisc_send_redirect() is called under RCU protection, not RTNL.

It must use dev_get_by_index_rcu() instead of __dev_get_by_index()

Fixes: 2f17becfbea5 ("vrf: check the original netdevice for generating redirect")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Stephen Suryaputra <ssuryaextr@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250207135841.1948589-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ndisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index d044c67019de6..264b10a947577 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1694,7 +1694,7 @@ void ndisc_send_redirect(struct sk_buff *skb, const struct in6_addr *target)
 	bool ret;
 
 	if (netif_is_l3_master(skb->dev)) {
-		dev = __dev_get_by_index(dev_net(skb->dev), IPCB(skb)->iif);
+		dev = dev_get_by_index_rcu(dev_net(skb->dev), IPCB(skb)->iif);
 		if (!dev)
 			return;
 	}
-- 
2.39.5




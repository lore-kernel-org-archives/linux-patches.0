Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB47D18FC86;
	Wed, 19 Feb 2025 08:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955522; cv=none; b=sccpCmHqxfS8nrTXq7921vVbnCuBFoE0uYMDPDfm5F6zOoJYZleSLMHq1PzTmc3hizYZ4D6e3bAb6IFyqKnHgdt0/EeUF30nunG8Dpx01JfKKiZ8nU5PmDklWFxuLXvlyT79Zg6n1+jDdKtvL7xPoxyBM586VUDC8KNheJQLmak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955522; c=relaxed/simple;
	bh=Nx/sDaRxz7fpdYdFh0JIyK+qhgINaDq6kOoiRShWYHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9aFl3f0wLE3c5gXXExNuywhzvWv3f1+8LG28LCPwNd9FWp5MDezl1cwem2B9XhwUirjOAM7l2e+MF0QT1q14fdNcxwdOSj9w9zb7ttx6DIH6Mg21r2pNb/eXsziZKgpqwYvcHmGs17n198gEpLCXIF49tTquOzOK2NOmol9un4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MmTBPOqP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MmTBPOqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B31BC4CED1;
	Wed, 19 Feb 2025 08:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955522;
	bh=Nx/sDaRxz7fpdYdFh0JIyK+qhgINaDq6kOoiRShWYHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MmTBPOqPG2ve2b5NKy+1M5QlfXu3hP1HqDrImIvcpT85yrdahdeGv0DYS40j6Cri1
	 HSvAs6JBA0sqywcRsg2QT2Q09/Y0kN1uyDQ7VlEkQYaMFyo61vJGciUB2XKyBHXYAs
	 j9hNi9/DDF3wkQnZH5x7ehj24jojpAhF2tH/LrPk=
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
Subject: [PATCH 6.6 008/152] ndisc: ndisc_send_redirect() must use dev_get_by_index_rcu()
Date: Wed, 19 Feb 2025 09:27:01 +0100
Message-ID: <20250219082550.356361916@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2ad0ef47b07c2..561972143ca42 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1680,7 +1680,7 @@ void ndisc_send_redirect(struct sk_buff *skb, const struct in6_addr *target)
 	bool ret;
 
 	if (netif_is_l3_master(skb->dev)) {
-		dev = __dev_get_by_index(dev_net(skb->dev), IPCB(skb)->iif);
+		dev = dev_get_by_index_rcu(dev_net(skb->dev), IPCB(skb)->iif);
 		if (!dev)
 			return;
 	}
-- 
2.39.5




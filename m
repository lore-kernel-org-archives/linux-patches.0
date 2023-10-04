Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFEF1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="brmAqDWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60ADC433C9;
	Wed,  4 Oct 2023 18:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443916;
	bh=xIiC2bA8sgQrcvIAYZ5M6CSu00+eZwnVonsGeStigxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=brmAqDWv/QEyDADbAuJFHtgtWqMY7i0Ppx7/KHlUvNr+dhoQ3hUQNU6kHCLuKMLWQ
	 9GpZZ8cWOfFILwk5gZw6UEmPsQK9kRUu8B7kR27B0nwKu2QHb5tmBY0JQkv6jfqGVO
	 ru/9n11olhJcwafoM25/ddVd4FsAVCujz2iMMsGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Kyle Zeng <zengyhkyle@gmail.com>,
	Stephen Suryaputra <ssuryaextr@gmail.com>,
	Vadim Fedorenko <vfedorenko@novek.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 066/321] ipv4: fix null-deref in ipv4_link_failure
Date: Wed,  4 Oct 2023 19:53:31 +0200
Message-ID: <20231004175232.243502862@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <zengyhkyle@gmail.com>

[ Upstream commit 0113d9c9d1ccc07f5a3710dac4aa24b6d711278c ]

Currently, we assume the skb is associated with a device before calling
__ip_options_compile, which is not always the case if it is re-routed by
ipvs.
When skb->dev is NULL, dev_net(skb->dev) will become null-dereference.
This patch adds a check for the edge case and switch to use the net_device
from the rtable when skb->dev is NULL.

Fixes: ed0de45a1008 ("ipv4: recompile ip options in ipv4_link_failure")
Suggested-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Kyle Zeng <zengyhkyle@gmail.com>
Cc: Stephen Suryaputra <ssuryaextr@gmail.com>
Cc: Vadim Fedorenko <vfedorenko@novek.ru>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 33626619aee79..0a53ca6ebb0d5 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1213,6 +1213,7 @@ EXPORT_INDIRECT_CALLABLE(ipv4_dst_check);
 
 static void ipv4_send_dest_unreach(struct sk_buff *skb)
 {
+	struct net_device *dev;
 	struct ip_options opt;
 	int res;
 
@@ -1230,7 +1231,8 @@ static void ipv4_send_dest_unreach(struct sk_buff *skb)
 		opt.optlen = ip_hdr(skb)->ihl * 4 - sizeof(struct iphdr);
 
 		rcu_read_lock();
-		res = __ip_options_compile(dev_net(skb->dev), &opt, skb, NULL);
+		dev = skb->dev ? skb->dev : skb_rtable(skb)->dst.dev;
+		res = __ip_options_compile(dev_net(dev), &opt, skb, NULL);
 		rcu_read_unlock();
 
 		if (res)
-- 
2.40.1




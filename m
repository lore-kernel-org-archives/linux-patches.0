Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6922154F94;
	Thu, 30 Nov 2023 16:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2V/GhAJ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC16FC433C8;
	Thu, 30 Nov 2023 16:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361466;
	bh=+QUrsZ2lo/FCGq3QEvqUMJyyBUyIQrAjDgCHiKjE8Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2V/GhAJ2wO7ArfQFaOVN+ZbKy7XnIqe6uyrsBVTlhosnIMEG0MZve/uLiOuXM9bkM
	 gdX88nXoPIR9GRB5OCHUILy1XSr1MYDShMafEWk8TZspFQBdTFyaRRFF9DWKFA502/
	 +c331+NFF4BLOXN4FtGprVSzzteVUaJ00qCPY4gI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kunwu Chan <chentao@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/112] ipv4: Correct/silence an endian warning in __ip_do_redirect
Date: Thu, 30 Nov 2023 16:21:21 +0000
Message-ID: <20231130162141.403084236@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit c0e2926266af3b5acf28df0a8fc6e4d90effe0bb ]

net/ipv4/route.c:783:46: warning: incorrect type in argument 2 (different base types)
net/ipv4/route.c:783:46:    expected unsigned int [usertype] key
net/ipv4/route.c:783:46:    got restricted __be32 [usertype] new_gw

Fixes: 969447f226b4 ("ipv4: use new_gw for redirect neigh lookup")
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Link: https://lore.kernel.org/r/20231119141759.420477-1-chentao@kylinos.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index b214b5a2e045f..3bad9aa066db3 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -780,7 +780,7 @@ static void __ip_do_redirect(struct rtable *rt, struct sk_buff *skb, struct flow
 			goto reject_redirect;
 	}
 
-	n = __ipv4_neigh_lookup(rt->dst.dev, new_gw);
+	n = __ipv4_neigh_lookup(rt->dst.dev, (__force u32)new_gw);
 	if (!n)
 		n = neigh_create(&arp_tbl, &new_gw, rt->dst.dev);
 	if (!IS_ERR(n)) {
-- 
2.42.0




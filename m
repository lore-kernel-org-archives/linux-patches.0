Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D973D382;
	Thu, 30 Nov 2023 16:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3rHr3tK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138D5C433C8;
	Thu, 30 Nov 2023 16:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361913;
	bh=0NzEIgra3vOR4r8A+s5I4H5e/GNjwJsrdzgsxKMuNmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v3rHr3tKDTQ0ydR6JEi9OcYTsb40OmijRhHiS5GGignk4ckhVV+72sPHqZ4SnVpur
	 T2y/8bzXmR1ByvfSwF1Gdcp9FHCbM2qd7QMxqH40dqJ6a+T2jiwCHFR9Qs5OwHCVgW
	 jYS5wrXiq10MprgDfGsaQGliX0l1mzfcgsYBx0UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kunwu Chan <chentao@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 13/69] ipv4: Correct/silence an endian warning in __ip_do_redirect
Date: Thu, 30 Nov 2023 16:22:10 +0000
Message-ID: <20231130162133.515320508@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162133.035359406@linuxfoundation.org>
References: <20231130162133.035359406@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ea5329cb0fce2..12c59d700942f 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -786,7 +786,7 @@ static void __ip_do_redirect(struct rtable *rt, struct sk_buff *skb, struct flow
 			goto reject_redirect;
 	}
 
-	n = __ipv4_neigh_lookup(rt->dst.dev, new_gw);
+	n = __ipv4_neigh_lookup(rt->dst.dev, (__force u32)new_gw);
 	if (!n)
 		n = neigh_create(&arp_tbl, &new_gw, rt->dst.dev);
 	if (!IS_ERR(n)) {
-- 
2.42.0




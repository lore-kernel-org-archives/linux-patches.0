Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061886;
	b=uOdTBELznlF/d4lBxGxY9XTguOygYvEAxnAL9zz5cevIXPhky+PPrFl4vYU4qTGDjYhY
	 cCItSxcN/fcRocLbLBZQqg2t5JnebS1RorQ9yRtM/Txfy1nMtOSVpPHfCCPlrjBJFfwfB
	 y2NJMzIetT5WRzebhBYbJAck98QnzrEbI1aIbE7Ew35wCNSEnOpHfXFevjbXVx0AAnpYs
	 xvf6YIOFOugy1MdwTDxlFOZ++2ActnQZZ0twwX+ec5PD+GRdQ0s9JrOCHtSxBPaS6QMC2
	 Mxn6//dq2IfNU7d94/jHHlhDyK7puzlIdIIdDjrN2OyUITyemGrFiEy3m+ZWuXkYxEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061886;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XzmPBMcU71UKSu4txbYvBlWAeLxJ2k0Tr1QXP4bq390=;
	b=EgZZ5HJE7Cr15RLRzOwWYQz6j6pzhZ7n6Cp03C5lZJvrTi6rifL4H1H2YZEvoVY0Upb0
	 4TTHOfWa/GdSXXv2gpt4prB/LvjIs9wHPs0gf6GjseQFQiZAS3J69Rq+qzvYaR3HPfQf6
	 FGtaragm4azQwHq1zor+bhc+MtoAiM5wGIC30zcHzeugBHF+AgsehAy3ojzhxkKJsDcQb
	 v667RWkqNUT5QeyAmTICLszmfayVePHMTQDKrF0Gcrnm23OkOkB+GVY52AqkboCOE8OsY
	 rJ/42A/Rlb2S5MD7V+quJknkQJbDxA25up84lQAyxECmYK8/mr0bkzX2JeI6k2SJ89w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ooubH3q/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75ACC606A326;
	Thu, 19 Nov 2026 04:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ooubH3q/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72F21F000C4;
	Thu, 19 Nov 2026 04:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061886;
	bh=XzmPBMcU71UKSu4txbYvBlWAeLxJ2k0Tr1QXP4bq390=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ooubH3q/aqAn8s7oy33uUcqeFnhGcOknw33K3BxgIYHpBWY/nz48m+xp5ZH4J6wEI
	 5W2TUan7DsozxQ7280LP/W5PCye3JNBl6BFb92rGizMH6WL85i9Ya2uU30bVlCwPMX
	 6jiMvF8ZWLEABTnQ/P+x+ihGAIeiP7tOEc5ddicQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1713/1848] RDMA/srp: Avoid reading uninitialized has_port on srp_parse_in() failure
Date: Wed, 18 Nov 2026 16:02:31 +0100
Message-ID: <20261118150031.398455529@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Serhat Kumral <serhatkumral1@gmail.com>

[ Upstream commit 4b8f20dc8d25f575e8b8bb5abb09ab803a7e1a3f ]

srp_parse_in() returns -ENOMEM without initializing *has_port if
kstrdup() fails. Only check has_port when srp_parse_in() succeeds.

Fixes: bcef5b721568 ("RDMA/srp: Accept again source addresses that do not have a port number")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
Link: https://patch.msgid.link/20261016211509.12973-1-serhatkumral1@gmail.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index afce854dada64..7af361de551f5 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3449,7 +3449,7 @@ static int srp_parse_options(struct net *net, const char *buf,
 			}
 			ret = srp_parse_in(net, &target->rdma_cm.dst.ss, p,
 					   &has_port);
-			if (!has_port)
+			if (ret == 0 && !has_port)
 				ret = -EINVAL;
 			if (ret < 0) {
 				pr_warn("bad dest parameter '%s'\n", p);
-- 
2.53.0




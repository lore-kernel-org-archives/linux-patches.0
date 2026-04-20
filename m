Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8225B480358;
	Mon, 20 Apr 2026 13:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691887; cv=none; b=qzF7nbm2jzZDvpT7moDF1sMQ6sKCr0aGMNI6nQ5giqeNdZ9nw89vW0Il6QIznsfQHx6RlVaKEO+qO99yBRh7GzP1Ijc8wTURoFFYXuOiFDVLNA1pICtHt4QjKT4W61t/0EzYse4NZg8e/+ov/W4O2dBmL04se8ekrrxbaeEZ/MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691887; c=relaxed/simple;
	bh=roumjjX3wmX0gls+ObDCrYtcYGp/uv/iESRyqV4NtOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lIjuABJe4Ar+ybBf2WoNhhJxXssiQuxj8FJHPdXeb4I+k3AiWjtH6wzQdas+wczvutL45bnjTJNaNH7y4/x/t3RJWdA+Rs5lk33XNko46PPQY1E4aJfmqquQysOOr+SRvm1bBVwLtTM7wDQsEtiZsD0H6jP2ovRdXwzPYLMNzh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GXVszSrZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GXVszSrZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B0FC2BCB4;
	Mon, 20 Apr 2026 13:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691887;
	bh=roumjjX3wmX0gls+ObDCrYtcYGp/uv/iESRyqV4NtOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GXVszSrZqZJodJMXCLdAZ3x0d/UdKl2+KNM17UhAiWwQU9WAl/e94WpApO29WKZOh
	 ypJWL1pm0y5xsnYh9QVCR295suRu9fcScKKu8dRl9EvnXyu8nNKttvde44ejS2az4x
	 47QPOWzffMDuCEZG/LzZZW0BwEr0V3hLcpUmjJaOnfS/mtcVRrvj09zOgk7Z7S98Yu
	 WZcUt+6rrwYkl5T1u2aOTIljK7rJzO8Ab82LazFVtRujNLYg0yZxst+7wsvoD6elXu
	 ZzRIGgHUuxrepQJZw99lR9C5s31EduOrokfSC1VXMj4bJN9zVuKNDnl27u9NNaI7sP
	 I0LMC2EnnNr4Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Keenan Dong <keenanat2000@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	sln@onemain.com,
	eyal.birger@gmail.com,
	benedictwong@google.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] xfrm: account XFRMA_IF_ID in aevent size calculation
Date: Mon, 20 Apr 2026 09:20:46 -0400
Message-ID: <20260420132314.1023554-252-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 net/xfrm/xfrm_user.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 306e4f65ce264..1ddcf2a1eff7a 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2668,7 +2668,8 @@ static inline unsigned int xfrm_aevent_msgsize(struct xfrm_state *x)
 	       + nla_total_size(4) /* XFRM_AE_RTHR */
 	       + nla_total_size(4) /* XFRM_AE_ETHR */
 	       + nla_total_size(sizeof(x->dir)) /* XFRMA_SA_DIR */
-	       + nla_total_size(4); /* XFRMA_SA_PCPU */
+	       + nla_total_size(4) /* XFRMA_SA_PCPU */
+	       + nla_total_size(sizeof(x->if_id)); /* XFRMA_IF_ID */
 }
 
 static int build_aevent(struct sk_buff *skb, struct xfrm_state *x, const struct km_event *c)
@@ -2780,7 +2781,12 @@ static int xfrm_get_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
 	c.portid = nlh->nlmsg_pid;
 
 	err = build_aevent(r_skb, x, &c);
-	BUG_ON(err < 0);
+	if (err < 0) {
+		spin_unlock_bh(&x->lock);
+		xfrm_state_put(x);
+		kfree_skb(r_skb);
+		return err;
+	}
 
 	err = nlmsg_unicast(net->xfrm.nlsk, r_skb, NETLINK_CB(skb).portid);
 	spin_unlock_bh(&x->lock);
-- 
2.53.0


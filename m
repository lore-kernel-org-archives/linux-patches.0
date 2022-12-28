Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5F41863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53EACC433D2;
	Wed, 28 Dec 2022 14:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239398;
	bh=8X3BOSCVSt9qX7U7xKTdL9+lkBopTscmsePnf1c/US4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DtsQJzmcL5NGcbUHwjkCApflQjC9leiF1k2BT00g8Ghm13h8Zc6SmZFMyOtWI/O1u
	 W8XnA00pnCQWqSq83XbeTywE+oJOBrvz8TawYLOz2/Bpzxhgyw/F6CUr8jGz+gTK4Q
	 jntZSLRh36AiZkTGnKWUgrBgM3Yr78RQ0QEoYIBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Fomichev <sdf@google.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 218/731] bpf: Move skb->len == 0 checks into __bpf_redirect
Date: Wed, 28 Dec 2022 15:35:25 +0100
Message-Id: <20221228144302.880021309@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit 114039b342014680911c35bd6b72624180fd669a ]

To avoid potentially breaking existing users.

Both mac/no-mac cases have to be amended; mac_header >= network_header
is not enough (verified with a new test, see next patch).

Fixes: fd1894224407 ("bpf: Don't redirect packets with invalid pkt_len")
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/r/20221121180340.1983627-1-sdf@google.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/test_run.c | 3 ---
 net/core/filter.c  | 7 ++++++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 7583ee98c35b..11d254ce3581 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -470,9 +470,6 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
 {
 	struct qdisc_skb_cb *cb = (struct qdisc_skb_cb *)skb->cb;
 
-	if (!skb->len)
-		return -EINVAL;
-
 	if (!__skb)
 		return 0;
 
diff --git a/net/core/filter.c b/net/core/filter.c
index fb5b9dbf3bc0..68b1509e6188 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2123,6 +2123,11 @@ static int __bpf_redirect_no_mac(struct sk_buff *skb, struct net_device *dev,
 {
 	unsigned int mlen = skb_network_offset(skb);
 
+	if (unlikely(skb->len <= mlen)) {
+		kfree_skb(skb);
+		return -ERANGE;
+	}
+
 	if (mlen) {
 		__skb_pull(skb, mlen);
 
@@ -2144,7 +2149,7 @@ static int __bpf_redirect_common(struct sk_buff *skb, struct net_device *dev,
 				 u32 flags)
 {
 	/* Verify that a link layer header is carried */
-	if (unlikely(skb->mac_header >= skb->network_header)) {
+	if (unlikely(skb->mac_header >= skb->network_header || skb->len == 0)) {
 		kfree_skb(skb);
 		return -ERANGE;
 	}
-- 
2.35.1




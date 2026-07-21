Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38ED46AA71;
	Tue, 21 Jul 2026 15:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648326; cv=none; b=LhoE4szLJ3GYUYtJauiMIlOET67DNkvcxCjNTpa0sLrs2Asyvjmzsiuzkw45IKPv+/eON6IC1vtuUgJCBsahkKGY6pDC9wBCSc+AufMEkPOnC5MDxN124RFFNFuDrvc5zQZc9B+aMF8pZM1XAEz9WAeQp12g1aOItOLfaj+Ng18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648326; c=relaxed/simple;
	bh=y1HWtFSRqD0cbkBqKy0kcax9eeW8YsF6il75OUGXYfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYS0iTSLZkM2j6BrufdJx7lprJcx5qUXmnRC4RILhRS/00GMY865/Tce+FFE/k80BY8wNALh1LY+n+3O+QTAGV3luO45fEvhJ9g3u4QvrnjI/2tYvToLKaKfqEwFOysf2IiNWNVBaxslS3b993QyKfF37EWX6GfdMviddVCFXKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wfLZN6zB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wfLZN6zB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4479E1F00A3A;
	Tue, 21 Jul 2026 15:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648325;
	bh=ZcvSBgyX3ysa6tEf0YodA7Lf/2WZUZEjf1Kf0sw5+ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wfLZN6zBKJtWafUqn2TStAipOfzTrfcSGu68JfWtC1frG4goY60JyBZpgC0HYyokq
	 l58stoM3wS2gYP/CDvUME1S64IPkoR4/4DY6kxQW3Q8k8gaWql9l18/p4FXoT3BoaI
	 yjxgqB8DeJYnJDElTNQ53wZveBVwAk7UjXv3r6RA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0157/2077] vxlan: Fix potential null-ptr-deref in vxlan_gro_prepare_receive().
Date: Tue, 21 Jul 2026 16:57:10 +0200
Message-ID: <20260721152556.387933431@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 30a45c0bffdd62350261e2f2689fdba426a33578 ]

udp_tunnel_sock_release() could set sk->sk_user_data to NULL
while vxlan_gro_prepare_receive() is running.

Let's check if rcu_dereference_sk_user_data() is NULL after
skb_gro_remcsum_init().

Fixes: 5602c48cf875 ("vxlan: change vxlan to use UDP socket GRO")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260502031401.3557229-7-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index b5b1253ac08ba4..89397447a14d45 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -657,14 +657,18 @@ static struct vxlanhdr *vxlan_gro_prepare_receive(struct sock *sk,
 						  struct sk_buff *skb,
 						  struct gro_remcsum *grc)
 {
-	struct sk_buff *p;
 	struct vxlanhdr *vh, *vh2;
 	unsigned int hlen, off_vx;
-	struct vxlan_sock *vs = rcu_dereference_sk_user_data(sk);
+	struct vxlan_sock *vs;
+	struct sk_buff *p;
 	__be32 flags;
 
 	skb_gro_remcsum_init(grc);
 
+	vs = rcu_dereference_sk_user_data(sk);
+	if (!vs)
+		return NULL;
+
 	off_vx = skb_gro_offset(skb);
 	hlen = off_vx + sizeof(*vh);
 	vh = skb_gro_header(skb, hlen, off_vx);
-- 
2.53.0




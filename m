Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783081D7E5C;
	Tue, 21 Jul 2026 20:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665657; cv=none; b=lcyIBa6067fQDRiYzOkUgNJcajvnPv3CQ7HJo7M+XJUyN2fCwMRItSdAxql1tik+wp8zw0mWzTQbKnT5ZzLuPsjYgBsPxYEbjozv5JA2N8cVlR00HVeaZ5RigmOq/zEFmg1ghfNOzQPsBswOl/ZO0+3UPKpGc63eJct9ahugPP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665657; c=relaxed/simple;
	bh=ZOx+tlnM+jx7hZOBxU6a3A/A7pa6c+SJdL5HGYZ9Yng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEQRws7vrD1yGbv1tGh1EmHOtylfLuXJLRHDvknG5abzHIOhGnvCsUV93IdWMN990hCEDE066M7ES/v5FcVvyzawjZ/caH2dNyrOBqgv7n/3a8Zz4BXRY3xYnWLq+eIXhydDQ0BOZ/WLPxZQ4AS0YKeUowg3fk7DqV2lT2GmjN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8kQ9QcH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8kQ9QcH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922901F000E9;
	Tue, 21 Jul 2026 20:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665655;
	bh=cGFT/MgzHBL/ZSu2LYbpFAn0bVBAPVPlyBIzWR63/+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z8kQ9QcH4JJ6pe3GzlM/5qUlLED3zIdxBMQ7vk72RHgS/Fo5mBTIXXHinRtH1YGpt
	 LpZ1QsfAVl+h8ughHKHQu9IQQcmVd8uumHuBr8KnL5YhlHLjYA80Pg4yuqCb+DQVoO
	 ZGONF1BOfXA5+Uq/kh+bXj4TCvMP5V8Ai6bvzeX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0386/1266] vxlan: Fix potential null-ptr-deref in vxlan_gro_prepare_receive().
Date: Tue, 21 Jul 2026 17:13:43 +0200
Message-ID: <20260721152450.461466022@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 958d3be4f99086..1a3a00476a9368 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -680,14 +680,18 @@ static struct vxlanhdr *vxlan_gro_prepare_receive(struct sock *sk,
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




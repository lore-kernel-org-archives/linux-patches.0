Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7C446A60E;
	Tue, 21 Jul 2026 19:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661628; cv=none; b=snwpAIL8pXB9kZjfKH/V5l26tTWMs+m+BWTQKZuMBlbsCEDP21vC4993rhzoncFGYAvAsr/axZHzW1YEkTUoJw6WlKd11U+8vKSxe/VpfPZjY9ZTu5+7iS/evUgXuhg10uU/cp8RiOlSai4WlcN2jJMgoSddw/QOcVggjRFikpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661628; c=relaxed/simple;
	bh=CybnVnIGUbvVLXabbSoo7laq/kVAGwsTgNguGLv0oRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ve/OijTX/hcLM3PYSpRTKM3e38Cgi0MhvvP8j3qhzVOcBvGJMgJmPUBJpjgzmrdWZZLWZ4Uh3A3J8zHDJo3dQ8UrGSjG2TUNOmoAu4Tsfv9zXQ/uI0JX1UAbqGg0Ijoj/OpdZKhU2pQwu/zhgtkTtFIDXuGSL0azg4hn4vRJ1po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n8HP5iRl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n8HP5iRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04DE1F000E9;
	Tue, 21 Jul 2026 19:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661627;
	bh=fJvGSsva1USLiw+3OTZcOYbKh9h+07/RXDXUbediwQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n8HP5iRlZzmVWzYCW6wY+kvlHe9y3IDjTRT2j5bCaSqC7x8vKVvHAsbdOySXZOsnr
	 Of4pzr2gp4qp5AKOTKrtO0GQyT7YjcTAtb33qGdgqnJ2XU/rU3BwfuOqYKS3N7OhiN
	 Y2PANgN0+g1+Hbz0lJGPe987JP+xCp0dBZLPYBkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0095/1276] vxlan: Fix potential null-ptr-deref in vxlan_gro_prepare_receive().
Date: Tue, 21 Jul 2026 17:08:58 +0200
Message-ID: <20260721152448.220278217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 765d25eee2fe48..596efc51cac77b 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -679,14 +679,18 @@ static struct vxlanhdr *vxlan_gro_prepare_receive(struct sock *sk,
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




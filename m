Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C93D44AB6A;
	Tue, 21 Jul 2026 21:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668753; cv=none; b=ajIVenMzy89X7Y0cKTtbmPKwS8jpbWXTWMK1YaC8T3EB7pOfKj6RwxKm1jVRQJpR2vxrY9arANZH5ZYPBpMZOHQhnhPa2soArziRZduEKmPyCUkKGE+fhgWEN9QiNJHvGNjQmtsUBUpLnF9AZPi0VAB75GjeEms0e8Xy1hDIPH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668753; c=relaxed/simple;
	bh=jfmn/mNik03I9m0uSVCOrPoGGguz6JNJD9/MjIoq+6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LbRdAnaKwoOURD7JhgMLgZ/pZBLsLyDl7rlh02/faHULfVCFtFNOq8JzHAXp3C3KmWEwwlLxnX5sp78pfppgR6LhIlKvrfRO7sOnvhUIE801XG8dV5v30nzXgNB3d5y1pDOhzm9sV1xZHVw8aCAYuyuxotAu/qUrBkirdDkrma8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YpxX1d7i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YpxX1d7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE5B1F000E9;
	Tue, 21 Jul 2026 21:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668752;
	bh=gXeB/eO4CoDVn4b3YvMJjoJyRx/zZs7n89BNporZjVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YpxX1d7iez/x8OyrmzpTYqmwsWq55+SZyIr6WiXyv/OccExxJDDzC+HOlxPDBoz0w
	 /MYi4p2Wt+B4rvg0PzsT3U+es+3HvYzX5lRe2HllvHWjAn6lf6cmx+NI0BiOYg6Qj9
	 FE7jWV7X1tTGsowIVjXrFTF9yPsHHrU6Q6gFMZJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0296/1067] vxlan: Fix potential null-ptr-deref in vxlan_gro_prepare_receive().
Date: Tue, 21 Jul 2026 17:14:57 +0200
Message-ID: <20260721152431.222602828@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9d7ebf8aa79f66..4f689fe2f8c5a1 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -727,14 +727,18 @@ static struct vxlanhdr *vxlan_gro_prepare_receive(struct sock *sk,
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




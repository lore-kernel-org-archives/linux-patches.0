Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208836;
	b=VF7dP5Yjftmvykaq77YYQaYNULVD3KOzOztE7/GB4fOFPBJCYZ9APqta3m+kFUcUYO3k
	 uI1zVKMaDXwjd+cMjb3Max07pH16pxsPPBCTR9qRErIRF0NZk52fxDgJX/Twl68yUyEAE
	 3SHgCuOc2YTASJpQBDBGZDftkC6ci86khDK3ZxqTJ409ub2IOCzieo+iV9qv3r5xpolA4
	 Yv/sGMcVYvFr2DjarMaK/r/P1ilLo5YCtIh/1a1uBO7c81qmvmsAUl8mPAAsDb9BcItL2
	 JJ8CWHZIFr47/F9YWifwhmKk5zA7ZKntjaDLKboVnB9ASz1EtFyeYrwd0hJaXhj9DRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208836;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sUjXHGAd9T2CRro4CmgfPZYTYa3LS+mqauai0KYlMvA=;
	b=WkZN9lt5bHBdIaj7ZjrVMGUyRPS6BfVk+zqijK6H9S3ljtDtTaOjGsdZkeXa7MhFU6aS
	 AlSNEaqnuuaqPUVnxsO6UcdfnZzvgtxHQqMD7ZFnv8drS79/kEKTtpcAtZS4E9Nz620qG
	 TuqSLc4jW4y/Hqn4jzSc3XnG1VtXNNBFe8A7qpDcEMBSZsIjshoEIi9AZfXS1HM7Avld8
	 tWAVqD2sXsZDrMuhQ4SOe39/zZg9oWh5Z0TojOaI+nU1gqf0IC/qWzQuMPhiyaFy0EIgL
	 2fDRhigdtTb1FSRPHbhjGoLulIyqYf6gCIGuLx7iV9Iq19bWXS8h8/Hx5cLrYG0RyPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bGH+IbbX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE92606A321;
	Wed, 28 Oct 2026 17:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bGH+IbbX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040CF1F01825;
	Wed, 28 Oct 2026 17:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208835;
	bh=sUjXHGAd9T2CRro4CmgfPZYTYa3LS+mqauai0KYlMvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bGH+IbbXa+oJqxh7NjUwRFrBCiAm7c7Rx+Fwf/iBSJReUzjkeYnQi9lX7939ojvnQ
	 Ai2QEn64+gTV1/GkNg6ez+lH85XE9A2+b0foQh4WyXmMYtvAdRBvaoCTYj2iCkYRkO
	 Nn9XBy/WaRBZcJ9cam+s9xukCIiufprCQvf5ERlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Artem Novikov <naa@amicon.ru>,
	Fedor Pchelkin <pchelkin@ispras.ru>
Subject: [PATCH 5.10 259/516] vxlan: Fix potential null-ptr-deref in vxlan_gro_prepare_receive().
Date: Wed, 28 Oct 2026 17:56:51 +0100
Message-ID: <20261028170009.627184777@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

commit 30a45c0bffdd62350261e2f2689fdba426a33578 upstream.

udp_tunnel_sock_release() could set sk->sk_user_data to NULL
while vxlan_gro_prepare_receive() is running.

Let's check if rcu_dereference_sk_user_data() is NULL after
skb_gro_remcsum_init().

Fixes: 5602c48cf875 ("vxlan: change vxlan to use UDP socket GRO")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260502031401.3557229-7-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Artem Novikov: Apply the check to the older vxlan_gro_receive()
  implementation. Initialize the remcsum state first and use the
  existing out path for cleanup when sk_user_data has been cleared. ]
Signed-off-by: Artem Novikov <naa@amicon.ru>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan/vxlan_core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -790,12 +790,16 @@ static struct sk_buff *vxlan_gro_receive
 	struct vxlanhdr *vh, *vh2;
 	unsigned int hlen, off_vx;
 	int flush = 1;
-	struct vxlan_sock *vs = rcu_dereference_sk_user_data(sk);
+	struct vxlan_sock *vs;
 	__be32 flags;
 	struct gro_remcsum grc;
 
 	skb_gro_remcsum_init(&grc);
 
+	vs = rcu_dereference_sk_user_data(sk);
+	if (!vs)
+		goto out;
+
 	off_vx = skb_gro_offset(skb);
 	hlen = off_vx + sizeof(*vh);
 	vh   = skb_gro_header_fast(skb, off_vx);



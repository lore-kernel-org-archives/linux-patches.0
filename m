Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621761;
	b=3avmDCW3ASBjNNiRW2k3uo/8uIwDNLyWYFewYVJ1yqSmVDdmodjm1P7MgajXCy6naViV
	 t+tFxVts+mbgHQ2fXN5zmYleM5gXOsQ4X+d4+kTkHghBbWkHfcA6W2yCFCN8GRIeydHks
	 KFpRC5vYuA4JwO5nL8VGpVVywWRfiyZBV2qY0HL2bLtH6ZQ3bulplgPVxFsBiivY/UMVR
	 IiNqnyx9CXhWOfatk9n0lylVRQ4SpXJWOUL2IHHWHRoN4yLahTYvP3GTQFk0XVGPPqHn0
	 YOhlywhWvEOZNtocoPTfVWlDdz2j/Q4ATyW+FhXDz46M6GN64sXw698i2Zwcrk+VMRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SLfT3XM8X+xZDR/3fxwolxXnXCVE46VRd2BEbUnwV2k=;
	b=Wt+iWzflYHzJXwyjr1LoyZYi3swr0z2jsJqpoQolYkpAqChGgrWK7ZmgNv+Z02vIqrRm
	 WCrDopex9qjbVBM0oZG1gaFHj1ADSqfWkf15A0HGgdARpiBU2plwT+wfqDi4qJaKKrvD8
	 M+Fy6fYKfJ437jl1TnjjpMnxu/dKxptyShaJvg1rf4VFzQD+CWymREZ8QKhSa5bS5Y+x5
	 O1+sp/+XSY2XAz7Rfoi7RXLpqwpWpdR59Z72XCdG6fPf6DqVX3YznO+zngqsvQZBGpQnq
	 KqIZWB3dxAbO/pgENhhpqhIAWkrY8+QQX6qHYrDbZBTD3rK7Ak3OLDVrijM8XGhabVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z0nPAv2j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA64B606A336;
	Wed, 25 Nov 2026 15:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z0nPAv2j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F621F000ED;
	Wed, 25 Nov 2026 15:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621760;
	bh=SLfT3XM8X+xZDR/3fxwolxXnXCVE46VRd2BEbUnwV2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z0nPAv2jKeUFTECFXjkC7P3cmGaWYZHRuV/XQOz2sLbO1KhP1z6V/LKRqEltg8tEg
	 KZQvBKFTNS+QMt0sGjjr7LfD5QJfJukg+kl4ewOChbGzBqZncRHXM2GS6rK9TpzLN1
	 GqXI10zPXYDTKTs6m7qPO67sykKYf/3wjkAnmspI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anil Kaushik <anilkaushikwireless@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 328/990] netlink: Do not call the unbind callback with the table locked
Date: Wed, 25 Nov 2026 15:28:15 +0100
Message-ID: <20261125143829.771249606@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anil Kaushik <anilkaushikwireless@gmail.com>

[ Upstream commit a36b9e205cb3c452ab96cc783e63465d466fe615 ]

When netlink_bind() fails to insert the socket, it calls
netlink_undo_bind() with the table locked. genl_unbind() then takes
cb_lock, while genl_unregister_family() and genl_register_family() take
cb_lock for writing and then wait in netlink_table_grab() for the table
users to go away:

  netlink_bind()                 genl_unregister_family()
    netlink_lock_table()           down_write(&cb_lock)
    netlink_insert() fails
    netlink_undo_bind()            netlink_table_grab()
      genl_unbind()                  waits for nl_table_users == 0
        down_read(&cb_lock)

An unprivileged user can get here by binding to a port ID that is in
use, with nl_groups set. Lockdep does not see it, as nl_table_users is a
plain counter.

Unlock the table first, as the comment in netlink_release() asks for.

Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261101101347.3910654-1-anilkaushikwireless@gmail.com
Fixes: 3de21a8990d3 ("genetlink: Add per family bind/unbind callbacks")
Signed-off-by: Anil Kaushik <anilkaushikwireless@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261102120929.4077030-1-anilkaushikwireless@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index fb7785a59af59..9e1f64f18e3f8 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1032,8 +1032,9 @@ static int netlink_bind(struct socket *sock, struct sockaddr *addr,
 			netlink_insert(sk, nladdr->nl_pid) :
 			netlink_autobind(sock);
 		if (err) {
+			netlink_unlock_table();
 			netlink_undo_bind(BITS_PER_TYPE(u32), groups, sk);
-			goto unlock;
+			return err;
 		}
 	}
 
-- 
2.53.0




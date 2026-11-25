Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624678;
	b=o+/PHrfYMESX73KvV3S0I1m17nLxGZrES12gbnB/ed96rDLAQSvjDfLNoId/wNK2bgsM
	 hCJD7+2P3tEV0e3gHTrREZ77wIFoj7gTDz1ravBY40u2p4bENlBUqFR0MdR1tqxQrfNwV
	 F6EIAfbqRbyLFxcJipSa52UHkUcPSbJmAzVsfjszBSzb26SV58i0mhpQ9CINzINEW672h
	 fgMcQwqhqrjoOmFupeojkkihk3t9MX3Glv4p6o74T80HTGojyjMNg4iuLcoXcYiHgPuWE
	 zWdpMCZ08ZOTZq7l6IfP/i/qXCDTQiM3A+1d2r/BP5GkZlnIqpYG+viNU0II0Xfzw9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624678;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ucCpX+QHAuG7EeW4+aY8fk0qGd5Frq2N3mJa18x/4yE=;
	b=ybwDbQBat3FNeoZ396oyQnHxvTsOwkF963EizkwGb80PbUJm+9fI4+jmfxD1pZ+HgA0C
	 J8EtgrRMwnMhwjAQxTHbpggw5lrDdKU1kVMT4yvb5/I5B3BCLJryfXYu8H6iNDfw1fRvR
	 T4Zyy/8Z1vWASsapHSV8sR/sBbVhUVK2Dp4TE7h6+ph6U2oMHLwssGFil82eWQ5OUgOpb
	 Kav+3JR1tJIA+SvGhSr9BnYOkNrbczGK6173JHssDpQ9G+jGTaRMRG22yrf9ldLYrFdy2
	 3OkDFYz+8JqyGvt8gTEgK3LqOx8Nm5Fkf+B7IeI7nVXst2/rL8DMBjETOCzPQbGX1vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q5Ezzh8E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7F6606A339;
	Wed, 25 Nov 2026 16:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q5Ezzh8E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D531F000C0;
	Wed, 25 Nov 2026 16:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624677;
	bh=ucCpX+QHAuG7EeW4+aY8fk0qGd5Frq2N3mJa18x/4yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q5Ezzh8EK6/E/f/eizKXK/0CADbwA4NOL0zt56jpQJ2j8iXX09uw3LvH0MtHi8Cv7
	 Ku3h4bZxEZoK5Glf3asbgRjDpyjvkBP1Sk5PHtCY1ASHN/6ruQyCr5QmVe82wUnPBJ
	 lPd0JkNOg6KOGn9LkXyiZm5xNyy7605ADZ+30EEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anil Kaushik <anilkaushikwireless@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 269/816] netlink: Do not call the unbind callback with the table locked
Date: Wed, 25 Nov 2026 15:30:17 +0100
Message-ID: <20261125143855.435955991@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8977798d42322..9cc71da6dd966 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1031,8 +1031,9 @@ static int netlink_bind(struct socket *sock, struct sockaddr *addr,
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C71341A5
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oa9mHmnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47018C433C7;
	Mon,  9 Oct 2023 13:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859378;
	bh=iNmjJ9j6+YDiffEmQ+y22j3sdTUn6riDfbKWwl8/F1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oa9mHmnvHpEBF/yv3B2fKS8okEW35yURV7rMNAa0/ZOPvT3FDcCrVpQoOAVEXwzKj
	 a/1gxYlH2Pb+Lqh021WzuDPJoIz2GFHAOL6HSHYrRF5ZiIOxD+qbEOrRYJ4Lyrwd8f
	 b7tVqRdREWOY1wnf0ucHEqdVXKdtCxkz3v05Hk1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 48/55] sctp: update transport state when processing a dupcook packet
Date: Mon,  9 Oct 2023 15:06:47 +0200
Message-ID: <20231009130109.537967380@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130107.717692466@linuxfoundation.org>
References: <20231009130107.717692466@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 2222a78075f0c19ca18db53fd6623afb4aff602d ]

During the 4-way handshake, the transport's state is set to ACTIVE in
sctp_process_init() when processing INIT_ACK chunk on client or
COOKIE_ECHO chunk on server.

In the collision scenario below:

  192.168.1.2 > 192.168.1.1: sctp (1) [INIT] [init tag: 3922216408]
    192.168.1.1 > 192.168.1.2: sctp (1) [INIT] [init tag: 144230885]
    192.168.1.2 > 192.168.1.1: sctp (1) [INIT ACK] [init tag: 3922216408]
    192.168.1.1 > 192.168.1.2: sctp (1) [COOKIE ECHO]
    192.168.1.2 > 192.168.1.1: sctp (1) [COOKIE ACK]
  192.168.1.1 > 192.168.1.2: sctp (1) [INIT ACK] [init tag: 3914796021]

when processing COOKIE_ECHO on 192.168.1.2, as it's in COOKIE_WAIT state,
sctp_sf_do_dupcook_b() is called by sctp_sf_do_5_2_4_dupcook() where it
creates a new association and sets its transport to ACTIVE then updates
to the old association in sctp_assoc_update().

However, in sctp_assoc_update(), it will skip the transport update if it
finds a transport with the same ipaddr already existing in the old asoc,
and this causes the old asoc's transport state not to move to ACTIVE
after the handshake.

This means if DATA retransmission happens at this moment, it won't be able
to enter PF state because of the check 'transport->state == SCTP_ACTIVE'
in sctp_do_8_2_transport_strike().

This patch fixes it by updating the transport in sctp_assoc_update() with
sctp_assoc_add_peer() where it updates the transport state if there is
already a transport with the same ipaddr exists in the old asoc.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://lore.kernel.org/r/fd17356abe49713ded425250cc1ae51e9f5846c6.1696172325.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/associola.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 0a5764016721b..629f56cbe22cb 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1204,8 +1204,7 @@ int sctp_assoc_update(struct sctp_association *asoc,
 		/* Add any peer addresses from the new association. */
 		list_for_each_entry(trans, &new->peer.transport_addr_list,
 				    transports)
-			if (!sctp_assoc_lookup_paddr(asoc, &trans->ipaddr) &&
-			    !sctp_assoc_add_peer(asoc, &trans->ipaddr,
+			if (!sctp_assoc_add_peer(asoc, &trans->ipaddr,
 						 GFP_ATOMIC, trans->state))
 				return -ENOMEM;
 
-- 
2.40.1




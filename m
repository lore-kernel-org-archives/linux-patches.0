Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB01402444;
	Thu, 30 Jul 2026 14:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421911; cv=none; b=uvT+JbR7Ct+4nz0auFU25pJCSIvpCHd1kxBz0OrrdytEQ1SvbugqT4ScUw0x5EkJ5CKaR2lkkCTwx4bbgJx/9Il+iMytDDpQnIMDUTwaKwXHkcpcbpL7qL0gAVX45OzWcV23dEP58faPtU5mx2L8MCVguq3XMB/5TjbEl6mqudA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421911; c=relaxed/simple;
	bh=yLzAxX7w36aawgo+i5NGk13h+v7YqUC3it0ckcSYX5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uEHmNgI06vXfiXh/uE3bBZpb8S0mNJ5dHGPSJdjUX/rGjVnB6M2GID6UtpHuh0HC8GxPFcEQU5pSWkj3oKfNKG4Nf+VJsZzB3SbBxtxLHTYWGXLlF52U/CvyycdORsor0bJTZzKQeAYyEMU0nEp6IefQalmFXeokYvFq5D6n5KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CwqLfgrN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwqLfgrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5FB1F000E9;
	Thu, 30 Jul 2026 14:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421910;
	bh=jg+UGc+1d+TvcIPh29T6QJEjqdmNLgeewcQgCUFY+Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CwqLfgrNRrIvOAMQzvWUKgTxn4FzLf9S/jah8f+4Dov44Sm6J3VN62lszWgfDkV0U
	 ac/4JGf2mkGL0oPm0AJuwrRfj/LVqqqopVk+R9QrhVVI9anmU9O4nS9vlq4JZ6wjGb
	 j9qSF/YUm44pwAZs21Q0U6YkJxW7Jcbxua0UKikQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Baffo <marco@mandelbit.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 224/744] ovpn: fix use after free in unlock_ovpn()
Date: Thu, 30 Jul 2026 16:08:17 +0200
Message-ID: <20260730141449.046714689@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Marco Baffo <marco@mandelbit.com>

[ Upstream commit e1ad6fe5db719874efa45b2caf9934552e09fc43 ]

unlock_ovpn() iterates over the release_list using llist_for_each_entry()
and drops the peer reference inside the loop body via ovpn_peer_put().

If this drops the last reference, the peer is eventually freed. However,
llist_for_each_entry() reads peer->release_entry.next in the loop advance
expression, which runs after the body. By that time the peer may have
already been freed, resulting in a use after free when advancing to the
next list entry.

Fix this by using llist_for_each_entry_safe(), which caches the next
pointer before executing the loop body.

Fixes: 80747caef33d ("ovpn: introduce the ovpn_peer object")
Signed-off-by: Marco Baffo <marco@mandelbit.com>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/peer.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ovpn/peer.c b/drivers/net/ovpn/peer.c
index 1844d97154cea7..7dedbe54a37cfb 100644
--- a/drivers/net/ovpn/peer.c
+++ b/drivers/net/ovpn/peer.c
@@ -26,11 +26,12 @@ static void unlock_ovpn(struct ovpn_priv *ovpn,
 			 struct llist_head *release_list)
 	__releases(&ovpn->lock)
 {
-	struct ovpn_peer *peer;
+	struct ovpn_peer *peer, *next;
 
 	spin_unlock_bh(&ovpn->lock);
 
-	llist_for_each_entry(peer, release_list->first, release_entry) {
+	llist_for_each_entry_safe(peer, next, release_list->first,
+				  release_entry) {
 		ovpn_socket_release(peer);
 		ovpn_peer_put(peer);
 	}
-- 
2.53.0




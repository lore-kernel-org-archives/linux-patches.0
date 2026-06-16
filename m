Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCE33876CF;
	Tue, 16 Jun 2026 17:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631744; cv=none; b=AbYW7Jx7g53l5LtuPNkzUCoO59QmRnxgUdurl92C1CSojw7zobuDmlJgcRG1MNphUxPJh9q5nOBSYedWPklOkc7cUd5w4S+KcRD44mBmhdaQleEL9jQFS2QNMzvJ1KzJ1seND207b7Ey9480r/b/pHUjcbnKlqqgPLSH9k/mo5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631744; c=relaxed/simple;
	bh=mAeQG8ACfeu+LOnF8H3i/4gA78shVXDYHSbeuya3nWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3tlG0yXPhxesrMs61UV1hy4LwsUM4COHKS/wSYwmfZJ8ZtBinQYo62cGKs7lfKN2nUXD+REpWo0F3PFUYgvL/82WPIVWkjw2Qu9zI3dXCdK2qoN5CeAxi3q7/0QvyIKAu53iB2w1eS+6oWYEsqhxXlM7Gmn1Ug9AyPPYpFSeFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wk71w+hq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wk71w+hq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285471F000E9;
	Tue, 16 Jun 2026 17:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631742;
	bh=OEqvpfkMd9atCoMnnw25yRzuMgb3arcqv52cNIUs3CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wk71w+hqyGZ6GZ9dG/TwIBDJUhPTx1e45AuHcXZRXVlJhB8eAdxJHnMgqSxO/Hr/e
	 bPJxjZSrI8wMEXwhHROvEGNMDRsvy1GlruMxCKPD7dZOOZR/DM3u0UacgjV0gB+iXr
	 ktCqVUm8pehZ91bT64MVH1v+U6vuB1j04K6nKQjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Moreno <amorenoz@redhat.com>,
	Aaron Conole <aconole@redhat.com>,
	Eelco Chaudron <echaudro@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 247/522] net: openvswitch: fix possible kfree_skb of ERR_PTR
Date: Tue, 16 Jun 2026 20:26:34 +0530
Message-ID: <20260616145137.532721600@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Adrian Moreno <amorenoz@redhat.com>

[ Upstream commit ee30dd2909d8b98619f4341c70ec8dc8e155ab02 ]

After the patch in the "Fixes" tag, the allocation of the "reply" skb
can happen either before or after locking the ovs_mutex.

However, error cleanups still follow the classical reversed order,
assuming "reply" is allocated before locking: it is freed after unlocking.

If "reply" allocation happens after locking the mutex and it fails,
"reply" is left with an ERR_PTR, and execution jumps to the correspondent
cleanup stage which will try to free an invalid pointer.

Fix this by setting the pointer to NULL after having saved its error
value.

Fixes: 893f139b9a6c ("openvswitch: Minimize ovs_flow_cmd_new|set critical sections.")
Signed-off-by: Adrian Moreno <amorenoz@redhat.com>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Acked-by: Eelco Chaudron <echaudro@redhat.com>
Link: https://patch.msgid.link/20260604121946.942164-1-amorenoz@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/datapath.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index c751d6b36febd1..0c0d89470145a1 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1263,6 +1263,7 @@ static int ovs_flow_cmd_set(struct sk_buff *skb, struct genl_info *info)
 
 		if (IS_ERR(reply)) {
 			error = PTR_ERR(reply);
+			reply = NULL;
 			goto err_unlock_ovs;
 		}
 	}
-- 
2.53.0




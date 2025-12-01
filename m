Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB2625A33A;
	Mon,  1 Dec 2025 11:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588803; cv=none; b=jNm9EywNpYaXpoDhvbHdWSPzS2Z3U5s8ra/zu502nFeaNOyQprjbMEt5FDFI6sDMbmX0L0OZ8RD+ORkBxqi7SzRg3xOS4ZXwoYnZIztIw4kXr4ed6wYQ20noXpUf5IyYo+eDnIBnpqRi6LinLmI0BXvPFPtjB4BH0fKFf06eUxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588803; c=relaxed/simple;
	bh=boSPu/Kq1uytmidNmBQBZ4eqSzAy40KYofzKXRLDFpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XADOPViuJswGXgFzzYSvrsSFKF1ud/Rss72nmNNyED2lgQdekbU5WR2cBcrB3uAUaN55b4ny0/s/+B1XL5Jmj+dRnxz/Zx/CF5C5HlFO077iNWt2OcNpIZx1nzc++jF/fWpPiWiQsBUcsIsUlHOvJzHjx273qVWJMgANCMcEXHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wns6SF4O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wns6SF4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47EF8C4CEF1;
	Mon,  1 Dec 2025 11:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588802;
	bh=boSPu/Kq1uytmidNmBQBZ4eqSzAy40KYofzKXRLDFpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wns6SF4OCV8NmgYxTKOxWwpHSEjO2RFQisldw40G46BfkVeryxcrKdPDtKs/Bzx6i
	 TFH3xKDQFVwhiSpRYIHqooPvkbzZOOPg0fahsbvGnzxhFA6OvGoiYyjhceg+yC517m
	 uAUNBax3wvj47za/MnLculVNqFnHen6VQdpQkC+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Vosburgh <jv@jvosburgh.net>,
	Breno Leitao <leitao@debian.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 176/187] net: netpoll: fix incorrect refcount handling causing incorrect cleanup
Date: Mon,  1 Dec 2025 12:24:44 +0100
Message-ID: <20251201112247.565140318@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 49c8d2c1f94cc2f4d1a108530d7ba52614b874c2 ]

commit efa95b01da18 ("netpoll: fix use after free") incorrectly
ignored the refcount and prematurely set dev->npinfo to NULL during
netpoll cleanup, leading to improper behavior and memory leaks.

Scenario causing lack of proper cleanup:

1) A netpoll is associated with a NIC (e.g., eth0) and netdev->npinfo is
   allocated, and refcnt = 1
   - Keep in mind that npinfo is shared among all netpoll instances. In
     this case, there is just one.

2) Another netpoll is also associated with the same NIC and
   npinfo->refcnt += 1.
   - Now dev->npinfo->refcnt = 2;
   - There is just one npinfo associated to the netdev.

3) When the first netpolls goes to clean up:
   - The first cleanup succeeds and clears np->dev->npinfo, ignoring
     refcnt.
     - It basically calls `RCU_INIT_POINTER(np->dev->npinfo, NULL);`
   - Set dev->npinfo = NULL, without proper cleanup
   - No ->ndo_netpoll_cleanup() is either called

4) Now the second target tries to clean up
   - The second cleanup fails because np->dev->npinfo is already NULL.
     * In this case, ops->ndo_netpoll_cleanup() was never called, and
       the skb pool is not cleaned as well (for the second netpoll
       instance)
  - This leaks npinfo and skbpool skbs, which is clearly reported by
    kmemleak.

Revert commit efa95b01da18 ("netpoll: fix use after free") and adds
clarifying comments emphasizing that npinfo cleanup should only happen
once the refcount reaches zero, ensuring stable and correct netpoll
behavior.

Cc: <stable@vger.kernel.org> # 3.17.x
Cc: Jay Vosburgh <jv@jvosburgh.net>
Fixes: efa95b01da18 ("netpoll: fix use after free")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251107-netconsole_torture-v10-1-749227b55f63@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/netpoll.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -858,6 +858,10 @@ void __netpoll_cleanup(struct netpoll *n
 
 	synchronize_srcu(&netpoll_srcu);
 
+	/* At this point, there is a single npinfo instance per netdevice, and
+	 * its refcnt tracks how many netpoll structures are linked to it. We
+	 * only perform npinfo cleanup when the refcnt decrements to zero.
+	 */
 	if (refcount_dec_and_test(&npinfo->refcnt)) {
 		const struct net_device_ops *ops;
 
@@ -867,8 +871,7 @@ void __netpoll_cleanup(struct netpoll *n
 
 		RCU_INIT_POINTER(np->dev->npinfo, NULL);
 		call_rcu(&npinfo->rcu, rcu_cleanup_netpoll_info);
-	} else
-		RCU_INIT_POINTER(np->dev->npinfo, NULL);
+	}
 }
 EXPORT_SYMBOL_GPL(__netpoll_cleanup);
 



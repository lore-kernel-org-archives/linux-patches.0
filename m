Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32F434A3BC;
	Wed,  3 Dec 2025 16:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778454; cv=none; b=s4NF+NjHg8HGFI1842M8IipaEvPOnWWXybMk+Izb3RphyuU67aLVQFS2lORyhg18s8bSX/77okjA5QJLat3BgOYcsf7PYyp0I8lqpKFFSGfHwYZspvaiOtlGDjJAd1ehm9B2wI3l8s/4hZ958tpsrHX5jfOvqDXCKYN6sOrQYBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778454; c=relaxed/simple;
	bh=Og1ykeIFP4sKskX61HLXzr0/7hOrFbipzc4i6S1U32M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mc8DcT8ZwYWwrZ7phoT+dluQp1YHuhSPWoooThB514Wqs52kSF+AaaJW4QUGWQeInXkgOoNYl2tkKPlL9gl+U//bct3bjIVRDsd6j6Rcs0/q05MoKIfD+TGWNpXpa2RqL+ypf3uRiJqCJx6+r58hez98RxKIfWR3yTkti2KmBeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vnFd4n/G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vnFd4n/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B23FC4CEF5;
	Wed,  3 Dec 2025 16:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778454;
	bh=Og1ykeIFP4sKskX61HLXzr0/7hOrFbipzc4i6S1U32M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vnFd4n/GTc+UK7icvhQWLG8iEW5M3eqaviL3w2qhROADst7cP3aW6UqFqVyjnKR7p
	 X30erakMM/Eqs5svdsCIyL2INlGz9mh01pPC3Q46r6u+kI29eztljdwvs7x5qBmgCq
	 X7BjXiLb9/gFGfLHMe6vCKrsv7Kcq4tDxgWOC6ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Vosburgh <jv@jvosburgh.net>,
	Breno Leitao <leitao@debian.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 318/392] net: netpoll: fix incorrect refcount handling causing incorrect cleanup
Date: Wed,  3 Dec 2025 16:27:48 +0100
Message-ID: <20251203152425.861478644@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -851,6 +851,10 @@ void __netpoll_cleanup(struct netpoll *n
 
 	synchronize_srcu(&netpoll_srcu);
 
+	/* At this point, there is a single npinfo instance per netdevice, and
+	 * its refcnt tracks how many netpoll structures are linked to it. We
+	 * only perform npinfo cleanup when the refcnt decrements to zero.
+	 */
 	if (refcount_dec_and_test(&npinfo->refcnt)) {
 		const struct net_device_ops *ops;
 
@@ -860,8 +864,7 @@ void __netpoll_cleanup(struct netpoll *n
 
 		RCU_INIT_POINTER(np->dev->npinfo, NULL);
 		call_rcu(&npinfo->rcu, rcu_cleanup_netpoll_info);
-	} else
-		RCU_INIT_POINTER(np->dev->npinfo, NULL);
+	}
 }
 EXPORT_SYMBOL_GPL(__netpoll_cleanup);
 



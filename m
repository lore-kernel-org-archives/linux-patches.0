Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB363FB1B;
	Mon, 23 Jun 2025 22:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716245; cv=none; b=WC5jftyWn3BjRYKETLuh8YXho/SjmW570I33SqoEKXOOv0x5U9yFYEeoc9uGELi4E9dyGSqKJOrK4dVdx2SHcKiX2k/2oOdBVVy6Ci548ctKDuYjfrVek4XVTyeI2CnOn/9r9AvJUmKWjSpJruPdlXKgNGAlaAnLZeRro1G63q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716245; c=relaxed/simple;
	bh=PaMuhCNHAfyMNtUBtGRxQdx59wmXjNBBcpoCZWqEwhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHOdqfFLNicxQE+7tPaYAY7AOYKyJbYp4335wb+i3e1UyENFGuoj3gsV+ODUhLkZEQ70uh0LDIybMtlRW8Y0XBohonnw906PKVnVLayyxSY6mC+0s0XA8sLh4LqvCpB2inDECw4HRJE9Beuykor3TOI5aqo75oO8ZVnHPuMjYBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9HbbVZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9HbbVZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C21C4CEEA;
	Mon, 23 Jun 2025 22:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716245;
	bh=PaMuhCNHAfyMNtUBtGRxQdx59wmXjNBBcpoCZWqEwhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9HbbVZWWLIiEQtNuOKFfzjx+k0rUCZbNWR65X8szYHo1JTd0bALnymGwjYM2J7YH
	 Yz+o9Az6s9t/Vrh35iCivOZrS3rftl7fQBUpXXmjME8pT4fGYjq8rTlRYdtvRf8xkp
	 43SfGMQEtfLMUB5PTvAY83SzjeMRxXdni8UImO4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jeremy Kerr <jk@codeconstruct.com.au>
Subject: [PATCH 6.6 272/290] net: make for_each_netdev_dump() a little more bug-proof
Date: Mon, 23 Jun 2025 15:08:53 +0200
Message-ID: <20250623130635.102871976@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

commit f22b4b55edb507a2b30981e133b66b642be4d13f upstream.

I find the behavior of xa_for_each_start() slightly counter-intuitive.
It doesn't end the iteration by making the index point after the last
element. IOW calling xa_for_each_start() again after it "finished"
will run the body of the loop for the last valid element, instead
of doing nothing.

This works fine for netlink dumps if they terminate correctly
(i.e. coalesce or carefully handle NLM_DONE), but as we keep getting
reminded legacy dumps are unlikely to go away.

Fixing this generically at the xa_for_each_start() level seems hard -
there is no index reserved for "end of iteration".
ifindexes are 31b wide, tho, and iterator is ulong so for
for_each_netdev_dump() it's safe to go to the next element.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ The mctp RTM_GETADDR rework backport of acab78ae12c7 ("net: mctp: Don't
  access ifa_index when missing") pulled 2d45eeb7d5d7 ("mctp: no longer
  rely on net->dev_index_head[]") as a dependency. However, that change
  relies on this backport for correct behaviour of
  for_each_netdev_dump().

  Jakub mentions[1] that nothing should be relying on the old behaviour
  of for_each_netdev_dump(), hence the backport.

  [1]: https://lore.kernel.org/netdev/20250609083749.741c27f5@kernel.org/ ]
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netdevice.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3036,7 +3036,8 @@ extern rwlock_t				dev_base_lock;		/* De
 #define net_device_entry(lh)	list_entry(lh, struct net_device, dev_list)
 
 #define for_each_netdev_dump(net, d, ifindex)				\
-	xa_for_each_start(&(net)->dev_by_index, (ifindex), (d), (ifindex))
+	for (; (d = xa_find(&(net)->dev_by_index, &ifindex,		\
+			    ULONG_MAX, XA_PRESENT)); ifindex++)
 
 static inline struct net_device *next_net_device(struct net_device *dev)
 {



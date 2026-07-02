Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225C034EF0E;
	Thu,  2 Jul 2026 16:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010297; cv=none; b=U2Qy4REVNpCCPBsP6HtnbIFppV2IkVn602wvUwJY8Y1l6ZMz69GokeLPtokOBY8Fhsk6RXj0nvdfeyrN92tqJK0ho+tBsqp8f+qPqw31tP7nbjouBxL4cugZ0I4V8MNCtKVskujuE8x4wI+KReIo28aCZGp0bW6fPh6SgIqhtXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010297; c=relaxed/simple;
	bh=LZ8nHrV3UPim69GG9nkQN3fHQqs1f49iHTlBlvtgP2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DEKqhIz9eFS5HKyQodD/u3xECGJzKbF/KTLtK/WrGCECxK2vfUWfITkHO8JGbtQouVbBAKAj7UrxlI0yZJIp0ydcSgwRYugmkcx1BwCdkJ+vm5gi/PgGUoyVRVqaJ/zaCp8/IIrO59NcebvHCSJwyNIWDBYwV+G+CThdvIpQpVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=INX34Nj2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="INX34Nj2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CBC1F000E9;
	Thu,  2 Jul 2026 16:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010296;
	bh=/zSiibbrlWe2C+U1GFHfGwY+y19gRPIDUudL11wSwB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=INX34Nj2mCVsLZYAg8Sh0DBky93gr7D9mieJIMnMeERUZPVDmS3FeG9zHAhwKJqVm
	 ljH/ekfSEiCrmrI8zEUgVTs37N9UpZ/uC7qVGY7YnOaJ8XELkCOOSKTRmbk/OElvmt
	 HaSPOoHTxZaOLv4MxlbNEv7/ziu/r20V8VswO1wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Santosh Kalluri <santosh.kalluri129@gmail.com>,
	=?UTF-8?q?R=C3=A9mi=20Denis-Courmont?= <remi@remlab.net>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/204] net: phonet: free phonet_device after RCU grace period
Date: Thu,  2 Jul 2026 18:18:31 +0200
Message-ID: <20260702155119.791281973@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Santosh Kalluri <santosh.kalluri129@gmail.com>

[ Upstream commit 71de0177b28da751f407581a4515cf4d762f6296 ]

phonet_device_destroy() removes a phonet_device from the per-net device
list with list_del_rcu(), but frees it immediately. RCU readers walking
the same list can still hold a pointer to the object after it has been
removed, leading to a slab-use-after-free.

Use kfree_rcu(), matching the lifetime rule already used by
phonet_address_del() for the same object type.

Fixes: eeb74a9d45f7 ("Phonet: convert devices list to RCU")
Cc: stable@vger.kernel.org
Signed-off-by: Santosh Kalluri <santosh.kalluri129@gmail.com>
Acked-by: Rémi Denis-Courmont <remi@remlab.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/phonet/pn_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/phonet/pn_dev.c
+++ b/net/phonet/pn_dev.c
@@ -105,7 +105,7 @@ static void phonet_device_destroy(struct
 		for_each_set_bit(addr, pnd->addrs, 64)
 			phonet_address_notify(net, RTM_DELADDR, ifindex, addr);
 
-		kfree(pnd);
+		kfree_rcu(pnd, rcu);
 	}
 }
 



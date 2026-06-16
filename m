Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B495234889F;
	Tue, 16 Jun 2026 15:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624200; cv=none; b=VptQAv4NM7n9YZZHL928sT84pTaIWcR5JfmebjhwJQ1glqcZ5VK4hx21k/nUUMl3SOTlPY6o+AjZYNKFb+GFXTRJvSQUE2zxwgvjLGfK5n/jc5wNtjOVa1FgjQijxJ5KPV3c/VrclUwXJ1cSiRV8z8rT6du5++Gr5H/uvTuAd2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624200; c=relaxed/simple;
	bh=bg/kP50O8qlPgX073V64zKcnuVhPp+I3n921gaw5R6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i78wg80HzTa/2cfkphLs7HPpZEkY7oj1SZO9mN5yy85Wkd1DM8j1fClCmexxph1e/88f6+/nHDNEAlRs68IBkQDgv2W1WJ3oyNrk4y7VAa5LotZ9ax7252iCPUPREz3QjPwxTIScv8xmze3xdrkUZHfjW/tLPsES/aN5Efhxc+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNqPX9SR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNqPX9SR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942941F000E9;
	Tue, 16 Jun 2026 15:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624199;
	bh=rS6C3s9qn0l2L5+sebhVoPgLHMV11rlFxCzIbdfM7kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fNqPX9SRHcV1PxAvBW7Nj8NRVUw9mUnXnRACT+YozT0W/HXRM6+B+Opjf9mOjLMJh
	 RWtKfV8fpDlET2Cviv6dPf00f/3Fdxe8CRswPS5asWAGIOGlN7QSGBTlDFiBsX6awq
	 eS/0SBIAKmSwlbKls5UIPFGZYZZKT2Tp86eVmVKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Santosh Kalluri <santosh.kalluri129@gmail.com>,
	=?UTF-8?q?R=C3=A9mi=20Denis-Courmont?= <remi@remlab.net>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 291/378] net: phonet: free phonet_device after RCU grace period
Date: Tue, 16 Jun 2026 20:28:42 +0530
Message-ID: <20260616145125.390928789@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Santosh Kalluri <santosh.kalluri129@gmail.com>

commit 71de0177b28da751f407581a4515cf4d762f6296 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/phonet/pn_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/phonet/pn_dev.c
+++ b/net/phonet/pn_dev.c
@@ -108,7 +108,7 @@ static void phonet_device_destroy(struct
 		for_each_set_bit(addr, pnd->addrs, 64)
 			phonet_address_notify(net, RTM_DELADDR, ifindex, addr);
 
-		kfree(pnd);
+		kfree_rcu(pnd, rcu);
 	}
 }
 



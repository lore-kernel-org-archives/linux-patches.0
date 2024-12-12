Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D911209695;
	Thu, 12 Dec 2024 17:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025807; cv=none; b=QjjPAkybSfTDBT3WQLfAR4zdofrwRXxvZ6uTCk6Hx0Qi+Rc9s1BC9AsBfyhApvFeEPm0WsDljrsnr7IzeeTi//r2dBVZopMeh52P6tYyiYCHal7gu+z1hVl1yxLPApLDP+Tb0cgtgrjdfrXWJYv7Gaw4bz3eN8kBAS3Vw5I2v9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025807; c=relaxed/simple;
	bh=lvTaaEpgGyXLB6ojEy9ef9xr4yZ71EA5LhAnHb/IyHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i05x2/EDk3Uz2xeTRoF04fm+PDFq/9KfLEXnA7oDxHMS4/kR8i2VBQeUNDyEYXVLMAt1DI6BFEtjLsH6cc4jbEF3u0UNKBqmjIgl6BCVxYp7bl9BkhmoKGJtAbq8VHJg16QUNSrhKrBTpIQ2h1M1hcOgWPzDcZmcnIzn35/13mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i2aDP7GO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i2aDP7GO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C038C4CECE;
	Thu, 12 Dec 2024 17:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025807;
	bh=lvTaaEpgGyXLB6ojEy9ef9xr4yZ71EA5LhAnHb/IyHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i2aDP7GOmC1IY98Y31J5GWk4ly7H2EzemEitle3mXojNSaozKAdOsJ8THbMJQwYXK
	 3mpwzb6vskS8j2BxX8ZkNFJRFKt7NkrPn/mvCVQC/icajr3R+SPYmHLAlre3oPEbmm
	 ao1/V6aS4x+dDqDda/5PCr3hA4jPYM+09m59iiCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Kubiak <michal.kubiak@intel.com>,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 293/321] netpoll: Use rcu_access_pointer() in __netpoll_setup
Date: Thu, 12 Dec 2024 16:03:31 +0100
Message-ID: <20241212144241.555315757@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit c69c5e10adb903ae2438d4f9c16eccf43d1fcbc1 ]

The ndev->npinfo pointer in __netpoll_setup() is RCU-protected but is being
accessed directly for a NULL check. While no RCU read lock is held in this
context, we should still use proper RCU primitives for consistency and
correctness.

Replace the direct NULL check with rcu_access_pointer(), which is the
appropriate primitive when only checking for NULL without dereferencing
the pointer. This function provides the necessary ordering guarantees
without requiring RCU read-side protection.

Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20241118-netpoll_rcu-v1-1-a1888dcb4a02@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 9b263a5c0f36f..9a67aa989d606 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -615,7 +615,7 @@ int __netpoll_setup(struct netpoll *np, struct net_device *ndev)
 		goto out;
 	}
 
-	if (!ndev->npinfo) {
+	if (!rcu_access_pointer(ndev->npinfo)) {
 		npinfo = kmalloc(sizeof(*npinfo), GFP_KERNEL);
 		if (!npinfo) {
 			err = -ENOMEM;
-- 
2.43.0




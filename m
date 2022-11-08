Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA9D15CAC
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3336C433D6;
	Tue,  8 Nov 2022 13:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915518;
	bh=0XeJTDaZ2kNEgnNvNK0O5IJ3qGtlj3K0leq7ZHTDuxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yzo0LkD3a4hmsG8WNCyGgr+RzsWYSP071+4O4VuXbhjJhzoxOe0eiETK5C+Wh04sD
	 iOJhSG18gKfT6gFl+dPRf3nkEyXmdPcghG61MWCESDcqpDK1bxVF0RA0tV4mPiUacU
	 rwJuKJLiP9ht+b1Ojm/TZ2Rxivm1XY+Skaa5dFDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/118] RDMA/cma: Use output interface for net_dev check
Date: Tue,  8 Nov 2022 14:38:11 +0100
Message-Id: <20221108133341.276779020@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Håkon Bugge <haakon.bugge@oracle.com>

[ Upstream commit eb83f502adb036cd56c27e13b9ca3b2aabfa790b ]

Commit 27cfde795a96 ("RDMA/cma: Fix arguments order in net device
validation") swapped the src and dst addresses in the call to
validate_net_dev().

As a consequence, the test in validate_ipv4_net_dev() to see if the
net_dev is the right one, is incorrect for port 1 <-> 2 communication when
the ports are on the same sub-net. This is fixed by denoting the
flowi4_oif as the device instead of the incoming one.

The bug has not been observed using IPv6 addresses.

Fixes: 27cfde795a96 ("RDMA/cma: Fix arguments order in net device validation")
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Link: https://lore.kernel.org/r/20221012141542.16925-1-haakon.bugge@oracle.com
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index b5fa19a033c0..9ed5de38e372 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1437,7 +1437,7 @@ static bool validate_ipv4_net_dev(struct net_device *net_dev,
 		return false;
 
 	memset(&fl4, 0, sizeof(fl4));
-	fl4.flowi4_iif = net_dev->ifindex;
+	fl4.flowi4_oif = net_dev->ifindex;
 	fl4.daddr = daddr;
 	fl4.saddr = saddr;
 
-- 
2.35.1




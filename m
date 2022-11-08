Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D1615CAD
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:00:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD36C433D6;
	Tue,  8 Nov 2022 14:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916035;
	bh=2YLkmnQ3uSWSb0trxb7Y31xIioTxe44hZ3feI36o5C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Tp3mVa5XcbPcxv3aBl44/Wwa56fmNVmueMdHi21Irg/P4NxQSfN3RnzT9rUul0I4
	 tbVqoPextLcHw4WQVJC182cOuawKonTIx8aZ89+w4gQ/E6FgduGDr/Sa0bQ/4QDEIf
	 g3MV8vz8KqQc/L6AeCOknnTGbCpTgn7VO+ZR/QyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 013/144] RDMA/cma: Use output interface for net_dev check
Date: Tue,  8 Nov 2022 14:38:10 +0100
Message-Id: <20221108133345.886463545@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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
index 0da66dd40d6a..fd192104fd8d 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1433,7 +1433,7 @@ static bool validate_ipv4_net_dev(struct net_device *net_dev,
 		return false;
 
 	memset(&fl4, 0, sizeof(fl4));
-	fl4.flowi4_iif = net_dev->ifindex;
+	fl4.flowi4_oif = net_dev->ifindex;
 	fl4.daddr = daddr;
 	fl4.saddr = saddr;
 
-- 
2.35.1




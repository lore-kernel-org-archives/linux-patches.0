Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AB2171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA01CC433D2;
	Mon, 22 May 2023 19:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784498;
	bh=100CBOEQouBGkjLwQkhKz1BrM0aikwl8UCC1w0QAoBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B9+aXFaG7E24hLXi7vOkVgo81n4docm2yvsgaUz3aKFnW9ddpO8SQEPAKt7EWhate
	 Ebp5dEnUj+TJHWF5ZUyjBfowSVB1ey2VCDyzp7RdFHmatYmlR1aDmy7pH/GdkteO22
	 eQpGukr4bsGuHF4iNMCwF9BE37j+iTQxzVXkO0FM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Child <nnac123@linux.ibm.com>,
	Piotr Raczynski <piotr.raczynski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 102/364] net: Catch invalid index in XPS mapping
Date: Mon, 22 May 2023 20:06:47 +0100
Message-Id: <20230522190415.305033152@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nick Child <nnac123@linux.ibm.com>

[ Upstream commit 5dd0dfd55baec0742ba8f5625a0dd064aca7db16 ]

When setting the XPS value of a TX queue, warn the user once if the
index of the queue is greater than the number of allocated TX queues.

Previously, this scenario went uncaught. In the best case, it resulted
in unnecessary allocations. In the worst case, it resulted in
out-of-bounds memory references through calls to `netdev_get_tx_queue(
dev, index)`. Therefore, it is important to inform the user but not
worth returning an error and risk downing the netdevice.

Signed-off-by: Nick Child <nnac123@linux.ibm.com>
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
Link: https://lore.kernel.org/r/20230321150725.127229-1-nnac123@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8fbd241849c01..b3d8e74fcaf06 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2535,6 +2535,8 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	struct xps_map *map, *new_map;
 	unsigned int nr_ids;
 
+	WARN_ON_ONCE(index >= dev->num_tx_queues);
+
 	if (dev->num_tc) {
 		/* Do not allow XPS on subordinate device directly */
 		num_tc = dev->num_tc;
-- 
2.39.2




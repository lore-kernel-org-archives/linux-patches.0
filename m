Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F8F171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF4AC433D2;
	Mon, 22 May 2023 19:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783576;
	bh=rBaENMPcYH9khGCnR9G8YZifplk6iDBMO+D/7Fp0kkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1C/fhKE/9SfXS/KAr6XRiMf5d3Mdx2ryu8DGHM0bA4MuRDy6mgMw1jdQVa9ZS6zpY
	 LhM0hs1XTp4ym5yMXcJNC1UxaW6rk+NRquIXKdV4/4snKPctjJSJIzdIMg/JrIDQAB
	 lAfoCOqRyRgNWdohHTm7muwFFaaSbn0Qm9zjVD7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Child <nnac123@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 083/292] netdev: Enforce index cap in netdev_get_tx_queue
Date: Mon, 22 May 2023 20:07:20 +0100
Message-Id: <20230522190408.048639987@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
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

[ Upstream commit 1cc6571f562774f1d928dc8b3cff50829b86e970 ]

When requesting a TX queue at a given index, warn on out-of-bounds
referencing if the index is greater than the allocated number of
queues.

Specifically, since this function is used heavily in the networking
stack use DEBUG_NET_WARN_ON_ONCE to avoid executing a new branch on
every packet.

Signed-off-by: Nick Child <nnac123@linux.ibm.com>
Link: https://lore.kernel.org/r/20230321150725.127229-2-nnac123@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b072449b0f1ac..eac51e22a52a8 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2428,6 +2428,7 @@ static inline
 struct netdev_queue *netdev_get_tx_queue(const struct net_device *dev,
 					 unsigned int index)
 {
+	DEBUG_NET_WARN_ON_ONCE(index >= dev->num_tx_queues);
 	return &dev->_tx[index];
 }
 
-- 
2.39.2




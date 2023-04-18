Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCE72566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F39C4339B;
	Tue, 18 Apr 2023 12:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681820667;
	bh=/8NdQGa/ROLTzs+jTM0whWEcbehms3Ue4zcMMEjo+yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ftJr2e3KHsq01Utm+a0sQGNLTLM/mHrj6dGatWrBVB2d7hF+ADP9Pv7gD8gkGWDu8
	 tajLqN+M2Q4PT04oIzXkwGjNAE624lcmoH6DGj5zIT9xQn1HyfFq/NSGnzyiYtCa8i
	 b1do6Y0K6N4GiVT9g+PPKGsajxMkYSYs+fA5HEHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 24/37] 9p/xen : Fix use after free bug in xen_9pfs_front_remove due to race condition
Date: Tue, 18 Apr 2023 14:21:34 +0200
Message-Id: <20230418120255.518281826@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120254.687480980@linuxfoundation.org>
References: <20230418120254.687480980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zheng Wang <zyytlz.wz@163.com>

[ Upstream commit ea4f1009408efb4989a0f139b70fb338e7f687d0 ]

In xen_9pfs_front_probe, it calls xen_9pfs_front_alloc_dataring
to init priv->rings and bound &ring->work with p9_xen_response.

When it calls xen_9pfs_front_event_handler to handle IRQ requests,
it will finally call schedule_work to start the work.

When we call xen_9pfs_front_remove to remove the driver, there
may be a sequence as follows:

Fix it by finishing the work before cleanup in xen_9pfs_front_free.

Note that, this bug is found by static analysis, which might be
false positive.

CPU0                  CPU1

                     |p9_xen_response
xen_9pfs_front_remove|
  xen_9pfs_front_free|
kfree(priv)          |
//free priv          |
                     |p9_tag_lookup
                     |//use priv->client

Fixes: 71ebd71921e4 ("xen/9pfs: connect to the backend")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_xen.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index ebe232fd45f74..f7008f1daaace 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -290,6 +290,10 @@ static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
 	write_unlock(&xen_9pfs_lock);
 
 	for (i = 0; i < priv->num_rings; i++) {
+		struct xen_9pfs_dataring *ring = &priv->rings[i];
+
+		cancel_work_sync(&ring->work);
+
 		if (!priv->rings[i].intf)
 			break;
 		if (priv->rings[i].irq > 0)
-- 
2.39.2




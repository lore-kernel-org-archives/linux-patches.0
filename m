Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB69A359A72
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302475; cv=none; b=GO+QQzr0HYNdNHBIUige+FRFpBvE0ejZbrSvYhQrjq/2zeMeagGnzEoS+NmZsqtELXsKuJP/UJQLhN7nSQexrXr3agQilkOSmSrKX6NMNvzL6sL1AZJkwzydK+EibXy6KT8qk8u6Or5vRctHwj+rlxE9hPYY+s6gjbvzt5wGa90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302475; c=relaxed/simple;
	bh=Lbm6T0DzmCVBSAB9vJQrg+Z0k/WHj38arF7TwDb50mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLmmq+TUWkxAcTWb1yigILg6m4sMjJE5apN9oVtJrBZ6nsAH2R/J72fPuv61zt+YzGOeACl4NrXHt3VSWRa8Y13+113mUQ9X95sMo21oO9AQWMK0xwNrXb9J2k8Pk+Oll6EJmETT7HfpWqWguojnW07A7Gx+DbrDVajrXxdi5As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K3Erx76e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K3Erx76e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4076DC116D0;
	Sat, 28 Feb 2026 18:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302474;
	bh=Lbm6T0DzmCVBSAB9vJQrg+Z0k/WHj38arF7TwDb50mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3Erx76eWdcYWjab7WJrXrS4a23Tj/GBMjt/zgakedAKcKXQuvqwxG0TBSDlSqE5B
	 bt+UwuIL8bha1HVqGWqb/Ddt+wGlxcpPuY18ja3fYzpVl/yhh0qsu4S83HyNTQbZ8Q
	 ZoNAvSLHPUh2H6Itr8rNxZf77KuZnbUP5KWlfqyIjkaTZdpby9MO0hPdCu99PuPg6f
	 7rgObHO7wtRWbzY+7fb30ZF+n5A5anoqQ5xSa1H//rYNiOLMsil2cR2zeUQRfHVtC4
	 0JHvFcb8SexH4Qwj1pl7Usk22mkuPlO3+ZTU/pNqm0ACAh7vjyZRU9c7HkHw/UjZrg
	 z6E41EQnB9/9w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Juergen Gross <jgross@suse.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 220/232] xen-netback: reject zero-queue configuration from guest
Date: Sat, 28 Feb 2026 13:11:13 -0500
Message-ID: <20260228181127.1592657-220-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

[ Upstream commit 6d1dc8014334c7fb25719999bca84d811e60a559 ]

A malicious or buggy Xen guest can write "0" to the xenbus key
"multi-queue-num-queues". The connect() function in the backend only
validates the upper bound (requested_num_queues > xenvif_max_queues)
but not zero, allowing requested_num_queues=0 to reach
vzalloc(array_size(0, sizeof(struct xenvif_queue))), which triggers
WARN_ON_ONCE(!size) in __vmalloc_node_range().

On systems with panic_on_warn=1, this allows a guest-to-host denial
of service.

The Xen network interface specification requires
the queue count to be "greater than zero".

Add a zero check to match the validation already present
in xen-blkback, which has included this
guard since its multi-queue support was added.

Fixes: 8d3d53b3e433 ("xen-netback: Add support for multiple queues")
Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://patch.msgid.link/20260212224040.86674-1-n7l8m4@u.northwestern.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/xenbus.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index 001636901ddae..a972b05da96fc 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -735,10 +735,11 @@ static void connect(struct backend_info *be)
 	 */
 	requested_num_queues = xenbus_read_unsigned(dev->otherend,
 					"multi-queue-num-queues", 1);
-	if (requested_num_queues > xenvif_max_queues) {
+	if (requested_num_queues > xenvif_max_queues ||
+	    requested_num_queues == 0) {
 		/* buggy or malicious guest */
 		xenbus_dev_fatal(dev, -EINVAL,
-				 "guest requested %u queues, exceeding the maximum of %u.",
+				 "guest requested %u queues, but valid range is 1 - %u.",
 				 requested_num_queues, xenvif_max_queues);
 		return;
 	}
-- 
2.51.0


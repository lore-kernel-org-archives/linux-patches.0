Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693002C21D4;
	Tue, 12 Aug 2025 18:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024335; cv=none; b=IhMVnGWuJ6aPfg8SCO6ibW9fSJtz8EgVx7yrO7IHkSr1FRFGI/dLxwYdrVYRRSInFvokRswlor2dh41Xa0p7h3oSxLIwGfVsYJF9FaxSk+wVuZG6TqjMlNw0dSdeJnKolaSmvkaJfhYXQcSuAtOK0QZrJQ1yKTlJYTLKSy3DuxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024335; c=relaxed/simple;
	bh=j279tONBKdKHtObIst/rozWWZ2CdEY9Zwu3xqotee3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iE3v44POrIaNZcR9vU640aaPIyGbtJgHvKZzRFERU+3BUGpscExm7Bj4nDyVEvhYdfoGEClLPrGlrAu5YfhVZhdRUoPVf/HLnAbvHOG5MAXVeireuIYn/UvakXRzu83UGTTn8QuWjqBkwkAPORgrE4quxJznAPzUoA6MoOL+oFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=di+ENN8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="di+ENN8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD76EC4CEF0;
	Tue, 12 Aug 2025 18:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024335;
	bh=j279tONBKdKHtObIst/rozWWZ2CdEY9Zwu3xqotee3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=di+ENN8P5nriqXSZdNV0zODLmsv62iJ6jkTtCzYi2uRxKJ6FDZO3Ip9Xuk+jkPsHU
	 3G77JQg3ak7BArvaCE+NKQhVWT1tqy23NmKL0dIxeV6vhmyVkULCwpOQdlcPDVySgW
	 7JNam7bDXHAOwOpAH+6ZWuIZMpCnd99/FFOfQX8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parav Pandit <parav@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 341/627] RDMA/ipoib: Use parent rdma device net namespace
Date: Tue, 12 Aug 2025 19:30:36 +0200
Message-ID: <20250812173432.256100073@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Bloch <mbloch@nvidia.com>

[ Upstream commit f1208b05574f63c52e88109d8c75afdf4fc6bf42 ]

Use the net namespace of the underlying rdma device.
After honoring the rdma device's namespace, the ipoib
netdev now also runs in the same net namespace of the
rdma device.

Add an API to read the net namespace of the rdma device
so that ULP such as IPoIB can use it to initialize its
netdev.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Stable-dep-of: f458ccd2aa2c ("RDMA/uverbs: Check CAP_NET_RAW in user namespace for flow create")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 2 ++
 include/rdma/ib_verbs.h                   | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index f2f5465f2a90..7acafc5c0e09 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2577,6 +2577,8 @@ static struct net_device *ipoib_add_port(const char *format,
 
 	ndev->rtnl_link_ops = ipoib_get_link_ops();
 
+	dev_net_set(ndev, rdma_dev_net(hca));
+
 	result = register_netdev(ndev);
 	if (result) {
 		pr_warn("%s: couldn't register ipoib port %d; error %d\n",
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index af43a8d2a74a..c83e5a375cd6 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -4855,6 +4855,11 @@ static inline int ibdev_to_node(struct ib_device *ibdev)
 bool rdma_dev_access_netns(const struct ib_device *device,
 			   const struct net *net);
 
+static inline struct net *rdma_dev_net(struct ib_device *device)
+{
+	return read_pnet(&device->coredev.rdma_net);
+}
+
 #define IB_ROCE_UDP_ENCAP_VALID_PORT_MIN (0xC000)
 #define IB_ROCE_UDP_ENCAP_VALID_PORT_MAX (0xFFFF)
 #define IB_GRH_FLOWLABEL_MASK (0x000FFFFF)
-- 
2.39.5




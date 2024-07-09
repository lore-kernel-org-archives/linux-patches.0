Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE9455E4C;
	Tue,  9 Jul 2024 11:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524804; cv=none; b=L+kxTLo4VNPy5WRMNlcLBJALi84AEHaDNxs0HTN6wvXzX7WXelJjspKdVOdKehm+0PinlyypgLa86XPI0NAe1XcamymymwLE2+gQheod6PlgQyiFyUM5khc6cFQo80cRfbXfm4NbQbJ0PC3/c0VtcFkMHFYMHI1G/cfleZiNuBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524804; c=relaxed/simple;
	bh=FnN5IoK70vSXRoKA74oLZC6YD1fncyxbsP2aY3ucdb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AzypJEjfVoa4x9o3nTiQPhI/lMe9MAN3r5KVvcSvppQsebUlCOGqVdSGhxZeuNis88UAOQBSVZy5IiYuWJN76bm6sPMqaRhrdgrmkWIcDc3vas32mLYIb6RInUfTHoLNtiZq5lZDJW88HMZf6J8V7S2RNNuB1AXf43nY8HSDads=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VMKYR2WW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VMKYR2WW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3BCC3277B;
	Tue,  9 Jul 2024 11:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524803;
	bh=FnN5IoK70vSXRoKA74oLZC6YD1fncyxbsP2aY3ucdb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMKYR2WWu9xqRuQUsYCeBmglejdz8kYuva3QuSC9LXlasGbPg++Os1TDEl++onWcY
	 FVwXkwNfShWFbr7/RBywjYeFAv5tl4XcQdOn22zpDd2IAXqDe0OWN5nzezDSP0LqQl
	 iKP8qLdnBr3ooZtIcsw4riHRp6WcxyBa37nR56sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilay Shroff <nilay@linux.ibm.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/102] nvme-multipath: find NUMA path only for online numa-node
Date: Tue,  9 Jul 2024 13:10:54 +0200
Message-ID: <20240709110654.910595016@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilay Shroff <nilay@linux.ibm.com>

[ Upstream commit d3a043733f25d743f3aa617c7f82dbcb5ee2211a ]

In current native multipath design when a shared namespace is created,
we loop through each possible numa-node, calculate the NUMA distance of
that node from each nvme controller and then cache the optimal IO path
for future reference while sending IO. The issue with this design is that
we may refer to the NUMA distance table for an offline node which may not
be populated at the time and so we may inadvertently end up finding and
caching a non-optimal path for IO. Then latter when the corresponding
numa-node becomes online and hence the NUMA distance table entry for that
node is created, ideally we should re-calculate the multipath node distance
for the newly added node however that doesn't happen unless we rescan/reset
the controller. So essentially, we may keep using non-optimal IO path for a
node which is made online after namespace is created.
This patch helps fix this issue ensuring that when a shared namespace is
created, we calculate the multipath node distance for each online numa-node
instead of each possible numa-node. Then latter when a node becomes online
and we receive any IO on that newly added node, we would calculate the
multipath node distance for newly added node but this time NUMA distance
table would have been already populated for newly added node. Hence we
would be able to correctly calculate the multipath node distance and choose
the optimal path for the IO.

Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 6cf0ce7aff678..d0154859421db 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -559,7 +559,7 @@ static void nvme_mpath_set_live(struct nvme_ns *ns)
 		int node, srcu_idx;
 
 		srcu_idx = srcu_read_lock(&head->srcu);
-		for_each_node(node)
+		for_each_online_node(node)
 			__nvme_find_path(head, node);
 		srcu_read_unlock(&head->srcu, srcu_idx);
 	}
-- 
2.43.0




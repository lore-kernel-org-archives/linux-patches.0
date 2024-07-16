Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AED8195B27;
	Tue, 16 Jul 2024 15:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144622; cv=none; b=r3aQK3WUOf7SD8NWGe7EIlz3igKoV4FpipeBS73r/C6jN9ApILYyik7/NsfV2ky7S3wqORXYzoBDolxdxhEu/bk4TcXcU0sw9OmhbFJIP3rYoTM5dagUoM9h0R6zm6if7jlc9+Uf0vzzfa4d87TA81Jw+tSYOpAaEC4AbAK0BLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144622; c=relaxed/simple;
	bh=BtulGJ9LNbRAPcObdIkHOHkZoaha5oeazXu1dvH510I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEjHD/Z8hVrRXytLcwykCkknPfFLoHIG3iqO1CUD87bP3U9tT41zuEPvJzjSbv3aBRdCFsY9ZiebRHcgZ6yabvxoAnl7uCOBRBHDExlYX0LHRRUDYzRtiu1aarlsM8BGz0ZK1fSuyjqnNq/8TVksBcLYw3iR3aXjbb5nbno2i9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m4xw9UbL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m4xw9UbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF86C116B1;
	Tue, 16 Jul 2024 15:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144622;
	bh=BtulGJ9LNbRAPcObdIkHOHkZoaha5oeazXu1dvH510I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m4xw9UbLzdvI5CRfm+krfdv+SVkFOTYXy0fPdzEaOCMB7DXNksRD8b9Nj6SaExhj9
	 RfZFUw+VVX8xeoCCJJdRDm0S11SRRsB+4AkLJpyrJcfLUwHFjYmkzeZB0JpXL4SK0y
	 NtNuephVRyxpSvCmOdZx7PMAJJTgEZzxMIVLkwgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilay Shroff <nilay@linux.ibm.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/108] nvme-multipath: find NUMA path only for online numa-node
Date: Tue, 16 Jul 2024 17:31:06 +0200
Message-ID: <20240716152747.947535835@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9f59f93b70e26..54ca60db65473 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -420,7 +420,7 @@ static void nvme_mpath_set_live(struct nvme_ns *ns)
 		int node, srcu_idx;
 
 		srcu_idx = srcu_read_lock(&head->srcu);
-		for_each_node(node)
+		for_each_online_node(node)
 			__nvme_find_path(head, node);
 		srcu_read_unlock(&head->srcu, srcu_idx);
 	}
-- 
2.43.0




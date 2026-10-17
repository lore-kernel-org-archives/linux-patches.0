Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3DB3B6C06;
	Sat, 17 Oct 2026 16:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255300; cv=none; b=buVKoYUzMn2u4Hderu6+0FuhM9EyXyjOSqCgPvc7Fc/P4Fw/6n9aR595ihWgJOsUdhrll1elbV16nTP7hrDhe9ymKFFZ+5AdKlu4kAEmeDH5wJEuvc0RSri1VieBb+0lDoLB6BcglfUsWZMyRV40PQS/NBLLF/uaSu/SN7x0XAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255300; c=relaxed/simple;
	bh=FPfVlEyVkrYkJYeqieJvi69P4fvQMpNJl4yWe9NoNgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aamhrLS93vaThsYJ5bPFHCUU2+EpiO/84kwQos12tV0hUNh20hH0c8/2pAgsYUwJ7IE+28a1kFsSwuZUclZkm+P7/RVajektMJFBG527eXkERK6c4amYPW4TDYr/IKbjnmvPUbSxai/lCNbHRWtERKsbPipdMB3mJ/j+Ori++nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kfBMg5Xl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kfBMg5Xl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE931F000C4;
	Sat, 17 Oct 2026 16:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255299;
	bh=HKgLjSy0N42vXA4I8dPTDhwVqEDmRCXddEmHmNvWNW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kfBMg5XlJtqrV1ala/PF9Dpw0AfYLh6kLZ3UDN6UJ58JnEl1wsb1miZHRyFH3FlAY
	 vlSzhNPuJ/WU3oGX31/+xxajsiCh8RxX5DsdVKf8ZI3Wd/CLkSz93lfIjFqhtIsvVa
	 8Z5LnGM5VeOyh3t5tpqb7drRvR9Vzta9Nq+YFzp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 703/869] RDMA/rvt: Return NULL after port allocation failure
Date: Sat, 17 Oct 2026 17:59:04 +0200
Message-ID: <20261017160054.990540409@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 2982eaf3b9d2d953318c74cd6f1b7576ea6d7b1f ]

rvt_alloc_device() deallocates the IB device when its port array cannot
be allocated but then returns the pointer to the released allocation.
Callers treat any non-NULL value as valid and dereference it, resulting
in a use-after-free.

Return NULL immediately after deallocation so callers can propagate the
allocation failure.

Fixes: ff6acd69518e ("IB/rdmavt: Add device structure allocation")
Link: https://patch.msgid.link/20260708-clean-init-one-hfi1-v1-1-b9e9641268a5@nvidia.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rdmavt/vt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 5499025e8a0ad..b1750f2a6dcbc 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -54,8 +54,10 @@ struct rvt_dev_info *rvt_alloc_device(size_t size, int nports)
 		return rdi;
 
 	rdi->ports = kcalloc(nports, sizeof(*rdi->ports), GFP_KERNEL);
-	if (!rdi->ports)
+	if (!rdi->ports) {
 		ib_dealloc_device(&rdi->ibdev);
+		return NULL;
+	}
 
 	return rdi;
 }
-- 
2.53.0




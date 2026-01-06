Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CF635FF65;
	Tue,  6 Jan 2026 17:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721762; cv=none; b=nupl6il/moCOGa8ByoUmCnaT5v+KmNm7o4YeDcjYGGqzourj7OogWw4w+qHlAgQP9j8FyBlsS4c8ydYgJswBGqw8xEAEuRdwaYUztt/B9K1JFh778hKy9f0PHJnVAD/fX+jdhuUzrVG80x8g/s1m/A+bObRRMK1fOKE44RrFSZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721762; c=relaxed/simple;
	bh=jIhr2SHWjYcEiunZs8qhtq+LW+E7qv4BP7PlKE6B94Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWX1PQ59LmrMFQo3aBhOeCBFTLYR1vi68rDso60x1KTqgcaIANNyvCEse3J6bmRYEjOTtAhKIzFlvaLEWYebuf1xXx3sdGM9889Q5UnDrhZj+plVHVnkS13O7ZdCNeBHa+jC4lWBwFKe80rjVvn+54O3RFn0v6v7dT8sZe5cc3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LqkgbzIl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LqkgbzIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16ADAC116C6;
	Tue,  6 Jan 2026 17:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721762;
	bh=jIhr2SHWjYcEiunZs8qhtq+LW+E7qv4BP7PlKE6B94Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LqkgbzIl+y4l2E9qblWtQ+esfjuIA52EiAW5YIq7rlGjYXZpBfl+PcEmfz95w2Rep
	 n3pgqzYaCe2phGrChgexQ3q+lja98jStSLka3SZ+NQEUnn7lFzXOYHg3j/a9mEGWDh
	 IOeMWRijwNL6hg5bqXrG1bwmfO52t9aTkE2zqywY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 065/312] RDMA/ucma: Fix rdma_ucm_query_ib_service_resp struct padding
Date: Tue,  6 Jan 2026 18:02:19 +0100
Message-ID: <20260106170550.202395748@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 2dc675f614850b80deab7cf6d12902636ed8a7f4 ]

On a few 32-bit architectures, the newly added ib_user_service_rec
structure is not 64-bit aligned the way it is on most regular ones.

Add explicit padding into the rdma_ucm_query_ib_service_resp and
rdma_ucm_resolve_ib_service structures that embed it, so that the layout
is compatible across all of them.

This is an ABI change on i386, aligning it with x86_64 and the other
64-bit architectures to avoid having to use a compat ioctl handler.

Fixes: 810f874eda8e ("RDMA/ucma: Support query resolved service records")
Link: https://patch.msgid.link/r/20251208133311.313977-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/rdma/rdma_user_cm.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/rdma/rdma_user_cm.h b/include/uapi/rdma/rdma_user_cm.h
index 5ded174687ee..838f8d460256 100644
--- a/include/uapi/rdma/rdma_user_cm.h
+++ b/include/uapi/rdma/rdma_user_cm.h
@@ -192,6 +192,7 @@ struct rdma_ucm_query_path_resp {
 
 struct rdma_ucm_query_ib_service_resp {
 	__u32 num_service_recs;
+	__u32 reserved;
 	struct ib_user_service_rec recs[];
 };
 
@@ -354,7 +355,7 @@ enum {
 
 #define RDMA_USER_CM_IB_SERVICE_NAME_SIZE 64
 struct rdma_ucm_ib_service {
-	__u64 service_id;
+	__aligned_u64 service_id;
 	__u8  service_name[RDMA_USER_CM_IB_SERVICE_NAME_SIZE];
 	__u32 flags;
 	__u32 reserved;
@@ -362,6 +363,7 @@ struct rdma_ucm_ib_service {
 
 struct rdma_ucm_resolve_ib_service {
 	__u32 id;
+	__u32 reserved;
 	struct rdma_ucm_ib_service ibs;
 };
 
-- 
2.51.0




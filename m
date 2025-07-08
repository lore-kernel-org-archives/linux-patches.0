Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E83A8F5E;
	Tue,  8 Jul 2025 16:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993384; cv=none; b=Jzhj7rtmqVkQtEa1hKCRP7aVO5mMZOYkxmSqCx5cN1e5Ff3BY5HHOhij8nHgIQFzAW5iYu/yPznkHDqCheLIY+se2BvX/guVRjR9vQDCtsi+mI3Ua8iGvQ6MgsVDJam8Zx/Unlz2PmnMzPg8lz9/rJPq3faFn6jwAPMxin4C11U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993384; c=relaxed/simple;
	bh=0AWgBvnSU1PYyRjtzl6g63vweO+4ro9ryGrqkw2SMh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NdxQ0aLShV8EA8vZ4KNUBGSc455PckRzSeVlfHzW/jyLX7onK/6DsC5j6tQrad/aFUyXBDHj39wQ0HLapffvd2phUbPFveDZPyDEHLAToFYm7UfM929MtwTSTAQu6MgWIKN9B4gPQBl4PUJbIVZAaHRLU68iEUS2kHZzIXgYnYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kKVDR9Jj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kKVDR9Jj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2E9C4CEED;
	Tue,  8 Jul 2025 16:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993384;
	bh=0AWgBvnSU1PYyRjtzl6g63vweO+4ro9ryGrqkw2SMh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kKVDR9JjY4ZSJRifwmut3yKmmifUaj3DH/Gpbqk2P6uU6tNBpKRfqJZFpgHTz+ROx
	 z2ypMexObiYSv0erBMLFyMnWQq3YmkYGvkiJJ7ICek1jamxoXDF5l69IXrgBXxsMNr
	 dI3+RMluRyzOiwJ8eHbXWqRedP8Jq8VlCRB0O6ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 056/178] RDMA/mlx5: Fix CC counters query for MPV
Date: Tue,  8 Jul 2025 18:21:33 +0200
Message-ID: <20250708162238.145321040@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit acd245b1e33fc4b9d0f2e3372021d632f7ee0652 ]

In case, CC counters are querying for the second port use the correct
core device for the query instead of always using the master core device.

Fixes: aac4492ef23a ("IB/mlx5: Update counter implementation for dual port RoCE")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://patch.msgid.link/9cace74dcf106116118bebfa9146d40d4166c6b0.1750064969.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/counters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/counters.c b/drivers/infiniband/hw/mlx5/counters.c
index 943e9eb2ad20d..a506fafd2b151 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -418,7 +418,7 @@ static int do_get_hw_stats(struct ib_device *ibdev,
 			 */
 			goto done;
 		}
-		ret = mlx5_lag_query_cong_counters(dev->mdev,
+		ret = mlx5_lag_query_cong_counters(mdev,
 						   stats->value +
 						   cnts->num_q_counters,
 						   cnts->num_cong_counters,
-- 
2.39.5




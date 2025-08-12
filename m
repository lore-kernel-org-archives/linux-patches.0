Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6B52C21D4;
	Tue, 12 Aug 2025 18:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024368; cv=none; b=B5oFp0n8ojCs3GruSGIBW9FqcADurZu1/zAWuMUIAWt5z2DXPwu8wajafZbQqJ936U8lrbru+60wiuj0O7PxBFtHkcJzUynsAuqQ4VHvK14GBVS/p7lMU/WJtLMIvoKczYGnMXAxtJf5UOUWPyn6dkTNiyJVvv6mByMgq7hk6ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024368; c=relaxed/simple;
	bh=9sxdf9FttpBhzLkIypetlAg+wstQpEN32w+biiEvzkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=neG2jULQWL9Y/31paDdINIOZgODg8NfUa3M1s2ZN34rPJ72CyDDngP3khmbXTSUFlpVBoR8fjTY2cZ2d999NvA2NUeCnh4b5zotyF7ACEFoPGKODhVpub2CQuPJjnMNHU/9v+6Ssmshu7Cx8mcgy2jv4B7s79Lwq+Mok0Shc1w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2SSUoqUK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2SSUoqUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68AAC4CEF0;
	Tue, 12 Aug 2025 18:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024368;
	bh=9sxdf9FttpBhzLkIypetlAg+wstQpEN32w+biiEvzkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2SSUoqUKsJIHCEQP94tQshZxpxAqNo9B3UkjQSc/wBLI0yBoARZOGwdRK3SxpBMtw
	 26fQYJLkzZknlHngkFcPIEuetxbqQ9WV4deB4WpG+h02RBcmJA8N6gXZS7XENIk3mu
	 PniYcvm7O2YHt+0Fd9yOc/48nT8HrB/5vTqVO3u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parav Pandit <parav@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 345/627] RDMA/uverbs: Check CAP_NET_RAW in user namespace for QP create
Date: Tue, 12 Aug 2025 19:30:40 +0200
Message-ID: <20250812173432.417207302@linuxfoundation.org>
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

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit 0498c2d9984ed2ad75b1cd5ba6abfa1226742df5 ]

Currently, the capability check is done in the default
init_user_ns user namespace. When a process runs in a
non default user namespace, such check fails. Due to this
when a process is running using Podman, it fails to create
the QP.

Since the RDMA device is a resource within a network namespace,
use the network namespace associated with the RDMA device to
determine its owning user namespace.

Fixes: 2dee0e545894 ("IB/uverbs: Enable QP creation with a given source QP number")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Link: https://patch.msgid.link/0e5920d1dfe836817bb07576b192da41b637130b.1750963874.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 6700c2c66167..4d96e4a678f3 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1451,7 +1451,7 @@ static int create_qp(struct uverbs_attr_bundle *attrs,
 	}
 
 	if (attr.create_flags & IB_QP_CREATE_SOURCE_QPN) {
-		if (!capable(CAP_NET_RAW)) {
+		if (!rdma_uattrs_has_raw_cap(attrs)) {
 			ret = -EPERM;
 			goto err_put;
 		}
-- 
2.39.5




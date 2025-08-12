Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E638294A17;
	Tue, 12 Aug 2025 18:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024404; cv=none; b=lFNpvauIHv+Sd08fZGLtAoJzgUvTC410asPfJoKGfBDqts5EEbbbzSEQQpRiaQaj2/B7jX9RN/hkewzLK7uTjDVDciQMo/9qPc3aHz50xTyJliC/Sx9rkGoLcvphExZzDKqmLPp8ujw38SKF3RmB48BQp6hjMWT4GItJOy7fkLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024404; c=relaxed/simple;
	bh=DFFejc6Dv+RjVxfVmnLYSOiQxVT8ebhp6npg9E8czw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyY9bEMdMBZOhzVe4YEPOlWUeTR+ieKOi9ixcpHnRuFzUrknZIBaUPpVwXF+Wsc3g2PmvT4pxL5iga0UkCxkdVX8aRRSeyDUfmqjZM3K0urwhrxzxjg4e2tLyS6nti8d3+gzsvrbJ6EZBx0eeZjM7nydjSjnqHE3lJ/TpzUE7pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUPTtjY+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUPTtjY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D231C4CEF0;
	Tue, 12 Aug 2025 18:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024403;
	bh=DFFejc6Dv+RjVxfVmnLYSOiQxVT8ebhp6npg9E8czw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oUPTtjY+CiHey9whvkFz51H1V9l7sOOtd7eGUR4NrFNPTEFFsfugvWA6ImXibCpf4
	 BYv/AUviftY4Y/vLdkFAKimjPsuoOwZIxUCMRE5Y3WkPllh0G1Artxh8ogglZ7xvVd
	 cA6BaEWU5QuF3I2+2C9Mk8uWkY1yoqSVX72sPXdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parav Pandit <parav@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 346/627] RDMA/uverbs: Check CAP_NET_RAW in user namespace for RAW QP create
Date: Tue, 12 Aug 2025 19:30:41 +0200
Message-ID: <20250812173432.453338289@linuxfoundation.org>
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

[ Upstream commit a6dca091ba7646ff5304af660c94fa51b6696476 ]

Currently, the capability check is done in the default
init_user_ns user namespace. When a process runs in a
non default user namespace, such check fails. Due to this
when a process is running using Podman, it fails to create
the QP.

Since the RDMA device is a resource within a network namespace,
use the network namespace associated with the RDMA device to
determine its owning user namespace.

Fixes: 6d1e7ba241e9 ("IB/uverbs: Introduce create/destroy QP commands over ioctl")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Link: https://patch.msgid.link/7b6b87505ccc28a1f7b4255af94d898d2df0fff5.1750963874.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_std_types_qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_std_types_qp.c b/drivers/infiniband/core/uverbs_std_types_qp.c
index 7b4773fa4bc0..be0730e8509e 100644
--- a/drivers/infiniband/core/uverbs_std_types_qp.c
+++ b/drivers/infiniband/core/uverbs_std_types_qp.c
@@ -133,7 +133,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
 		device = xrcd->device;
 		break;
 	case IB_UVERBS_QPT_RAW_PACKET:
-		if (!capable(CAP_NET_RAW))
+		if (!rdma_uattrs_has_raw_cap(attrs))
 			return -EPERM;
 		fallthrough;
 	case IB_UVERBS_QPT_RC:
-- 
2.39.5




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020962;
	b=v7UGhYnkgSEJHq2cyjb4cQv9QeBHpI4pIWE5h/X7zSoZwQBqfeGZFOyO3MQw97PrAhFg
	 ER22vBelOVul1uNxZi8LPCko38mn90mqmbIdbO9yZPy18UJZbH1cEfEHvDi8YD6L3dMl6
	 4eNBPePBLR/9d7J8UNNSaqUa26TIB191vBjqojsRpApxUWc1+hhlmHbE+c0qAlp9wLUou
	 cNBzlXUPUR15EPMnktLnpSQgdBZvaeiW+khNS20XEGp20etawjIttrRTnve5ZTWEsjJl8
	 vBCN5p0Q037pVhg3FoHdKxQXyE2nvVUqKGU8cRaSCaf1isXcL7VLulWV3VVKdq1uFAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MsWAHCBHcIi1idhrxwI7VLY5Yh+vh4a/WtE3aHjuJMo=;
	b=Ct/iJaPdsC2VrNBji6TqoaXaqtBUuGoya4tGfQE5195Ghucawo6FzQbTuymOWKhqpVZx
	 j8ucUtGvJXLSA2fuIkQ1n11pOIO4hgawpgTg3BnXwEPRNTif9NJiYKcEqYG46ksHH2zMx
	 SRXdaoNsL3/XFSGDSl9b4yvo9J9+xr+y9W86BXyfUVEs2IXt0wBoHfVJroc52CC03huRs
	 qAq9c5Jx0MVpEmibladBJT4MNmgmkzk2gc6XW2mbwznUHFq3Ge6nY1MuVXc1IxicXxZV6
	 qb+lrEDYrIwPyqf96BKE1DIKqknW3iBBlJU5hGwHaPTSlfgqnqAMUZGl+96kCXLSDYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dmSxIyfi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868DD606A31C;
	Wed, 18 Nov 2026 16:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dmSxIyfi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E033C1F000C4;
	Wed, 18 Nov 2026 16:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020962;
	bh=MsWAHCBHcIi1idhrxwI7VLY5Yh+vh4a/WtE3aHjuJMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dmSxIyfi8oFbxfmcRwxztE9Rxp1XzWO6G/UcGNyUrUldshseJoogUSNUM55uHm1WS
	 4NXomPUTL6xeyHbjBKfytycEG9ag01Wa4ak8K1WExYRKcDSloXY5eT9QXR9PoRhja4
	 lS2Y3uZLGcMGweli8wQar8XbdzLO4IvBvI5NfS4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2136/2651] RDMA/core: Free unpublished port statistics after initial-read failure
Date: Wed, 18 Nov 2026 15:56:16 +0100
Message-ID: <20261118150402.781303558@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit d74bdcfa89fa45d3a506cddc37b3bf1b76cea0ce ]

An initial port counter read can fail after allocating its statistics
buffer and wrapper. Free these both allocations.

Fixes: 467f432a521a ("RDMA/core: Split port and device counter sysfs attributes")
Link: https://patch.msgid.link/20261015-ib-core-fixes-v1-2-60f6da3ddec3@nvidia.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/sysfs.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 69df8b703cbd5..4cd861b5d953c 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -996,8 +996,8 @@ static int setup_hw_port_stats(struct ib_port *port,
 					    data->stats->num_counters);
 	if (ret != data->stats->num_counters) {
 		if (WARN_ON(ret >= 0))
-			return -EINVAL;
-		return ret;
+			ret = -EINVAL;
+		goto err_free_data;
 	}
 
 	data->stats->timestamp = jiffies;
@@ -1031,6 +1031,11 @@ static int setup_hw_port_stats(struct ib_port *port,
 
 	port->hw_stats_data = data;
 	return 0;
+
+err_free_data:
+	rdma_free_hw_stats_struct(data->stats);
+	kfree(data);
+	return ret;
 }
 
 struct rdma_hw_stats *ib_get_hw_stats_port(struct ib_device *ibdev,
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C407D83A17;
	Tue, 30 Jul 2024 17:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358983; cv=none; b=q8JWZ2SsUVqJUxElZMMLpmcHay9gheI3NtLBgu2oVNSLv3Nes7f331hytOx0VOQmuBha9HeSsiT6c1MhnaBtA9gsCvkuYiQjmmNaz+8xfPxH+Wl4d7Hxwh4mC3Cp2OxFnqobRuVdjesNNHV4hL2gL89glj9A8nIKAqJAOmQiyQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358983; c=relaxed/simple;
	bh=PlZ27Z+TM4b2gT4s264HIv6QoPH6uGdYhQofuRRhN6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lRGQiqSkTGZ7cRwzhkwsHE058JLKBZdVgP2dk5asL86jRrs/UG6rO53zike5Q0Lng9eAmloNaFVmuRWQePRJwcZNCEjzDhrVTf8DDikZVSLONLW8u9e9Y3fn3SHlf0stxQB64O5uURgu3vqohvh3F5dbiPkyq9EmZjzpCQORmjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jrw6wObu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jrw6wObu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33FE1C32782;
	Tue, 30 Jul 2024 17:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358983;
	bh=PlZ27Z+TM4b2gT4s264HIv6QoPH6uGdYhQofuRRhN6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jrw6wObu83zp2VuAkgoBEqrlS1O+SoktC8fQt0dpwPLfbCZreNO93ZkPOYqRGd+tA
	 iYbevgstm5vlWOids0srcUPmdCtzYsf4V0dhb+/81Dr3WXHcQY24Z9JVRqakirtJzb
	 NqvS2YPbFuXytC0Br1S+1bOxrlpTu6ntb1O5cxDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 439/440] nvme-pci: add missing condition check for existence of mapped data
Date: Tue, 30 Jul 2024 17:51:12 +0200
Message-ID: <20240730151632.919452327@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit c31fad1470389666ac7169fe43aa65bf5b7e2cfd ]

nvme_map_data() is called when request has physical segments, hence
the nvme_unmap_data() should have same condition to avoid dereference.

Fixes: 4aedb705437f ("nvme-pci: split metadata handling from nvme_map_data / nvme_unmap_data")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 42ef44cc7a852..27446fa847526 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -910,7 +910,8 @@ static blk_status_t nvme_prep_rq(struct nvme_dev *dev, struct request *req)
 	blk_mq_start_request(req);
 	return BLK_STS_OK;
 out_unmap_data:
-	nvme_unmap_data(dev, req);
+	if (blk_rq_nr_phys_segments(req))
+		nvme_unmap_data(dev, req);
 out_free_cmd:
 	nvme_cleanup_cmd(req);
 	return ret;
-- 
2.43.0




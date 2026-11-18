Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041427;
	b=c2WitacmDLdE6ySFLZfbSO/h9LRGOPxS3EemAghRjFE5eAfjXclwJkBNhdczdhdMkTTA
	 dKpQP/KJk27y6oByY/rwdPboSum+u5vINaRkzZ6GuQCd57ujsiLXFD53o6By3OltbDXsf
	 KswnClmzudcZTCNmh+eGpg8wQzRX0MKqnKatVvjoTZI/zmhTwBvK71C2csmpRg3i3Bzcv
	 wOGhktGdWbrVDdP2xMsqi7JrhOx30URp1BadktX2074x9SgiU+uiRVfWG7peGK5L1oR5/
	 ejvJeHTugEo3jZDonGUxHCeXDk2haKpV2GouUGkuMn1MTJpYMi9fAe1aWzBHh+58R5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041427;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=koXWCCSVx3f/Cl55qBPWiw6WVM6TTjNR7fHGFNnKSTc=;
	b=C8CUtPah0BX43k5JfbqfgqY8mL5H71VdXyd+5iyoM0/2mVHhuidSaHszdQXFYknGNblK
	 0FYQBNkgtn8PeIAMQggQlbhchIroA0wTuf4bOsAWzlx7OEP9Vby4Epxj6JBNwDKGV/dbb
	 BkFMTSYRZ1vgMGGoAX3dOSaoeJefnrzhC5utjrh9D/6bH0qSO/ULkYKQC8agLYpjQrsk/
	 kCw2wW/TMHPO3iHC4YjUo/z5VgxI8boZ5Hh1DpAhGIbyi3l0L8YZkPWg0FcI9uaqbvx9w
	 iNJ2w/MTcg+qNhiYkRUTfkHkFONhyvJjVwA/M+9msCf8eZP/t7dJH89uPe8BkcpSqMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gaePpHqD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDFC606A31C;
	Wed, 18 Nov 2026 22:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gaePpHqD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A1A1F000C4;
	Wed, 18 Nov 2026 22:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041427;
	bh=koXWCCSVx3f/Cl55qBPWiw6WVM6TTjNR7fHGFNnKSTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gaePpHqD9PMV8Dyh9pUaZhhVROk5eymiPHKoWZYT1D3NxgMCPShd1rDyMbh3HyPep
	 AtLqZpzLGF/DrZp+x7JAMVvfZ9rGbiMI1n0zhudF+PZg+3giuPNyxIIosm6CriSvKg
	 nN7cZOrRoWh8L9kesgBSr5G1X3ZvVYpOi9k5whXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2811/3318] nvme: tcp: split controller bringup handling
Date: Wed, 18 Nov 2026 15:57:13 +0100
Message-ID: <20261118150444.992868890@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 10fd7fb676d71482b64bc61f5058b1011133f984 ]

Drivers must call nvme_uninit_ctrl after a successful nvme_init_ctrl.
Split the allocation side out to make the error handling boundary easier
to navigate. The nvme tcp driver's error handling had different returns
in the error goto label's, which harm readability.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 87a1ac965502 ("nvme-tcp: store and use the caller's network namespace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index fd27e6a35bbcc..ad55b9e3e1050 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2670,7 +2670,7 @@ nvme_tcp_existing_controller(struct nvmf_ctrl_options *opts)
 	return found;
 }
 
-static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
+static struct nvme_tcp_ctrl *nvme_tcp_alloc_ctrl(struct device *dev,
 		struct nvmf_ctrl_options *opts)
 {
 	struct nvme_tcp_ctrl *ctrl;
@@ -2746,6 +2746,24 @@ static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
 	if (ret)
 		goto out_kfree_queues;
 
+	return ctrl;
+out_kfree_queues:
+	kfree(ctrl->queues);
+out_free_ctrl:
+	kfree(ctrl);
+	return ERR_PTR(ret);
+}
+
+static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
+		struct nvmf_ctrl_options *opts)
+{
+	struct nvme_tcp_ctrl *ctrl;
+	int ret;
+
+	ctrl = nvme_tcp_alloc_ctrl(dev, opts);
+	if (IS_ERR(ctrl))
+		return ERR_CAST(ctrl);
+
 	if (!nvme_change_ctrl_state(&ctrl->ctrl, NVME_CTRL_CONNECTING)) {
 		WARN_ON_ONCE(1);
 		ret = -EINTR;
@@ -2771,11 +2789,6 @@ static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
 	if (ret > 0)
 		ret = -EIO;
 	return ERR_PTR(ret);
-out_kfree_queues:
-	kfree(ctrl->queues);
-out_free_ctrl:
-	kfree(ctrl);
-	return ERR_PTR(ret);
 }
 
 static struct nvmf_transport_ops nvme_tcp_transport = {
-- 
2.53.0




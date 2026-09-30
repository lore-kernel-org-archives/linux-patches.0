Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6408046AA61;
	Wed, 30 Sep 2026 16:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784151; cv=none; b=eHE4DYLbLUGaiktuItfWcUQ40TvvW3JK66i2pRTeC7Dj4pUkYYLxLjCKjnQUHgLpgR2nxuV1S3BJhSXWKqmQG0Muhxf20ZRlGw1/CZSCDxdo3uggDsca8NVlQbE+VFZCusFMNMC1h4M48wACvTluZDsAuJ6ASUK3eJ0qjUpN3Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784151; c=relaxed/simple;
	bh=JPWQKLg4WCzdyRZJ2L67YBfnE1pchuVYgavTpJI1gRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2ZQobRQbbyMcNiloV4E+f27JGJ5JZGK0F6bRmuUtD1H1PXDFbRuxuMpKUATyjQd1Foo0o0DS9Uln2wV4jXzUPXIP1GYH98GTuA2XYKdsaCuX8atuzVTjLnIpCps3WKxOTeTVZvIVEfseA9gF+ogNaumNMVEEk0tP0Hzh410g+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dhTqBR98; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dhTqBR98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7C61F00893;
	Wed, 30 Sep 2026 16:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784145;
	bh=CqGZy/1Mjsl8uRLT1a7ft8cPdaXlqqiY2hzyZXRDUG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dhTqBR98nNMnvCm7x9WQmUrO3or+Svd5y7tZhqiMPbvARisWRhfzOeVgPz5GsTwV7
	 gpO8SyRbOw76c6HPyJKRZ0S43dGM/NtD73ykdCEK2rSy2ncSgDfFx2uChmN9ID/cOl
	 aua770eNJJ8/aROomzpbSy8W67u5EWMbN5DUxKaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/982] drm/amdkfd: Check bounds for allocate_sdma_queue restore_sdma_id
Date: Wed, 30 Sep 2026 17:13:07 +0200
Message-ID: <20260930152417.889088111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Francis <David.Francis@amd.com>

[ Upstream commit bfe9a7545b2a7be1c543f1741e16f2d5ec4116ae ]

allocate_sdma_queue has an option where the sdma queue id can be
specified (used by CRIU). We weren't bounds-checking that
value.

Confirm it's less than the maximum number of queues.

Signed-off-by: David Francis <David.Francis@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index 4e754e47bff36..89e3c37e6c56f 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1348,6 +1348,9 @@ static int allocate_sdma_queue(struct device_queue_manager *dqm,
 		}
 
 		if (restore_sdma_id) {
+			if (*restore_sdma_id >= get_num_sdma_queues(dqm))
+				return -EINVAL;
+
 			/* Re-use existing sdma_id */
 			if (!(dqm->sdma_bitmap & (1ULL << *restore_sdma_id))) {
 				pr_err("SDMA queue already in use\n");
@@ -1372,6 +1375,9 @@ static int allocate_sdma_queue(struct device_queue_manager *dqm,
 			return -ENOMEM;
 		}
 		if (restore_sdma_id) {
+			if (*restore_sdma_id >= get_num_xgmi_sdma_queues(dqm))
+				return -EINVAL;
+
 			/* Re-use existing sdma_id */
 			if (!(dqm->xgmi_sdma_bitmap & (1ULL << *restore_sdma_id))) {
 				pr_err("SDMA queue already in use\n");
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FC734A3AC;
	Tue, 16 Dec 2025 11:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885181; cv=none; b=Hlz7qyGOMCy9Kb3r5Fs4xxYLZntvv5np66lmTY6nRqbfS9O1Zi1jWLW8LmCvhw+DO5mpCNNpcXDStxkEu9YwYhlzF2nMRNlLTCNhrhUasgptVl4tgMYKv2CVueBHRPLd5Xxsa74PuG7S6ao3V8qXB4rggEk4oRpy5mYH/WWGL+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885181; c=relaxed/simple;
	bh=Yji7askEkZ6yG2DO14IFWtfvY3xE0YsnslMUWFpWm9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7tth8l+XDlsg4JwvY52hj4WYBQr3KTu8GFuWWGozM/AxAMYU2HSlLvex0/iefFryu7+PY2tzuwsjnCMBiTgUf0zejyWSQ5wg5cncI2bUaJPCWbPF3xLnADm6BiV1bUiBeiAPFTyIoYALcK7OjqvDpVgd6fDAJFIqULtubLMhXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RIe9yf5A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RIe9yf5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D661CC4CEF1;
	Tue, 16 Dec 2025 11:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885181;
	bh=Yji7askEkZ6yG2DO14IFWtfvY3xE0YsnslMUWFpWm9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RIe9yf5APgoOK8vuoQxLxcJsqaJnTXnY7jeKSUjFfVmaTDmI+YGavlh1/oUKcbPXj
	 bwpIuDO6MI34oZKru9O9QhlkKsrVMMj/vBdNG3WMlg5v6oCZo9nuEvLj7ThAaGHB6g
	 Xz2w6N6SBKVLWW1swscnEIZSmdY5UVky8EbZRCjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Wludzik, Jozef" <jozef.wludzik@intel.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 030/507] accel/ivpu: Fix race condition when mapping dmabuf
Date: Tue, 16 Dec 2025 12:07:51 +0100
Message-ID: <20251216111346.629617666@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wludzik, Jozef <jozef.wludzik@intel.com>

[ Upstream commit 63c7870fab67b2ab2bfe75e8b46f3c37b88c47a8 ]

Fix a race that can occur when multiple jobs submit the same dmabuf.
This could cause the sg_table to be mapped twice, leading to undefined
behavior.

Fixes: e0c0891cd63b ("accel/ivpu: Rework bind/unbind of imported buffers")
Signed-off-by: Wludzik, Jozef <jozef.wludzik@intel.com>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://lore.kernel.org/r/20251014071725.3047287-1-karol.wachowski@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_gem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/ivpu/ivpu_gem.c b/drivers/accel/ivpu/ivpu_gem.c
index 171e809575ad6..1fca969df19dc 100644
--- a/drivers/accel/ivpu/ivpu_gem.c
+++ b/drivers/accel/ivpu/ivpu_gem.c
@@ -45,12 +45,13 @@ static inline void ivpu_bo_unlock(struct ivpu_bo *bo)
 
 static struct sg_table *ivpu_bo_map_attachment(struct ivpu_device *vdev, struct ivpu_bo *bo)
 {
-	struct sg_table *sgt = bo->base.sgt;
+	struct sg_table *sgt;
 
 	drm_WARN_ON(&vdev->drm, !bo->base.base.import_attach);
 
 	ivpu_bo_lock(bo);
 
+	sgt = bo->base.sgt;
 	if (!sgt) {
 		sgt = dma_buf_map_attachment(bo->base.base.import_attach, DMA_BIDIRECTIONAL);
 		if (IS_ERR(sgt))
-- 
2.51.0




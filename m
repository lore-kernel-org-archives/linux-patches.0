Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547EF530E16;
	Thu, 17 Sep 2026 16:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661251; cv=none; b=noex855EuK6EQWtpfUbRZK/1w4uCNFYNXSbLRLRiRdAggUgDG1Lqu8cklbJa6eftSllGps5/+Y01hKSf4nSeM8uctbRdeQCpmwONZiHj4f6L3TInVcMQNJ1RqUSUaBxzqKNwjpyE1gvNejiSFFb9Cc8defmgjQ8pL3CzZxavbKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661251; c=relaxed/simple;
	bh=mbRdVgox2yJiK8GjkOcK0MQ3UvLMyZ3lRccqpkkHUDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B36Z5s68SfNJaLKAZS221c93apQ4XHLDSz8ifdWTHKI3hXiMxihFpPD4X1Dbadz0T9IQZsFOBaIMDaMHkC/KGE0XHLlb5Tx+kqt/gEVpsX0EP78JeZbkqabGT0kLFUKQoKx374n8HmAHFT+4L51EXj+sMzKhVJ/SntzMp2Xk5Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bjqjtaiU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bjqjtaiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF451F000FF;
	Thu, 17 Sep 2026 16:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661250;
	bh=N/7v7U/FIPuWOFhbg3+QLfh2+l/Yhkq6rzxQEyMpMTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bjqjtaiUbqiL4c7fziIOXC/ctC9MeE9799OB2HKsQSG7/VByGhp+VbVmC4xVesGH5
	 kDPMx1g4YNqOOrNPrHmobihMX8q1kY/6ijKN5bTnR0031AmYakBnCKeb9Q/iFO/9AT
	 /5Rg9vrTCB0uRwmitEuJIWPyuV8p9nRiKyAZairw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0134/1250] drm/amdkfd: Check bounds for allocate_sdma_queue restore_sdma_id
Date: Thu, 17 Sep 2026 15:58:49 +0100
Message-ID: <20260917151555.677588819@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 58266542cea08..7a752cff6c34a 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1599,6 +1599,9 @@ static int allocate_sdma_queue(struct device_queue_manager *dqm,
 		}
 
 		if (restore_sdma_id) {
+			if (*restore_sdma_id >= get_num_sdma_queues(dqm))
+				return -EINVAL;
+
 			/* Re-use existing sdma_id */
 			if (!test_bit(*restore_sdma_id, dqm->sdma_bitmap)) {
 				dev_err(dev, "SDMA queue already in use\n");
@@ -1625,6 +1628,9 @@ static int allocate_sdma_queue(struct device_queue_manager *dqm,
 			return -ENOMEM;
 		}
 		if (restore_sdma_id) {
+			if (*restore_sdma_id >= get_num_xgmi_sdma_queues(dqm))
+				return -EINVAL;
+
 			/* Re-use existing sdma_id */
 			if (!test_bit(*restore_sdma_id, dqm->xgmi_sdma_bitmap)) {
 				dev_err(dev, "SDMA queue already in use\n");
-- 
2.53.0




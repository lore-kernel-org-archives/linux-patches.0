Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A655AA695;
	Thu, 17 Sep 2026 16:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661257; cv=none; b=KWI4X/0m16TvtuHRjzmU0JmQDLpckbz+oXu2VlpvKS49vSMLjzKe/Ck6mWezBbk4anfXf4WkoLUtgQFZamG9IdwKsIq18CHASnc6n4X2guatK/Ueks3/MUUSkXc2Zx3uiNifkM3NeC63iZ/p6487NLIDuA+SiP9NPDLkqKmfzHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661257; c=relaxed/simple;
	bh=bWDSPiMDKiqhsJ9qXxpfQpIMQXnx6dd4wTZExW18U0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/e34mq9xZ/Le9vPkxTeVmu/VRfxlbBxRsNZDB+XzgJpI6u56YGHeNBfErR/PIXFN0UUr6HuMvHjbJDKYe5QgMxeQnSJ/pZ/KfgD2lz96M2FB/wX9wLFI3XxHwPpy/r+7l5+dfLxbaO8gvft2JIBLo8fGImvp0gqB6YOygPQ6GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wjx+nXY4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wjx+nXY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907EE1F000FF;
	Thu, 17 Sep 2026 16:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661256;
	bh=F+peQKnnRl1V9qZ+QOHB5BwChfJ8+i7VOguw8eGPEo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wjx+nXY4jpaeXO5HrRb7B828sxVhlTopMfCYqoximgYD22v4T9tfTolvbY5tkDxo5
	 3waE8R7mJIH3+aC5PyOETSgYt5cuCvSSyTlsTqp2WDDJ89sUE1yN1L4XNPj3wf7f11
	 BVU/uis2BOeoS82+YYxtGzFvpwkLrijhMRuayJFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0136/1250] drm/amdkfd: Check bounds on allocate_doorbell
Date: Thu, 17 Sep 2026 15:58:51 +0100
Message-ID: <20260917151555.733414565@linuxfoundation.org>
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

[ Upstream commit 1f087bb8cf9e8797633da35c85435e557ef74d06 ]

allocated_doorbell has an option to set the doorbell id
to a specific value (used by CRIU). This value was not
bounds checked.

Check to confirm it's less than KFD_MAX_NUM_OF_QUEUES_PER_PROCESS.

Signed-off-by: David Francis <David.Francis@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index 7a752cff6c34a..4de6bc59569a4 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -472,6 +472,9 @@ static int allocate_doorbell(struct qcm_process_device *qpd,
 	} else {
 		/* For CP queues on SOC15 */
 		if (restore_id) {
+			if (*restore_id >= KFD_MAX_NUM_OF_QUEUES_PER_PROCESS)
+				return -EINVAL;
+
 			/* make sure that ID is free  */
 			if (__test_and_set_bit(*restore_id, qpd->doorbell_bitmap))
 				return -EINVAL;
-- 
2.53.0




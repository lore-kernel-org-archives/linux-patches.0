Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC0130BF70;
	Wed, 30 Sep 2026 16:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784152; cv=none; b=L5FuSQJEwI4pq9azRSIMX4UjnFUjoMHOXABSfq9FWaCrG+FAYKgYV3up/laa2SdeAblhw78GrZroDXxPI0NloHvnWp3qEFlzPBMPABPa1Aj+bo8NwcvcB4bBYBbAjPtLl06Qqv4bApVKU4k34PKgkUYA+WtyraxixlWDcN+05cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784152; c=relaxed/simple;
	bh=Dd+gfFYMi+olYy5IMMPnvJaQTxmIWy13Sh4kYjBYGVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PcuSAxlxubT4POoq/IjrPf/yChLwom8IrGEjU5plItumeIadkTkIVCbFnMBWMKkhXcQ9JW2Anmdplkh5Ub0RHjVdzqBZX2yhPL84uUC0lpaVSoHPVFxWbEfquqrx6NEQE+IWB4XSutarpaiiMlf4SbNrDyIRdsXUD7TjAhNeT3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ii649ps6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ii649ps6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516B31F00899;
	Wed, 30 Sep 2026 16:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784147;
	bh=FoRuNpxgR2vt6iSgdeWvg3kBpP74bqLX9YsPAqF03Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ii649ps68LjW5UT9Zvrf9MRrzRygzuOoA2IEuHVQZ9a+DKhxcYBn0yjUiKdYPCzbj
	 xw9Sv310loy14p6JdKpfD4iHqc+/TQl7juHHfj6kMaw1t9fyu+GJ24p0fn/ioxIo1T
	 pEB2NWq4so54F1JZ1GmehvZ9W80U/KxLzoDHJBzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/982] drm/amdkfd: Check bounds on allocate_doorbell
Date: Wed, 30 Sep 2026 17:13:08 +0200
Message-ID: <20260930152417.910840782@linuxfoundation.org>
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
index 89e3c37e6c56f..689abc3d3a395 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -361,6 +361,9 @@ static int allocate_doorbell(struct qcm_process_device *qpd,
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




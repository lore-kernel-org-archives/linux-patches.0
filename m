Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205B13B6364;
	Thu, 17 Sep 2026 17:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667446; cv=none; b=kpZzZKRUI2aM/02av37not1OIweCq5H3daol4j6Aegrf1tNimtuL+oCsNupyQZQn2/wuPN4G6+tgVMSKEqEgaV9oErJ5HH65uEGIiVSJj69L43WD2r1iRsextJh2rUqplka7mgvNUGh8LHTM9D08Pif8I6irgO01C55ymvd+6W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667446; c=relaxed/simple;
	bh=zFBWfyW6GMbh7kqjREv8mz8YP+l+J7c8n0Akd7dzAfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbDcP6o+HINS9I63B5D0eRT/tBgRkz8Wton5Ytt/E5eWpPyKqDtWy0pPQ6efqWSiCwqyKVCdSb+htiUL2PLqCBofMvuh2qq25BnLKSSz4fpuujUdGOKzTDKbxLFae67Z5vn10SKL/5cI4du95eOUq0mg1dAmBuKzWY5JqiqVkBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VL5ekNLt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VL5ekNLt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3331F000FF;
	Thu, 17 Sep 2026 17:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667444;
	bh=hE1NcAhNJe15FfukZik7/BIgMzkHp3dSTop0P6NI9ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VL5ekNLtMFI5GK3eA3oADBjIMN/CvJUvIi06+ECc4+dQTCLTh4Ec5yf0rPAJr3Lm3
	 RXnL66e9OX2oCDvZOMy+Zk+N86OUYQktxYrEwZKjeCOVpgbYSjy/RYqmA0THkrFHYg
	 4JnPFxHgVSBjHbALjtH0DQikjBIjSAXYnDESj0rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0096/1102] drm/amdkfd: Check bounds on allocate_doorbell
Date: Thu, 17 Sep 2026 16:00:39 +0100
Message-ID: <20260917151541.903208437@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 775c86f0badd8..96e05078c524d 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -437,6 +437,9 @@ static int allocate_doorbell(struct qcm_process_device *qpd,
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




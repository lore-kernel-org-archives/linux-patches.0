Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5E358E2B4;
	Wed,  9 Sep 2026 14:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964376; cv=none; b=rZZeAUgI4EAPwGbroW3cs/55WfBSKp8bbx8OStuIKTU95nzow0mGJtOIZbRFkNJyVTYBfu7QBb4uDYJOUqWCS/xw4rE8n8X8wPnilsn4clhB7w2/ZPa/q8SIff3Jb4z07kuFZlCvv1SStUojCb1It8SHtXo6yzte5vqK9AJIq1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964376; c=relaxed/simple;
	bh=RKv4AbXtGZeOg1g6W082ayRl93Ie/zdvBOyFLfQVezM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZDfR7KftJrEBOulMIKfiDPqVAmYyawB9KFZYwtfbKOt1dIxm8CzMG+3yghyFvSbAX47/OkubOTtQ5CHFtjE17QdklUOTn3MGSDSrIGJszSAd+X5Z5ZJ0Ypm8gGWZYGB6Ehzh5rg4oRuZH2CjoW9UK+tZo6BX66HqCEaScV6Dw4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1lCLgvKH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1lCLgvKH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81F01F00A3A;
	Wed,  9 Sep 2026 14:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964375;
	bh=1VlQj14QmRIM8ADpjGAf0oXk33zZ1PZ1IsP7ipt9NFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1lCLgvKHMCECbiB6WfqlHtkA07QgJESCsonQw2cfMFa/WlKaJD15W4k6H3Hxctw1Q
	 7jT2WI3vp/nBwOV1q3SbT5tMWR4NVJ8hvHMDY+KM9HTK3ZPXv/Srmsmlhj9QUtpxIe
	 hmk/3AbtaR227DdPqfG0onWK6i8jN1eri7C0g/7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Marioukhine <Vladimir.Marioukhine@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 402/583] drm/amdkfd: guard against NULL restore_mqd in CRIU queue restore
Date: Wed,  9 Sep 2026 15:41:27 +0200
Message-ID: <20260909134251.931575754@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Marioukhine <Vladimir.Marioukhine@amd.com>

commit 6aa530642f95d5c48aa336416f94a35e7949b647 upstream.

Both create_queue_cpsch() and create_queue_nocpsch() unconditionally
call mqd_mgr->restore_mqd() when a CRIU restore is in progress
(qd != NULL), with no NULL guard. On any system where restore_mqd is
not implemented for the given queue type, a user holding
CAP_CHECKPOINT_RESTORE can trigger a kernel NULL pointer dereference
and panic the machine by issuing KFD_IOC_CRIU_OP_RESTORE with a
crafted queue restore object. Note that checkpoint_mqd is likewise
unimplemented on GFX12, so no legitimate CRIU image can reach this
path — only a hand-crafted restore payload.

Add a NULL guard for restore_mqd immediately after mqd_mgr is
resolved, unwinding via the existing error labels and returning
-EOPNOTSUPP if the callback is not implemented. This mirrors the
existing checkpoint_mqd guard in checkpoint_mqd().

Fixes: 48f0bdf4e38e ("drm/amdkfd: Added MQD manager files for GFX12.")
Cc: stable@vger.kernel.org
Signed-off-by: Vladimir Marioukhine <Vladimir.Marioukhine@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -653,6 +653,11 @@ static int create_queue_nocpsch(struct d
 
 	mqd_mgr = dqm->mqd_mgrs[get_mqd_type_from_queue_type(
 			q->properties.type)];
+	if (qd && !mqd_mgr->restore_mqd) {
+		pr_debug("restore_mqd not implemented for this GPU\n");
+		retval = -EOPNOTSUPP;
+		goto deallocate_vmid;
+	}
 	if (q->properties.type == KFD_QUEUE_TYPE_COMPUTE) {
 		retval = allocate_hqd(dqm, q);
 		if (retval)
@@ -2002,6 +2007,11 @@ static int create_queue_cpsch(struct dev
 
 	mqd_mgr = dqm->mqd_mgrs[get_mqd_type_from_queue_type(
 			q->properties.type)];
+	if (qd && !mqd_mgr->restore_mqd) {
+		pr_debug("restore_mqd not implemented for this GPU\n");
+		retval = -EOPNOTSUPP;
+		goto out_deallocate_doorbell;
+	}
 
 	if (q->properties.type == KFD_QUEUE_TYPE_SDMA ||
 		q->properties.type == KFD_QUEUE_TYPE_SDMA_XGMI)



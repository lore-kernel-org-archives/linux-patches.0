Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AEED3D9DC0;
	Sat, 12 Sep 2026 11:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214208; cv=none; b=a/cRHvCjLhF2R8eGqDn2s1ubrAa7dZb3mqvhOW1QuCgRDIAmI3vUPJxL5+xtw7Gt7If8FYBGit1hJtKvGF1PbgxvtzVChQ7MxMK8Xy/oAw9XEMmWkJHFmzc0I9mtsNXyd3ylIlNv5MLUtNvm8cFOOuZ+xWZm4LGlpXk5fn210X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214208; c=relaxed/simple;
	bh=OyIm6Kc/cIZrgfq88mTZ8slHmKFSKuUGFddXpg4YtwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r2/IlHDpccHpVF9E2DfW/uLYF8INFwl2C43HFPR5mORl78AmcQqMKywauEjKePkXf/GfV/xL0qDZ5JAgQx6VKtr4XGZ78L4IE8NAQjDnI/7G6E1Vf6p22WQYB1zKx8LRR7pUVX4BQyiVD6rge8deowCFknln1DFb4qEf7ErrIoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nttrc68Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nttrc68Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76081F00893;
	Sat, 12 Sep 2026 11:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214206;
	bh=+KXdiI73XsEDnP4tHxUNTkFap7hQOyNqRr2vOlX9mJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nttrc68YL7FtX2eC+EgzHF0UvgUUrJ3HdjglsjPbSjerAiKG0/mDMN+TCORXXkOsJ
	 DHFpK+8DDnLgYxBFpmhP1f1G/YMJaIm/whLq8sgExaqFvIzG7tayHmjyrY6nKtWBPX
	 CoyKdLUSVenXwaG1qBtVCEzNaV9dqs0zhVEU8nt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Marioukhine <Vladimir.Marioukhine@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 0279/1376] drm/amdkfd: guard against NULL restore_mqd in CRIU queue restore
Date: Sat, 12 Sep 2026 08:45:05 +0200
Message-ID: <20260912065613.764926899@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -617,6 +617,11 @@ static int create_queue_nocpsch(struct d
 
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
@@ -1967,6 +1972,11 @@ static int create_queue_cpsch(struct dev
 
 	mqd_mgr = dqm->mqd_mgrs[get_mqd_type_from_queue_type(
 			q->properties.type)];
+	if (qd && !mqd_mgr->restore_mqd) {
+		pr_debug("restore_mqd not implemented for this GPU\n");
+		retval = -EOPNOTSUPP;
+		goto out_deallocate_doorbell;
+	}
 
 	if (q->properties.type == KFD_QUEUE_TYPE_SDMA ||
 		q->properties.type == KFD_QUEUE_TYPE_SDMA_XGMI)



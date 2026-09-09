Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520FD569F31;
	Wed,  9 Sep 2026 14:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963147; cv=none; b=KK1zXGbqVgADS42J91fLYW+rLMbm/OCe40dN+7ZsfYPo8xoIB1IRbK1kLI9KAprAZqkrQa0jXzrn2Yl0cqcFEtXDlW5R1XKSZPidztT9fbUhZJ/aJXOehTiEo9KhPdQ3gYZejdRD5zhnh3dkNrsuOJk9TArKSAX0sve3+ULJOS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963147; c=relaxed/simple;
	bh=wsqV7ZSbeqNi/BENNUinss8fqCGs8fa5PzRW9v2i6RE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tzfnr0fMBum8Zz2pqdxX+v7MhzU7d63M7FoW1b4T5LLJHHB4zrYK2kUXJdu9o28DKYkVbanQsotMgbqjJC2TwtjtXz3JZrXnpehwdYQMxtLUPtQbPRqJ1dX89dIIU6jPc1aiu4h7Rab2rhBaH6/eZgm91vCOKcv6LCLfd/PnSiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ZA3Vsx1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ZA3Vsx1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B561F00A3A;
	Wed,  9 Sep 2026 14:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963146;
	bh=VuPqHGwEVZ+TXw7DpcVqqsD4pv6B0GTqJBHyN5upz1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ZA3Vsx1pwrchnqzw11aIoUkZJxiJoZZd5YEjHf1m2Chdxp8UH4e2IqIHrNI+kyXo
	 cLHcvURAF8yCvIsWJZdn0JkWRCkHHZY6a/HqNKB4I8OhfD5FbD/0+AnZNIfYSzj78w
	 XzPU0EYKZWP7b3bp/r2T8zhGmCfvvKiC5BPSrmoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Marioukhine <Vladimir.Marioukhine@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 518/556] drm/amdkfd: guard against NULL restore_mqd in CRIU queue restore
Date: Wed,  9 Sep 2026 15:43:18 +0200
Message-ID: <20260909134248.649221594@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -796,6 +796,11 @@ static int create_queue_nocpsch(struct d
 
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
@@ -2162,6 +2167,11 @@ static int create_queue_cpsch(struct dev
 
 	mqd_mgr = dqm->mqd_mgrs[get_mqd_type_from_queue_type(
 			q->properties.type)];
+	if (qd && !mqd_mgr->restore_mqd) {
+		pr_debug("restore_mqd not implemented for this GPU\n");
+		retval = -EOPNOTSUPP;
+		goto out_deallocate_doorbell;
+	}
 
 	if (q->properties.type == KFD_QUEUE_TYPE_SDMA ||
 		q->properties.type == KFD_QUEUE_TYPE_SDMA_XGMI)



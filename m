Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833242EA46B;
	Fri, 21 Nov 2025 13:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731474; cv=none; b=WFvJr/rfJpQf+zG0to8OMjGlWqWH18I4+veUZHC70vbCiJ0ue7QyLGt0vov0lpgD7WopAObktfiJEA9itHfXbjPNHUtHbe2A/VEI8qpBcNOmQ1GZDDd+VGjUgemh0aUjDN1m/Vjcorwwrw+ayq3sPBYkoylFz95npWgkveJs51I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731474; c=relaxed/simple;
	bh=3O3TFnNK2GXFSaPrFR8voJdYwwRdpOg2c2EZFD5J5sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZihbytyz2n15HR+VRZY1WWXrMDKwO+mc3ohoO1WVrriyD4xu9aekPhWjlN4Zp2KB3Z7DEPrD68StXY6ushIsTT5ef9eJWig6nUgDzi0mdnTh+nhyVkUNHCZP1Uf3iK++Bc7bT3ZKOFK9JelXFaRdIW8NVNI8jrVqCgsFKL4YRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AmYWsM7c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AmYWsM7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30C6C116C6;
	Fri, 21 Nov 2025 13:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731474;
	bh=3O3TFnNK2GXFSaPrFR8voJdYwwRdpOg2c2EZFD5J5sI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AmYWsM7cL1pylHVwji1GVVyRTlP6u/WWPpV6zWtCacQg2n4We2KStVqflUXpGW2lG
	 DVuLfg6mFMsF6Y8MsFn+V2hhJEeKYqmB4B3hCkeu6KDnvvM8lADLKd6H76HMh02rpo
	 b6hkKXJTjsfbmvmy3S+LQB1mWezsmnMBwrTgPPA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Kim <jonathan.kim@amd.com>,
	Philip Yang <philip.yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.17 219/247] drm/amdkfd: relax checks for over allocation of save area
Date: Fri, 21 Nov 2025 14:12:46 +0100
Message-ID: <20251121130202.594149928@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

From: Jonathan Kim <jonathan.kim@amd.com>

commit d15deafab5d722afb9e2f83c5edcdef9d9d98bd1 upstream.

Over allocation of save area is not fatal, only under allocation is.
ROCm has various components that independently claim authority over save
area size.

Unless KFD decides to claim single authority, relax size checks.

Signed-off-by: Jonathan Kim <jonathan.kim@amd.com>
Reviewed-by: Philip Yang <philip.yang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 15bd4958fe38e763bc17b607ba55155254a01f55)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_queue.c
@@ -297,16 +297,16 @@ int kfd_queue_acquire_buffers(struct kfd
 		goto out_err_unreserve;
 	}
 
-	if (properties->ctx_save_restore_area_size != topo_dev->node_props.cwsr_size) {
-		pr_debug("queue cwsr size 0x%x not equal to node cwsr size 0x%x\n",
+	if (properties->ctx_save_restore_area_size < topo_dev->node_props.cwsr_size) {
+		pr_debug("queue cwsr size 0x%x not sufficient for node cwsr size 0x%x\n",
 			properties->ctx_save_restore_area_size,
 			topo_dev->node_props.cwsr_size);
 		err = -EINVAL;
 		goto out_err_unreserve;
 	}
 
-	total_cwsr_size = (topo_dev->node_props.cwsr_size + topo_dev->node_props.debug_memory_size)
-			  * NUM_XCC(pdd->dev->xcc_mask);
+	total_cwsr_size = (properties->ctx_save_restore_area_size +
+			   topo_dev->node_props.debug_memory_size) * NUM_XCC(pdd->dev->xcc_mask);
 	total_cwsr_size = ALIGN(total_cwsr_size, PAGE_SIZE);
 
 	err = kfd_queue_buffer_get(vm, (void *)properties->ctx_save_restore_area_address,
@@ -352,8 +352,8 @@ int kfd_queue_release_buffers(struct kfd
 	topo_dev = kfd_topology_device_by_id(pdd->dev->id);
 	if (!topo_dev)
 		return -EINVAL;
-	total_cwsr_size = (topo_dev->node_props.cwsr_size + topo_dev->node_props.debug_memory_size)
-			  * NUM_XCC(pdd->dev->xcc_mask);
+	total_cwsr_size = (properties->ctx_save_restore_area_size +
+			   topo_dev->node_props.debug_memory_size) * NUM_XCC(pdd->dev->xcc_mask);
 	total_cwsr_size = ALIGN(total_cwsr_size, PAGE_SIZE);
 
 	kfd_queue_buffer_svm_put(pdd, properties->ctx_save_restore_area_address, total_cwsr_size);



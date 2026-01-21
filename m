Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9351DED5C;
	Wed, 21 Jan 2026 18:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020423; cv=none; b=dTbhZVdGH/BdDjnY4b7izWIKN2WRr7kR2arCrpkKVqZ2tQVc/rHTmp46Z6hHCPekxsRMM6KxjvX019nsA0rtoq/0Bkmw3hemg9yfnmh4E2mmicy433ecxNSGXfxETjGRnMMG7BFCpU5YTtU57GaTzLu0mc1wy86DGcJjhFf8yZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020423; c=relaxed/simple;
	bh=v1uqy2RshDvcAjmITisrgkrtrRfhY/qmikh2c1eqin0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PT1vNHPOPu/eP/Ly/H+E+bnZ6Mqcyc9GHzP69Zhty0sekUlyRDWRG3hKucoCiq4avtwoMVSXvKs/yh95IOSjp4OArywVLQ9HKVm/VGBqKvc7vHQn044UeVOFJxfVhztgRYM1HkQnU+BdhBJEbmICpqUvUaxbkUFBvIRa8M3LBU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VAFdrs6Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VAFdrs6Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94834C4CEF1;
	Wed, 21 Jan 2026 18:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020423;
	bh=v1uqy2RshDvcAjmITisrgkrtrRfhY/qmikh2c1eqin0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VAFdrs6YxVY0vBobe64SbmTybgLnqHgkyf8tb50LCYlY2+1ckbzMOORvxQhfHXI25
	 9zmo7IhLosiEuSq3kaN+fIJbwHhhhzrGF47+HCb5bBmlKeAaNdj7dwpKyBDnal5d4Y
	 TlFIrXwEUS1awq4ePjz+iAZWvxja8ZocYFB16nJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Oak Zeng <Oak.Zeng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 154/198] drm/amdkfd: fix a memory leak in device_queue_manager_init()
Date: Wed, 21 Jan 2026 19:16:22 +0100
Message-ID: <20260121181424.096412341@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit 80614c509810fc051312d1a7ccac8d0012d6b8d0 upstream.

If dqm->ops.initialize() fails, add deallocate_hiq_sdma_mqd()
to release the memory allocated by allocate_hiq_sdma_mqd().
Move deallocate_hiq_sdma_mqd() up to ensure proper function
visibility at the point of use.

Fixes: 11614c36bc8f ("drm/amdkfd: Allocate MQD trunk for HIQ and SDMA")
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Signed-off-by: Felix Kuehling <felix.kuehling@amd.com>
Reviewed-by: Oak Zeng <Oak.Zeng@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b7cccc8286bb9919a0952c812872da1dcfe9d390)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c |   19 ++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -2905,6 +2905,14 @@ static int allocate_hiq_sdma_mqd(struct
 	return retval;
 }
 
+static void deallocate_hiq_sdma_mqd(struct kfd_node *dev,
+				    struct kfd_mem_obj *mqd)
+{
+	WARN(!mqd, "No hiq sdma mqd trunk to free");
+
+	amdgpu_amdkfd_free_gtt_mem(dev->adev, &mqd->gtt_mem);
+}
+
 struct device_queue_manager *device_queue_manager_init(struct kfd_node *dev)
 {
 	struct device_queue_manager *dqm;
@@ -3028,19 +3036,14 @@ struct device_queue_manager *device_queu
 		return dqm;
 	}
 
+	if (!dev->kfd->shared_resources.enable_mes)
+		deallocate_hiq_sdma_mqd(dev, &dqm->hiq_sdma_mqd);
+
 out_free:
 	kfree(dqm);
 	return NULL;
 }
 
-static void deallocate_hiq_sdma_mqd(struct kfd_node *dev,
-				    struct kfd_mem_obj *mqd)
-{
-	WARN(!mqd, "No hiq sdma mqd trunk to free");
-
-	amdgpu_amdkfd_free_gtt_mem(dev->adev, &mqd->gtt_mem);
-}
-
 void device_queue_manager_uninit(struct device_queue_manager *dqm)
 {
 	dqm->ops.stop(dqm);



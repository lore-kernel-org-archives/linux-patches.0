Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFA528853A;
	Wed,  4 Feb 2026 15:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217332; cv=none; b=f+16puQCTu6VukDe22nl5xqlXXEzfVt0+t1bZpPNRzMBm7SkxrJIorJZfPwFa4S+uTZ3M9VF9PxJhWbHm82jDEu9qiYsXl69A+i7m0UiZw9fNs68xpT8LpvGj1sqFWZpG9Kie0ikDjQEZZEXnf+ZvOwcfJntHsl6V+nWpN+NiZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217332; c=relaxed/simple;
	bh=RWobgHbIUFQjkVC/aP7rowwVC5TIgWGqHxhsGL6JU8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nC98DeHki8+clDl0UdFsiUDpKrRSdixANfq+MY3K2utoUWI6Za0A0bDfV7LpUXmBE18yqmbWr0/yJWRUnwgD4uUFrytbDzsR3QDO80nId3v54i9+keHy3YWiqrIzptC4CNXzi/zQcd2RP7Ht/tNGJP8vMjIX9PZUF9zlHVlurqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBypYqun; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBypYqun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F33C4CEF7;
	Wed,  4 Feb 2026 15:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217332;
	bh=RWobgHbIUFQjkVC/aP7rowwVC5TIgWGqHxhsGL6JU8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBypYqun8v9/xfj6EWX4XRX/HjfLLL1f4MdfM5+2OJFO0cK2TLzV+2DLPgOFFBMB8
	 +KjMX5ld19B3aiOWForSOKFBrqzCgE3r50IijoTOAcoFAHToLtswnFX4HZsc1nUgnB
	 VXDfSxRD6VukSMJt6ZA4Eq7xncz4C2XUzBuZhHP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Oak Zeng <Oak.Zeng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 192/206] drm/amdkfd: fix a memory leak in device_queue_manager_init()
Date: Wed,  4 Feb 2026 15:40:23 +0100
Message-ID: <20260204143905.139247881@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1847,6 +1847,14 @@ static int allocate_hiq_sdma_mqd(struct
 	return retval;
 }
 
+static void deallocate_hiq_sdma_mqd(struct kfd_dev *dev,
+				    struct kfd_mem_obj *mqd)
+{
+	WARN(!mqd, "No hiq sdma mqd trunk to free");
+
+	amdgpu_amdkfd_free_gtt_mem(dev->kgd, &mqd->gtt_mem);
+}
+
 struct device_queue_manager *device_queue_manager_init(struct kfd_dev *dev)
 {
 	struct device_queue_manager *dqm;
@@ -1980,19 +1988,13 @@ struct device_queue_manager *device_queu
 	if (!dqm->ops.initialize(dqm))
 		return dqm;
 
+	deallocate_hiq_sdma_mqd(dev, &dqm->hiq_sdma_mqd);
+
 out_free:
 	kfree(dqm);
 	return NULL;
 }
 
-static void deallocate_hiq_sdma_mqd(struct kfd_dev *dev,
-				    struct kfd_mem_obj *mqd)
-{
-	WARN(!mqd, "No hiq sdma mqd trunk to free");
-
-	amdgpu_amdkfd_free_gtt_mem(dev->kgd, mqd->gtt_mem);
-}
-
 void device_queue_manager_uninit(struct device_queue_manager *dqm)
 {
 	dqm->ops.uninitialize(dqm);



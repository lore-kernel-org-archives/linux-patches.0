Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61121357D09;
	Wed, 30 Sep 2026 18:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794320; cv=none; b=O0hnfRL42PEpmIagU+1bpCDcVYb9t1kG06KCShRhtVMfeGcV4Msb1s8sLniglVjPeDUTMfbK0Fbs17LoI2ffiafv3T+2iHci82y76Y9Jb7j6V+Mrrja7kvgBXI8Q2B5cMcGzA4Vk/bMxzcbVUdrEQ0yrPN0/S8PETyNzJIGKJc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794320; c=relaxed/simple;
	bh=jTpNu92f2q+Or2Zcks2QtBlh06XJ64VGRwhBkLvC+fI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhGHD0EZ+1Dgbj42W3shwh6Buc0PAyfC7N8GaTt+dde3YQax5Pb5GTcg/MmdKnrtdBK3rZQcM7Bfe9E3zpd9svY1tNlumDaPxL2S2Qpde6O6u4IllyIGYlpwRHXtKdske9Q6jn+Vk7DKSAsAu19mNYqdE/8A7rn3wFpcQStwdsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKZXZI3i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKZXZI3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2A21F000FF;
	Wed, 30 Sep 2026 18:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794319;
	bh=Br0ggGOsVeb3VS74ZQWLYmwb5Q9wO8W605/XafKWsyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UKZXZI3iqmTjyF6x8Wgm80NWZmPeMyhYOAh0ePhje5K8scuFjDyIm7cKiu+edyek2
	 vWTkmgGjq8OAeZsb84ZkWlv31mZCaHaWzZGjvLvV3CRfkTMqKIzvkLgIuZLYzA9Hhn
	 0elzpD2HRhiKwXecBvp8bAGtEpSPs9CDPIV2z8NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Shetaia <Amir.Shetaia@amd.com>,
	Alysa Liu <Alysa.Liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0169/1193] drm/amdkfd: fix UAF race in destroy_queue_cpsch
Date: Wed, 30 Sep 2026 17:14:13 +0200
Message-ID: <20260930152437.946337486@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alysa Liu <Alysa.Liu@amd.com>

[ Upstream commit ac081deaf16a639ea7dff2f285fe421a33c1ade0 ]

wait_on_destroy_queue() drops locks to wait for queue resume, allowing
a concurrent destroy to free the queue. Use is_being_destroyed flag to
serialize destruction.

Reviewed-by: Amir Shetaia <Amir.Shetaia@amd.com>
Signed-off-by: Alysa Liu <Alysa.Liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index 01481112a4ae3..85d461340e64e 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -2048,6 +2048,9 @@ static int wait_on_destroy_queue(struct device_queue_manager *dqm,
 	if (pdd->qpd.is_debug)
 		return ret;
 
+	if (q->properties.is_being_destroyed)
+		return -EBUSY;
+
 	q->properties.is_being_destroyed = true;
 
 	if (pdd->process->debug_trap_enabled && q->properties.is_suspended) {
@@ -2060,6 +2063,9 @@ static int wait_on_destroy_queue(struct device_queue_manager *dqm,
 		dqm_lock(dqm);
 	}
 
+	if (ret)
+		q->properties.is_being_destroyed = false;
+
 	return ret;
 }
 
@@ -2151,7 +2157,7 @@ static int destroy_queue_cpsch(struct device_queue_manager *dqm,
 	return retval;
 
 failed_try_destroy_debugged_queue:
-
+	q->properties.is_being_destroyed = false;
 	dqm_unlock(dqm);
 	return retval;
 }
-- 
2.53.0




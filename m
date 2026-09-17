Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF324D7D2F;
	Thu, 17 Sep 2026 17:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667821; cv=none; b=gOS/EYR8XR7BgcabuwccpLBHGc+fAs0SeJNCqxEKvwY6THEujHkT2Zjne266pp/BhaDnqBSDAJJVlq/xTEbXVQgIgd1I+IJiJDqB7GHQ7UWjl0y9hXLcdDfGySJoqzNjJpoS+0ZmpxyK0m5NnwluJrndisLePwB9CPF4j3kKkZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667821; c=relaxed/simple;
	bh=Bc/5V2HnMbNpfFp3EpnfyQbs88GoX2qGrrfJY4oh1q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LabgHOGMXIEchFaEGqQD2u3bL6P8LAsYfJZkz8I3zTvO+FKyxD1UPYZHFPX9hzl8IZ3ulN9vJaq/2IWjvuMBL7Hyx+7m1h8NnUMf1ZwMNEVpjuoag4jmun+JDqA9xrCGjPs3vOwnEFnBzwVQfQaeuoRCH6m9TG0f05nqsQso3WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YmyzuZbo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YmyzuZbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DBA1F000FF;
	Thu, 17 Sep 2026 17:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667819;
	bh=123aqxgAPU+xGLGrATWGtrWlkAVA53Y6VjPfl64TFEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YmyzuZboxxiGcCnPb2tq3bxD+zoX360TlG+fgafIIiCyAFUNDpZjyKeaFQjUqQ6H9
	 TURA5RCbskv6e4PSr+X0Mg1HhuVCZDhEE+NLwXtSgZOxqdQuPqRi5MujlVT2M3VSYS
	 wowqMBpxvtPMuYtASEH+6fE7r3GQ3qsFC+fko5Rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Shetaia <Amir.Shetaia@amd.com>,
	Alysa Liu <Alysa.Liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0221/1102] drm/amdkfd: fix UAF race in destroy_queue_cpsch
Date: Thu, 17 Sep 2026 16:02:44 +0100
Message-ID: <20260917151545.127651950@linuxfoundation.org>
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
index 96e05078c524d..f2a7e91e20947 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -2362,6 +2362,9 @@ static int wait_on_destroy_queue(struct device_queue_manager *dqm,
 	if (pdd->qpd.is_debug)
 		return ret;
 
+	if (q->properties.is_being_destroyed)
+		return -EBUSY;
+
 	q->properties.is_being_destroyed = true;
 
 	if (pdd->process->debug_trap_enabled && q->properties.is_suspended) {
@@ -2374,6 +2377,9 @@ static int wait_on_destroy_queue(struct device_queue_manager *dqm,
 		dqm_lock(dqm);
 	}
 
+	if (ret)
+		q->properties.is_being_destroyed = false;
+
 	return ret;
 }
 
@@ -2467,7 +2473,7 @@ static int destroy_queue_cpsch(struct device_queue_manager *dqm,
 	return retval;
 
 failed_try_destroy_debugged_queue:
-
+	q->properties.is_being_destroyed = false;
 	dqm_unlock(dqm);
 	return retval;
 }
-- 
2.53.0




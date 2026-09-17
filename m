Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23745172C9;
	Thu, 17 Sep 2026 16:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664268; cv=none; b=e992CvJPAwNwlPYz8q53iFsAKxCEDYjDaXH+W6Pp7i4V4NO4wAYLF+RV/alp4BEM6EeVO/IU4VlwQBEHCWyKiFIrrjVCZqYyGgM78xaPfhVwJfBioyFWmc7LJprKyq+vVWrtoCarASEbvpwn0oR0R2E5BA2H6krj7XmOLEY/Jbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664268; c=relaxed/simple;
	bh=I1++zwOe1VTMAvyQkOlTXGVhfDMIUVvGufQMFcstq6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwxMSAceZl55j5Xx69OxIebvCDqXYqJvfBYzHEOtbH8sN+aihww5DJdF6i5GEG3mUEvehSscaRkMr+Zy/UZRM9dFooBbZEUaSFELbyRMbbYG4SQVOcG84lAu2KUyaVjaR0gIS/j+XsQg2D3f4RZKDW/mmN2PoL+EW+PcN9ic9b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FTfjz8Db; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FTfjz8Db"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152FB1F00893;
	Thu, 17 Sep 2026 16:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664267;
	bh=/myfrsduq7tAljz7Cvczdz4r52wKZ8021SttmQnDrUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FTfjz8DbQ1M/akqv4s77FYL0BJW/WxRqVGHwH/upobzPsayi0QjCBSnmyEluy0+mg
	 fTVJMnz1M12+KAlPeGahapXxmN3BSCFw0MHyps3ELeZ+dF2e5iLhZZOLhHhcXNMtP5
	 v3dfB+i0LdumwGqOHh+P9CMqFpUedSvKXFU8DFQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Shetaia <Amir.Shetaia@amd.com>,
	Alysa Liu <Alysa.Liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0315/1250] drm/amdkfd: fix UAF race in destroy_queue_cpsch
Date: Thu, 17 Sep 2026 16:01:50 +0100
Message-ID: <20260917151600.640438155@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 4de6bc59569a4..af8e6f53249da 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -2517,6 +2517,9 @@ static int wait_on_destroy_queue(struct device_queue_manager *dqm,
 	if (pdd->qpd.is_debug)
 		return ret;
 
+	if (q->properties.is_being_destroyed)
+		return -EBUSY;
+
 	q->properties.is_being_destroyed = true;
 
 	if (pdd->process->debug_trap_enabled && q->properties.is_suspended) {
@@ -2529,6 +2532,9 @@ static int wait_on_destroy_queue(struct device_queue_manager *dqm,
 		dqm_lock(dqm);
 	}
 
+	if (ret)
+		q->properties.is_being_destroyed = false;
+
 	return ret;
 }
 
@@ -2622,7 +2628,7 @@ static int destroy_queue_cpsch(struct device_queue_manager *dqm,
 	return retval;
 
 failed_try_destroy_debugged_queue:
-
+	q->properties.is_being_destroyed = false;
 	dqm_unlock(dqm);
 	return retval;
 }
-- 
2.53.0




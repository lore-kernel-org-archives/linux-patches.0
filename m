Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0910847884C;
	Tue, 16 Jun 2026 16:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629085; cv=none; b=XeJnWS2QcyAHtZqCpkqIaEbx8mB1tCgvdyUx1lHin+09Uel2cptO/7/VD3doUQ+EqM0ygvcgLpw52j62I1Uz/NkMt8rkYUtAN95/xBG1kuKTUMI+Pj3Jkz4Kjmc+SfJpsb4i9G71opz/dbVnG6cY0nLkbX6+Pj1qiIuLSJ1tiqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629085; c=relaxed/simple;
	bh=FDRPL9hda+aBVT2SyhWDuRUplVKLSXdPeSv6uH94JMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7FbTpPfR/tZtzg/WLHKEQWcRMxo8PjkMDDBhIo7fGGoLjYjrTLJr0NMkLGGb5e0SU7xDOj1cxEBE9JdrRc2r/j8h+L7H7QMjZnS6CO9qcQrjZEJkGFNGQgRf4YVZkhyfquVThqIvOxs4Hc3ipYg3PWr6v7QO46NjI52pv2lD28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lRqS+1fm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lRqS+1fm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5691F000E9;
	Tue, 16 Jun 2026 16:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629083;
	bh=5q7/UPaRIvCB7rcstWwGkCccPgPjkLQYbWCNS6BR1EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lRqS+1fmVPvpVU6v27NMW1DfLeJLCFhqM+LN90/gndROQLJaa24LEl1O0HHREI3rn
	 QhZOeIEyJFKJFSmnc73TXXYhHtqPe10hMGoRSUn69hH8rnRtMAukwVPGMrKUHuq/x0
	 ZD47XCsDgOqrER8FcoTYtJhqztgjMPhIrvKD4j7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <jinhuieric.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 186/452] drm/amdkfd: fix a vulnerability of integer overflow in kfd debugger
Date: Tue, 16 Jun 2026 20:26:53 +0530
Message-ID: <20260616145127.608240906@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Eric Huang <jinhuieric.huang@amd.com>

commit 93f5534b35a05ef8a0109c1eefa800062fee810a upstream.

get_queue_ids() computes array_size = num_queues * sizeof(uint32_t),
which could overflow on 32-bit size_t build. using array_size()
instead, it saturates to SIZE_MAX on overflow.

Signed-off-by: Eric Huang <jinhuieric.huang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2d57a0475f085c08b49312dfd8edcb461845f285)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -2786,12 +2786,14 @@ static void copy_context_work_handler (s
 
 static uint32_t *get_queue_ids(uint32_t num_queues, uint32_t *usr_queue_id_array)
 {
-	size_t array_size = num_queues * sizeof(uint32_t);
-
 	if (!usr_queue_id_array)
 		return NULL;
 
-	return memdup_user(usr_queue_id_array, array_size);
+	if (num_queues > KFD_MAX_NUM_OF_QUEUES_PER_PROCESS)
+		return ERR_PTR(-EINVAL);
+
+	return memdup_user(usr_queue_id_array,
+			   array_size(num_queues, sizeof(uint32_t)));
 }
 
 int resume_queues(struct kfd_process *p,



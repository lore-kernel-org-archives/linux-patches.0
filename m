Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A790312C48A;
	Tue, 30 Apr 2024 10:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474676; cv=none; b=GuMmzsJzp3Km0RTJpJSmQt94pjmf82n+/5klnF9JK2BvoJl+9oT09IPTlGBE3TCOAXGrEJUXem4EJvsMfhriGaX80302lf2JKS3NsZYteEYFuNSMGBDNVmagFUeIfnOXGgfYyEnQW4dNiNfE+W8PAV93hhyANdG2UZ5Sq9qyjSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474676; c=relaxed/simple;
	bh=vk8vgy5j3pxl2K2FFaN6EKfuEXTeVGbhZ0U8JQQniY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tsVKKDzbEJnhbBLWfWb51IWs0Vz+3UDnBHDIhJjtFmGTZJw4VmX2dZPs7O5qrtiKoGjAm1MfyRvFW/lLjZ+d3LQZqWDcqZIDSPJ8Dl+IbkVGs/SzlM9RNo1MTu5fBjhCCV4SbVGCeLuqkFVJib6CD0EvxfcNTFU9sHVXKVslfLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qtxt4710; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qtxt4710"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1FDC2BBFC;
	Tue, 30 Apr 2024 10:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474675;
	bh=vk8vgy5j3pxl2K2FFaN6EKfuEXTeVGbhZ0U8JQQniY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qtxt47109NL4wNDltmGxLhxRlR4PSOH3LJ4us4SSvXCdzH/+JCS2HykPaU9HwnKN8
	 TNVGW7ASbDzaeMFJ/xjMYw7/wL15j7YY2j7+Sy13pAAGg2sTwltbJPLyZycPyfziDe
	 Q38B/sLZ0fPN7tgtsi2z0ff060j4dzJvJASdHvjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	Gang BA <Gang.Ba@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.8 180/228] drm/amdkfd: Fix eviction fence handling
Date: Tue, 30 Apr 2024 12:39:18 +0200
Message-ID: <20240430103108.997997415@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Kuehling <felix.kuehling@amd.com>

commit 37865e02e6ccecdda240f33b4332105a5c734984 upstream.

Handle case that dma_fence_get_rcu_safe returns NULL.

If restore work is already scheduled, only update its timer. The same
work item cannot be queued twice, so undo the extra queue eviction.

Fixes: 9a1c1339abf9 ("drm/amdkfd: Run restore_workers on freezable WQs")
Signed-off-by: Felix Kuehling <felix.kuehling@amd.com>
Reviewed-by: Philip Yang <Philip.Yang@amd.com>
Tested-by: Gang BA <Gang.Ba@amd.com>
Reviewed-by: Gang BA <Gang.Ba@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index b79986412cd8..aafdf064651f 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -1922,6 +1922,8 @@ static int signal_eviction_fence(struct kfd_process *p)
 	rcu_read_lock();
 	ef = dma_fence_get_rcu_safe(&p->ef);
 	rcu_read_unlock();
+	if (!ef)
+		return -EINVAL;
 
 	ret = dma_fence_signal(ef);
 	dma_fence_put(ef);
@@ -1949,10 +1951,9 @@ static void evict_process_worker(struct work_struct *work)
 		 * they are responsible stopping the queues and scheduling
 		 * the restore work.
 		 */
-		if (!signal_eviction_fence(p))
-			queue_delayed_work(kfd_restore_wq, &p->restore_work,
-				msecs_to_jiffies(PROCESS_RESTORE_TIME_MS));
-		else
+		if (signal_eviction_fence(p) ||
+		    mod_delayed_work(kfd_restore_wq, &p->restore_work,
+				     msecs_to_jiffies(PROCESS_RESTORE_TIME_MS)))
 			kfd_process_restore_queues(p);
 
 		pr_debug("Finished evicting pasid 0x%x\n", p->pasid);
-- 
2.44.0




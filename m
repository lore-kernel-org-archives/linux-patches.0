Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BB1583AC3;
	Wed,  9 Sep 2026 14:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963088; cv=none; b=V/SY3fJEVCMchSjyKsnTq7biUTfGpiqWbNH/0m4jDE5OQU7vby6sioXSURFQcdpybn3UBUX1xRCaOPYWgwwOIfETEejnPRBp2AjqRoSjmk1PS2o56NrdtH5yt4I3MKDPQYRtUh7HSJtMAh7B6IbPeD29YuGU864N6SnYXcv2p/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963088; c=relaxed/simple;
	bh=LwJ8/KP7zE3ITG+Soc/oR+ghvDbXpQgK/Eu7fNUGB+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/iVcbzrtc/2WxCemj0Z3WM/5bDWbrRvR4rzCpjPgLHxnqsQNWppDALxdZNgahOB7eKVufyrRpGCWz0oOj3u+SOqvqNQa9Ys96IPQ3Hy2vrZuNAgpUmq1Yg0SXem28GPvYpltI6mRUvPY/6PJYKB3JW/B2jaHNGWZ/Lg05sMTFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPXMJqn5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPXMJqn5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795511F00A3A;
	Wed,  9 Sep 2026 14:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963087;
	bh=SfKnuxx4ltmkK8gjk7TC71Pgkd/YMQ+oA+/V6mA37Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hPXMJqn5E+K9wt/QF4406gMZ5sni8Lix5kxrd0I2Fqh0Kb5K9DuI+8WKvnOJdb6k0
	 Pq68k0lQW002ZWmjBXXlPeVgKVLQE5KIvf7n7JKi/hETlwKiSI248Ryz/2oMnGdZKp
	 KhczSEZYaKKOQQkM8StSorZ9Y56fHy/qfdVszXpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Priya Hosur <Priya.Hosur@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 514/556] drm/amdkfd: Add TLB flush after MES queue eviction/suspension
Date: Wed,  9 Sep 2026 15:43:14 +0200
Message-ID: <20260909134248.523722600@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Priya Hosur <Priya.Hosur@amd.com>

commit 94e25cb6ab7f4f025bcdcd8ea79fda30f12843a4 upstream.

MES (Micro Engine Scheduler) does not perform heavy-weight TLB
invalidation after unmapping queues, unlike HWS which does this
automatically. This causes a race condition where in-flight DMA
descriptors can access memory that has been unmapped, leading to page
faults and GPU queue hangs during SVM page migration.

The issue manifests as KFDSVMRangeTest.MultiThreadMigrationTest
failures on gfx1151 (Strix Point) with XNACK mode 1 enabled - the GPU
compute queue hangs with packets submitted but never consumed.

Add kfd_flush_tlb() calls after MES queue removal in two locations:
- evict_process_queues_cpsch(): after all queues removed during eviction
- suspend_queues(): after debug/criu queue suspension (with mem_fence barrier)

This ensures all in-flight memory accesses from unmapped queues are
flushed before memory is freed or migrated.

Signed-off-by: Priya Hosur <Priya.Hosur@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f5c4f88e0f9c45a8fb9dfac0c1df726c95e41b77)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1375,6 +1375,14 @@ static int evict_process_queues_cpsch(st
 		}
 	}
 
+	/*
+	 * Heavy-weight TLB flush after MES removes queues to ensure
+	 * in-flight memory accesses complete before memory is freed/migrated.
+	 * HWS does this automatically, MES does not.
+	 */
+	if (dqm->dev->kfd->shared_resources.enable_mes)
+		kfd_flush_tlb(pdd);
+
 	if (!dqm->dev->kfd->shared_resources.enable_mes) {
 		pdd->last_evict_timestamp = get_jiffies_64();
 		retval = execute_queues_cpsch(dqm,
@@ -3651,8 +3659,11 @@ int suspend_queues(struct kfd_process *p
 		if (!per_device_suspended) {
 			dqm_unlock(dqm);
 			mutex_unlock(&p->event_mutex);
-			if (total_suspended)
+			if (total_suspended) {
 				amdgpu_amdkfd_debug_mem_fence(dqm->dev->adev);
+				/* Heavy-weight TLB flush after MES suspends queues */
+				kfd_flush_tlb(pdd);
+			}
 			continue;
 		}
 



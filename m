Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216219;
	b=ZpXN68ndfhsiLL4ti/gSWDmmBfwV7PjaG2qWubwcRHLzIJrgl03UdtvjJXwZax+oy9Fu
	 5CXWFSn2FOCMhkIboi4kTC+jtUFCUyQ2TNulpf8WxGlse4zMPRCen8/Dsehhuc6/Iu0iV
	 x0h1aCUIthW35s1YVbMmLDk9c/+LP2vTMI962xF57rRJNN/DL7eWPi+tFxXavP9yPhKoZ
	 xV08l+qwB0D1FUEind7UvLsjy92H+zkmi7ehyVDyvF4qlBLWMFG8Ynkj+a8Qmz1wDwvO1
	 yHWbq0GrTOCJUcitN3g4V5jbaEcbD26cVunxJZSJNiz57llyH4PMqAkPWvxhLAWjDSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dfs81RsNFrppwKfS+D6QYbZs8oMt461WCJK2TQ2yCOI=;
	b=OO2JjXjQ60aB5buqQtl20meVSPBA+8GvvPQKSfnFP1EF8SGTpnqm6g5Bqgb0J7B3ayMw
	 FCIcpa/7iKvYBc26dkhUbwTk6OBFeZJgJ/Ixt8MjkXGqAnvJ7vngp8HXm6TYBtZp7zFPi
	 9t7P91ZpunKRqQ9ZBW+0iVquYcE2/qFXc3rc//opn4aSOyjjoYH6a8d3uKK8wCzPHK5ud
	 wJeR0GIfb9SsDsY+nw245GNUIE1p6VoL9EpHKwWktAXAu3QvEfdKNTPUeoQBM92X4p2zQ
	 BR7/W+d2ssZmeGX8WleoVcC4et8cuy30PhiMM3gDZO+NHF5Ncx7AfXI7IsIKOl4RnJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E7NWZilo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70281606A31D;
	Wed, 28 Oct 2026 19:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E7NWZilo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFA81F031E0;
	Wed, 28 Oct 2026 19:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216219;
	bh=Dfs81RsNFrppwKfS+D6QYbZs8oMt461WCJK2TQ2yCOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E7NWZilow7fMWGrohnYKsO9/zR0h+R94q1T9jXE6dzZhpjMl55ATczFlQs+Yk0fGh
	 AQRSwz7LbDcUMWNi2SRz8iFSe1RCCErormkfvXdVGw4AqvYDds7D0T35uESoD8EzLq
	 2cStfw9bsJzqH1vy9YajL8ghzUWcOWikcQ++hcO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Priya Hosur <Priya.Hosur@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1482/1887] drm/amdkfd: Add TLB flush after MES queue eviction/suspension
Date: Wed, 28 Oct 2026 17:59:38 +0100
Message-ID: <20261028170533.175866919@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Priya Hosur <Priya.Hosur@amd.com>

[ Upstream commit 94e25cb6ab7f4f025bcdcd8ea79fda30f12843a4 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index 976e2c808679a..8d48fc01ad35b 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1005,6 +1005,15 @@ static int evict_process_queues_cpsch(struct device_queue_manager *dqm,
 			}
 		}
 	}
+
+	/*
+	 * Heavy-weight TLB flush after MES removes queues to ensure
+	 * in-flight memory accesses complete before memory is freed/migrated.
+	 * HWS does this automatically, MES does not.
+	 */
+	if (dqm->dev->shared_resources.enable_mes && pdd->drm_file)
+		kfd_flush_tlb(pdd, TLB_FLUSH_HEAVYWEIGHT);
+
 	pdd->last_evict_timestamp = get_jiffies_64();
 	if (!dqm->dev->shared_resources.enable_mes)
 		retval = execute_queues_cpsch(dqm,
-- 
2.53.0




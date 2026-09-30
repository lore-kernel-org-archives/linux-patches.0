Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3AD3DD84F;
	Wed, 30 Sep 2026 18:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794141; cv=none; b=YcQZhkklAOXqa0iOhfqD36wnKWFE17f4Rd1biKdgnbuzP29h5sFuTMv+CVi4gNJT8p9Yne79kKJ4CtU4b/kl8UZZlPsA2HKqiol3GRoYuF08eMz6Jb1qkQ5zQcFrdSuXC00Istp50c3cmCsFKAlIQWHzWT2KLSLAQ5oTOFjGR7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794141; c=relaxed/simple;
	bh=x0rBElwCxomQ7KI52AKUbm/sl2C8yDxychhE6gmHw50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJg7/efWBPksPe+Gc7SYy0WsUg4uoPco6H6uDuYYBR+M1CbUXlU0zrIGfCf5uuDOtNyiQVqrYT7DI33zh6lgw7DBTAC1qkT8r9EeKKOhEQCrrhxgM6awJOh3022YTHWx4sowijx7ghr4v8dkr/FH42u6RvG3q9u5HQGhcjJYxh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tpvTy16z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tpvTy16z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA501F000FF;
	Wed, 30 Sep 2026 18:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794140;
	bh=X2hDjhnSH1Sux8dSV9ESB0DUXuuHJ9tMVCRBEVN4EJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tpvTy16zePpcxECJxD3z75sy5HNlJfGemY9v9tcQQO8M5+jnIktl4xtykuQ1Guwjp
	 D4GKe1jkYIy5U2M/aYM1ljx9bpL/4BArnfM8sFidaQuSRoNjygsRI9CPgGgo5Y4nUn
	 eJrwTgQJybzT/iJy4YqJXYJYeOp80nJxu3ojC8FM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0061/1193] drm/amdkfd: Check bounds for allocate_sdma_queue restore_sdma_id
Date: Wed, 30 Sep 2026 17:12:25 +0200
Message-ID: <20260930152435.632222993@linuxfoundation.org>
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

From: David Francis <David.Francis@amd.com>

[ Upstream commit bfe9a7545b2a7be1c543f1741e16f2d5ec4116ae ]

allocate_sdma_queue has an option where the sdma queue id can be
specified (used by CRIU). We weren't bounds-checking that
value.

Confirm it's less than the maximum number of queues.

Signed-off-by: David Francis <David.Francis@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index 8126cd5f3a2ff..f4f7c65be2139 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1484,6 +1484,9 @@ static int allocate_sdma_queue(struct device_queue_manager *dqm,
 		}
 
 		if (restore_sdma_id) {
+			if (*restore_sdma_id >= get_num_sdma_queues(dqm))
+				return -EINVAL;
+
 			/* Re-use existing sdma_id */
 			if (!test_bit(*restore_sdma_id, dqm->sdma_bitmap)) {
 				pr_err("SDMA queue already in use\n");
@@ -1509,6 +1512,9 @@ static int allocate_sdma_queue(struct device_queue_manager *dqm,
 			return -ENOMEM;
 		}
 		if (restore_sdma_id) {
+			if (*restore_sdma_id >= get_num_xgmi_sdma_queues(dqm))
+				return -EINVAL;
+
 			/* Re-use existing sdma_id */
 			if (!test_bit(*restore_sdma_id, dqm->xgmi_sdma_bitmap)) {
 				pr_err("SDMA queue already in use\n");
-- 
2.53.0




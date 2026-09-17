Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C130A4D488E;
	Thu, 17 Sep 2026 17:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667557; cv=none; b=YefHHk+Hf9+13j+fLFztq3EfJgo7zqNhJ7Fb1PUVYu5pJ106nk8D4aljvHi/ODJWkx8tRapU60jCjqKH9xpVZF4ScvQbCEI1DOmrS/mVbJedwhdeixANaXXcguwkZxo+oweSpEy0xLNhWDUrdDVKIW6kbWGMVDwYuWMBYMiM+PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667557; c=relaxed/simple;
	bh=KuKehXZMXNEO6Jdj6GIKTSTzrEfjxbLM4TTXd8ysr58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKRsJV5h4FHDd0giIKzLVSTmenBrA2YbZ2QJPBLfQMjgmUCLAH9zkaMHNJYi5sQFM8nXnowxCllWp1q7cjZoDolGYBfVF4S2g+0rg58xwkcVLL/UaybAsT2scGtaphWy8/8zOm55M9CXHBb0akYjnJnEiYcWw2bFCSPbahYKvTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1TGLsih; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1TGLsih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEFE81F000FF;
	Thu, 17 Sep 2026 17:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667556;
	bh=zfQ9RM3oFEVVHZGZn4SKNj/vhm2TF/HtvGZk4GcSaAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i1TGLsihS9/6eCTv/WZS3U1rjb4qa645aQ44CwBMcSUCxs2r3FvfWsDTYyF3R/mVL
	 FcB/ti/pPO1SORM+7cqs+4/nm0rL1iflQiGfsz6dVwRUwjw3C0OlLWujgUmy+U6fgz
	 YsTindWS3GUozsumFn8Y5qCav6viGOXdj58dGkC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0094/1102] drm/amdkfd: Check bounds for allocate_sdma_queue restore_sdma_id
Date: Thu, 17 Sep 2026 16:00:37 +0100
Message-ID: <20260917151541.851793518@linuxfoundation.org>
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
index 5240b5c442a01..775c86f0badd8 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1550,6 +1550,9 @@ static int allocate_sdma_queue(struct device_queue_manager *dqm,
 		}
 
 		if (restore_sdma_id) {
+			if (*restore_sdma_id >= get_num_sdma_queues(dqm))
+				return -EINVAL;
+
 			/* Re-use existing sdma_id */
 			if (!test_bit(*restore_sdma_id, dqm->sdma_bitmap)) {
 				dev_err(dev, "SDMA queue already in use\n");
@@ -1575,6 +1578,9 @@ static int allocate_sdma_queue(struct device_queue_manager *dqm,
 			return -ENOMEM;
 		}
 		if (restore_sdma_id) {
+			if (*restore_sdma_id >= get_num_xgmi_sdma_queues(dqm))
+				return -EINVAL;
+
 			/* Re-use existing sdma_id */
 			if (!test_bit(*restore_sdma_id, dqm->xgmi_sdma_bitmap)) {
 				dev_err(dev, "SDMA queue already in use\n");
-- 
2.53.0




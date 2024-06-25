Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2149D12EBEA;
	Tue, 25 Jun 2024 09:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308689; cv=none; b=DeSojkWexfcw96eRWBMWIkWOmtuFgZBTpzsUv/7HPsADnyzJo0g7y9AOOdvCZsGrtx3vsQs4kuf7S8jfhCOFK/5jqPiWMUuZFytL2G6nAFWyGHQ6IsyuThW9VkxDvmsDYLztwEyYUFJPQTtaFQWqSLYWCiHuhLKTJVvZjQI0Yas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308689; c=relaxed/simple;
	bh=vHv7+MytU02UuPNyH3qHauPsl8biHkzMqpR0/3H76aM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYY+IUyR0Xnnj7a38mLKl/dpB+/RZiDhHGXOQKHj/zVzsduGDckc9piHD/cyzPBGl8p6X07mjVhwScV0nQdZcPAoj4pHxLt7Ug2xO4HgzPrQGoGMXYMh0at7fPEZi6Q+Jx5KngROKF31hUlWpT/19y/eOLZuqsNjHWgerK9DLHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f9fWIr2m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9fWIr2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE7FC32786;
	Tue, 25 Jun 2024 09:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308689;
	bh=vHv7+MytU02UuPNyH3qHauPsl8biHkzMqpR0/3H76aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9fWIr2m0O4bkZkw37CxQB1NKDwDp8wCcME8rvM+tHwZGnCRpVzQFFLO9+7HzzpZG
	 ZaTAoGFj5YixGSRxw2jYWeRxK235PGODBdjNkkyFd9CChmOuGYwRULEcyYpjz1Idb5
	 4Iceg0SvGmDYAeQrE+wYrZXP0wnwLCFok7MoInC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Roman Li <roman.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.9 207/250] drm/amd/display: Remove redundant idle optimization check
Date: Tue, 25 Jun 2024 11:32:45 +0200
Message-ID: <20240625085555.999564634@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Li <roman.li@amd.com>

commit e2654a4453ba3dac9baacf9980d841d84e15b869 upstream.

[Why]
Disable idle optimization for each atomic commit is unnecessary,
and can lead to a potential race condition.

[How]
Remove idle optimization check from amdgpu_dm_atomic_commit_tail()

Fixes: 196107eb1e15 ("drm/amd/display: Add IPS checks before dcn register access")
Cc: stable@vger.kernel.org
Reviewed-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Acked-by: Roman Li <roman.li@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9149,9 +9149,6 @@ static void amdgpu_dm_atomic_commit_tail
 
 	trace_amdgpu_dm_atomic_commit_tail_begin(state);
 
-	if (dm->dc->caps.ips_support && dm->dc->idle_optimizations_allowed)
-		dc_allow_idle_optimizations(dm->dc, false);
-
 	drm_atomic_helper_update_legacy_modeset_state(dev, state);
 	drm_dp_mst_atomic_wait_for_dependencies(state);
 



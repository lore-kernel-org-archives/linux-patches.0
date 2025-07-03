Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78AC2EAD1B;
	Thu,  3 Jul 2025 14:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554645; cv=none; b=X9ExPAoUGpb81pEvaKUEUfSvS2vnci6qyYyLlThwYPZrEBfwULyA1HRY8IAoruCGyfhgmj7JpnUIJeWOnUwHaMOrd9ETo8AUj1DSKTly9lcg2u3F87DBCEnVa9ADO4hurViVwCG27444gOklJBanJ2oGhv6eEd05geDjEERQ8bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554645; c=relaxed/simple;
	bh=Psc32TIf+X58j4XYxRKYMZBHJhb7A867Piy+jx7dryA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHGmOs9WvS8pPlfiX+oLkkFqSKHqL77RmuL48tfIaDqRfAJXllaCguQU8RIbC8LuDeLw2mRibs3h954VaUfKK+LoJ5ivys6QhDK9NgW3J/jntv+X4ieVEY1JVmEMFUJ+l9iV/3hHMoHvfyX58Y7qVTLmlPyuNuKxt/yWI+R1oLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ROeAzvD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ROeAzvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E18FC4CEE3;
	Thu,  3 Jul 2025 14:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554645;
	bh=Psc32TIf+X58j4XYxRKYMZBHJhb7A867Piy+jx7dryA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ROeAzvDUM7z300Ydp98xdYNGh2hhswAaxpCvBs1fA5ZpnzOzgWtBxakWZzdMeo+Z
	 /wgw059u27uN2QyUUboDwQYKjWIQrVJ6F9YCJkl5LscTIsjwpD5oaVcr+yjkcZR5nt
	 +jWD1Wgx7cJAp7ob3/nHmsWY88hlTBWiCvz+ahqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 036/263] amd/amdkfd: fix a kfd_process ref leak
Date: Thu,  3 Jul 2025 16:39:16 +0200
Message-ID: <20250703144005.745167089@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yifan Zhang <yifan1.zhang@amd.com>

[ Upstream commit 90237b16ec1d7afa16e2173cc9a664377214cdd9 ]

This patch is to fix a kfd_prcess ref leak.

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Philip Yang <Philip.Yang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_events.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
index fecdb67940750..3a926eb82379b 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -1331,6 +1331,7 @@ void kfd_signal_poison_consumed_event(struct kfd_node *dev, u32 pasid)
 	user_gpu_id = kfd_process_get_user_gpu_id(p, dev->id);
 	if (unlikely(user_gpu_id == -EINVAL)) {
 		WARN_ONCE(1, "Could not get user_gpu_id from dev->id:%x\n", dev->id);
+		kfd_unref_process(p);
 		return;
 	}
 
-- 
2.39.5




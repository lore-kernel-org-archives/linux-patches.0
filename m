Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016432F55;
	Thu, 13 Jun 2024 12:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282761; cv=none; b=YpmiIfu2hN2FZB+eqWOAVir1adjRnzUo6A7t1t1eN29Q+d/Xw4EOF16Ke3Prow8t88eDOb1/b8HlE2FiYHLeXAX3P7GZaHZSQJUQ/WdajncJLXJzOhqiXdRYMHQ6bvwlCimanmSrpwzl8S2Us4dvIDdlo21yDKHeBk2urPQVEUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282761; c=relaxed/simple;
	bh=eYnKa9nCXR9h8NJ+Ki4s+AjW/adXBf/yeVF3KGvE498=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T4OQRtw915oYq0TihZMpSax0khBzLC3fOLfOe8Hc/gk+bYUgSKDqrsIgTbRDTPHx8GT6WpaCOu9tEhOKi698aX9UkSqahu0U6bPBY5HVqyiM1WFrhPkla/YlXsl8Gt4flWrQy2UUN5pJ8bTRan9l21N8qLDt7B69Xd33NRmOwOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GdJAMfy2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GdJAMfy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C219C2BBFC;
	Thu, 13 Jun 2024 12:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282760;
	bh=eYnKa9nCXR9h8NJ+Ki4s+AjW/adXBf/yeVF3KGvE498=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GdJAMfy20yCBM//Nb31EsuZzregRGQ5u+PHAzMFkxoUbN07RPW8NCM1yYEP3f9iTn
	 ag1oGQWAuhOV2j4RzxSWh7JkwD3fplAHb4m+wh2ob/SAQ3rG0v0Gm+FXw93ldFOilF
	 TF9XOuQnMNP6vp9hh/K7dRketQdLjkjf01VcSPVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Zhou <bob.zhou@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Le Ma <le.ma@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 355/402] drm/amdgpu: add error handle to avoid out-of-bounds
Date: Thu, 13 Jun 2024 13:35:12 +0200
Message-ID: <20240613113315.984220711@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Zhou <bob.zhou@amd.com>

commit 8b2faf1a4f3b6c748c0da36cda865a226534d520 upstream.

if the sdma_v4_0_irq_id_to_seq return -EINVAL, the process should
be stop to avoid out-of-bounds read, so directly return -EINVAL.

Signed-off-by: Bob Zhou <bob.zhou@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Le Ma <le.ma@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -2152,6 +2152,9 @@ static int sdma_v4_0_process_trap_irq(st
 
 	DRM_DEBUG("IH: SDMA trap\n");
 	instance = sdma_v4_0_irq_id_to_seq(entry->client_id);
+	if (instance < 0)
+		return instance;
+
 	switch (entry->ring_id) {
 	case 0:
 		amdgpu_fence_process(&adev->sdma.instance[instance].ring);



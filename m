Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAA41ACEDA;
	Mon, 23 Jun 2025 21:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712908; cv=none; b=bEFpnZGa1ObhZTW+W2b6kIqgoe+W4/iLkNaDZvuNGZmCgdI4g5/ID2wm6SCDg9yt5u6kfFpD01ZRIUK0oqbBB2mAojUJ01E3J013wYsoauYVZri+l27bqxsTQTzPncASWI2jx62qYY2eaSY7ZpQk4lE0tq6T2hcJR5KaMqF7Crk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712908; c=relaxed/simple;
	bh=SbgKOSHaynTdD91CfpivsZvfrOui6cFg33hbaCL+wZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y50VfmV40pd9eG7e7fQUjyXCROTE2MSpN0FTN/t57fwNLU1wkg0qRdUzvScv9pibyhmbUcz9etfkXnp9vIENqdGaMGGsMLQKYfCbU9FaQ7yL3yo6zrprc6cNW7W9C6yIHeBno1wxM0MSBhq3FIDITsuznW+ALdAtUHNcxCIV5NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TlQGXNUx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TlQGXNUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A34C4CEEA;
	Mon, 23 Jun 2025 21:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712908;
	bh=SbgKOSHaynTdD91CfpivsZvfrOui6cFg33hbaCL+wZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TlQGXNUxUgaj/jKTGYEAJ7KO7Vffze0se839rjlL4wFdc8zrkM2J+OFgnSdOH0veE
	 tg4LY8y8D3OAMb2ggMea0ISiDrJVoefwtz5L+0lYB9s8RzqFzfM0Ck0dQH54Am/8C8
	 r5xIFKh0Qs0ZiigwpgwmgFbHDje4ho78VIYcG0vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amber Lin <Amber.Lin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 300/592] drm/amdkfd: Set SDMA_RLCx_IB_CNTL/SWITCH_INSIDE_IB
Date: Mon, 23 Jun 2025 15:04:18 +0200
Message-ID: <20250623130707.528389969@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Amber Lin <Amber.Lin@amd.com>

[ Upstream commit ab9fcc6362e0699fc1150aa1d8503c40fce2c1e1 ]

When submitting MQD to CP, set SDMA_RLCx_IB_CNTL/SWITCH_INSIDE_IB bit so
it'll allow SDMA preemption if there is a massive command buffer of
long-running SDMA commands.

Signed-off-by: Amber Lin <Amber.Lin@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
index 80320a6c8854a..97933d2a38032 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
@@ -495,6 +495,10 @@ static void update_mqd_sdma(struct mqd_manager *mm, void *mqd,
 	m->sdma_engine_id = q->sdma_engine_id;
 	m->sdma_queue_id = q->sdma_queue_id;
 	m->sdmax_rlcx_dummy_reg = SDMA_RLC_DUMMY_DEFAULT;
+	/* Allow context switch so we don't cross-process starve with a massive
+	 * command buffer of long-running SDMA commands
+	 */
+	m->sdmax_rlcx_ib_cntl |= SDMA0_GFX_IB_CNTL__SWITCH_INSIDE_IB_MASK;
 
 	q->is_active = QUEUE_IS_ACTIVE(*q);
 }
-- 
2.39.5




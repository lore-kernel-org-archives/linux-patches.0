Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6B576058;
	Mon, 29 Jan 2024 17:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548633; cv=none; b=KDvB6LsTDkksJR9BSMjbqzjhySM3zX6PnhTfz0isTGILH1ByY5n8to8JjQT1HhoIEW9M8aa6+hmlEG5sBsda0ondL3cigQyNj2FQrW5hQQfOzAqIshza4yAM4p6mzwJZgr8qr3pRYeETW8XuFGyFP590WvT5g4D2pUiXwnPXVhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548633; c=relaxed/simple;
	bh=Isl5y1q60aRo3jJeqnSWSQyo2ep5FblIfXAcCS1m6bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3Qi0AK/vkHxLJs8mmAojDKu0qCN/wD+diQuyB2gapxwziOvDM4Zts/apUV7E7Jcz6bHcXLUpA7F/ceol5FA+F9ASICcfSPoZSE4szJfPmgp+SXmkT/A1dXMHXE2uhsImYJUBAcmOaJms0+mikm8BwtLjHvtOD4Jlc/GzekK7do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hkajlNj/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hkajlNj/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC31AC43390;
	Mon, 29 Jan 2024 17:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548633;
	bh=Isl5y1q60aRo3jJeqnSWSQyo2ep5FblIfXAcCS1m6bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hkajlNj/+Qujk5NL4EjUDN8haTXCqTACCIybrhTFSICSzYusyIP+W1+FSog10JA7o
	 bJvPASYz6JARji5mV7xORiMR+U9dHKIra5FxTQJGA0UE+nHvWZaTc0J30Wo1zCKf9p
	 s75bMjk4i3+Ov+f2tDn2D6ZhbqQzkzzi2vdk6mJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feifei Xu <Feifei.Xu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 299/331] drm/amdgpu/gfx11: set UNORD_DISPATCH in compute MQDs
Date: Mon, 29 Jan 2024 09:06:03 -0800
Message-ID: <20240129170023.620773265@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 3380fcad2c906872110d31ddf7aa1fdea57f9df6 ]

This needs to be set to 1 to avoid a potential deadlock in
the GC 10.x and newer.  On GC 9.x and older, this needs
to be set to 0. This can lead to hangs in some mixed
graphics and compute workloads. Updated firmware is also
required for AQL.

Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c           | 2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index 59efd4ece92d..d0c3ec9f4fb6 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -3807,7 +3807,7 @@ static int gfx_v11_0_compute_mqd_init(struct amdgpu_device *adev, void *m,
 			    (order_base_2(prop->queue_size / 4) - 1));
 	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, RPTR_BLOCK_SIZE,
 			    (order_base_2(AMDGPU_GPU_PAGE_SIZE / 4) - 1));
-	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, UNORD_DISPATCH, 0);
+	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, UNORD_DISPATCH, 1);
 	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, TUNNEL_DISPATCH, 0);
 	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, PRIV_STATE, 1);
 	tmp = REG_SET_FIELD(tmp, CP_HQD_PQ_CONTROL, KMD_QUEUE, 1);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
index 15277f1d5cf0..d722cbd31783 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
@@ -224,6 +224,7 @@ static void update_mqd(struct mqd_manager *mm, void *mqd,
 	m->cp_hqd_pq_control = 5 << CP_HQD_PQ_CONTROL__RPTR_BLOCK_SIZE__SHIFT;
 	m->cp_hqd_pq_control |=
 			ffs(q->queue_size / sizeof(unsigned int)) - 1 - 1;
+	m->cp_hqd_pq_control |= CP_HQD_PQ_CONTROL__UNORD_DISPATCH_MASK;
 	pr_debug("cp_hqd_pq_control 0x%x\n", m->cp_hqd_pq_control);
 
 	m->cp_hqd_pq_base_lo = lower_32_bits((uint64_t)q->queue_address >> 8);
-- 
2.43.0




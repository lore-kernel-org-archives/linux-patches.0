Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F05515897;
	Wed, 30 Sep 2026 17:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788530; cv=none; b=cta+96UX3i1qblN7h42ZFfqCaWNsXt7LcaYdhyo5DQYyXa8jl67Sryx21kx8fr0aEuU4ImhsWSAnW5C9ic/zNJAXEpTwbBuVM2GNXS3o0tY19aKbbnzJ+eLX/CLAWXwEu40ImV4W4u8dqe/pii/3k55hMoJ4iXSJOTpszB7ChnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788530; c=relaxed/simple;
	bh=jUdbJrVZqAIJxw69M3KLPL+fDLiPCMenKt2a0NsFxx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jveCQhaw1JNIuoJ2nk7CsA5/k85xjI5t9Z2FjVE1u3tK03hIINav5gL2CN/63QrwsNOprdhms4gt0WfXt4qaQ/XOl2Ez/7ElsqFjbQ70M8IkNPs/Inl7Fs+p24YtKRniuseMJ+FiJZTfmfNH5cGZw4Oc5Iq2MsXDbKvzmSBxuS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F4R/Av+E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F4R/Av+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E9F1F000FF;
	Wed, 30 Sep 2026 17:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788529;
	bh=mb9ZzzVbIUqcK5kHrm83jaYJF6aqld0TiznehI8kgDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F4R/Av+Eycsh/+yzrupgVkz4piWVtC5Mzh0M/tssoQLMY0Cq2m1F3TNjmYIZ7wEDO
	 fFt1HTZCkRLvHAz3qHWd7OpSLnNze2FjxHtZ2eb9AAOwAUspmn2dn5Y50G0wmMACP5
	 DzH1s+a+HKxRLNelNHHO5hWN96o4BhU5/YZKQspA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Zhou <tao.zhou1@amd.com>,
	Dmitriy Chumachenko <Dmitry.Chumachenko@cyberprotect.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 155/877] drm/amdgpu: check ras and obj before dereference
Date: Wed, 30 Sep 2026 17:17:46 +0200
Message-ID: <20260930152418.066740066@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Dmitriy Chumachenko <Dmitry.Chumachenko@cyberprotect.ru>

[ Upstream commit 723d4dc628d764b19cf9efca14b82cca5ff020c9 ]

nbio_v7_9_handle_ras_controller_intr_no_bifring() dereferences ras and obj
without checking either for NULL. Both amdgpu_ras_get_context() and
amdgpu_ras_find_obj() can return NULL, e.g. during the window between
adev->nbio.ras being set (early in amdgpu_ras_init(), by design, to
enable the fatal-error interrupt as soon as possible) and the PCIE_BIF
ras object actually being created in RAS late_init. Any interrupt in that
window crashes in hard-IRQ context.

This is analogous to commit d190b459b2a4 ("drm/amdgpu: the warning
dereferencing obj for nbio_v7_4"), which fixed the same issue in the
nbio_v7_4 handler.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 7692e1ee2446 ("drm/amdgpu: add RAS fatal error handler for NBIO v7.9")
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Dmitriy Chumachenko <Dmitry.Chumachenko@cyberprotect.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c7071767a50a32ed727cf800ac84372429e3b4b3)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c
index 8e401f8b2a054..2b3a1b9f8efc0 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c
@@ -518,7 +518,7 @@ static void nbio_v7_9_handle_ras_controller_intr_no_bifring(struct amdgpu_device
 						RAS_CNTLR_INTERRUPT_CLEAR, 1);
 		WREG32_SOC15(NBIO, 0, regBIF_BX0_BIF_DOORBELL_INT_CNTL, bif_doorbell_intr_cntl);
 
-		if (!ras->disable_ras_err_cnt_harvest) {
+		if (ras && !ras->disable_ras_err_cnt_harvest && obj) {
 			/*
 			 * clear error status after ras_controller_intr
 			 * according to hw team and count ue number
-- 
2.53.0




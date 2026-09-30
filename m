Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F143CC7EB;
	Wed, 30 Sep 2026 19:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796181; cv=none; b=GWNtL6oWAzHcwluNgl6923j2WZY/OGyTlZgILD7C4MwoyYgeAWbfk3lCHRcsf4RsOfPk5lgsEIYJKgbH05FNIA2QPwAGRudrvSEtehvSGi2S8DNr4cC6aWI0Av9oYrU36A5EWOgM/h8h+Kn8PdayjSnd+xWqhIR/KmjFpkWuTz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796181; c=relaxed/simple;
	bh=OFszsUDudN43WnJk6P8bVdPzDBGxyn5fANx5hV4Dw4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlBYWETZ5hXGNQaT/xPkmRNTT+LtiUsWuqKvDigrmTZ4xZlMQzVF0qv9Rx2J9kefierkBLIbYExhBHKhVEaaiM6pP+/4W86ZN6PbsjFMfoE3niKtZfLgBRmtDPCGW+SOjI1cZ7U9GJEffdyeYCvogG8Ocr+fULol3du75QUix+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEmhAeLS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEmhAeLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199F11F00898;
	Wed, 30 Sep 2026 19:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796179;
	bh=9N65IMIgFBdV+F4YydR+sNp26vDFN8RatvgFuiCX+e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tEmhAeLSNuwnNHbUI10euEfeqq07CC2y7A1poaxITJ8lNbiT35FeXKyammmxaocUK
	 wUFmmON+5wcnMkIA5be7JR8Z49jSE6jimyswYivyXnu9EP3kookG93+KNvUVo6UENt
	 bgyYTQXQA3pMV08mSEmA4x5uS3WmC2O/Nb19Mzmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Zhou <tao.zhou1@amd.com>,
	Dmitriy Chumachenko <Dmitry.Chumachenko@cyberprotect.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0823/1193] drm/amdgpu: check ras and obj before dereference
Date: Wed, 30 Sep 2026 17:25:07 +0200
Message-ID: <20260930152452.532562632@linuxfoundation.org>
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
index 0a601336cf697..3c8eb81ce41f7 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c
@@ -582,7 +582,7 @@ static void nbio_v7_9_handle_ras_controller_intr_no_bifring(struct amdgpu_device
 						RAS_CNTLR_INTERRUPT_CLEAR, 1);
 		WREG32_SOC15(NBIO, 0, regBIF_BX0_BIF_DOORBELL_INT_CNTL, bif_doorbell_intr_cntl);
 
-		if (!ras->disable_ras_err_cnt_harvest) {
+		if (ras && !ras->disable_ras_err_cnt_harvest && obj) {
 			/*
 			 * clear error status after ras_controller_intr
 			 * according to hw team and count ue number
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D6780045;
	Mon,  8 Apr 2024 13:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582022; cv=none; b=s0eyFilp+9agSDH/r6mBvsh0CyuaTK/tZ/HIGVnt9YH6uc3zebahu0D0H1FNhF16CGgwFxMV8tY2JcikCuT9Yu+278cSdYpmfYHxpITErV2s4dYYzJbNy/9pNMD9W3hQrk/E0wUgtFkAoNdUUnfR+N9ev6bAhEROccc4kiHcj40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582022; c=relaxed/simple;
	bh=rQsknRAikpkXAnd5Z7MKuiZ+m1ukK7nOjaKQeFxhAkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jY6l+K9kfKWRZJ+MiLw0NgBKFm3Xx3lz4uViA7fL2cZrhNQu42LCf/sFeI/b+hr4dg7y7ozvb2ZZ7Qx0edWzi2LbiTCyZe5gnJ83BnT9CUd3gocp5tCTjznj4onr4RqhRvHQl8XqIggwfpPscY7yGhHZuPUPqtBswgJWLKtUinU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gT/5USW4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gT/5USW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AB6C43390;
	Mon,  8 Apr 2024 13:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582022;
	bh=rQsknRAikpkXAnd5Z7MKuiZ+m1ukK7nOjaKQeFxhAkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gT/5USW4T92ztUHI/NcI/qL63rzeLPBM9zyleMrfP2VAvhqwiOoQvHg0IqwUsaYev
	 gbbBrFmT0PtREYIF+ve3rSaCqCRdqMnEr9aTl7PfGaK5RSZUxSr2SlAC4OuOXj+BOL
	 TWsEUbpcVUDJtFYFn19p7vz/R/gFDWVrM0TebrmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/138] drm/amd: Flush GFXOFF requests in prepare stage
Date: Mon,  8 Apr 2024 14:58:06 +0200
Message-ID: <20240408125258.462641054@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit ca299b4512d4b4f516732a48ce9aa19d91f4473e ]

If the system hasn't entered GFXOFF when suspend starts it can cause
hangs accessing GC and RLC during the suspend stage.

Cc: <stable@vger.kernel.org> # 6.1.y: 5095d5418193 ("drm/amd: Evict resources during PM ops prepare() callback")
Cc: <stable@vger.kernel.org> # 6.1.y: cb11ca3233aa ("drm/amd: Add concept of running prepare_suspend() sequence for IP blocks")
Cc: <stable@vger.kernel.org> # 6.1.y: 2ceec37b0e3d ("drm/amd: Add missing kernel doc for prepare_suspend()")
Cc: <stable@vger.kernel.org> # 6.1.y: 3a9626c816db ("drm/amd: Stop evicting resources on APUs in suspend")
Cc: <stable@vger.kernel.org> # 6.6.y: 5095d5418193 ("drm/amd: Evict resources during PM ops prepare() callback")
Cc: <stable@vger.kernel.org> # 6.6.y: cb11ca3233aa ("drm/amd: Add concept of running prepare_suspend() sequence for IP blocks")
Cc: <stable@vger.kernel.org> # 6.6.y: 2ceec37b0e3d ("drm/amd: Add missing kernel doc for prepare_suspend()")
Cc: <stable@vger.kernel.org> # 6.6.y: 3a9626c816db ("drm/amd: Stop evicting resources on APUs in suspend")
Cc: <stable@vger.kernel.org> # 6.1+
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3132
Fixes: ab4750332dbe ("drm/amdgpu/sdma5.2: add begin/end_use ring callbacks")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 77e35b919b064..b11690a816e73 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4190,6 +4190,8 @@ int amdgpu_device_prepare(struct drm_device *dev)
 	if (r)
 		return r;
 
+	flush_delayed_work(&adev->gfx.gfx_off_delay_work);
+
 	for (i = 0; i < adev->num_ip_blocks; i++) {
 		if (!adev->ip_blocks[i].status.valid)
 			continue;
-- 
2.43.0




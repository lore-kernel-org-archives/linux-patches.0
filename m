Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB4F2566FB;
	Thu, 17 Apr 2025 18:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915505; cv=none; b=Wo8ELAve7mRXQuxaSyRGnp847GDxohBzwTDrJvtjaNuEOss4E/kVp+M+vFHUm2Q0AHvoqiudNzlX4pEQPls709a9BLy6MQaw9ZeKxfemoyvjJff1i1ANbf3xf9/Tfp/ocRkMHhCaRZj7T8qN2bWOR2/BPT+Xmj8Zk56DV9BoWBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915505; c=relaxed/simple;
	bh=EWbU5w1KODgLSbIlxXU9NxI5MLrsaHgH9uz/w5AwE/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hmURBdREe7YaZEGlj9PaKHvYqPMAGCvsv621qW2onAin+eZX/XqF6khkitK5hdjgsvPgKndmrylFg0vC66iStHWZ68kdX0534dtGvIaAuDEWKxaKl3ACh1rq6QFWFAnWb9UJyFTDd/8h0b4f0bHga42ag9HoNfnM8G8C/qjdyYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bhYAuUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bhYAuUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B10EC4CEE4;
	Thu, 17 Apr 2025 18:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915504;
	bh=EWbU5w1KODgLSbIlxXU9NxI5MLrsaHgH9uz/w5AwE/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0bhYAuUbIORY5gE+kle/PihVicN1rJaG0s9RAjYj4+sCitbNNJataKM8FOqY2UmtV
	 I0b3q2CG0PAcubgzbB+32byW/4H8rf8J8rUDqob2DU/bUgDKpFWkkXOpxEFLX9gi15
	 xqeS1n81pTTH8Afm4wreDKdJhYzooxUezNB2zqo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 148/393] drm/amdgpu: handle amdgpu_cgs_create_device() errors in amd_powerplay_create()
Date: Thu, 17 Apr 2025 19:49:17 +0200
Message-ID: <20250417175113.534048869@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 1435e895d4fc967d64e9f5bf81e992ac32f5ac76 ]

Add error handling to propagate amdgpu_cgs_create_device() failures
to the caller. When amdgpu_cgs_create_device() fails, release hwmgr
and return -ENOMEM to prevent null pointer dereference.

[v1]->[v2]: Change error code from -EINVAL to -ENOMEM. Free hwmgr.

Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
index a71c6117d7e54..0115d26b5af92 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
@@ -51,6 +51,11 @@ static int amd_powerplay_create(struct amdgpu_device *adev)
 	hwmgr->adev = adev;
 	hwmgr->not_vf = !amdgpu_sriov_vf(adev);
 	hwmgr->device = amdgpu_cgs_create_device(adev);
+	if (!hwmgr->device) {
+		kfree(hwmgr);
+		return -ENOMEM;
+	}
+
 	mutex_init(&hwmgr->msg_lock);
 	hwmgr->chip_family = adev->family;
 	hwmgr->chip_id = adev->asic_type;
-- 
2.39.5




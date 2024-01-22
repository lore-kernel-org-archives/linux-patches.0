Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3629B5DF2F;
	Tue, 23 Jan 2024 01:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974400; cv=none; b=gMvCNykDy/o7oYQaN1Aksz0VtzPMlT2OWN1re1OK61FnKJaznjw8JKuwPDkBz52Xjwq+SoUowKHpQNRk1LBIKT5DOn0YxAbQT4I2rYsaOmZE+haQpwcsnkvbJYKow6WfhD5zQ6n0RDUNQlRKE8ySPiHle4rtafElXVRiS/2qRdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974400; c=relaxed/simple;
	bh=OM3RlWDoXPxh4UIYFW44b5y9tf9jEoJYlBc/YM9mpRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DACX7hcjErFVZHrrVa5og8mDyTfjIl1xjYN95PLBgelqqqfnCUafzoDo8pFeYlpSINaW5ztexmLHDodEo8cAXnk4nLqmw0yPcSCaUCTX2Q+eTo/7l2ar3lfdpNVecdFuigOltrkIHHyPxlfg5lPDHU/D2hXL0h/qdJDehWNCM3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1LjFmMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1LjFmMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF86C433C7;
	Tue, 23 Jan 2024 01:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974400;
	bh=OM3RlWDoXPxh4UIYFW44b5y9tf9jEoJYlBc/YM9mpRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z1LjFmMogkq0wPJTCWB1VEZH54RSSYW/YgbMGALxq1xT9Gp0vQ5Ya+bQOWokXMo+m
	 BXWx8fneDxuyECnA9XJgskYKXSUU8psrVutQ4uOuyQRw8/hv65YsceKeGlZ4u39b3g
	 SvVCLaNN+IWqm+/BhgUs3tZp0fDg/npRYmWk0U2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 210/374] drivers/amd/pm: fix a use-after-free in kv_parse_power_table
Date: Mon, 22 Jan 2024 15:57:46 -0800
Message-ID: <20240122235751.941642647@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit 28dd788382c43b330480f57cd34cde0840896743 ]

When ps allocated by kzalloc equals to NULL, kv_parse_power_table
frees adev->pm.dpm.ps that allocated before. However, after the control
flow goes through the following call chains:

kv_parse_power_table
  |-> kv_dpm_init
        |-> kv_dpm_sw_init
	      |-> kv_dpm_fini

The adev->pm.dpm.ps is used in the for loop of kv_dpm_fini after its
first free in kv_parse_power_table and causes a use-after-free bug.

Fixes: a2e73f56fa62 ("drm/amdgpu: Add support for CIK parts")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/kv_dpm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/kv_dpm.c b/drivers/gpu/drm/amd/pm/powerplay/kv_dpm.c
index 6ba4c2ae69a6..309c9f0b8f83 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/kv_dpm.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/kv_dpm.c
@@ -2731,10 +2731,8 @@ static int kv_parse_power_table(struct amdgpu_device *adev)
 		non_clock_info = (struct _ATOM_PPLIB_NONCLOCK_INFO *)
 			&non_clock_info_array->nonClockInfo[non_clock_array_index];
 		ps = kzalloc(sizeof(struct kv_ps), GFP_KERNEL);
-		if (ps == NULL) {
-			kfree(adev->pm.dpm.ps);
+		if (ps == NULL)
 			return -ENOMEM;
-		}
 		adev->pm.dpm.ps[i].ps_priv = ps;
 		k = 0;
 		idx = (u8 *)&power_state->v2.clockInfoIndex[0];
-- 
2.43.0




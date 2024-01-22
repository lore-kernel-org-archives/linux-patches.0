Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4D766B3C;
	Tue, 23 Jan 2024 02:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975325; cv=none; b=KGY7yZ967dD8npw+KpOmgLHTclgGnWbFc8Xke1LepQ4yc+ut4wbNLbl7Vzr1LbFHqUb6gizg0JnPbRcoW9p7pH4zmzDKeJREc6gy5Ox11KNND5+iXrUQN0GUiHi3csp/ctoccUJIjyr9cOy/tHI2S4n2v3MANYNwK/zAt6THYQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975325; c=relaxed/simple;
	bh=aiA/Q7LilYw3fZEWTxXwT52Qh1GmBYOPW1FSn67FcdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vv6cyLA5NjAIoPHgM1ItTNB2PwyBVAJy3x2pc5xvWV7tURIpTX8oAIYpcaABDwW5wliZez2UoQKHR5GoQhgV4qaT4G5OwtyHf+VRLRG+sJCE2U3kXSAi8oMMmi66NF0dO5zXWBYPKz5Nr6GK4HlMTQHYTtsU6B5WRGWT44vmByU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iHcojgR7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iHcojgR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04FAC43399;
	Tue, 23 Jan 2024 02:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975325;
	bh=aiA/Q7LilYw3fZEWTxXwT52Qh1GmBYOPW1FSn67FcdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iHcojgR7SgbNFY7T6r0pxmipa7Zj0UTqiIbuUkClLVc5v+CscmSAEgRawR/Nu/ABE
	 o+BcF9oJCsyO9GcUbV8MO3UNednaQ9Jny4Z3kLGC6FaSdpPUdkMXXmOiKHtqzBmzEZ
	 pcUQWeFNhalPqSKqNruBfKrZT9TRYjoEj6XjHjbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 289/583] drm/amd/pm: fix a double-free in si_dpm_init
Date: Mon, 22 Jan 2024 15:55:40 -0800
Message-ID: <20240122235820.849628159@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit ac16667237a82e2597e329eb9bc520d1cf9dff30 ]

When the allocation of
adev->pm.dpm.dyn_state.vddc_dependency_on_dispclk.entries fails,
amdgpu_free_extended_power_table is called to free some fields of adev.
However, when the control flow returns to si_dpm_sw_init, it goes to
label dpm_failed and calls si_dpm_fini, which calls
amdgpu_free_extended_power_table again and free those fields again. Thus
a double-free is triggered.

Fixes: 841686df9f7d ("drm/amdgpu: add SI DPM support (v4)")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
index 02e69ccff3ba..f81e4bd48110 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -7379,10 +7379,9 @@ static int si_dpm_init(struct amdgpu_device *adev)
 		kcalloc(4,
 			sizeof(struct amdgpu_clock_voltage_dependency_entry),
 			GFP_KERNEL);
-	if (!adev->pm.dpm.dyn_state.vddc_dependency_on_dispclk.entries) {
-		amdgpu_free_extended_power_table(adev);
+	if (!adev->pm.dpm.dyn_state.vddc_dependency_on_dispclk.entries)
 		return -ENOMEM;
-	}
+
 	adev->pm.dpm.dyn_state.vddc_dependency_on_dispclk.count = 4;
 	adev->pm.dpm.dyn_state.vddc_dependency_on_dispclk.entries[0].clk = 0;
 	adev->pm.dpm.dyn_state.vddc_dependency_on_dispclk.entries[0].v = 0;
-- 
2.43.0




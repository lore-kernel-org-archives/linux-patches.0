Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227B33314C3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301208; cv=none; b=Vja3pKZuxU4KyGHxFpQ3uooHtVJTBalXj+MsYMqQCliiOztICd02ucUwC8tup1/Ixxw9VkqnGiF8dbXUYWBdOqFPi4psGOLf7cf7Vjf9vkKGStpY0IqUL5u5k+dedr1m6oWD9nQoM8+bQfbrrDB8jshTSLL0TmY/53dQOo3dkyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301208; c=relaxed/simple;
	bh=oMsgW4wAbKiiOyclAZQWaUXIvISwr8whDNKET9ezJ50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GO4CarVpSm1MrnvVNhhdjUQp/sQoGs1jZHSkHayE0T0bjTcsd+HTDXzi1NEQcfsuVv62GXmTgfaISqrpCuy7dYRyWxxWGdN+Z+sl4tfsZW3tGzeNXpZchr7Loio6dZXdICxyMA6eDDtRNGMJgdoKHdT3CHkIHf5Fi++J6N0bZMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XiA13ZIa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XiA13ZIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839C7C19423;
	Sat, 28 Feb 2026 17:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301208;
	bh=oMsgW4wAbKiiOyclAZQWaUXIvISwr8whDNKET9ezJ50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XiA13ZIaJibBLbXLhh/J4s8gkDLdJmnHh07o25fI4atmEPinZo0uc73Llgoc7yFve
	 X+khg0VsX9AO/UYQX85GV+g6o17GmJ8i80VXr6M9RNYpcTvyfMAZ+mxkHgXEtugLUf
	 Oj9eQIWLZr/gAfX+FnsXSH7Ww9/IaC12uuPuKnilsv39Uif2puMeNoiNN7ig0puiFM
	 sk7HPVdt2QQe7er91MjOcS1ANVt999DiGjGqdER+tF4UQ45Hgpc3+WtxT0VDAsdesz
	 h05TzBaMo5AHBUSp0pVrldpcG6CT6FrmFnuewVI9fGNs2TS6le/evnDI9sEyC3jqJ6
	 1ZN1BK4QU7PcQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: decce6 <decce6@proton.me>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 382/752] drm/amdgpu: Add HAINAN clock adjustment
Date: Sat, 28 Feb 2026 12:41:33 -0500
Message-ID: <20260228174750.1542406-382-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: decce6 <decce6@proton.me>

[ Upstream commit 49fe2c57bdc0acff9d2551ae337270b6fd8119d9 ]

This patch limits the clock speeds of the AMD Radeon R5 M420 GPU from
850/1000MHz (core/memory) to 800/950 MHz, making it work stably. This
patch is for amdgpu.

Signed-off-by: decce6 <decce6@proton.me>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
index a1da3e5812ce3..9342f0b8bab2a 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -3469,6 +3469,11 @@ static void si_apply_state_adjust_rules(struct amdgpu_device *adev,
 			max_sclk = 60000;
 			max_mclk = 80000;
 		}
+		if ((adev->pdev->device == 0x666f) &&
+		    (adev->pdev->revision == 0x00)) {
+			max_sclk = 80000;
+			max_mclk = 95000;
+		}
 	} else if (adev->asic_type == CHIP_OLAND) {
 		if ((adev->pdev->revision == 0xC7) ||
 		    (adev->pdev->revision == 0x80) ||
-- 
2.51.0


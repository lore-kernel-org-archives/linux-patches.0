Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826921DEFC5;
	Tue,  8 Oct 2024 12:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390269; cv=none; b=T6LUCWt8uhPEEEn7mvRJedqhd1mkec+a+kaOHZ0bHa202GMWQGImVzJLsNPXVR4dRcMzHJVaNPJDg89sosDduoCUSocgTh54/kSek4OZYVWGLXRP3HEQYMp9UU8q4RElTzH8ELBTEBuCsY1hppirEBVw4LL7xfXo/Em2yr31GzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390269; c=relaxed/simple;
	bh=cMYC30j5nwKsX2PJziNS1B+HqrTPUOcUaDQHdzlXyn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+XG/8BC4TtlAIQ1eE3ig0QeK5kBSNhm8xs/4DUh828X7s+Esmu3i+4Mliv8f7gILtvsmALFD7pHi7AQdLFxekT4NjvvJUGKvKKr/JdTPTtaSGAEcBqFNYFps7lAKbCBrFAz4lwW0VzUBevMH7qNn26wL9xT+wecrbZzFeTlELU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w+vumtZ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w+vumtZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DE2C4CEC7;
	Tue,  8 Oct 2024 12:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390269;
	bh=cMYC30j5nwKsX2PJziNS1B+HqrTPUOcUaDQHdzlXyn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w+vumtZ4lIFg9yP38IdwkYzfRKvJnB8E6rWaJfduIdms4Vd04lwuCGupDsIHgvuR4
	 c1ic5elfkeu5M8ntGKiNLhWXtybh9jAO3o0EKf58HKW6pWHyrjBnQDXwcuBAV9mR01
	 ciFnV9PqKRrb+TcjV0DtEFTgXD0qoAxBDvkQTuEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 241/482] drm/amdgpu/gfx11: use rlc safe mode for soft recovery
Date: Tue,  8 Oct 2024 14:05:04 +0200
Message-ID: <20241008115657.780085438@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 3f2d35c325534c1b7ac5072173f0dc7ca969dec2 ]

Protect the MMIO access with safe mode.

Acked-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index 0bcdcb2101577..6b5cd0dcd25f4 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -5792,7 +5792,9 @@ static void gfx_v11_0_ring_soft_recovery(struct amdgpu_ring *ring,
 	value = REG_SET_FIELD(value, SQ_CMD, MODE, 0x01);
 	value = REG_SET_FIELD(value, SQ_CMD, CHECK_VMID, 1);
 	value = REG_SET_FIELD(value, SQ_CMD, VM_ID, vmid);
+	amdgpu_gfx_rlc_enter_safe_mode(adev, 0);
 	WREG32_SOC15(GC, 0, regSQ_CMD, value);
+	amdgpu_gfx_rlc_exit_safe_mode(adev, 0);
 }
 
 static void
-- 
2.43.0




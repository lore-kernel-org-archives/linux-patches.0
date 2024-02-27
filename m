Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EE913B798;
	Tue, 27 Feb 2024 14:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043895; cv=none; b=ua49GN5+rEDPohm4fMogiiF8EefoC/T5gx1fLNarmaaQCiVTCJN2lG40xFBMuNl31rFZlVGSaFNE+Kk/qAS29u+zcipUrqPARHal5/rmMuOL5EYtJlwvUm6ib26Y1qd7pU9MCAnX9kSWu7VUul9r3hAQE6E/AY2fiDpfJ9vXQg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043895; c=relaxed/simple;
	bh=tqaS0/Tn53tFo8IPWZFUgklhRIKeEhYR9NVb2laT6r8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btadzVVNOddRpFkJEH28JLCN/0+IXsoNPQpogcr2mPiz0ttX3ItcDu+KxHGLlDIgB+z15XkSIgAkiwCFeKt3PBYMDRGvEN/S3sLgHm5Xl5lGnH7DLoPccEKGCgcV8g7Ud3kHtHaN12L5SMdg+3mcPEoXtljk0DD1TLEUG7bpim8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PqWjyOcV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PqWjyOcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB061C433C7;
	Tue, 27 Feb 2024 14:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043895;
	bh=tqaS0/Tn53tFo8IPWZFUgklhRIKeEhYR9NVb2laT6r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PqWjyOcVnHH9Sd3VKrOHUltCROHslmJvQjmSbPBg5nqlNfK/Obc4KJpK/BkGg/wzu
	 wnmRsoKO6Gf8KcjtaoQ2OgbszJpW+/PLWaHVmaM/2nEDLMceej1pz47qtxy8ZASeDz
	 ogAnQsnQj+Du2GMtoeJr5B/hNpVtl/NidjNWMDlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trek <trek00@inbox.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 45/84] drm/amdgpu: Check for valid number of registers to read
Date: Tue, 27 Feb 2024 14:27:12 +0100
Message-ID: <20240227131554.337789254@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trek <trek00@inbox.ru>

[ Upstream commit 13238d4fa6764fa74dcf863d5f2227765b3753eb ]

Do not try to allocate any amount of memory requested by the user.
Instead limit it to 128 registers. Actually the longest series of
consecutive allowed registers are 48, mmGB_TILE_MODE0-31 and
mmGB_MACROTILE_MODE0-15 (0x2644-0x2673).

Bug: https://bugs.freedesktop.org/show_bug.cgi?id=111273
Signed-off-by: Trek <trek00@inbox.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
index 26a1173df9586..1f4acb4c3efb8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -650,6 +650,9 @@ static int amdgpu_info_ioctl(struct drm_device *dev, void *data, struct drm_file
 		if (info->read_mmr_reg.count > 128)
 			return -EINVAL;
 
+		if (info->read_mmr_reg.count > 128)
+			return -EINVAL;
+
 		regs = kmalloc_array(info->read_mmr_reg.count, sizeof(*regs), GFP_KERNEL);
 		if (!regs)
 			return -ENOMEM;
-- 
2.43.0




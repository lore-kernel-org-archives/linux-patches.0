Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E33427702D;
	Wed,  4 Feb 2026 15:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218784; cv=none; b=WmmkeL9W7ZQbVkquq7s0vtaWjTBdbKWvlWpfcGNGIxW1gs9RnBETkO3ZWI3eSEA3rYkggM8DvJSOufhvwJQ5+8cZ686l4dcFVq/jwTTJIIAhejZxtfx/5b4A0J2hgPLsr8eWqbMY3Enlw1XeaPuaSQ6AzU6sf/BX9aoUeMRhJYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218784; c=relaxed/simple;
	bh=sO/DuiGIzkkgKmkBlSfVb9cjzTCA81jotny3e2C/DHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFuaTvuKXmsKqrG5ejFV/dJZiDiLJzoaKPCErn+7kcRpELjHKtlSVr6C7ouCCyqWGBiX8CxBfj/xpVPRkR2s356ZF3lNpJWRoX4CcHLSwNZlheyjZ90soNPag9R8PP3n1uAw7wLd75BTxrn9TxN30Q/Mnly+FGKAr2K00lgC4t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HUx/POfn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUx/POfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079E7C4CEF7;
	Wed,  4 Feb 2026 15:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218784;
	bh=sO/DuiGIzkkgKmkBlSfVb9cjzTCA81jotny3e2C/DHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HUx/POfnqgziWgA5nf9M9eGo6RUjiKeoX9+CHRk8/LE5mlOIJlgh01pxjx6gBa7t/
	 a76iutBrBjVZywXm8R6igMR+kimoVzAbQ4SBxELxjwkGAgyN74iu55Bf1CXFAjkeYF
	 vhh+qhXZpRjI3M5MCCFI+99lrYyDKp20gVdh0JSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 61/87] drm/amdgpu/soc21: fix xclk for APUs
Date: Wed,  4 Feb 2026 15:40:59 +0100
Message-ID: <20260204143849.115106449@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit e7fbff9e7622a00c2b53cb14df481916f0019742 upstream.

The reference clock is supposed to be 100Mhz, but it
appears to actually be slightly lower (99.81Mhz).

Closes: https://gitlab.freedesktop.org/mesa/mesa/-/issues/14451
Reviewed-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 637fee3954d4bd509ea9d95ad1780fc174489860)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/soc21.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/soc21.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
@@ -225,7 +225,13 @@ static u32 soc21_get_config_memsize(stru
 
 static u32 soc21_get_xclk(struct amdgpu_device *adev)
 {
-	return adev->clock.spll.reference_freq;
+	u32 reference_clock = adev->clock.spll.reference_freq;
+
+	/* reference clock is actually 99.81 Mhz rather than 100 Mhz */
+	if ((adev->flags & AMD_IS_APU) && reference_clock == 10000)
+		return 9981;
+
+	return reference_clock;
 }
 
 



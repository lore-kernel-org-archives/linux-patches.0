Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C855E1AD9F9;
	Mon, 14 Oct 2024 15:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919027; cv=none; b=VUdjidySy7ru6X5sT7DzM0NONrLmBUbYkZwHxAM8CflSMFIEIu1IO5IHK6LxF1BoiLef8l4twQZYdFroNLJG2zhcWLLmYollQunUiIDFRpBNXZDm77F8dEsFG+Ptm1U/p67on06/ZN5X4OyuVUac8cJrELEgSldpiTBaSYfsHcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919027; c=relaxed/simple;
	bh=QYX30Ru8aqbvjFyzKXC/geDP23MJaTyW3/y/WIXef0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jeNz2hXmouQy9beGxCENst7pXyrDL9xuq3AnnhIDAEWxBOtgjoR9yEM9a1TYc7sARGdYjOwbvOSRLacKUMOmLrGx3LDNuL4l93mZRpkxzi6n+MQwvsXseujjZl/dft6fbH5G3WWgZ0GKoZ4JIGABrHU8Da/BpetkSdJfAbHHyO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wh6+5t5e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wh6+5t5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36019C4CEC3;
	Mon, 14 Oct 2024 15:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919027;
	bh=QYX30Ru8aqbvjFyzKXC/geDP23MJaTyW3/y/WIXef0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wh6+5t5eoCRTKe1c3qELRHvwiMOtZDvJV4VaWUcB8eEqNbRhpKka0V/0SnDeqd2Ew
	 e6v2WfkXwUvxsfv1TCVQ8q7Q3Gc2WMIEYQr/1tJ4Vvx3C8EUMZzccJC2qANcfxPlut
	 8Ijpde0Em+7E1DSI+i0u5aVmUEzCr/y+phZdqqVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yannick Fertre <yannick.fertre@foss.st.com>,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 490/798] drm/stm: ltdc: reset plane transparency after plane disable
Date: Mon, 14 Oct 2024 16:17:24 +0200
Message-ID: <20241014141237.220394554@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Yannick Fertre <yannick.fertre@foss.st.com>

[ Upstream commit 02fa62d41c8abff945bae5bfc3ddcf4721496aca ]

The plane's opacity should be reseted while the plane
is disabled. It prevents from seeing a possible global
or layer background color set earlier.

Signed-off-by: Yannick Fertre <yannick.fertre@foss.st.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240712131344.98113-1-yannick.fertre@foss.st.com
Signed-off-by: Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/stm/ltdc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/stm/ltdc.c b/drivers/gpu/drm/stm/ltdc.c
index 1d22afcf34ba7..a192f77915454 100644
--- a/drivers/gpu/drm/stm/ltdc.c
+++ b/drivers/gpu/drm/stm/ltdc.c
@@ -1514,6 +1514,9 @@ static void ltdc_plane_atomic_disable(struct drm_plane *plane,
 	/* Disable layer */
 	regmap_write_bits(ldev->regmap, LTDC_L1CR + lofs, LXCR_LEN | LXCR_CLUTEN |  LXCR_HMEN, 0);
 
+	/* Reset the layer transparency to hide any related background color */
+	regmap_write_bits(ldev->regmap, LTDC_L1CACR + lofs, LXCACR_CONSTA, 0x00);
+
 	/* Commit shadow registers = update plane at next vblank */
 	if (ldev->caps.plane_reg_shadow)
 		regmap_write_bits(ldev->regmap, LTDC_L1RCR + lofs,
-- 
2.43.0




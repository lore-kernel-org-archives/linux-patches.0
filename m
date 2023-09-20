Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE64230FA7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:23:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3305AC433CA;
	Wed, 20 Sep 2023 12:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212635;
	bh=r7sYNdA6PodDS4OprRBccx/TvwygNjVOn0PFzqhcfXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=knlOoeTKgxzAwBgUrLxRcAp//Hhd3rCFR3NVFhvjUVQMZpp0xCL3GCPfsZxBeoS9k
	 SAHu10Rq02xv1yceFrXs5mckEwUp/99btoKLrbpx1az75UmIN8vx9dsiLk8tsZTvAg
	 aiIvVygWKSyoMREE2pOmoxDsTO5RlhyPEZ6JpV48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 74/83] drm/amd/display: enable cursor degamma for DCN3+ DRM legacy gamma
Date: Wed, 20 Sep 2023 13:32:04 +0200
Message-ID: <20230920112829.575850763@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112826.634178162@linuxfoundation.org>
References: <20230920112826.634178162@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Melissa Wen <mwen@igalia.com>

commit 57a943ebfcdb4a97fbb409640234bdb44bfa1953 upstream.

For DRM legacy gamma, AMD display manager applies implicit sRGB degamma
using a pre-defined sRGB transfer function. It works fine for DCN2
family where degamma ROM and custom curves go to the same color block.
But, on DCN3+, degamma is split into two blocks: degamma ROM for
pre-defined TFs and `gamma correction` for user/custom curves and
degamma ROM settings doesn't apply to cursor plane. To get DRM legacy
gamma working as expected, enable cursor degamma ROM for implict sRGB
degamma on HW with this configuration.

Cc: stable@vger.kernel.org
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2803
Fixes: 96b020e2163f ("drm/amd/display: check attr flag before set cursor degamma on DCN3+")
Signed-off-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6971,6 +6971,13 @@ static void handle_cursor_update(struct
 	attributes.rotation_angle    = 0;
 	attributes.attribute_flags.value = 0;
 
+	/* Enable cursor degamma ROM on DCN3+ for implicit sRGB degamma in DRM
+	 * legacy gamma setup.
+	 */
+	if (crtc_state->cm_is_degamma_srgb &&
+	    adev->dm.dc->caps.color.dpp.gamma_corr)
+		attributes.attribute_flags.bits.ENABLE_CURSOR_DEGAMMA = 1;
+
 	attributes.pitch = attributes.width;
 
 	if (crtc_state->stream) {



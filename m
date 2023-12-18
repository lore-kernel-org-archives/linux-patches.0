Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3914FF6F;
	Mon, 18 Dec 2023 14:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W1E4/9Uv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B25C433C7;
	Mon, 18 Dec 2023 14:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908380;
	bh=gJ2VcbOi7AlYjfbLdHePX6w3PzvmKmAtRynCqQw9pPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W1E4/9UvH0EvwfnZuLrPJ2w/GC4hSCFx4QzzC0iLFofY/oOpfEyOx2gjkYD55OPrg
	 nbxocj+Bzr+RW5Azs6c0/sQILwhW/DlUT9a1HK8IpH5BprOHNrEmrb8KLjPtV9qcE0
	 bDpGY5exgsbzIxJr6BjVQTB2fGsozhcA2NoTsx9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Herbert <mark.herbert42@gmail.com>,
	Camille Cho <camille.cho@amd.com>,
	Krunoslav Kovac <krunoslav.kovac@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.6 148/166] drm/amd/display: Restore guard against default backlight value < 1 nit
Date: Mon, 18 Dec 2023 14:51:54 +0100
Message-ID: <20231218135111.737729543@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit b96ab339ee50470d13a1faa6ad94d2218a7cd49f upstream.

Mark reports that brightness is not restored after Xorg dpms screen blank.

This behavior was introduced by commit d9e865826c20 ("drm/amd/display:
Simplify brightness initialization") which dropped the cached backlight
value in display code, but also removed code for when the default value
read back was less than 1 nit.

Restore this code so that the backlight brightness is restored to the
correct default value in this circumstance.

Reported-by: Mark Herbert <mark.herbert42@gmail.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3031
Cc: stable@vger.kernel.org
Cc: Camille Cho <camille.cho@amd.com>
Cc: Krunoslav Kovac <krunoslav.kovac@amd.com>
Cc: Hamza Mahfooz <hamza.mahfooz@amd.com>
Fixes: d9e865826c20 ("drm/amd/display: Simplify brightness initialization")
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c
@@ -280,8 +280,8 @@ bool set_default_brightness_aux(struct d
 	if (link && link->dpcd_sink_ext_caps.bits.oled == 1) {
 		if (!read_default_bl_aux(link, &default_backlight))
 			default_backlight = 150000;
-		// if > 5000, it might be wrong readback
-		if (default_backlight > 5000000)
+		// if < 1 nits or > 5000, it might be wrong readback
+		if (default_backlight < 1000 || default_backlight > 5000000)
 			default_backlight = 150000;
 
 		return edp_set_backlight_level_nits(link, true,



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2378149C69;
	Fri,  6 Dec 2024 14:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496999; cv=none; b=I4QmmRI7OfBPk9lnmSxS0RvUSJcHMuK3kVHDS6Irk+09rVwuN+3FeIhI+v10LA7gYfHmVhHj6B5DIo04dmttmcHd4Oy/d5jI8PdC1AsUZj4b/ZwNsG+D/9iCgbVc2pvRUpbs3sPw/pOSIGqIkK6GSdruLJP+yLSwwwFsRJAQUYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496999; c=relaxed/simple;
	bh=Ulf8KwSRVGllHQsvxRCBG8FmMvB7NejFvQLp0jnVijI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJ/zOTRb/S5Il625AnOXE5j/AlG7+/Tuy6ojct1nSKk2DghgCJ6292NTuJV/TryP5w5pNJmBrE2oHpaRbzAdlz5nMnIshNZIxM/oDa1hD6Ph2M/Jxx8epIe/cDzq4esSthG4SXMKGtmOSDlpBpHEhnPH9aOYQMe0ArFo4p40hpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SPrslKII; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SPrslKII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786A1C4CED1;
	Fri,  6 Dec 2024 14:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496998;
	bh=Ulf8KwSRVGllHQsvxRCBG8FmMvB7NejFvQLp0jnVijI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SPrslKIIOcE0u7KwQcKtxq182/DhtuPma/U618jbzHlTTJnlrYE2CVFRDLv0Ix18P
	 Fw6Ko3BHFlCTSeoYQHaaoiGq7fFIigJNvb6WscZNOanKc8TFjM++oksHBqr03T7YlS
	 aoNPwP3qUHOQKcgogfdweGYBQpv2t7X3PBFibX9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dom Cobley <popcornmix@gmail.com>,
	Maxime Ripard <mripard@kernel.org>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 166/676] drm/vc4: hdmi: Avoid hang with debug registers when suspended
Date: Fri,  6 Dec 2024 15:29:45 +0100
Message-ID: <20241206143659.835727307@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Dom Cobley <popcornmix@gmail.com>

[ Upstream commit 223ee2567a55e4f80315c768d2969e6a3b9fb23d ]

Trying to read /sys/kernel/debug/dri/1/hdmi1_regs
when the hdmi is disconnected results in a fatal system hang.

This is due to the pm suspend code disabling the dvp clock.
That is just a gate of the 108MHz clock in DVP_HT_RPI_MISC_CONFIG,
which results in accesses hanging AXI bus.

Protect against this.

Fixes: 25eb441d55d4 ("drm/vc4: hdmi: Add all the vc5 HDMI registers into the debugfs dumps")
Signed-off-by: Dom Cobley <popcornmix@gmail.com>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240621152055.4180873-17-dave.stevenson@raspberrypi.com
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index c6e986f71a26f..d4487f4cb3034 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -179,6 +179,8 @@ static int vc4_hdmi_debugfs_regs(struct seq_file *m, void *unused)
 	if (!drm_dev_enter(drm, &idx))
 		return -ENODEV;
 
+	WARN_ON(pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev));
+
 	drm_print_regset32(&p, &vc4_hdmi->hdmi_regset);
 	drm_print_regset32(&p, &vc4_hdmi->hd_regset);
 	drm_print_regset32(&p, &vc4_hdmi->cec_regset);
@@ -188,6 +190,8 @@ static int vc4_hdmi_debugfs_regs(struct seq_file *m, void *unused)
 	drm_print_regset32(&p, &vc4_hdmi->ram_regset);
 	drm_print_regset32(&p, &vc4_hdmi->rm_regset);
 
+	pm_runtime_put(&vc4_hdmi->pdev->dev);
+
 	drm_dev_exit(idx);
 
 	return 0;
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5126F2FE;
	Thu, 12 Dec 2024 16:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019236; cv=none; b=ROJV9sprqqHhjp6UKksHKVpcJcorlIZmokoeu2SHV6NyqPxt0oFl8NIJV9igEjffM6d5GmzW19JZMKWFP7xPCAAG2TUdf/Uolir3ftnHH37s/QqZSMYt3Q0LSSiV06VnpbvXt+ZfDQ1B9niqTcfZ4fabKNRWn0wONFYD5WVQc5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019236; c=relaxed/simple;
	bh=hLrf19LJ8FWF3KZdtsXgnH/i1fPhezgK+YlvXUGneQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N9CblI4HhvFy6VaXp0h+dNfNILbSbtv+74ZVm+Pkm/yIA0pbOAH3Sg2zyjJY4KDjbnAODiBHRurpuUm+qawgEVybqAtqCx7I6Anw8raUJY0GDnnBRBZzMLFsYqNHSEmaOWKo1y9IAYtmEsQqMJdrOdg71PtRNsMr5/NnzI6qDL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+0216Ya; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+0216Ya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A70C4CED3;
	Thu, 12 Dec 2024 16:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019235;
	bh=hLrf19LJ8FWF3KZdtsXgnH/i1fPhezgK+YlvXUGneQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+0216YaBIrZSmDT45V75g+4GSFOXm9hXlmirQy5YCwh8vjvoj0e4SstOeOMTYBuW
	 GE/LfWAbYoaLXckagrmN06LbzjstvMN2uICGTys+JEL8W37nWTQwhOwQtgk6bQrV8t
	 4qKgnmHA7Yj1WotP2xeDXVheMRJEdW65CMSKErIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dom Cobley <popcornmix@gmail.com>,
	Maxime Ripard <mripard@kernel.org>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 127/772] drm/vc4: hdmi: Avoid hang with debug registers when suspended
Date: Thu, 12 Dec 2024 15:51:12 +0100
Message-ID: <20241212144355.175587513@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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
index 971801acbde60..649fd5c03f21d 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -170,6 +170,8 @@ static int vc4_hdmi_debugfs_regs(struct seq_file *m, void *unused)
 	if (!drm_dev_enter(drm, &idx))
 		return -ENODEV;
 
+	WARN_ON(pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev));
+
 	drm_print_regset32(&p, &vc4_hdmi->hdmi_regset);
 	drm_print_regset32(&p, &vc4_hdmi->hd_regset);
 	drm_print_regset32(&p, &vc4_hdmi->cec_regset);
@@ -179,6 +181,8 @@ static int vc4_hdmi_debugfs_regs(struct seq_file *m, void *unused)
 	drm_print_regset32(&p, &vc4_hdmi->ram_regset);
 	drm_print_regset32(&p, &vc4_hdmi->rm_regset);
 
+	pm_runtime_put(&vc4_hdmi->pdev->dev);
+
 	drm_dev_exit(idx);
 
 	return 0;
-- 
2.43.0




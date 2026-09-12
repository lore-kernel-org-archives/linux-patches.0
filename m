Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B34938E8CE;
	Sat, 12 Sep 2026 07:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196796; cv=none; b=R4r6Jcxrn/OCTISWERRR257EP+/A41/xFIllsBSEbk0vTnkCkW67XrFjLVFO+4rGaABvzg5glZcyIvgr3XDF/dSwRNUjByP3iUk8a3AidPuFJ3F7jD0rN4NvcTnioDpdEkhpBY580A3jxKnZRQv/E6lX7/tnQ1Z0a34r4O0881g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196796; c=relaxed/simple;
	bh=jKYQtAhul82ab/M4kBdO729D9NWidhhUlPpqaThfMY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eqe6nYsXmIgmVyrTngdls5qZwL/n7mU/w+D0C9rEo1H3XHl+ZwYn5JGmbrrI/lZg6Nyo+metVEUynF35Ftvm6GO+vEvnKHioKFJMDCTtDSQwt6lOTPzol1XdNz9CndZiaZJQf7xDVPPlCJzpfbcqXPcDSgqCM++xSLxHulFKvY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y3lxJUOt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y3lxJUOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51331F000FF;
	Sat, 12 Sep 2026 07:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196792;
	bh=IlwbcexT/Zzu+M/Qmatd4ju/UG9io1elUabmOJTLnEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y3lxJUOtvO4lQQ6M6CgGi1kImkgEqhSZ5qI/BDqIDnOCaiNb3tyQWIb6rB2ZYuJPI
	 Hq0QZPl6gSlBetS4O017iO/mdprPenHh+40wZI1YDNbddKhZZwAGKZYZyv7V5mgpM4
	 IXusXT4pPGFL4MfmY4wR6sIj3L17Apl/14/Q5H70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0037/1815] drm/tegra: dsi: Re-add clear enable register if DSI was powered by bootloader
Date: Sat, 12 Sep 2026 08:29:47 +0200
Message-ID: <20260912065649.891833728@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit 27a58cc1a9c7bbe92a43fb5045bd17e148c8a022 ]

Original commit b22fd0b9639e ("drm/tegra: dsi: Clear enable register if
powered by bootloader") was added to address the issue of DSI being in an
unknown state after the bootloader, ensuring correct panel configuration.
This worked fairly well under the assumption that the bootloader had set
up DSI; however, in cases where it did not, the device would hang because
a DSI read was called before the DSI hardware was ready.

Removing this workaround results in the issue described in the original
fix: the panel initialization sequence fails and the panel gets stuck in
an undefined state. This is especially noticeable with command mode panels

In order to properly address this issue, the original workaround is
restored and placed after the DSI hardware is prepared for R/W operations.
This fixes behavior for both cases: where DSI is set by the bootloader and
where DSI is untouched.

I have tested this change on Tegra20 (Motorola Atrix 4G),
Tegra114 (NVIDIA Tegra Note 7 and ASUS Transformer Pad TF701T), and
Tegra124 (Xiaomi Mi Pad) with U-Boot, using both bootloader-initialized
DSI and untouched DSI.

Fixes: b22fd0b9639e ("drm/tegra: dsi: Clear enable register if powered by bootloader")
Fixes: 660b299bed2a ("Revert "drm/tegra: dsi: Clear enable register if powered by bootloader"")
Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Reviewed-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260511074538.24563-3-clamor95@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/dsi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/tegra/dsi.c b/drivers/gpu/drm/tegra/dsi.c
index 7f25c50621c94..690e4488de3f6 100644
--- a/drivers/gpu/drm/tegra/dsi.c
+++ b/drivers/gpu/drm/tegra/dsi.c
@@ -922,6 +922,15 @@ static void tegra_dsi_encoder_enable(struct drm_encoder *encoder)
 		return;
 	}
 
+	/* If the bootloader enabled DSI it needs to be disabled
+	 * in order for the panel initialization commands to be
+	 * properly sent.
+	 */
+	value = tegra_dsi_readl(dsi, DSI_POWER_CONTROL);
+
+	if (value & DSI_POWER_CONTROL_ENABLE)
+		tegra_dsi_disable(dsi);
+
 	state = tegra_dsi_get_state(dsi);
 
 	tegra_dsi_set_timeout(dsi, state->bclk, state->vrefresh);
-- 
2.53.0




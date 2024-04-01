Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF493F8F4;
	Mon,  1 Apr 2024 16:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987279; cv=none; b=fPM5bTcL8XKTfwSClet8+X4tr61CLdnmZMc9Ig8GcSXcAaNErtGSezweIxTj3oKhnQi4kd12oJkN/LaKATqP3Pmt7cugS4OfYt1bC5CzVsXFAw9XwMVgaJ2fmkqeuCOSkeYP/OHoPL3Cd0ih/nsR73gzJb5IWfLEfFzaB6VVwK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987279; c=relaxed/simple;
	bh=X0MLQIVvTKiNEYjpRONVugPFtfxMb/e9SRmRWCfFWLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvhsP2W07Zxa9CLtqxKoWI7m1LqlH+OwXsh6C2tWr33AoQ96xkdUG6NGO1I6nGFcFtDoxZPpfjxxhEz8I/y4l4JvaKf+X69tlMpHw9olTJg9IjVqywkx3iuwM6rGgx9JyteyZ8Eu4t3pFs5ByfVp7czrlMyqjTWjlGe2VB1GuRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bo64/1Rv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bo64/1Rv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23BD6C433F1;
	Mon,  1 Apr 2024 16:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987278;
	bh=X0MLQIVvTKiNEYjpRONVugPFtfxMb/e9SRmRWCfFWLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bo64/1RvaIIGB7ydZ5YYA0vTPEzanIVsBa6uRzTMg+vIRLWzKyThJJxNw+V527aj4
	 2Tp/obKoabowEXUyhd9ig2d0zSkdSAyf5c78j8P0bHsLes8djpkVv5FlsV4yvP4Pe/
	 SwD6X/tEhz3wTKk/LoC0yF18FBjs80XAAW5i9ZIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrien Grassein <adrien.grassein@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 239/399] drm/bridge: lt8912b: do not return negative values from .get_modes()
Date: Mon,  1 Apr 2024 17:43:25 +0200
Message-ID: <20240401152556.311802333@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 171b711b26cce208bb628526b1b368aeec7b6fa4 ]

The .get_modes() hooks aren't supposed to return negative error
codes. Return 0 for no modes, whatever the reason.

Cc: Adrien Grassein <adrien.grassein@gmail.com>
Cc: stable@vger.kernel.org
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/dcdddcbcb64b6f6cdc55022ee50c10dee8ddbc3d.1709913674.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt8912b.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt8912b.c b/drivers/gpu/drm/bridge/lontium-lt8912b.c
index 9c0ffc1c6fac4..97d4af3d13653 100644
--- a/drivers/gpu/drm/bridge/lontium-lt8912b.c
+++ b/drivers/gpu/drm/bridge/lontium-lt8912b.c
@@ -441,23 +441,21 @@ lt8912_connector_mode_valid(struct drm_connector *connector,
 static int lt8912_connector_get_modes(struct drm_connector *connector)
 {
 	const struct drm_edid *drm_edid;
-	int ret = -1;
-	int num = 0;
 	struct lt8912 *lt = connector_to_lt8912(connector);
 	u32 bus_format = MEDIA_BUS_FMT_RGB888_1X24;
+	int ret, num;
 
 	drm_edid = drm_bridge_edid_read(lt->hdmi_port, connector);
 	drm_edid_connector_update(connector, drm_edid);
-	if (drm_edid) {
-		num = drm_edid_connector_add_modes(connector);
-	} else {
-		return ret;
-	}
+	if (!drm_edid)
+		return 0;
+
+	num = drm_edid_connector_add_modes(connector);
 
 	ret = drm_display_info_set_bus_formats(&connector->display_info,
 					       &bus_format, 1);
-	if (ret)
-		num = ret;
+	if (ret < 0)
+		num = 0;
 
 	drm_edid_free(drm_edid);
 	return num;
-- 
2.43.0




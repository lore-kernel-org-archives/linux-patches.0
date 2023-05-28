Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99021611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246A1C433D2;
	Sun, 28 May 2023 19:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302536;
	bh=1n+jjgJ3UNZcA6zH5dUL31reArfdZP1+aJEMvQU8Lr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y4aoXINiQflEeXC9hRvC7mU2Gm/V+0K+92tQvy2KpZfAwa8Pr4SgK35o/niyqd7m8
	 5pa0XobdzfttCcrQkrjaL+a80ugDMXFz2PAL1JNPieHYRfdC/N8dCM1cU5Moowqi00
	 i9JYidzFFFrXCg0fDlFcM+HvYd4gWRotCUiLi9zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Wenjing Liu <Wenjing.Liu@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Robin Chen <robin.chen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 014/119] drm/amd/display: hpd rx irq not working with eDP interface
Date: Sun, 28 May 2023 20:10:14 +0100
Message-Id: <20230528190835.809312831@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Robin Chen <robin.chen@amd.com>

commit eeefe7c4820b6baa0462a8b723ea0a3b5846ccae upstream.

[Why]
This is the fix for the defect of commit ab144f0b4ad6
("drm/amd/display: Allow individual control of eDP hotplug support").

[How]
To revise the default eDP hotplug setting and use the enum to git rid
of the magic number for different options.

Fixes: ab144f0b4ad6 ("drm/amd/display: Allow individual control of eDP hotplug support")
Cc: stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Wenjing Liu <Wenjing.Liu@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Robin Chen <robin.chen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit eeefe7c4820b6baa0462a8b723ea0a3b5846ccae)
Hand modified for missing file rename changes and symbol moves in 6.1.y.
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c |    9 +++++++--
 drivers/gpu/drm/amd/display/dc/dc_types.h     |    6 ++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -1634,14 +1634,18 @@ static bool dc_link_construct_legacy(str
 				link->irq_source_hpd = DC_IRQ_SOURCE_INVALID;
 
 			switch (link->dc->config.allow_edp_hotplug_detection) {
-			case 1: // only the 1st eDP handles hotplug
+			case HPD_EN_FOR_ALL_EDP:
+				link->irq_source_hpd_rx =
+						dal_irq_get_rx_source(link->hpd_gpio);
+				break;
+			case HPD_EN_FOR_PRIMARY_EDP_ONLY:
 				if (link->link_index == 0)
 					link->irq_source_hpd_rx =
 						dal_irq_get_rx_source(link->hpd_gpio);
 				else
 					link->irq_source_hpd = DC_IRQ_SOURCE_INVALID;
 				break;
-			case 2: // only the 2nd eDP handles hotplug
+			case HPD_EN_FOR_SECONDARY_EDP_ONLY:
 				if (link->link_index == 1)
 					link->irq_source_hpd_rx =
 						dal_irq_get_rx_source(link->hpd_gpio);
@@ -1649,6 +1653,7 @@ static bool dc_link_construct_legacy(str
 					link->irq_source_hpd = DC_IRQ_SOURCE_INVALID;
 				break;
 			default:
+				link->irq_source_hpd = DC_IRQ_SOURCE_INVALID;
 				break;
 			}
 		}
--- a/drivers/gpu/drm/amd/display/dc/dc_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_types.h
@@ -993,4 +993,10 @@ struct display_endpoint_id {
 	enum display_endpoint_type ep_type;
 };
 
+enum dc_hpd_enable_select {
+	HPD_EN_FOR_ALL_EDP = 0,
+	HPD_EN_FOR_PRIMARY_EDP_ONLY,
+	HPD_EN_FOR_SECONDARY_EDP_ONLY,
+};
+
 #endif /* DC_TYPES_H_ */



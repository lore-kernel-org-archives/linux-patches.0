Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1192A322A10;
	Mon, 18 Aug 2025 13:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523954; cv=none; b=JV7eQOsEK6gZbL+3r78nhtB4Zh+b89/8VTgZ+Z3QeGs8o0dz35rfa7Wr31e0ohOg1Tq94Dw1Bi2phCEVTWSFyVILZvh2yzKQ+i5dJypLFGM2PsZJ9lFrw3vZQ4VTgWY/3/U+EcZwU2NHgPBr7iRoXpyqp5WYbkCuSFYcWtwkR/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523954; c=relaxed/simple;
	bh=7gMkRvAen16xoK4ZXuwkulrQ+e8rPxEsnmJDpQin6hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASX9olxoFe6fiwlNYKhg7ImNIWcgLkokaKFEU3VK/BPusWIxesaXeJtg7f77lba1p2J4VUSE/lAdh3Lhn+mJMeJbL+H+4RRPoqWKtE6y/SCa7ExMgUMbpiJzoKtkmTjkJekLWd2x5OPj3GhmUvbIx0mjjP3kdqqyoa1VVPTGoq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/FFE4hH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/FFE4hH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD13C4CEEB;
	Mon, 18 Aug 2025 13:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523953;
	bh=7gMkRvAen16xoK4ZXuwkulrQ+e8rPxEsnmJDpQin6hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/FFE4hHCrDJybWgXzxHe//fewIiEEzbos5HaVeqZQlo7eVJl2cuVc2eLAKEva+kC
	 WgRKVRaNToD77wRm3fupq2ilbJ6dOv6ewzTkZwu7GdZ2J8oZBE4MD9E9UrgU1S5pGw
	 uGqECmvkqkU6N8DerhMUHXKUdYhFN2q4tRGJOzK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 322/515] drm/amd/display: Avoid trying AUX transactions on disconnected ports
Date: Mon, 18 Aug 2025 14:45:08 +0200
Message-ID: <20250818124510.830150820@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Lin <Wayne.Lin@amd.com>

[ Upstream commit deb24e64c8881c462b29e2c69afd9e6669058be5 ]

[Why & How]
Observe that we try to access DPCD 0x600h of disconnected DP ports.
In order not to wasting time on retrying these ports, call
dpcd_write_rx_power_ctrl() after checking its connection status.

Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/link/link_dpms.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
index 53c961f86d43..2c1dcde5e3ea 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
@@ -140,7 +140,8 @@ void link_blank_dp_stream(struct dc_link *link, bool hw_init)
 				}
 		}
 
-		if ((!link->wa_flags.dp_keep_receiver_powered) || hw_init)
+		if (((!link->wa_flags.dp_keep_receiver_powered) || hw_init) &&
+			(link->type != dc_connection_none))
 			dpcd_write_rx_power_ctrl(link, false);
 	}
 }
-- 
2.39.5




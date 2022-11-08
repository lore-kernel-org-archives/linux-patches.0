Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0580715CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67207C433C1;
	Tue,  8 Nov 2022 14:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916385;
	bh=iYPPDjE5b+YNweqYILqzJOl0TtXnAtSbJYHfhIpBaVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vfR41XZOhxDbVopLv3W5bS2apN3Ck5G49Uy1h79BwmaP2VsXN29HS5TuI+RHUS9w8
	 ySDdiyPaOw7wTP+drksOfrxXjnKhWl9ZoIo1NZFCU7InK6MwbolgN9P7nVUs/pcIIb
	 +Bua9q10JDNFZiobHWBtbb/reOBBsRY5mhsFDo8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.15 141/144] drm/rockchip: dsi: Force synchronous probe
Date: Tue,  8 Nov 2022 14:40:18 +0100
Message-Id: <20221108133351.247931776@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Brian Norris <briannorris@chromium.org>

commit 81e592f86f7afdb76d655e7fbd7803d7b8f985d8 upstream.

We can't safely probe a dual-DSI display asynchronously
(driver_async_probe='*' or driver_async_probe='dw-mipi-dsi-rockchip'
cmdline), because dw_mipi_dsi_rockchip_find_second() pokes one DSI
device's drvdata from the other device without any locking.

Request synchronous probe, at least until this driver learns some
appropriate locking for dual-DSI initialization.

Cc: <stable@vger.kernel.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20221019170255.2.I6b985b0ca372b7e35c6d9ea970b24bcb262d4fc1@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
@@ -1638,5 +1638,11 @@ struct platform_driver dw_mipi_dsi_rockc
 		.of_match_table = dw_mipi_dsi_rockchip_dt_ids,
 		.pm	= &dw_mipi_dsi_rockchip_pm_ops,
 		.name	= "dw-mipi-dsi-rockchip",
+		/*
+		 * For dual-DSI display, one DSI pokes at the other DSI's
+		 * drvdata in dw_mipi_dsi_rockchip_find_second(). This is not
+		 * safe for asynchronous probe.
+		 */
+		.probe_type = PROBE_FORCE_SYNCHRONOUS,
 	},
 };



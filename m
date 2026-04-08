Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F432324B1F;
	Wed,  8 Apr 2026 18:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672760; cv=none; b=jEFhc4WNKHVV9GJ7EW34agEdEldVdcw43ggZcvvx1JzUMUTZetSI+MvjzVqUV2G8YQkqJZ6MD9JLAK6pfUML6dBM0CCLT1JQJXlJsb6oFZSOpLsbwy71nK+x7EUIlJjgR2rM9WYo9MeveidWpVrLArZBsEEtTcfJ0tA9V6Hc/Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672760; c=relaxed/simple;
	bh=QUidgcDW21PccUI7dp1IZ0JPtxA2btAo1pepttSOXdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3a2uYmAgsBb1dA2yu8AiGvGPnsUHPU4KYn1LznheVhWA5Gp5C3zre4MHa+OUso1K1ODR4h16xbhoAZyu4sZouxcDAlhQszisC7DP71LhEmbSKvuqO7WfuJckuia7hGgSAFH0UCm0Y3HeUHkGYfZcf+a3xoETrsEeg9ZCgknxjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h/DkVBJ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h/DkVBJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE38CC19421;
	Wed,  8 Apr 2026 18:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672760;
	bh=QUidgcDW21PccUI7dp1IZ0JPtxA2btAo1pepttSOXdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h/DkVBJ7ZRYPC2V0jk3KKKlMVul/GGqugBdQrTdSZAbzWfr5B5xJAXMFSffwgivDj
	 KCHbumLJSJGpVoXC1KbNtrvGs8Gy8yzIIhfq4bDEy0RAWpabfsIDOp22rCEz+k3VsH
	 mTqsk8nCu6dhYRu/KC1mjjdWS0k5nUpkQYyyw00E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Shenwei Wang <shenwei.wang@nxp.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.6 130/160] gpio: mxc: map Both Edge pad wakeup to Rising Edge
Date: Wed,  8 Apr 2026 20:03:37 +0200
Message-ID: <20260408175918.045289830@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shenwei Wang <shenwei.wang@nxp.com>

commit c720fb57d56274213d027b3c5ab99080cf62a306 upstream.

Suspend may fail on i.MX8QM when Falling Edge is used as a pad wakeup
trigger due to a hardware bug in the detection logic. Since the hardware
does not support Both Edge wakeup, remap requests for Both Edge to Rising
Edge by default to avoid hitting this issue.

A warning is emitted when Falling Edge is selected on i.MX8QM.

Fixes: f60c9eac54af ("gpio: mxc: enable pad wakeup on i.MX8x platforms")
cc: stable@vger.kernel.org
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
Link: https://patch.msgid.link/20260324192129.2797237-1-shenwei.wang@nxp.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-mxc.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -576,12 +576,13 @@ static bool mxc_gpio_set_pad_wakeup(stru
 	unsigned long config;
 	bool ret = false;
 	int i, type;
+	bool is_imx8qm = of_device_is_compatible(port->dev->of_node, "fsl,imx8qm-gpio");
 
 	static const u32 pad_type_map[] = {
 		IMX_SCU_WAKEUP_OFF,		/* 0 */
 		IMX_SCU_WAKEUP_RISE_EDGE,	/* IRQ_TYPE_EDGE_RISING */
 		IMX_SCU_WAKEUP_FALL_EDGE,	/* IRQ_TYPE_EDGE_FALLING */
-		IMX_SCU_WAKEUP_FALL_EDGE,	/* IRQ_TYPE_EDGE_BOTH */
+		IMX_SCU_WAKEUP_RISE_EDGE,	/* IRQ_TYPE_EDGE_BOTH */
 		IMX_SCU_WAKEUP_HIGH_LVL,	/* IRQ_TYPE_LEVEL_HIGH */
 		IMX_SCU_WAKEUP_OFF,		/* 5 */
 		IMX_SCU_WAKEUP_OFF,		/* 6 */
@@ -596,6 +597,13 @@ static bool mxc_gpio_set_pad_wakeup(stru
 				config = pad_type_map[type];
 			else
 				config = IMX_SCU_WAKEUP_OFF;
+
+			if (is_imx8qm && config == IMX_SCU_WAKEUP_FALL_EDGE) {
+				dev_warn_once(port->dev,
+					      "No falling-edge support for wakeup on i.MX8QM\n");
+				config = IMX_SCU_WAKEUP_OFF;
+			}
+
 			ret |= mxc_gpio_generic_config(port, i, config);
 		}
 	}



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A5F5381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19C6C433C0;
	Mon, 19 Jun 2023 10:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170969;
	bh=ozGwol5j77GqcGczXvIkHbM/L9VeyQvm9N7tCJbeE5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WcqqpXuFwXJ18dSq1fKu1XChPd0v0eeEFIgvvV07GmTbJP0ZEj3LIUkUUYPmuitYL
	 P8ACkBSKVzGFepI6A132QNgnZUejLrs/k3UVjntowb6IXYLKzyz8aDPnewylrkRY8P
	 2rV6lbdCf/ZJeTeuGGhWDYGsCDvjxRRomqiwQC80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koba Ko <koba.ko@canonical.com>,
	Yehezkel Bernat <YehezkelShB@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.3 093/187] thunderbolt: Do not touch CL state configuration during discovery
Date: Mon, 19 Jun 2023 12:28:31 +0200
Message-ID: <20230619102202.094361812@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 3fe95742af29b8b4eccab2ba94bc521805c6e10c upstream.

If the boot firmware has already established tunnels, especially ones
that have special requirements from the link such as DisplayPort, we
should not blindly enable CL states (nor change the TMU configuration).
Otherwise the existing tunnels may not work as expected.

For this reason, skip the CL state enabling when we go over the existing
topology. This will also keep the TMU settings untouched because we do
not change the TMU configuration when CL states are not enabled.

Reported-by: Koba Ko <koba.ko@canonical.com>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/7831
Cc: stable@vger.kernel.org # v6.0+
Acked-By: Yehezkel Bernat <YehezkelShB@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tb.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -737,6 +737,7 @@ static void tb_scan_port(struct tb_port
 {
 	struct tb_cm *tcm = tb_priv(port->sw->tb);
 	struct tb_port *upstream_port;
+	bool discovery = false;
 	struct tb_switch *sw;
 	int ret;
 
@@ -804,8 +805,10 @@ static void tb_scan_port(struct tb_port
 	 * tunnels and know which switches were authorized already by
 	 * the boot firmware.
 	 */
-	if (!tcm->hotplug_active)
+	if (!tcm->hotplug_active) {
 		dev_set_uevent_suppress(&sw->dev, true);
+		discovery = true;
+	}
 
 	/*
 	 * At the moment Thunderbolt 2 and beyond (devices with LC) we
@@ -835,10 +838,14 @@ static void tb_scan_port(struct tb_port
 	 * CL0s and CL1 are enabled and supported together.
 	 * Silently ignore CLx enabling in case CLx is not supported.
 	 */
-	ret = tb_switch_enable_clx(sw, TB_CL1);
-	if (ret && ret != -EOPNOTSUPP)
-		tb_sw_warn(sw, "failed to enable %s on upstream port\n",
-			   tb_switch_clx_name(TB_CL1));
+	if (discovery) {
+		tb_sw_dbg(sw, "discovery, not touching CL states\n");
+	} else {
+		ret = tb_switch_enable_clx(sw, TB_CL1);
+		if (ret && ret != -EOPNOTSUPP)
+			tb_sw_warn(sw, "failed to enable %s on upstream port\n",
+				   tb_switch_clx_name(TB_CL1));
+	}
 
 	if (tb_switch_is_clx_enabled(sw, TB_CL1))
 		/*



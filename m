Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4FD328B53;
	Mon, 27 Oct 2025 19:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593557; cv=none; b=RJ+aCoV2AZxPkoPmwX/BrvMlZ52szyNJHRC+Wyhv25eS8TqEgFUCbRD0Ca1SGJqtK+E0Waighw7eWfDZgfE9psHuYh8pOyvDMB0u/5evEo6z2is45kF8WWUeaSzIXv6C2Xe6JeiLgS3u48lvpFEg6GIsaxpmfijprT97V/NhngI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593557; c=relaxed/simple;
	bh=YZqBmUQmknPBFRgSExfH5IwtbVNK/nSsJfRvXrvUN3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzY+0/NYAYN8+9V84GfO9ZX6nRgQowBmm/4zhfYqwpM4G5FqdzewPBAWk8E772IbEJWkQWIyjx+bkRNIye0qD9gkT8cwaxk/rBRSuTaMTeDHY7u/IHTxzAk1ayqhwiCEVgAOSXX8B2eEDpoc01A46f1Zd4eNXDIka5u9/293t0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iykFzqEB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iykFzqEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DF5C4CEF1;
	Mon, 27 Oct 2025 19:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593557;
	bh=YZqBmUQmknPBFRgSExfH5IwtbVNK/nSsJfRvXrvUN3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iykFzqEBRwqKOWHMISvWdlKXUD1D3Y7cATbShFWELTh+5niAbxcpnSIHo3DzoJyKE
	 qYp9Sh9jfGXdyfMqST7ehyQdppHff6s7sOk0hSKKJTUfLfBMOkF2xHC6SODQLgn5jJ
	 quEVdlR4/MJfDkaTKNk3KPPmvqKJXUjQ3VAMXGO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daniel Golle <daniel@makrotopia.org>
Subject: [PATCH 6.17 172/184] serial: 8250_mtk: Enable baud clock and manage in runtime PM
Date: Mon, 27 Oct 2025 19:37:34 +0100
Message-ID: <20251027183519.556624115@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

commit d518314a1fa4e980a227d1b2bda1badf433cb932 upstream.

Some MediaTek SoCs got a gated UART baud clock, which currently gets
disabled as the clk subsystem believes it would be unused. This results in
the uart freezing right after "clk: Disabling unused clocks" on those
platforms.

Request the baud clock to be prepared and enabled during probe, and to
restore run-time power management capabilities to what it was before commit
e32a83c70cf9 ("serial: 8250-mtk: modify mtk uart power and clock
management") disable and unprepare the baud clock when suspending the UART,
prepare and enable it again when resuming it.

Fixes: e32a83c70cf9 ("serial: 8250-mtk: modify mtk uart power and clock management")
Fixes: b6c7ff2693ddc ("serial: 8250_mtk: Simplify clock sequencing and runtime PM")
Cc: stable <stable@kernel.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://patch.msgid.link/de5197ccc31e1dab0965cabcc11ca92e67246cf6.1758058441.git.daniel@makrotopia.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_mtk.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/8250/8250_mtk.c
+++ b/drivers/tty/serial/8250/8250_mtk.c
@@ -435,6 +435,7 @@ static int __maybe_unused mtk8250_runtim
 	while
 		(serial_in(up, MTK_UART_DEBUG0));
 
+	clk_disable_unprepare(data->uart_clk);
 	clk_disable_unprepare(data->bus_clk);
 
 	return 0;
@@ -445,6 +446,7 @@ static int __maybe_unused mtk8250_runtim
 	struct mtk8250_data *data = dev_get_drvdata(dev);
 
 	clk_prepare_enable(data->bus_clk);
+	clk_prepare_enable(data->uart_clk);
 
 	return 0;
 }
@@ -475,13 +477,13 @@ static int mtk8250_probe_of(struct platf
 	int dmacnt;
 #endif
 
-	data->uart_clk = devm_clk_get(&pdev->dev, "baud");
+	data->uart_clk = devm_clk_get_enabled(&pdev->dev, "baud");
 	if (IS_ERR(data->uart_clk)) {
 		/*
 		 * For compatibility with older device trees try unnamed
 		 * clk when no baud clk can be found.
 		 */
-		data->uart_clk = devm_clk_get(&pdev->dev, NULL);
+		data->uart_clk = devm_clk_get_enabled(&pdev->dev, NULL);
 		if (IS_ERR(data->uart_clk)) {
 			dev_warn(&pdev->dev, "Can't get uart clock\n");
 			return PTR_ERR(data->uart_clk);


